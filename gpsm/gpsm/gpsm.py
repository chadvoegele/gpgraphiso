import gg.compiler
from gg.ast import *

WL = gg.lib.wl.Worklist()
dgraph = gg.lib.graph.Graph("dgraph")
qgraph = gg.lib.graph.Graph("qgraph")
tgraph = gg.lib.graph.Graph("tgraph")

ast = Module([
    CBlock([cgen.Include('edgelist_graph.h')]),
    CBlock([cgen.Include('gpsm.cu')]),
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
    Kernel('kernel_check', [dgraph.param(), qgraph.param(), ('int*', 'dprop_ptr'), ('int*', 'qprop_ptr'), ('unsigned*', 'c_set'), ('index_type', 'qv')], [
        ForAll("n", dgraph.nodes(), [
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
                    CDecl(('unsigned*', 'c_set_idx', '= index2d(c_set, %s, qv, node)' % dgraph.nodes().size())),
                    CBlock(['*c_set_idx = 0']),
                    CBlock(['break']),
                ]),
            ]),
            ForAll('qe2', tgraph.edges('qv'), [
                CDecl(('index_type', 'v', '= tgraph.getAbsDestination(qe2)')),
                ForAll('de', dgraph.edges('node'), [
                    CDecl(('index_type', 'vp', '= dgraph.getAbsDestination(de)')),
                    If('is_candidate(dgraph, tgraph, dprop_ptr, qprop_ptr, vp, v)', [
                        CDecl(('unsigned*', 'c_set_idx', '= index2d(c_set, %s, v, vp)' % dgraph.nodes().size())),
                        CBlock(['*c_set_idx = 1']),
                    ]),
                ]),
            ]),
        ]),
    ]),
    Kernel('init_candidate_verticies', [dgraph.param(), ('CSRGraphTy', 'tg'), tgraph.param(), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop'), ('std::vector<index_type>&', 'tree_order'), ('Shared<unsigned>&', 'c_set')], [
        CDecl(('dim3', 'blocks', '')),
        CDecl(('dim3', 'threads', '')),
        CBlock(['kernel_sizing(dgraph, blocks, threads)']),
        CDecl(('std::vector<unsigned>', 'initialized', '(%s)' % tgraph.nodes().size())),
        CDecl(('unsigned*', 'c_set_cptr', '= c_set.cpu_wr_ptr()')),
        CFor(CDecl(('unsigned', 'i', '= 0')), 'i < tgraph.nnodes*dgraph.nnodes', 'i++', [
            CBlock(['c_set_cptr[i] = 0']),
        ]),
        CDecl(('unsigned*', 'c_set_gptr', '= c_set.gpu_wr_ptr()')),
        CFor(CDecl(('std::vector<index_type>::iterator', 'u', '= tree_order.begin()')), 'u != tree_order.end()', 'u++', [
            CDecl(('unsigned', 'qv', '= *u')),
            If('!initialized[qv]', [
                Invoke('kernel_check', ('dgraph', 'tgraph', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'index2d(c_set_gptr, %s, qv, 0)' % dgraph.nodes().size(), 'qv')),
                CBlock(['initialized[qv]=1']),
            ]),
            ClosureHint(Pipe([
                Invoke('kernel_collect', ('dgraph', 'index2d(c_set_gptr, %s, qv, 0)' % dgraph.nodes().size())),
                Invoke('kernel_explore', ('dgraph', 'tgraph', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'c_set_gptr', 'qv')),
            ], wlinit=WLInit("65535", []), once=True)),
            CFor(CDecl(('index_type', 'e', '= tg.row_start[qv]')), 'e != tg.row_start[qv+1]', 'e++', [
                CBlock(['initialized[tg.edge_dst[e]]=1']),
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
        CBlock(['init_candidate_verticies(gg, tg, tgg, dprop, qprop, tree_order, c_set)']),
        ])
    ])
