import gg.compiler
from gg.ast import *
import gg.lib.aol
from gg.types import RangeIterator

WL = gg.lib.wl.Worklist()
graph = gg.lib.graph.Graph('graph')

ast = Module([
    CBlock([cgen.Include("ktruss.h")]),
    CBlock([cgen.Include("kernels/segmentedsort.cuh")]),
    CBlock([cgen.Include("kernels/reduce.cuh")]),
    #CBlock('#define DEBUG'),
    CDecl(('int', 'CUDA_DEVICE', '= 0')),
    CDecl(('mgpu::ContextPtr', 'mgc', '')),
    CDecl(('extern index_type', 'wlione_end', '')),  # for IrGL parsing
    CDecl(('extern WorklistT', 'in_wl', '')),  # for IrGL parsing
    CDecl(('extern WorklistT', 'out_wl', '')),  # for IrGL parsing
    # Instead of graph.nnodes, use 2*graph.nnodes. atomicDec can be called at most graph.nnodes
    # times on a particular vertex. After iterations, degree will still be higher than graph.nnodes.
    Kernel('init_degree', [graph.param(), ('unsigned*', 'degrees'), ('unsigned*', 'vremoved'), ('unsigned', 'k')], [
      ForAll("node", graph.nodes(), [
        CDecl(('int', 'degree', '= graph.getOutDegree(node)')),
        CBlock('degrees[node] = degree'),
        If('degrees[node] < k - 1', [
          WL.push("node"),
          CBlock('vremoved[node] = 1'),
        ]),
      ]),
    ]),
    Kernel('degree_filter_iter', [graph.param(), ('unsigned*', 'degrees'), ('unsigned*', 'vremoved'), ('unsigned', 'k')], [
      ForAll('wli', WL.items(), [
        CDecl(('int', 'src', '')),
        CDecl(('bool', 'pop', '')),
        WL.pop('pop', 'wli', 'src'),
        For('edge', graph.edges('src'), [
          CDecl(('int', 'dst', '= graph.getAbsDestination(edge)')),
          If('!vremoved[dst]', [
            CBlock('atomicSub(&degrees[dst], 1U)'),
            If('degrees[dst] < k - 1', [
              WL.push('dst'),
              CBlock('vremoved[dst] = 1'),
            ]),
          ]),
        ]),
      ]),
    ]),
    Kernel('degree_filter_finalize', [graph.param(), ('unsigned*', 'degrees'), ('unsigned*', 'vremoved')], [
      ForAll('n', RangeIterator('graph.nnodes'), [
        CBlock('degrees[n] = vremoved[n] ? 0 : degrees[n]'),
      ]),
    ]),
    Kernel('degree_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('Shared<unsigned>&', 'degrees'), ('Shared<unsigned>&', 'vremoved')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('degrees.alloc(g.nnodes)'),
      CBlock('degrees.zero_gpu()'),
      CBlock('vremoved.alloc(g.nnodes)'),
      CBlock('vremoved.zero_gpu()'),
      Pipe([
        Invoke('init_degree', ['gg', 'degrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'k']),
        Pipe([
          Invoke('degree_filter_iter', ['gg', 'degrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'k']),
        ]),
      ], wlinit=WLInit('g.nnodes'), once=True),
      Invoke('degree_filter_finalize', ['gg', 'degrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()']),

      CBlock('#ifdef DEBUG'),
        CBlock('printf("ver: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", n)'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("deg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", degrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
      CBlock('#endif'),

    ], host=True),
    Kernel("preprocess", [graph.param()], [
        ForAll("node", graph.nodes(), [
            CDecl(('int', 'degree', '= graph.getOutDegree(node)')),
            ClosureHint(ForAll("edge", graph.edges("node"), [
                CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
                CDecl(('int', 'dst_degree', '= graph.getOutDegree(dst)')),
                CBlock(["graph.edge_data[edge] = dst"]),
            ])),
        ])
    ]),
    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned*', 'degrees')], [
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= graph.getFirstEdge(u+1)')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= graph.getFirstEdge(v+1)')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        CDecl(('int', 'count', '= 0')),
        While('u_it < u_end && v_it < v_end', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d == 0 && degrees[a] > 0', [CBlock('count++')]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
        CBlock('return count'),
    ], device=True, ret_type = 'unsigned int'),
    Kernel('init_triangles', [graph.param(), ('unsigned*', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      If('0', [
        WL.push(0), # needed to get the worklist here
      ]),
      ForAll("v", graph.nodes(), [
        If('degrees[v] > 0', [
          ClosureHint(ForAll("edge", graph.edges("v"), [
            CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
            If('degrees[u] > 0', [
              CBlock('triangles[edge] = intersect(graph, u, v, degrees)'),
              If('triangles[edge] < k-2', [
                CDecl(('int', 'lindex', '= atomicAdd((int *)out_wl.dindex, 2)')),
                CBlock('out_wl.dwl[lindex] = edge'),
                CBlock('out_wl.dwl[lindex+1] = v'),
                CBlock('eremoved[edge] = 1'),
              ]),
            ]),
          ])),
        ]),
      ]),
    ]),
    Kernel("intersect_dec", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned*', 'degrees'), ('unsigned *', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned', 'k')], [
        If('0', [ WL.push(0) ]), # needed to get the worklist here
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= graph.getFirstEdge(u+1)')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= graph.getFirstEdge(v+1)')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        While('u_it < u_end && v_it < v_end', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d == 0 && degrees[a] > 0', [
              If('!eremoved[u_it]', [
                CBlock('atomicSub(&triangles[u_it], 1U)'),
                If('triangles[u_it] < k-2', [
                  CDecl(('int', 'lindex', '= atomicAdd((int *)out_wl.dindex, 2)')),
                  CBlock('out_wl.dwl[lindex] = u_it'),
                  CBlock('out_wl.dwl[lindex+1] = u'),
                  CBlock('eremoved[u_it] = 1'),
                ]),
              ]),
              If('!eremoved[v_it]', [
                CBlock('atomicSub(&triangles[v_it], 1U)'),
                If('triangles[v_it] < k-2', [
                  CDecl(('int', 'lindex', '= atomicAdd((int *)out_wl.dindex, 2)')),
                  CBlock('out_wl.dwl[lindex] = v_it'),
                  CBlock('out_wl.dwl[lindex+1] = v'),
                  CBlock('eremoved[v_it] = 1'),
                ]),
              ]),
            ]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
    ], device=True),
    Kernel('triangle_iter', [graph.param(), ('unsigned*', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      If('0', [
        WL.push(0),
      ]),
      ForAll('wlione', WL.items(), [
        CDecl(('unsigned', 'wli', '= wlione * 2')),
        If('!(wli < wlione_end)', [
           CBlock(['break']),
        ]),
        CDecl(('int', 'edge', '')),
        CDecl(('int', 'src', '')),
        CDecl(('bool', 'pop', '')),
        WL.pop('pop', 'wli', 'edge'),
        WL.pop('pop', 'wli+1', 'src'),
        CBlock('intersect_dec(graph, src, graph.getAbsDestination(edge), degrees, triangles, eremoved, k, in_wl, out_wl)', parse=False),
      ]),
    ]),
    Kernel('edge_removal', [graph.param(), ('unsigned*', 'degrees'), ('unsigned*', 'eremoved')], [
      ForAll("v", graph.nodes(), [
        If('degrees[v] > 0', [
          ClosureHint(ForAll("edge", graph.edges("v"), [
            CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
            If('degrees[v] > 0 && eremoved[edge]', [
              CBlock('atomicSub(&degrees[v], 1)'),
            ]),
          ])),
        ]),
      ]),
    ]),
    Kernel('set_one_if_pos', [graph.param(), ('unsigned*', 'degrees'), ('unsigned*', 'degree_pos')], [
      ForAll('n', RangeIterator('graph.nnodes'), [
        If('degrees[n] > 0', [
          CBlock('degree_pos[n] = 1'),
        ]),
      ]),
    ]),
    Kernel('triangle_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('Shared<unsigned>&', 'degrees'), ('Shared<unsigned>&', 'triangles'), ('Shared<unsigned>&', 'eremoved'), ('unsigned*', 'n_ktruss_nodes')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('triangles.alloc(g.nedges)'),
      CBlock('triangles.zero_gpu()'),
      CBlock('eremoved.alloc(g.nedges)'),
      CBlock('eremoved.zero_gpu()'),
      CDecl(('Shared<unsigned int>', 'valid_edges', '(g.nnodes)')),
      CBlock("valid_edges.zero_gpu()"),
      Invoke("preprocess", ['gg']),
      CBlock('gg.copy_to_cpu(g)'),
      CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc);", parse=False),

      CBlock('#ifdef DEBUG'),
        CBlock('printf("src: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes+1', 'n++', [
          CFor(CDecl(('unsigned', 'e', '= g.row_start[n]')), 'e < g.row_start[n+1]', 'e++', [
            CBlock('printf("%u ", n)'),
          ]),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("dst: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes+1', 'n++', [
          CFor(CDecl(('unsigned', 'e', '= g.row_start[n]')), 'e < g.row_start[n+1]', 'e++', [
            CBlock('printf("%u ", g.edge_dst[e])'),
          ]),
        ]),
        CBlock('printf("\\n")'),
      CBlock('#endif'),

      Pipe([
        Invoke('init_triangles', ['gg', 'triangles.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'degrees.gpu_rd_ptr()', 'k']),

        CBlock('#ifdef DEBUG'),
          WL.display_items(0),
          CBlock('printf("tri: ")'),
          CFor(CDecl(('unsigned', 'i', '= 0')), 'i < g.nedges', 'i++', [
            CBlock('printf("%u ", triangles.cpu_rd_ptr()[i])'),
          ]),
          CBlock('printf("\\n")'),
          CBlock('printf("rem: ")'),
          CFor(CDecl(('unsigned', 'i', '= 0')), 'i < g.nedges', 'i++', [
            CBlock('printf("%u ", eremoved.cpu_rd_ptr()[i])'),
          ]),
          CBlock('printf("\\n")'),
        CBlock('#endif'),

        Pipe([
          Invoke('triangle_iter', ['gg', 'triangles.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'degrees.gpu_rd_ptr()', 'k']),

          CBlock('#ifdef DEBUG'),
            WL.display_items(0),
            CBlock('printf("tri: ")'),
            CFor(CDecl(('unsigned', 'i', '= 0')), 'i < g.nedges', 'i++', [
              CBlock('printf("%u ", triangles.cpu_rd_ptr()[i])'),
            ]),
            CBlock('printf("\\n")'),
            CBlock('printf("rem: ")'),
            CFor(CDecl(('unsigned', 'i', '= 0')), 'i < g.nedges', 'i++', [
              CBlock('printf("%u ", eremoved.cpu_rd_ptr()[i])'),
            ]),
            CBlock('printf("\\n")'),
          CBlock('#endif'),
        ]),
      ], wlinit=WLInit('g.nedges'), once=True),
      Invoke('edge_removal', ['gg', 'degrees.gpu_wr_ptr()', 'eremoved.gpu_rd_ptr()']),

      CBlock('#ifdef DEBUG'),
        CBlock('printf("ver: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", n)'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("deg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", degrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
      CBlock('#endif'),

      CDecl(('Shared<unsigned>', 'degree_pos', '(g.nnodes)')),
      CBlock('degree_pos.zero_gpu()'),
      Invoke('set_one_if_pos', ['gg', 'degrees.gpu_rd_ptr()', 'degree_pos.gpu_wr_ptr()']),
      CBlock('mgpu::Reduce(degree_pos.gpu_rd_ptr(), g.nnodes, 0U, mgpu::plus<unsigned>(), (unsigned*)0, n_ktruss_nodes, *mgc);', parse=False),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k')], [
      CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
      CDecl(('Shared<unsigned>', 'degrees', '')),
      CDecl(('Shared<unsigned>', 'vremoved', '')),
      CBlock('degree_filter(g, gg, k, degrees, vremoved)'),
      CDecl(('Shared<unsigned>', 'triangles', '')),
      CDecl(('Shared<unsigned>', 'eremoved', '')),
      CDecl(('unsigned', 'n_ktruss_nodes', '')),
      CBlock('triangle_filter(g, gg, k, degrees, triangles, eremoved, &n_ktruss_nodes)'),
      CBlock('printf("# ktruss nodes: %u\\n", n_ktruss_nodes)'),
    ]),
])
