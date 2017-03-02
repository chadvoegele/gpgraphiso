import gg.compiler
from gg.ast import *

WL = gg.lib.wl.Worklist()
dgraph = gg.lib.graph.Graph("dgraph")
qgraph = gg.lib.graph.Graph("qgraph")
tgraph = gg.lib.graph.Graph("tgraph")

ast = Module([
    CBlock([cgen.Include('edgelist_graph.h')]),
    CDeclGlobal(("const char*", "prog_opts", '= ""')),
    CDeclGlobal(("const char*", "prog_usage", '= ""')),
    CDeclGlobal(("const char*", "prog_args_usage", '= ""')),
    CDeclGlobal(("void", "process_prog_opt(char c, char *optarg)", "{ }")),
    CDeclGlobal(("int", "process_prog_arg(int argc, char *argv[], int arg_start)", "{ return 1; }")),
    CDeclGlobal(("extern int", "SKELAPP_RETVAL", "")),
    CDeclGlobal(("extern const char*", "OUTPUT", "")),
    Kernel("calc_selectivity", [dgraph.param(), qgraph.param(), ('int*', 'dprop_ptr'), ('int*', 'qprop_ptr'), ('float*', 'selectivity_ptr')], [
        ForAll("node", qgraph.nodes(), [
            CDecl(("int", "degree", "= %s" % qgraph.edges("node").size())),
            CDecl(("int", "freq", "= 0")),
            CDecl(("int", "qprop", "= qprop_ptr[node]")),
            ForAll("dnode", dgraph.nodes(), [
                If("qprop == dprop_ptr[dnode]",
                    [CBlock(['freq = freq + 1'])],
                    ),
                ]),
            CDecl(("float", "selectivity", "= 1.0*degree/freq")),
            CBlock(['selectivity_ptr[node] = selectivity']),
            ])
    ]),
    Kernel('build_tree', (qgraph.param(), ('float*', 'selectivity'), ('gpgraphlib::EdgeListGraph&', 'tree'), ('std::vector<index_type>&', 'tree_order')), [
        CDecl(('std::vector<std::tuple<index_type, index_type, float>>', 'worklist', '')),
        CDecl(('std::vector<unsigned>', 'add_to_tree', '(qgraph.nnodes)')),
        CBlock(['std::fill(add_to_tree.begin(), add_to_tree.end(), 1)'], parse=False),
        CFor(CDecl(('index_type', 'n', '= 0')), 'n != qgraph.nnodes', 'n++', [
            CFor(CDecl(('index_type', 'e', '= qgraph.row_start[n]')), 'e != qgraph.row_start[n+1]', 'e++', [
                CBlock(['worklist.push_back(std::make_tuple(n,qgraph.edge_dst[e],selectivity[n]+selectivity[qgraph.edge_dst[e]]))'], parse=False),
            ]),
        ]),
        While('!worklist.empty()', [
            CBlock(['std::sort(worklist.begin(), worklist.end(), [](std::tuple<index_type, index_type, float>& me, std::tuple<index_type, index_type, float>& other) { return std::get<2>(me) < std::get<2>(other);})'], parse=False),
            CDecl(('index_type', 'next_node', '= std::get<0>(worklist.back())')),
            CDecl(('index_type', 'next_dst', '= std::get<1>(worklist.back())')),
            CBlock(['worklist.pop_back()']),
            If('tree.nnodes() == 0', [
                CBlock('next_node = selectivity[next_node] > selectivity[next_dst] ? next_node : next_dst'),
                CBlock(['worklist.clear()']),
            ]),
            If('!add_to_tree[next_dst]', [CBlock('continue')]),
            CBlock(['tree_order.push_back(next_node)']),
            CBlock(['add_to_tree[next_node] = 0']),
            CFor(CDecl(('index_type', 'e', '= qgraph.row_start[next_node]')), 'e != qgraph.row_start[next_node+1]', 'e++', [
                If('add_to_tree[qgraph.edge_dst[e]]', [
                    CBlock(['tree.addEdge(next_node, qgraph.edge_dst[e])']),
                    CBlock(['tree.addEdge(qgraph.edge_dst[e], next_node)']),
                    CBlock(['add_to_tree[qgraph.edge_dst[e]] = 0']),
                    CFor(CDecl(('index_type', 'e2', '= qgraph.row_start[qgraph.edge_dst[e]]')), 'e2 != qgraph.row_start[qgraph.edge_dst[e]+1]', 'e2++', [
                        If('add_to_tree[qgraph.edge_dst[e2]]', [
                            CBlock(['worklist.push_back(std::make_tuple(qgraph.edge_dst[e],qgraph.edge_dst[e2],selectivity[qgraph.edge_dst[e]]+selectivity[qgraph.edge_dst[e2]]))'], parse=False),
                        ]),
                    ]),
                ]),
            ]),
        ]),
    ], host=True),
    Kernel('index2d', [('unsigned*', 'arr'), ('unsigned', 'nd'), ('index_type', 'x'), ('index_type', 'y')], [
        CBlock(['return arr + x*nd + y']),
    ], ret_type='unsigned*', host=True),
    # TODO: remove this when move non-IrGL to separate file
    Kernel('index2d_dev', [('unsigned*', 'arr'), ('unsigned', 'nd'), ('index_type', 'x'), ('index_type', 'y')], [
        CBlock(['return arr + x*nd + y']),
    ], ret_type='unsigned*', device=True),
    Kernel('is_candidate', [dgraph.param(), qgraph.param(), ('int*', 'dprop_ptr'), ('int*', 'qprop_ptr'), ('index_type', 'dv'), ('index_type', 'qv')], [
        CBlock(['return dprop_ptr[dv] == qprop_ptr[qv] && %s <= %s' % (qgraph.edges('qv').size(), dgraph.edges('dv').size())]),
    ], ret_type='bool', device=True),
    Kernel('kernel_check', [dgraph.param(), qgraph.param(), ('int*', 'dprop_ptr'), ('int*', 'qprop_ptr'), ('unsigned*', 'c_set'), ('index_type', 'qv')], [
        ForAll("n", qgraph.nodes(), [
            CBlock(['c_set[n] = is_candidate(dgraph, qgraph, dprop_ptr, qprop_ptr, n, qv)']),
        ]),
    ]),
    Kernel('kernel_collect', [dgraph.param(), ('unsigned*', 'c_set')], [
        ForAll("node", dgraph.nodes(), [
            If('c_set[node]', [
                WL.push("node"),
            ]),
        ])
    ]),
    Kernel('kernel_explore', [dgraph.param(), tgraph.param(), ('int*', 'dprop_ptr'), ('int*', 'qprop_ptr'), ('unsigned*', 'c_set'), ('index_type', 'qv')], [
        CDecl([('int', 'node', '')]),
        CDecl([('bool', 'pop', '')]),
        ForAll("wlnode", WL.items(), [
            WL.pop('pop', 'wlnode', 'node'),
            ForAll('qe', tgraph.edges('qv'), [
                CDecl(('index_type', 'v', '= tgraph.getAbsDestination(qe)')),
                CDecl(('bool', 'some_match', '= false')),
                ForAll('de', dgraph.edges('node'), [
                    CDecl(('index_type', 'vp', '= dgraph.getAbsDestination(de)')),
                    If('is_candidate(dgraph, tgraph, dprop_ptr, qprop_ptr, vp, v)', [
                        CBlock(['some_match = true']),
                    ]),
                ]),
                If('!some_match', [
                    CDecl(('unsigned*', 'c_set_idx', '= index2d_dev(c_set, %s, qv, node)' % dgraph.nodes().size())),
                    CBlock(['*c_set_idx = 0']),
                    CBlock(['break']),
                ]),
            ]),
            ForAll('qe2', tgraph.edges('qv'), [
                CDecl(('index_type', 'v', '= tgraph.getAbsDestination(qe2)')),
                ForAll('de', dgraph.edges('node'), [
                    CDecl(('index_type', 'vp', '= dgraph.getAbsDestination(de)')),
                    If('is_candidate(dgraph, tgraph, dprop_ptr, qprop_ptr, vp, v)', [
                        CDecl(('unsigned*', 'c_set_idx', '= index2d_dev(c_set, %s, v, vp)' % dgraph.nodes().size())),
                        CBlock(['*c_set_idx = 1']),
                    ]),
                ]),
            ]),
        ]),
    ]),
    Kernel('init_candidate_verticies', [dgraph.param(), tgraph.param(), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop'), ('std::vector<index_type>&', 'tree_order'), ('Shared<unsigned>&', 'c_set')], [
        CDecl(('dim3', 'blocks', '')),
        CDecl(('dim3', 'threads', '')),
        CBlock(['kernel_sizing(dgraph, blocks, threads)']),
        CDecl(('std::vector<unsigned>', 'initialized', '(%s)' % tgraph.nodes().size())),
        CDecl(('unsigned*', 'c_set_gptr', '= c_set.gpu_wr_ptr()')),
        CFor(CDecl(('std::vector<index_type>::iterator', 'u', '= tree_order.begin()')), 'u != tree_order.end()', 'u++', [
            If('!initialized[*u]', [
                Invoke('kernel_check', ('dgraph', 'tgraph', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'index2d(c_set_gptr, %s, *u, 0)' % dgraph.nodes().size(), '*u')),
                CBlock(['initialized[*u]=1']),
            ]),
            ClosureHint(Pipe([
                Invoke('kernel_collect', ('dgraph', 'index2d(c_set_gptr, %s, *u, 0)' % dgraph.nodes().size())),
                Invoke('kernel_explore', ('dgraph', 'tgraph', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'c_set_gptr', '*u')),
            ], wlinit=WLInit("65535", []), once=True)),
            CFor(CDecl(('index_type', 'e', '= tgraph.row_start[*u]')), 'e != tgraph.row_start[*u]', 'e++', [
                CBlock(['initialized[tgraph.edge_dst[e]]=1']),
            ]),
        ]),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
        CDecl(('Shared<float>', 'selectivity', '= qg.nnodes')),
        Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),
        CDecl(('gpgraphlib::EdgeListGraph', 'tree', '')),
        CDecl(('std::vector<index_type>', 'tree_order', '')),
        CBlock(['build_tree(qg, selectivity.cpu_rd_ptr(), tree, tree_order)']),
        CDecl(('Shared<unsigned>', 'c_set', '= tree.nnodes()*g.nnodes')),
        CDecl(('CSRGraphTex', 'tg', '')),
        CDecl(('CSRGraphTex', 'tgg', '')),
        CBlock(['tg.nnodes = tree.nnodes()', 'tg.nedges = tree.nedges()', 'tg.allocOnHost()', 'tree.setCSR(tg.row_start, tg.edge_dst)', 'tg.copy_to_gpu(tgg);']),
        CBlock(['init_candidate_verticies(gg, tgg, dprop, qprop, tree_order, c_set)']),
        ])
    ])
