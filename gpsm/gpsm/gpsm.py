import gg.compiler
from gg.ast import *
import gg.lib.aol

WL = gg.lib.wl.Worklist()
dgraph = gg.lib.graph.Graph('dgraph')
qgraph = gg.lib.graph.Graph('qgraph')
tgraph = gg.lib.graph.Graph('tgraph')

candidate_src = gg.lib.aol.AppendOnlyList('candidate_src')
candidate_dst = gg.lib.aol.AppendOnlyList('candidate_dst')

ast = Module([
    CDecl(('extern WorklistT', 'in_wl', '')),  # only because below If fails to parse
    CDecl(('extern WorklistT', 'out_wl', '')),  # only because below If fails to parse
    CBlock([cgen.Include('algorithm')]),
    CBlock([cgen.Include('edgelist_graph.h')]),
    CBlock([cgen.Include('gpsm.cu')]),
    CBlock([cgen.Include('kernels/reduce.cuh')]),
    CDecl(('int', 'CUDA_DEVICE', '= 0')),
    CDecl(('mgpu::ContextPtr', 'mgc', '')),
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
    Kernel('init_candidate_vertices', [dgraph.param(), ('CSRGraphTy', 'tg'), tgraph.param(), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop'), ('std::vector<index_type>&', 'tree_order'), ('unsigned*', 'c_set_gptr')], [
        CDecl(('dim3', 'blocks', '')),
        CDecl(('dim3', 'threads', '')),
        CBlock(['kernel_sizing(dgraph, blocks, threads)']),
        CDecl(('std::vector<unsigned>', 'initialized', '(%s)' % tgraph.nodes().size())),
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
    Kernel('build_candidate_edges_gp', [dgraph.param(), qgraph.param(), ('unsigned*', 'c_set'), ('AppendOnlyList*', 'csrc_ptr'), ('AppendOnlyList*', 'cdst_ptr')], [
      CDecl(('unsigned*', 'c_set_idx', '')),
      ForAll('qsrc', qgraph.nodes(), [
        ForAll('qedge', qgraph.edges('qsrc'), [
          CDecl(('index_type', 'qdst', '= qgraph.getAbsDestination(qedge)')),
          ForAll('dsrc', dgraph.nodes(), [
            CBlock(['c_set_idx = index2d(c_set, dgraph.nnodes, qsrc, dsrc)']),
            If('*c_set_idx', [
              ForAll('dedge', dgraph.edges('dsrc'), [
                CDecl(('index_type', 'ddst', '= dgraph.getAbsDestination(dedge)')),
                CBlock(['c_set_idx = index2d(c_set, dgraph.nnodes, qdst, ddst)']),
                If('*c_set_idx', [
                  CBlock(['csrc_ptr[qedge].push(dsrc)']),
                  CBlock(['cdst_ptr[qedge].push(ddst)']),
                ]),
              ]),
            ]),
          ]),
        ]),
      ]),
    ]),
    Kernel('calc_edge_score', [dgraph.param(), qgraph.param(), ('AppendOnlyList*', 'csrc_ptr'), ('unsigned*', 'vertex_visited'), ('unsigned*', 'edge_visited'), ('unsigned*', 'edge_score')], [
      ForAll('qsrc', qgraph.nodes(), [
        ForAll('qedge', qgraph.edges('qsrc'), [
          CDecl(('index_type', 'qdst', '= qgraph.getAbsDestination(qedge)')),
          CDecl(('unsigned', 'visited_score', '')),
          If('edge_visited[qedge]', [
            CBlock(['visited_score = 3']),
          ], [
            If('vertex_visited[qsrc] && vertex_visited[qdst]', [
              CBlock(['visited_score = 0']),
            ], [
              If('vertex_visited[qsrc] || vertex_visited[qdst]', [
                CBlock(['visited_score = 1']),
              ], [
                CBlock(['visited_score = 2']),
              ]),
            ]),
          ]),
          CBlock(['edge_score[qedge] = visited_score*dgraph.nedges + csrc_ptr[qedge].nitems()']),
        ]),
      ]),
    ]),
    Kernel('init_solutions', [qgraph.param(), candidate_src.param(), candidate_dst.param(), ('unsigned' , 'qsrc'), ('unsigned', 'qdst')], [
      ForAll('cidx', candidate_src.items(), [
        CDecl(('unsigned', 'csrc', '= candidate_src.dl[cidx]')),
        CDecl(('unsigned', 'cdst', '= candidate_dst.dl[cidx]')),
        CDecl(('unsigned', 'wlindex', ' = out_wl.push_range(qgraph.nnodes)')),
        CBlock(['out_wl.dwl[wlindex+qsrc] = csrc'], parse=False),
        CBlock(['out_wl.dwl[wlindex+qdst] = cdst'], parse=False),
      ]),
    ]),
    Kernel('extend_solutions', [qgraph.param(), candidate_src.param(), candidate_dst.param(), ('unsigned' , 'qsrc'), ('unsigned', 'qdst'), ('unsigned*', 'vertex_visited')], [
      CDecl(('extern index_type', 'wlidx_one_end', '')),  # only because If below fails to parse otherwise
      ForAll('cidx', candidate_src.items(), [
        CDecl(('unsigned', 'csrc', '= candidate_src.dl[cidx]')),
        CDecl(('unsigned', 'cdst', '= candidate_dst.dl[cidx]')),
        ForAll('wlidx_one', WL.items(), [
          CDecl(('unsigned', 'wlidx', '= wlidx_one * qgraph.nnodes')),
          If('!(wlidx < wlidx_one_end)', [
            CBlock(['break']),
          ]),
          CDecl(('bool', 'csrc_mapped', ' = false')),
          CDecl(('bool', 'cdst_mapped', ' = false')),
          CFor(CDecl(('size_t', 'i', '= 0')), 'i < qgraph.nnodes', 'i++', [
            If('in_wl.dwl[wlidx+i] == csrc', [
              CBlock(['csrc_mapped = true']),
            ]),
            If('in_wl.dwl[wlidx+i] == cdst', [
              CBlock(['cdst_mapped = true']),
            ]),
          ]),
          If('(!vertex_visited[qsrc] && !csrc_mapped || in_wl.dwl[wlidx+qsrc] == csrc)' +
            '&& (!vertex_visited[qdst] && !cdst_mapped || in_wl.dwl[wlidx+qdst] == cdst)', [
            CDecl(('unsigned', 'out_wlidx', ' = out_wl.push_range(qgraph.nnodes)')),
            CFor(CDecl(('size_t', 'i', '= 0')), 'i < qgraph.nnodes', 'i++', [
              CBlock(['out_wl.dwl[out_wlidx+i] = in_wl.dwl[wlidx+i]']),
            ]),
            If('!vertex_visited[qsrc]', [
              CBlock(['out_wl.dwl[out_wlidx+qsrc] = csrc']),
            ]),
            If('!vertex_visited[qdst]', [
              CBlock(['out_wl.dwl[out_wlidx+qdst] = cdst']),
            ]),
          ]),
        ]),
      ]),
    ]),
    Kernel('join_edges_gp', [dgraph.param(), qgraph.param(), ('CSRGraphTy', 'qg'), ('Shared<AppendOnlyList>', 'candidate_src'), ('Shared<AppendOnlyList>', 'candidate_dst')], [
        CDecl(('dim3', 'blocks', '')),
        CDecl(('dim3', 'threads', '')),
        CBlock(['kernel_sizing(dgraph, blocks, threads)']),

        CDecl(('Shared<unsigned>', 'vertex_visited', '(qgraph.nnodes)')),
        CBlock(['vertex_visited.zero_gpu()']),
        CDecl(('Shared<unsigned>', 'edge_visited', '(qgraph.nedges)')),
        CBlock(['edge_visited.zero_gpu()']),
        CDecl(('Shared<unsigned>', 'edge_score', '(qgraph.nedges)')),
        CBlock(['edge_score.zero_gpu()']),
        CDecl(('Shared<unsigned>', 'edge_score_idx', '(qgraph.nedges)')),

        CDecl(('AppendOnlyList*', 'candidate_src_cp', '= candidate_src.cpu_rd_ptr()')),
        CDecl(('AppendOnlyList*', 'candidate_dst_cp', '= candidate_dst.cpu_rd_ptr()')),

        Pipe([
          CFor(CDecl(('unsigned', 'count_edges_visited', '= 0')), 'count_edges_visited != qgraph.nedges', 'count_edges_visited++', [
            Invoke('calc_edge_score', ['dgraph', 'qgraph', 'candidate_src.gpu_rd_ptr()', 'vertex_visited.gpu_rd_ptr()', 'edge_visited.gpu_rd_ptr()', 'edge_score.gpu_wr_ptr()']),
            CDecl(('index_type', 'selected_qsrc', '')),
            CDecl(('index_type', 'selected_qdst', '')),
            CDecl(('index_type', 'selected_qe', '')),
            CDecl(('unsigned*', 'edge_score_idx_cp', '= edge_score_idx.cpu_wr_ptr()')),
            CFor(CDecl(('unsigned', 'i', '= 0')), 'i < qgraph.nedges', 'i++', [
              CBlock(['edge_score_idx_cp[i] = i']),
            ]),
            # UINT_MAX passed as identity BUT requires that comparator "min_index" treats this not as an index!
            CBlock(['mgpu::Reduce(edge_score_idx.gpu_rd_ptr(), (int)qgraph.nedges, UINT_MAX, min_index<unsigned, unsigned>(edge_score.gpu_rd_ptr()), (unsigned*)0, &selected_qe, *mgc)'], parse=False),
            CBlock(['selected_qdst = qg.edge_dst[selected_qe]']),
            CBlock(['selected_qsrc = std::upper_bound(qg.row_start, qg.row_start+qg.nnodes, selected_qe) - qg.row_start - 1'], parse=False),

            If('count_edges_visited == 0', [
              Invoke('init_solutions', ['qgraph', 'candidate_src_cp[selected_qe]', 'candidate_dst_cp[selected_qe]', 'selected_qsrc', 'selected_qdst']),
            ], [
              Invoke('extend_solutions', ['qgraph', 'candidate_src_cp[selected_qe]', 'candidate_dst_cp[selected_qe]', 'selected_qsrc', 'selected_qdst', 'vertex_visited.gpu_rd_ptr()']),
            ]),
            CBlock(['pipe.in_wl().swap_slots()'], parse=False),
            CBlock(['pipe.advance2()'], parse=False),

            CDecl(('unsigned*', 'vertex_visited_cp', '= vertex_visited.cpu_wr_ptr()')),
            CBlock(['vertex_visited_cp[selected_qsrc] = 1']),
            CBlock(['vertex_visited_cp[selected_qdst] = 1']),
            CDecl(('unsigned*', 'edge_visited_cp', '= edge_visited.cpu_wr_ptr()')),
            CBlock(['edge_visited_cp[selected_qe] = 1']),
          ]),
        ], wlinit=WLInit("65535", []), once=True),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
        CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
        CDecl(('Shared<float>', 'selectivity', '= qg.nnodes')),
        Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),
        CDecl(('gpgraphlib::EdgeListGraph', 'tree', '')),
        CDecl(('std::vector<index_type>', 'tree_order', '')),
        CBlock(['build_tree(qg, selectivity.cpu_rd_ptr(), tree, tree_order)']),
        CDecl(('Shared<unsigned>', 'c_set', '= tree.nnodes()*g.nnodes')),
        CBlock(['memset(c_set.cpu_wr_ptr(), 0, sizeof(unsigned)*tree.nnodes()*g.nnodes)']),
        CDecl(('CSRGraphTex', 'tg', '')),
        CDecl(('CSRGraphTex', 'tgg', '')),
        CBlock(['tg.nnodes = tree.nnodes()', 'tg.nedges = tree.nedges()', 'tg.allocOnHost()', 'tree.setCSR(tg.row_start, tg.edge_dst)', 'tg.copy_to_gpu(tgg);']),
        CBlock(['init_candidate_vertices(gg, tg, tgg, dprop, qprop, tree_order, c_set.gpu_wr_ptr())']),

        CDecl(('Shared<AppendOnlyList>', 'candidate_src', '= qg.nedges')),
        CDecl(('AppendOnlyList*', 'candidate_src_cp', '= candidate_src.cpu_wr_ptr()')),
        CDecl(('Shared<AppendOnlyList>', 'candidate_dst', '= qg.nedges')),
        CDecl(('AppendOnlyList*', 'candidate_dst_cp', '= candidate_dst.cpu_wr_ptr()')),
        CFor(CDecl(('size_t', 'i', '= 0')), 'i < qg.nedges', 'i++', [
          CBlock(['candidate_src_cp[i] = AppendOnlyList(g.nedges)'], parse=False),
          CBlock(['candidate_dst_cp[i] = AppendOnlyList(g.nedges)'], parse=False),
        ]),
        Invoke('build_candidate_edges_gp', ('gg', 'qgg', 'c_set.gpu_rd_ptr()', 'candidate_src.gpu_wr_ptr()', 'candidate_dst.gpu_wr_ptr()')),
        CBlock(['join_edges_gp(gg, qgg, qg, candidate_src, candidate_dst)']),
        ])
    ])
