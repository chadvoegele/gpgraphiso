import unittest

import gg.compiler
from gg.ast import *

import pyirgltest
import gpsm.gpsm
import test_gpsm

skip_tests = False

class GPSMTests(pyirgltest.test.IrGLTest):
    @unittest.skipIf(skip_tests, 'selectivity1')
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
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(
                '{ {0,1}, {0,2}, {1,0}, {1,4}, {1,3}, {2,0}, {2,3}, {2,4}, {3,1}, {3,2}, {3,5}, {4,2}, {4,1}, {4,5}, {5,3}, {5,4}, {6,4} }',
                '{ 5,1,9,9,1,5,9 }',
                '{ {0,1}, {0,2}, {1,0}, {1,3}, {2,0}, {2,3}, {3,1}, {3,2} }',
                '{ 5,1,9,1 }'),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'selectivity2')
    def test_selectivity2(self):
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
                CDecl(('std::vector<float>', 'expected_selectivity_vec','= { 1.0/3, 1, 1, 3.0/4, 2, 1.0/2 }')),
                CBlock(['EXPECT_EQ(expected_selectivity_vec, selectivity_vec)']),
            ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,6 }, { 6,1 }, { 1,5 }, { 5,1 }, { 2,5 }, { 5,2 }, { 2,6 }, { 6,2 }, { 5,6 }, { 6,5 }, { 6,7 }, { 7,6 }, { 6,3 }, { 3,6 }, { 3,7 }, { 7,3 }, { 3,4 }, { 4,3 }, { 7,4 }, { 4,7 }, { 4,8 }, { 8,4 } }',
                '{ 1, 0, 1, 1, 0, 0, 2, 2, 0 }',
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,4 }, { 4,1 }, { 1,3 }, { 3,1 }, { 2,4 }, { 4,2 }, { 2,3 }, { 3,2 }, { 3,4 }, { 4,3 }, { 4,5 }, { 5,4 } }',
                '{ 1, 0, 1, 0, 2, 2 }'),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'spanning_test')
    def test_spanning_test(self):
        dgraph = gg.lib.graph.Graph("dgraph")
        qgraph = gg.lib.graph.Graph("qgraph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
                CDecl(('Shared<float>', 'selectivity', '= qg.nnodes')),
                Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),
                CDecl(('gpgraphlib::EdgeListGraph', 'tree', '')),
                CDecl(('std::vector<index_type>', 'tree_order', '')),
                CBlock(['build_tree(qg, selectivity.cpu_rd_ptr(), tree, tree_order)']),
                CDecl(('std::vector<unsigned>', 'expected_tree_order','= { 4, 1 }')),
                CBlock(['EXPECT_EQ(expected_tree_order, tree_order)']),
                CDecl(('std::vector<unsigned>', 'row_start','(tree.nnodes()+1)')),
                CDecl(('std::vector<unsigned>', 'edge_dst','(tree.nedges())')),
                CBlock(['tree.setCSR(row_start.data(), edge_dst.data())']),
                CDecl(('std::vector<unsigned>', 'expected_row_start','= { 0, 1, 3, 4, 5, 9, 10 }')),
                CBlock(['EXPECT_EQ(expected_row_start, row_start)']),
                CDecl(('std::vector<unsigned>', 'expected_edge_dst','= { 1, 0, 4, 4, 4, 1, 2, 3, 5, 4 }')),
                CBlock(['EXPECT_EQ(expected_edge_dst, edge_dst)']),
                ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,6 }, { 6,1 }, { 1,5 }, { 5,1 }, { 2,5 }, { 5,2 }, { 2,6 }, { 6,2 }, { 5,6 }, { 6,5 }, { 6,7 }, { 7,6 }, { 6,3 }, { 3,6 }, { 3,7 }, { 7,3 }, { 3,4 }, { 4,3 }, { 7,4 }, { 4,7 }, { 4,8 }, { 8,4 } }',
                '{ 1, 0, 1, 1, 0, 0, 2, 2, 0 }',
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,4 }, { 4,1 }, { 1,3 }, { 3,1 }, { 2,4 }, { 4,2 }, { 2,3 }, { 3,2 }, { 3,4 }, { 4,3 }, { 4,5 }, { 5,4 } }',
                '{ 1, 0, 1, 0, 2, 2 }'),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'candidate vertices test')
    def test_candidate_vertices(self):
        dgraph = gg.lib.graph.Graph("dgraph")
        qgraph = gg.lib.graph.Graph("qgraph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
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
                CBlock(['init_candidate_verticies(gg, tg, tgg, dprop, qprop, tree_order, c_set.gpu_wr_ptr())']),
                CDecl(('std::vector<unsigned>', 'c_set_vec', '')),
                CDecl(('unsigned*', 'c_set_ptr', '= c_set.cpu_rd_ptr()')),
                CBlock(['c_set_vec.assign(c_set_ptr, c_set_ptr + tree.nnodes()*g.nnodes)']),
                CDecl(('std::vector<unsigned>', 'expected_c_set_vec','= {' +
                  ' /*u1*/ 1, 0, 1, 0, 0, 0, 0, 0, 0,' +
                  ' /*u2*/ 0, 1, 0, 0, 0, 1, 0, 0, 0,' +
                  ' /*u3*/ 0, 0, 1, 1, 0, 0, 0, 0, 0,' +
                  ' /*u4*/ 0, 1, 0, 0, 0, 1, 0, 0, 0,' +
                  ' /*u5*/ 0, 0, 0, 0, 0, 0, 1, 0, 0,' +
                  ' /*u6*/ 0, 0, 0, 0, 0, 0, 0, 1, 0 }')),
                CBlock(['EXPECT_EQ(c_set_vec, expected_c_set_vec)']),
                ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,6 }, { 6,1 }, { 1,5 }, { 5,1 }, { 2,5 }, { 5,2 }, { 2,6 }, { 6,2 }, { 5,6 }, { 6,5 }, { 6,7 }, { 7,6 }, { 6,3 }, { 3,6 }, { 3,7 }, { 7,3 }, { 3,4 }, { 4,3 }, { 7,4 }, { 4,7 }, { 4,8 }, { 8,4 } }',
                '{ 1, 0, 1, 1, 0, 0, 2, 2, 0 }',
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,4 }, { 4,1 }, { 1,3 }, { 3,1 }, { 2,4 }, { 4,2 }, { 2,3 }, { 3,2 }, { 3,4 }, { 4,3 }, { 4,5 }, { 5,4 } }',
                '{ 1, 0, 1, 0, 2, 2 }'),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'candidate edges test')
    def test_candidate_edges(self):
        dgraph = gg.lib.graph.Graph("dgraph")
        qgraph = gg.lib.graph.Graph("qgraph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
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
                CBlock(['init_candidate_verticies(gg, tg, tgg, dprop, qprop, tree_order, c_set.gpu_wr_ptr())']),
                CDecl(('std::vector<gpgraphlib::EdgeListGraph>', 'candidate_edges', '(qg.nedges)')),
                CDecl(('unsigned*', 'c_set_cpu_ptr', '= c_set.cpu_rd_ptr()')),
                CBlock(['build_candidate_edges(g, qg, c_set_cpu_ptr, candidate_edges)']),
                CBlock(['join_edges(g, qg, candidate_edges);']),
                # TODO: Add tests here
                CBlock(['EXPECT_EQ(1, 1)']),
                ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,6 }, { 6,1 }, { 1,5 }, { 5,1 }, { 2,5 }, { 5,2 }, { 2,6 }, { 6,2 }, { 5,6 }, { 6,5 }, { 6,7 }, { 7,6 }, { 6,3 }, { 3,6 }, { 3,7 }, { 7,3 }, { 3,4 }, { 4,3 }, { 7,4 }, { 4,7 }, { 4,8 }, { 8,4 } }',
                '{ 1, 0, 1, 1, 0, 0, 2, 2, 0 }',
                '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,4 }, { 4,1 }, { 1,3 }, { 3,1 }, { 2,4 }, { 4,2 }, { 2,3 }, { 3,2 }, { 3,4 }, { 4,3 }, { 4,5 }, { 5,4 } }',
                '{ 1, 0, 1, 0, 2, 2 }'),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'compile')
    def test_compile(self):
        test_ast = Module([test_gpsm.testcore.kernel_sizing()])
        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

if __name__ == '__main__':
    unittest.main()
