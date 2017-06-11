import gg.compiler
from gg.ast import *
from gg.ast.params import *
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
    Kernel('init_degree', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'vremoved'), ('unsigned', 'k')], [
      ForAll('src', graph.nodes(), [
        For('edge', graph.edges('src'), [
          CDecl(('int', 'dst', '= graph.getAbsDestination(edge)')),
          If('!vremoved[dst]', [
            CBlock('outdegrees[src]++'),
            CBlock('atomicAdd(&indegrees[dst], 1U)'),
          ]),
        ]),
      ]),
    ]),
    Kernel('mark_degree', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'vremoved'), ('unsigned', 'k')], [
      ForAll('src', graph.nodes(), [
        If('outdegrees[src] < k - 1', [
          CBlock('vremoved[src] = 1'),
        ]),
      ]),
    ]),
    Kernel('degree_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('Shared<unsigned>&', 'outdegrees'), ('Shared<unsigned>&', 'indegrees'), ('Shared<unsigned>&', 'vremoved')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('outdegrees.alloc(g.nnodes)'),
      CBlock('outdegrees.zero_gpu()'),
      CBlock('indegrees.alloc(g.nnodes)'),
      CBlock('indegrees.zero_gpu()'),
      CBlock('vremoved.alloc(g.nnodes)'),
      CBlock('vremoved.zero_gpu()'),
      Invoke('init_degree', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'k']),
      #Invoke('mark_degree', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'k']),

      CBlock('#ifdef DEBUG'),
        CBlock('printf("ver: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", n)'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("outdeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", outdegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("indeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", indegrees.cpu_rd_ptr()[n])'),
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
    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned*', 'vremoved'), ('unsigned*', 'eremoved')], [
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
            If('d == 0 && !vremoved[a] && !eremoved[u_it] && !eremoved[v_it]', [CBlock('count++')]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
        CBlock('return count'),
    ], device=True, ret_type = 'unsigned int'),
    Kernel('init_triangles', [graph.param(), ('unsigned*', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned*', 'vremoved'), ('unsigned', 'k')], [
      ForAll("v", graph.nodes(), [
        ClosureHint(ForAll("edge", graph.edges("v"), [
          CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
          CBlock('triangles[edge] = intersect(graph, u, v, vremoved, eremoved)'),
        ])),
      ]),
    ]),
    Kernel('mark_triangles', [graph.param(), ('unsigned*', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned', 'k'), ('unsigned*', 'removed_edge')], [
      ForAll("v", graph.nodes(), [
        ClosureHint(ForAll("edge", graph.edges("v"), [
          If('!eremoved[edge]', [
            CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
            If('triangles[edge] < k-2', [
              CBlock('eremoved[edge] = 1'),
              CBlock('*removed_edge = 1'),
            ]),
          ]),
        ])),
      ]),
    ]),
    Kernel('edge_removal', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'eremoved'), ('unsigned*', 'vremoved')], [
      ForAll('src', graph.nodes(), [
        # Remove isolate vertices
        If('outdegrees[src] == 0 && indegrees[src] == 0', [
          CBlock('vremoved[src] = 1'),
        ]),
        ClosureHint(ForAll('edge', graph.edges('src'), [
          CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
          If('eremoved[edge]', [
            CBlock('outdegrees[src]--'),
            CBlock('atomicSub(&indegrees[dst], 1U)'),
            If('outdegrees[src] == 0 && indegrees[src] == 0', [
              CBlock('vremoved[src] = 1'),
            ]),
            If('outdegrees[dst] == 0 && indegrees[dst] == 0', [
              CBlock('vremoved[dst] = 1'),
            ]),
          ]),
        ])),
      ]),
    ]),
    Kernel('triangle_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('Shared<unsigned>&', 'outdegrees'), ('Shared<unsigned>&', 'indegrees'), ('Shared<unsigned>&', 'triangles'), ('Shared<unsigned>&', 'eremoved'), ('Shared<unsigned>&', 'vremoved'), ('unsigned*', 'n_ktruss_nodes'), ('unsigned*', 'n_ktruss_edges')], [
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

      CDecl(('Shared<unsigned>', 'removed_edge', '(1)')),
      CBlock('*removed_edge.cpu_wr_ptr() = 1'),
      While('*removed_edge.cpu_wr_ptr()', [
        CBlock('*removed_edge.cpu_wr_ptr() = 0'),
        Invoke('init_triangles', ['gg', 'triangles.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'vremoved.gpu_rd_ptr()', 'k']),
        Invoke('mark_triangles', ['gg', 'triangles.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'k', 'removed_edge.gpu_wr_ptr()']),
      ]),
      Invoke('edge_removal', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'eremoved.gpu_rd_ptr()', 'vremoved.gpu_rd_ptr()']),

      CBlock('#ifdef DEBUG'),
        CBlock('printf("ver: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", n)'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("outdeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", outdegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("indeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", indegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
      CBlock('#endif'),

      CDecl(('unsigned', 'n_nodes_removed', '= 0')),
      CBlock('mgpu::Reduce(vremoved.gpu_rd_ptr(), g.nnodes, 0U, mgpu::plus<unsigned>(), (unsigned*)0, &n_nodes_removed, *mgc);', parse=False),
      CBlock('*n_ktruss_nodes = g.nnodes - n_nodes_removed'),

      CDecl(('unsigned', 'n_edges_removed', '= 0')),
      CBlock('mgpu::Reduce(eremoved.gpu_rd_ptr(), g.nedges, 0U, mgpu::plus<unsigned>(), (unsigned*)0, &n_edges_removed, *mgc);', parse=False),
      CBlock('*n_ktruss_edges = g.nedges - n_edges_removed'),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k')], [
      CBlock('#ifdef DEBUG'),
        CBlock('printf("# nodes: %u\\n", g.nnodes)'),
        CBlock('printf("# edges: %u\\n", g.nedges)'),
      CBlock('#endif'),

      CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
      CDecl(('Shared<unsigned>', 'outdegrees', '')),
      CDecl(('Shared<unsigned>', 'indegrees', '')),
      CDecl(('Shared<unsigned>', 'vremoved', '')),
      CBlock('degree_filter(g, gg, k, outdegrees, indegrees, vremoved)'),
      CDecl(('Shared<unsigned>', 'triangles', '')),
      CDecl(('Shared<unsigned>', 'eremoved', '')),
      CDecl(('unsigned', 'n_ktruss_nodes', '')),
      CDecl(('unsigned', 'n_ktruss_edges', '')),
      CBlock('triangle_filter(g, gg, k, outdegrees, indegrees, triangles, eremoved, vremoved, &n_ktruss_nodes, &n_ktruss_edges)'),
      CBlock('printf("# ktruss nodes: %u\\n", n_ktruss_nodes)'),
      CBlock('printf("# ktruss edges: %u\\n", n_ktruss_edges)'),
    ]),
])
