import gg.compiler
from gg.ast import *
import gg.lib.aol
from gg.types import RangeIterator

WL = gg.lib.wl.Worklist()
max_ktruss_nodes = gg.lib.aol.AppendOnlyList('max_ktruss_nodes')
graph = gg.lib.graph.Graph('graph')

def EL(node):
    return LaunchConfig(node, blocks = "edge_blocks")

def NL(node):
    return LaunchConfig(node, blocks = "node_blocks")

ast = Module([
    CBlock([cgen.Include("kernels/segmentedsort.cuh")]),
    CBlock([cgen.Include("kernels/reducebykey.cuh")]),
    CBlock([cgen.Include("ktruss.h")]),
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
    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned int *', 'valid_edges'), ('int *', 'count'), ('index_type', 'edge')], [
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
    Kernel("count_triangles", [graph.param(), ('unsigned int *', 'valid_edges'), ('int *', 'count')], [
        CDecl(('int', 'lcount', '=0')),
        ForAll("v", graph.nodes(), [
            CDecl(('bool', 'pop', '')),
            Assign('pop', graph.valid_node("v")),
            ClosureHint(ForAll("edge", graph.edges("v", limit='valid_edges[v]'), [
                CDecl(('index_type', 'u', '= graph.getAbsDestination(edge)')),
                CDecl(('index_type', 'd_u', '= graph.getOutDegree(u)')),
                CBlock('intersect(graph, u, v, valid_edges, count, edge)'),
            ])),
        ]),
    ]),
    Kernel("count_triangle_back_edge", [graph.param(), ('unsigned int *', 'valid_edges'), ('int *', 'count')], [
        ForAll('src', graph.nodes(), [
            ClosureHint(ForAll("edge", graph.edges('src', limit='valid_edges[src]'), [
                CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
                CDecl(('index_type', 'back_idx', '= findBackEdge(graph, src, dst, valid_edges)')),
                CBlock('count[back_idx] = count[edge]'),
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
        Invoke('count_triangle_back_edge', ['gg', 'valid_edges.gpu_rd_ptr()', 'count.gpu_wr_ptr()']),
    ], host=True),
    Kernel("init", [graph.param()], [
        ForAll("node", graph.nodes(), [CBlock("graph.node_data[node] = node")])
    ]),
    # no equivalent since this preps the edge list
    Kernel("prep_edge_src", [graph.param(), ('index_type *', 'edge_src')], [
        ForAll("node", graph.nodes(), [
            CDecl(('bool', 'pop', '')),
            Assign('pop', graph.valid_node("node")),
            ClosureHint(ForAll("edge", graph.edges("node"), [
                CBlock("edge_src[edge] = node")
            ]))
        ])
    ]),
    # _Select_winner_init
    Kernel("hook_init", [graph.param(), ('index_type *', 'edge_src'), ('int*', 'edge_tri_count')], [
        ForAll("edge", RangeIterator("graph.nedges"), [
            If('edge_tri_count[edge] > 0', [
                CDecl(('index_type', 'x', '= edge_src[edge]')),
                CDecl(('index_type', 'y', '= graph.getAbsDestination(edge)')),
                CDecl(('index_type', 'mx', '= x > y ? x : y')),
                CDecl(('index_type', 'mn', '= x > y ? y : x')),
                CBlock("graph.node_data[mx] = mn"),
            ]),
        ]),
    ]),
    # select_winner2
    Kernel("hook_high_to_low", [graph.param(), ('const __restrict__ index_type *', 'edge_src'), ('char *', 'marks'), ('int*', 'edge_tri_count')], [
        ForAll("edge", RangeIterator("graph.nedges"), [
            If('edge_tri_count[edge] > 0', [
                If("!marks[edge]", [
                    CDecl(('index_type', 'u', '= edge_src[edge]')),
                    CDecl(('index_type', 'v', '= graph.getAbsDestination(edge)')),
                    CDecl(('node_data_type', 'p_u', '= graph.node_data[u]')),
                    CDecl(('node_data_type', 'p_v', '= graph.node_data[v]')),
                    CDecl(('index_type', 'mx', '= p_u > p_v ? p_u : p_v')),
                    CDecl(('index_type', 'mn', '= p_u > p_v ? p_v : p_u')),
                    If("mx == mn", [
                        CBlock("marks[edge] = 1")
                    ], [
                        CBlock("graph.node_data[mn] = mx"),
                        ReturnFromParallelFor("true")
                    ]),
                ]),
            ]),
        ])
    ]),
    # select_winner
    Kernel("hook_low_to_high", [graph.param(), ('index_type *', 'edge_src'), ('char *', 'marks'), ('int*', 'edge_tri_count')], [
        ForAll("edge", RangeIterator("graph.nedges"), [
            If('edge_tri_count[edge] > 0', [
                If("!marks[edge]", [
                    CDecl(('index_type', 'u', '= edge_src[edge]')),
                    CDecl(('index_type', 'v', '= graph.getAbsDestination(edge)')),
                    CDecl(('node_data_type', 'p_u', '= graph.node_data[u]')),
                    CDecl(('node_data_type', 'p_v', '= graph.node_data[v]')),
                    CDecl(('index_type', 'mx', '= p_u > p_v ? p_u : p_v')),
                    CDecl(('index_type', 'mn', '= p_u > p_v ? p_v : p_u')),
                    If("mx == mn", [
                        CBlock("marks[edge] = 1")
                    ], [
                        CBlock("graph.node_data[mx] = mn"),
                        ReturnFromParallelFor("true")
                    ]),
                ]),
            ]),
        ])
    ]),
    # p_jump
    Kernel("p_jump", [graph.param()], [
        ForAll("node", graph.nodes(), [
            CDecl(('node_data_type', 'p_u', '= graph.node_data[node]')),
            CDecl(('node_data_type', 'p_v', '= graph.node_data[p_u]')),
            If("p_u != p_v", [
                CBlock("graph.node_data[node] = p_v"),
                ReturnFromParallelFor("true"),
            ])
        ])
    ]),
    # update_mask, note we use worklists, not masks
    Kernel("identify_roots", [graph.param()], [
        ForAll("node", graph.nodes(), [
            If("graph.node_data[node] == node", [
                WL.push("node")
            ]),
        ])
    ]),
    # p_jump_masked, but using a worklist
    Kernel("p_jump_roots", [graph.param()], [
        ForAll("wlnode", WL.items(), [
            CDecl(('bool', 'pop', '')),
            CDecl(('int', 'node', '')),
            WL.pop("pop", "wlnode", "node"),
            CDecl(('node_data_type', 'p_u', '= graph.node_data[node]')),
            CDecl(('node_data_type', 'p_v', '= graph.node_data[p_u]')),
            If("p_u != p_v", [
                CBlock("graph.node_data[node] = p_v"),
                ReturnFromParallelFor("true"),
            ])
        ])
    ]),
    # p_jump_unmasked, using a worklist
    Kernel("p_jump_leaves", [graph.param()], [
        ForAll("node", graph.nodes(), [
            CDecl(('node_data_type', 'p_u', '= graph.node_data[node]')),
            CDecl(('node_data_type', 'p_v', '= graph.node_data[p_u]')),
            If("p_u != p_v", [
                CBlock("graph.node_data[node] = p_v")
            ])
        ])
    ]),
    # same, but this is counted in timing, maybe use ReturnSum
    Kernel("count_components", [graph.param(), ('int *', 'count')], [
        ForAll("node", graph.nodes(), [
            If("node == graph.node_data[node]", [
                CBlock("atomicAdd(count, 1)")
            ])
        ]),
    ]),
    Kernel('set_gpu_ones', [('unsigned*', 'data'), ('unsigned', 'size')], [
        ForAll('i', RangeIterator('size', ty='unsigned'), [
            CBlock('data[i] = 1'),
        ]),
    ]),
    Kernel('set_gpu_ascending', [('unsigned*', 'data'), ('unsigned', 'size')], [
        ForAll('i', RangeIterator('size', ty='unsigned'), [
            CBlock('data[i] = i'),
        ]),
    ]),
    Kernel('set_ktruss_nodes', [graph.param(), max_ktruss_nodes.param(), ('unsigned*', 'indices'), ('int*', 'components'), ('unsigned*', 'max_component_head_index')], [
        ForAll("node", graph.nodes(), [
            If('graph.node_data[node] == components[*max_component_head_index]', [
                max_ktruss_nodes.push('indices[node]'),
            ])
        ]),
    ]),
    Kernel('maximal_ktruss', [('CSRGraphTy&', 'g'), ('CSRGraphTy&', 'gg'), ('Shared<int>&', 'edge_tri_count'), ('int&', 'max_ktruss_size'), max_ktruss_nodes.param()], [
        CDecl(('dim3', 'blocks', '')),
        CDecl(('dim3', 'threads', '')),
        CBlock(['kernel_sizing(g, blocks, threads)']),
        Names(['edge_data_type']),
        CDecl([('int', 'it_hk', '= 1'),]),
        CDecl([('Shared<index_type>', 'edge_src', '(gg.nedges)')]),
        CDecl([('Shared<char>', 'edge_marks', '(gg.nedges)')]),
        CDecl(('bool', 'flag', '= false')),
        CDecl(('int', 'edge_blocks', '')),
        CDecl(('int', 'node_blocks', '')),
        CBlock("edge_blocks = g.nedges / TB_SIZE + 1"),
        CBlock("node_blocks = g.nnodes / TB_SIZE + 1"),
        CBlock('edge_marks.zero_gpu()'),
        NL(Invoke("prep_edge_src", ["gg", "edge_src.gpu_wr_ptr()"])),
        NL(Invoke("init", ["gg"])),
        EL(Invoke("hook_init", ["gg", "edge_src.gpu_rd_ptr()", 'edge_tri_count.gpu_rd_ptr()'])),
        NL(ClosureHint(Iterate("while", "any", "p_jump", ["gg"]))),
        Pipe([DoWhile("flag", [
            Invoke("identify_roots", ["gg"]),
            If("it_hk != 0", [
                EL(Invoke("hook_low_to_high", ["gg", "edge_src.gpu_rd_ptr()", "edge_marks.gpu_wr_ptr()", 'edge_tri_count.gpu_rd_ptr()'])),
                CBlock("flag = *(retval.cpu_rd_ptr())", parse=False, _scope="cpu"),
                CBlock("flag = _rv.local", parse=False, _scope="gpu"),
                CBlock("it_hk = (it_hk + 1) % 4")
            ], [
                EL(Invoke("hook_high_to_low", ["gg", "edge_src.gpu_rd_ptr()", "edge_marks.gpu_wr_ptr()", 'edge_tri_count.gpu_rd_ptr()'])),
                CBlock("flag = *(retval.cpu_rd_ptr())", parse=False, _scope="cpu"),
                CBlock("flag = _rv.local", parse=False, _scope="gpu"),
            ]),
            If("!flag", [CBlock("break")]),
            ClosureHint(Iterate("while", "any", "p_jump_roots", ["gg"])),
            NL(Invoke("p_jump_leaves", ["gg"])),
        ])], wlinit=WLInit("gg.nnodes", []), once=True),
        #CBlock('printf("iterations: %d\\n", it_hk)'),
        CDecl(('Shared<int>', 'ncomponents', '(1)')),
        CBlock("*(ncomponents.cpu_wr_ptr()) = 0"),
        Invoke("count_components", ['gg', 'ncomponents.gpu_wr_ptr()']),
        CDecl(('Shared<unsigned>', 'ones', '(g.nnodes)')),
        Invoke('set_gpu_ones', ['ones.gpu_wr_ptr()', 'g.nnodes']),
        CDecl(('Shared<unsigned>', 'indices', '(g.nnodes)')),
        Invoke('set_gpu_ascending', ['indices.gpu_wr_ptr()', 'g.nnodes']),
        CDecl(('Shared<int>', 'components', '(*(ncomponents.cpu_rd_ptr()))')),
        CDecl(('Shared<unsigned>', 'component_size', '(*(ncomponents.cpu_rd_ptr()))')),
        CBlock('mgpu::MergesortPairs(gg.node_data, indices.gpu_wr_ptr(), g.nnodes, mgpu::less<int>(), *mgc);', parse=False),
        CBlock('mgpu::ReduceByKey(gg.node_data, ones.gpu_wr_ptr(), g.nnodes, 0U, mgpu::plus<unsigned>(), mgpu::equal_to<int>(), components.gpu_wr_ptr(), component_size.gpu_wr_ptr(), 0, 0, *mgc);', parse=False),
        CBlock('mgpu::Reduce(component_size.gpu_wr_ptr(), *(ncomponents.cpu_rd_ptr()), INT_MIN, mgpu::maximum<int>(), (int*)0, &max_ktruss_size, *mgc);', parse=False),
        CDecl(('Shared<unsigned>', 'max_component_head_index', '(1)')),
        CDecl(('Shared<unsigned>', 'max_component_indices', '(*(ncomponents.cpu_rd_ptr()))')),
        Invoke('set_gpu_ascending', ['max_component_indices.gpu_wr_ptr()', '(*(ncomponents.cpu_rd_ptr()))']),
        CBlock('mgpu::Reduce(max_component_indices.gpu_wr_ptr(), *(ncomponents.cpu_rd_ptr()), 0U, ' +
                             'max_index<unsigned, unsigned>(component_size.gpu_rd_ptr()), ' +
                             'max_component_head_index.gpu_wr_ptr(), (unsigned*)0, *mgc)', parse=False),
        Invoke('set_ktruss_nodes', ['gg', 'max_ktruss_nodes', 'indices.gpu_rd_ptr()', 'components.gpu_rd_ptr()', 'max_component_head_index.gpu_rd_ptr()']),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True)], [
        CDecl(('Shared<int>', 'count', '(g.nedges)')),
        CBlock(['count_triangle_edges(g, gg, count)']),
        CDecl(('int', 'max_ktruss_size', '')),
        CDecl(('AppendOnlyList', 'max_ktruss_nodes', '(g.nnodes)')),
        CBlock(['maximal_ktruss(g, gg, count, max_ktruss_size, max_ktruss_nodes)']),
        CDecl(('std::vector<int>', 'ktruss_nodes_vec', '(max_ktruss_nodes.nitems())')),
        CBlock(['ktruss_nodes_vec.assign(max_ktruss_nodes.list.cpu_rd_ptr(), max_ktruss_nodes.list.cpu_rd_ptr()+max_ktruss_nodes.nitems())']),
        CBlock('printf("max ktruss # nodes: %d\\n", max_ktruss_size)'),
        CFor(CDecl(('unsigned', 'i', ' = 0')), 'i < ktruss_nodes_vec.size()', 'i++', [
          CBlock('printf("ktruss node[%u]=%d\\n", i, ktruss_nodes_vec[i])'),
        ]),
    ]),
])
