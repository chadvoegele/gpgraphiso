import gg.compiler
from gg.ast import *
import gg.lib.aol

WL = gg.lib.wl.Worklist()
graph = gg.lib.graph.Graph('graph')

ast = Module([
    CBlock([cgen.Include("kernels/segmentedsort.cuh")]),
    CDecl(('int', 'CUDA_DEVICE', '= 0')),
    CDecl(('mgpu::ContextPtr', 'mgc', '')),
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
                #Remove symmetry breaking to count all edges for ktruss building.
                #If('(dst_degree > degree) || (dst_degree == degree && dst > node)', [
                    CBlock(["graph.edge_data[edge] = dst"]),
                    CBlock(["atomicAdd(valid_edges + node, 1)"]),
                #], [
                    #CBlock(["graph.edge_data[edge] = graph.nnodes" ]),
                #]),
            ])),
        ])
    ]),
    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned int *', 'valid_edges')], [
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= u_start + valid_edges[u]')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= v_start + valid_edges[v]')),
        CDecl(('int', 'count', '= 0')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        While('u_it < u_end && v_it < v_end', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
            If('d == 0', [CBlock('count++')]),
        ]),
        CBlock('return count'),
    ], device=True, ret_type = 'unsigned int'),
    Kernel("count_triangles", [graph.param(), ('unsigned int *', 'valid_edges'), ('int *', 'count')], [
        CDecl(('int', 'lcount', '=0')),
        ForAll("v", graph.nodes(), [
            CDecl(('bool', 'pop', '')),
            CDecl(('int', 'd_v', '')),
            Assign('pop', graph.valid_node("v")),
            ClosureHint(ForAll("edge", graph.edges("v", limit='valid_edges[v]'), [
                CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
                CDecl(('index_type', 'd_u', '= graph.getOutDegree(u)')),
                CDecl(('int', 'xcount', '= 0')),
                CBlock('count[edge] = intersect(graph, u, v, valid_edges)'),
            ])),
        ]),
    ]),
    Kernel('count_triangle_edges', [('CSRGraphTy&', 'g'), ('CSRGraphTy&', 'gg'), ('Shared<int>&', 'count')], [
        CDecl(('dim3', 'blocks', '')),
        CDecl(('dim3', 'threads', '')),
        CBlock(['kernel_sizing(g, blocks, threads)']),
        CBlock("count.zero_gpu()"),
        CDecl(('Shared<unsigned int>', 'valid_edges', '(g.nnodes)')),
        CBlock("valid_edges.zero_gpu()"),
        Invoke("preprocess", ['gg', 'valid_edges.gpu_wr_ptr()']),
        CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc);", parse=False),
        Invoke("count_triangles", ['gg', 'valid_edges.gpu_rd_ptr()', 'count.gpu_wr_ptr()']),
    ], host=True),
])
