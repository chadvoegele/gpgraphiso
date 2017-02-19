import gg.compiler
from gg.ast import *

WL = gg.lib.wl.Worklist()
dgraph = gg.lib.graph.Graph("dgraph")
qgraph = gg.lib.graph.Graph("qgraph")

ast = Module([
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
    Kernel("gg_main", [params.GraphParam('hg', True), params.GraphParam('gg', True), params.GraphParam('qhg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
        CDecl(('Shared<float>', 'selectivity', '= qhg.nnodes')),
        Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),
        ])
    ])
