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
    CDecl(('unsigned', 'KTRUSS_K', '= 3')),
    CDecl(('int', 'CUDA_DEVICE', '= 0')),
    CDecl(('mgpu::ContextPtr', 'mgc', '')),
    # Instead of graph.nnodes, use 2*graph.nnodes. atomicDec can be called at most graph.nnodes
    # times on a particular vertex. After iterations, degree will still be higher than graph.nnodes.
    Kernel('init_degree', [graph.param(), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      ForAll("node", graph.nodes(), [
        CDecl(('int', 'degree', '= graph.getOutDegree(node)')),
        CBlock('degrees[node] = degree'),
        If('degrees[node] < k - 1', [
          WL.push("node"),
          CBlock('atomicExch(&degrees[node], 2*graph.nnodes)'),
        ]),
      ]),
    ]),
    Kernel('degree_filter_iter', [graph.param(), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      ForAll('wli', WL.items(), [
        CDecl(('int', 'src', '')),
        CDecl(('bool', 'pop', '')),
        WL.pop('pop', 'wli', 'src'),
        For('edge', graph.edges('src'), [
          CDecl(('int', 'dst', '= graph.getAbsDestination(edge)')),
          CBlock('atomicDec(&degrees[dst], 2*graph.nnodes)'),
          If('degrees[dst] < k - 1', [
            WL.push('dst'),
            CBlock('atomicExch(&degrees[dst], 2*graph.nnodes)'),
          ]),
        ]),
      ]),
    ]),
    Kernel('degree_filter_finalize', [graph.param(), ('unsigned*', 'degrees')], [
      ForAll('n', RangeIterator('graph.nnodes'), [
        CBlock('degrees[n] = degrees[n] > graph.nnodes ? 0 : degrees[n]'),
      ]),
    ]),
    Kernel('degree_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('Shared<unsigned>&', 'degrees')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('degrees.alloc(g.nnodes)'),
      Pipe([
        Invoke('init_degree', ['gg', 'degrees.gpu_wr_ptr()', 'KTRUSS_K']),
        Pipe([
          Invoke('degree_filter_iter', ['gg', 'degrees.gpu_wr_ptr()', 'KTRUSS_K']),
        ]),
      ], wlinit=WLInit('g.nnodes'), once=True),
      Invoke('degree_filter_finalize', ['gg', 'degrees.gpu_wr_ptr()']),
    ], host=True),
    Kernel("preprocess", [graph.param(), ('unsigned int *', 'valid_edges')], [
        CDecl(('const index_type', 'last', ' = graph.nnodes')),
        ForAll("node", graph.nodes(), [
            CDecl(('bool', 'pop', '')),
            CDecl(('int', 'degree', '')),
            Assign('pop', graph.valid_node("node")),
            If("pop", [
                CBlock('degree = graph.getOutDegree(node)')
            ]),
            ClosureHint(ForAll("edge", graph.edges("node"), [
                CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
                CDecl(('int', 'dst_degree', '= graph.getOutDegree(dst)')),
                If('(dst_degree > degree) || (dst_degree == degree && dst > node)', [
                    CBlock(["graph.edge_data[edge] = dst"]),
                    CBlock(["atomicAdd(valid_edges + node, 1)"]),
                ], [
                    # + dst, makes resulting edge_dst = [ sorted valid, sorted invalid ]
                    CBlock(["graph.edge_data[edge] = graph.nnodes + dst" ]),
                ]),
            ])),
        ])
    ]),
    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned int *', 'valid_edges'), ('unsigned *', 'count'), ('index_type', 'edge')], [
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= u_start + valid_edges[u]')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= v_start + valid_edges[v]')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        While('u_it < u_end && v_it < v_end', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d == 0', [
                CBlock('atomicAdd(count + u_it, 1)'),
                CBlock('atomicAdd(count + v_it, 1)'),
                CBlock('atomicAdd(count + edge, 1)'),
            ]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
    ], device=True),
    Kernel('init_triangles', [graph.param(), ('unsigned*', 'valid_edges'), ('unsigned*', 'triangles'), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      ForAll("v", graph.nodes(), [
        If('degrees[v] > 0', [
          CDecl(('bool', 'pop', '')),
          Assign('pop', graph.valid_node("v")),
          ClosureHint(ForAll("edge", graph.edges("v", limit='valid_edges[v]'), [
            CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
            If('degrees[u] > 0', [
              CBlock('intersect(graph, u, v, valid_edges, triangles, edge)'),
            ]),
          ])),
        ]),
      ]),
    ]),
    Kernel("intersect_iter", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned int *', 'valid_edges'), ('unsigned *', 'count'), ('index_type', 'edge'), ('unsigned', 'k'), ('int*', 'done')], [
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= u_start + valid_edges[u]')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= v_start + valid_edges[v]')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        While('u_it < u_end && v_it < v_end', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d == 0', [
                If('count[u_it] < k-2 || count[v_it] < k-2 || count[edge] < k-2', [
                  If('count[u_it] < k-2', [
                    CBlock('atomicExch(&count[u_it], 2*graph.nedges)'),
                  ], [
                    CBlock('atomicDec(&count[u_it], 2*graph.nedges)'),
                    CBlock('*done = 0'),
                  ]),
                  If('count[v_it] < k-2', [
                    CBlock('atomicExch(&count[v_it], 2*graph.nedges)'),
                  ], [
                    CBlock('atomicDec(&count[v_it], 2*graph.nedges)'),
                    CBlock('*done = 0'),
                  ]),
                  If('count[edge] < k-2', [
                    CBlock('atomicExch(&count[edge], 2*graph.nedges)'),
                  ], [
                    CBlock('atomicDec(&count[edge], 2*graph.nedges)'),
                    CBlock('*done = 0'),
                  ]),
                ]),
            ]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
    ], device=True),
    Kernel('triangle_iter', [graph.param(), ('unsigned*', 'valid_edges'), ('unsigned*', 'triangles'), ('unsigned*', 'degrees'), ('unsigned', 'k'), ('int*', 'done')], [
      ForAll("v", graph.nodes(), [
        If('degrees[v] > 0', [
          CDecl(('bool', 'pop', '')),
          Assign('pop', graph.valid_node("v")),
          ClosureHint(ForAll("edge", graph.edges("v", limit='valid_edges[v]'), [
            CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
            If('degrees[u] > 0', [
              CBlock('intersect_iter(graph, u, v, valid_edges, triangles, edge, k, done)'),
            ]),
          ])),
        ]),
      ]),
    ]),
    Kernel('triangle_degree_dec', [graph.param(), ('unsigned*', 'valid_edges'), ('unsigned*', 'triangles'), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      ForAll("v", graph.nodes(), [
        If('degrees[v] > 0', [
          CDecl(('bool', 'pop', '')),
          Assign('pop', graph.valid_node("v")),
          ClosureHint(ForAll("edge", graph.edges("v", limit='valid_edges[v]'), [
            CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
            If('degrees[u] > 0 && (triangles[edge] > graph.nedges || triangles[edge] < k-2)', [
              CBlock('atomicSub(&degrees[u], 1)'),
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
    Kernel('triangle_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('Shared<unsigned>&', 'degrees'), ('Shared<unsigned>&', 'triangles')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('triangles.alloc(g.nedges)'),
      CBlock('triangles.zero_gpu()'),
      CDecl(('Shared<unsigned int>', 'valid_edges', '(g.nnodes)')),
      CBlock("valid_edges.zero_gpu()"),
      Invoke("preprocess", ['gg', 'valid_edges.gpu_wr_ptr()']),
      CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc);", parse=False),
      Invoke('init_triangles', ['gg', 'valid_edges.gpu_rd_ptr()', 'triangles.gpu_wr_ptr()', 'degrees.gpu_rd_ptr()', 'KTRUSS_K']),
      CDecl(('Shared<int>', 'done', '(1)')),
      CBlock('done.cpu_wr_ptr()[0] = 0'),
      While('!done.cpu_rd_ptr()[0]', [
        CBlock('done.cpu_wr_ptr()[0] = 1'),
        Invoke('triangle_iter', ['gg', 'valid_edges.gpu_rd_ptr()', 'triangles.gpu_wr_ptr()', 'degrees.gpu_rd_ptr()', 'KTRUSS_K', 'done.gpu_wr_ptr()']),
      ]),
      Invoke('triangle_degree_dec', ['gg', 'valid_edges.gpu_rd_ptr()', 'triangles.gpu_rd_ptr()', 'degrees.gpu_wr_ptr()', 'KTRUSS_K']),
      CDecl(('Shared<unsigned>', 'degree_pos', '(g.nnodes)')),
      CBlock('degree_pos.zero_gpu()'),
      Invoke('set_one_if_pos', ['gg', 'degrees.gpu_rd_ptr()', 'degree_pos.gpu_wr_ptr()']),
      CDecl(('unsigned', 'ktruss_nodes', '')),
      CBlock('mgpu::Reduce(degree_pos.gpu_rd_ptr(), g.nnodes, 0U, mgpu::plus<unsigned>(), (unsigned*)0, &ktruss_nodes, *mgc);', parse=False),
      CBlock('printf("# ktruss nodes=%u\\n", ktruss_nodes)'),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True)], [
      CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
      CDecl(('Shared<unsigned>', 'degrees', '')),
      CBlock('degree_filter(g, gg, degrees)'),
      CDecl(('Shared<unsigned>', 'triangles', '')),
      CBlock('triangle_filter(g, gg, degrees, triangles)'),
    ]),
])
