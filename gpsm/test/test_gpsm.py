import unittest

import gg.compiler
from gg.ast import *

import pyirgltest

class PredicateTests(pyirgltest.test.IrGLTest):
    def test_selectivity1(self):
        dgraph = gg.lib.graph.Graph("dgraph")
        qgraph = gg.lib.graph.Graph("qgraph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('hg', True), params.GraphParam('gg', True), params.GraphParam('qhg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
                CDecl(('Shared<float>', 'selectivity', '= qhg.nnodes')),
                Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),
                CDecl(('std::vector<float>', 'selectivity_vec', '')),
                CDecl(('float*', 'selectivity_ptr', '= selectivity.cpu_rd_ptr()')),
                CBlock(['selectivity_vec.assign(selectivity_ptr, selectivity_ptr + qhg.nnodes)']),
                CDecl(('std::vector<float>', 'expected_selectivity_vec','= { 1, 1, 2.0/3, 1 }')),
                CBlock(['EXPECT_EQ(expected_selectivity_vec, selectivity_vec)']),
            ]),
            Kernel('kernel_sizing', [params.GraphParam('g', True), ('dim3&', 'blocks'), ('dim3&', 'threads')], [
                CBlock([
                    ('threads.x = 256'),
                    ('threads.y = threads.z = 1'),
                    ('blocks.x = ggc_get_nSM() * 8'),
                    ('blocks.y = blocks.z = 1'),
                    ])
                ],
                host=True),
            Kernel("main", [], [
                CDecl(('std::list<std::pair<unsigned, unsigned>>', 'dlist','= { {0,1}, {0,2}, {1,0}, {1,4}, {1,3}, {2,0}, {2,3}, {2,4}, {3,1}, {3,2}, {3,5}, {4,2}, {4,1}, {4,5}, {5,3}, {5,4}, {6,4} }')),
                CDecl(('gpgraphlib::EdgeListGraph', 'delg', '= dlist')),
                CDecl(('CSRGraphTy', 'dg', '')),
                CBlock(['dg.nnodes = delg.nnodes()']),
                CBlock(['dg.nedges = delg.nedges()']),
                CBlock(['dg.allocOnHost()']),
                CBlock(['delg.setCSR(dg.row_start, dg.edge_dst)']),
                CDecl(('CSRGraphTy', 'dgg', '')),
                CBlock(('dg.copy_to_gpu(dgg)')),
                CDecl(('int', 'dprop_data[]', '= { 5,1,9,9,1,5,9 }')),
                CDecl(('Shared<int>', 'dprop', '= dg.nnodes')),
                CBlock(['memcpy(dprop.cpu_wr_ptr(), dprop_data, sizeof(dprop_data))']),
                CDecl(('std::list<std::pair<unsigned, unsigned>>', 'qlist','= { {0,1}, {0,2}, {1,0}, {1,3}, {2,0}, {2,3}, {3,1}, {3,2} }')),
                CDecl(('gpgraphlib::EdgeListGraph', 'qelg', '= qlist')),
                CDecl(('CSRGraphTy', 'qg', '')),
                CBlock(['qg.nnodes = qelg.nnodes()']),
                CBlock(['qg.nedges = qelg.nedges()']),
                CBlock(['qg.allocOnHost()']),
                CBlock(['qelg.setCSR(qg.row_start, qg.edge_dst)']),
                CBlock(('qg.copy_to_gpu(qgg)')),
                CDecl(('CSRGraphTy', 'qgg', '')),
                CDecl(('int', 'qprop_data[]', '= { 5,1,9,1 }')),
                CDecl(('Shared<int>', 'qprop', '= qg.nnodes')),
                CBlock(['memcpy(qprop.cpu_wr_ptr(), qprop_data, sizeof(qprop_data))']),
                CBlock(['gg_main(dg, dgg, qg, qgg, dprop, qprop)']),
                ],
                host=True,
                ret_type='int')
            ])

        import gpsm.gpsm
        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

if __name__ == '__main__':
    unittest.main()
