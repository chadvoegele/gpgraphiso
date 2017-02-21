import gg.compiler
from gg.ast import *

WL = gg.lib.wl.Worklist()
dgraph = gg.lib.graph.Graph("dgraph")
qgraph = gg.lib.graph.Graph("qgraph")

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
                CBlock(['worklist.push_back(std::make_tuple(n,qgraph.edge_dst[e],selectivity[n]+selectivity[e]))'], parse=False),
            ]),
        ]),
        While('!worklist.empty()', [
            CBlock(['std::sort(worklist.begin(), worklist.end(), [](std::tuple<index_type, index_type, float>& me, std::tuple<index_type, index_type, float>& other) { return std::get<2>(me) < std::get<2>(other);})'], parse=False),
            CDecl(('index_type', 'next_src', '= std::get<0>(worklist.back())')),
            CDecl(('index_type', 'next_node', '= std::get<1>(worklist.back())')),
            CBlock(['worklist.pop_back()']),
            If('tree.nnodes() == 0', [
                CBlock('next_node = selectivity[next_src] > selectivity[next_node] ? next_src : next_node'),
                CBlock(['worklist.clear()']),
            ]),
            If('!add_to_tree[next_node]', [CBlock('continue')]),
            CBlock(['tree_order.push_back(next_node)']),
            CBlock(['add_to_tree[next_node] = 0']),
            CFor(CDecl(('index_type', 'e', '= qgraph.row_start[next_node]')), 'e != qgraph.row_start[next_node+1]', 'e++', [
                If('add_to_tree[e]', [
                    CBlock(['tree.addEdge(next_node, e)']),
                    CBlock(['tree.addEdge(e, next_node)']),
                    CBlock(['add_to_tree[e] = 0']),
                    CFor(CDecl(('index_type', 'e2', '= qgraph.row_start[e]')), 'e2 != qgraph.row_start[e+1]', 'e2++', [
                        If('add_to_tree[e2]', [
                            CBlock(['worklist.push_back(std::make_tuple(e,e2,selectivity[e]+selectivity[e2]))'], parse=False),
                        ]),
                    ]),
                ]),
            ]),
        ]),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
        CDecl(('Shared<float>', 'selectivity', '= qg.nnodes')),
        Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),
        CDecl(('gpgraphlib::EdgeListGraph', 'tree', '')),
        CDecl(('std::vector<index_type>', 'tree_order', '')),
        CBlock(['build_tree(qg, selectivity.gpu_rd_ptr(), tree, tree_order)']),
        ])
    ])
