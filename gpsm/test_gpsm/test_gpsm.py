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
                CBlock(['c_set.zero_gpu()']),
                CDecl(('CSRGraphTex', 'tg', '')),
                CDecl(('CSRGraphTex', 'tgg', '')),
                CBlock(['tg.nnodes = tree.nnodes()', 'tg.nedges = tree.nedges()', 'tg.allocOnHost()', 'tree.setCSR(tg.row_start, tg.edge_dst)', 'tg.copy_to_gpu(tgg);']),
                CBlock(['init_candidate_vertices(gg, tg, tgg, dprop, qprop, tree_order, c_set.gpu_wr_ptr())']),

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
                CBlock(['c_set.zero_gpu()']),
                CDecl(('CSRGraphTex', 'tg', '')),
                CDecl(('CSRGraphTex', 'tgg', '')),
                CBlock(['tg.nnodes = tree.nnodes()', 'tg.nedges = tree.nedges()', 'tg.allocOnHost()', 'tree.setCSR(tg.row_start, tg.edge_dst)', 'tg.copy_to_gpu(tgg);']),
                CBlock(['init_candidate_vertices(gg, tg, tgg, dprop, qprop, tree_order, c_set.gpu_wr_ptr())']),

                CDecl(('Shared<AppendOnlyList>', 'candidate_src', '= qg.nedges')),
                CDecl(('AppendOnlyList*', 'candidate_src_cp', '= candidate_src.cpu_wr_ptr()')),
                CDecl(('Shared<AppendOnlyList>', 'candidate_dst', '= qg.nedges')),
                CDecl(('AppendOnlyList*', 'candidate_dst_cp', '= candidate_dst.cpu_wr_ptr()')),
                CFor(CDecl(('size_t', 'i', '= 0')), 'i < qg.nedges', 'i++', [
                  CBlock(['candidate_src_cp[i] =  AppendOnlyList(g.nedges)'], parse=False),
                  CBlock(['candidate_dst_cp[i] = AppendOnlyList(g.nedges)'], parse=False),
                ]),
                Invoke('build_candidate_edges_gp', ('gg', 'qgg', 'c_set.gpu_rd_ptr()', 'candidate_src.gpu_wr_ptr()', 'candidate_dst.gpu_wr_ptr()')),

                CDecl(('std::vector<gpgraphlib::EdgeListGraph>', 'candidate_edges', '(qg.nedges)')),
                CBlock(['candidate_src_cp = candidate_src.cpu_rd_ptr()']),
                CBlock(['candidate_dst_cp = candidate_dst.cpu_rd_ptr()']),
                CFor(CDecl(('size_t', 'i', '= 0')), 'i < qg.nedges', 'i++', [
                  CDecl(('int*', 'csrc_ptr', '= candidate_src_cp[i].list.cpu_rd_ptr()')),
                  CDecl(('int*', 'cdst_ptr', '= candidate_dst_cp[i].list.cpu_rd_ptr()')),
                  CFor(CDecl(('size_t', 'j', '= 0')), 'j < candidate_src_cp[i].nitems()', 'j++', [
                    CBlock(['candidate_edges.at(i).addEdge(csrc_ptr[j], cdst_ptr[j])']),
                  ]),
                ]),

                CDecl(('gpgraphlib::EdgeListGraph', 'e12', '= { {0, 1}, {2, 1}, {2, 5} }')),
                CBlock(['EXPECT_EQ(e12, candidate_edges.at(0))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e21', '= { {1, 0}, {1, 2}, {5, 2} }')),
                CBlock(['EXPECT_EQ(e21, candidate_edges.at(1))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e23', '= { {1, 2}, {5, 2} }')),
                CBlock(['EXPECT_EQ(e23, candidate_edges.at(2))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e24', '= { {1, 5}, {5, 1} }')),
                CBlock(['EXPECT_EQ(e24, candidate_edges.at(3))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e25', '= { {1, 6}, {5, 6} }')),
                CBlock(['EXPECT_EQ(e25, candidate_edges.at(4))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e32', '= { {2, 1}, {2, 5} }')),
                CBlock(['EXPECT_EQ(e32, candidate_edges.at(5))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e34', '= { {2, 1}, {2,5} }')),
                CBlock(['EXPECT_EQ(e34, candidate_edges.at(6))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e35', '= { {2, 6}, {3, 6} }')),
                CBlock(['EXPECT_EQ(e35, candidate_edges.at(7))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e42', '= { {1, 5}, {5, 1} }')),
                CBlock(['EXPECT_EQ(e42, candidate_edges.at(8))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e43', '= { {1, 2}, {5, 2} }')),
                CBlock(['EXPECT_EQ(e43, candidate_edges.at(9))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e45', '= { {1, 6}, {5, 6} }')),
                CBlock(['EXPECT_EQ(e45, candidate_edges.at(10))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e52', '= { {6, 1}, {6, 5} }')),
                CBlock(['EXPECT_EQ(e52, candidate_edges.at(11))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e53', '= { {6, 2}, {6, 3} }')),
                CBlock(['EXPECT_EQ(e53, candidate_edges.at(12))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e54', '= { {6, 1}, {6 ,5} }')),
                CBlock(['EXPECT_EQ(e54, candidate_edges.at(13))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e56', '= { {6, 7} }')),
                CBlock(['EXPECT_EQ(e56, candidate_edges.at(14))']),
                CDecl(('gpgraphlib::EdgeListGraph', 'e65', '= { {7, 6} }')),
                CBlock(['EXPECT_EQ(e65, candidate_edges.at(15))']),
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

    @unittest.skipIf(skip_tests, 'join edges test')
    def test_join_edges(self):
        dgraph = gg.lib.graph.Graph("dgraph")
        qgraph = gg.lib.graph.Graph("qgraph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), params.GraphParam('qg', True), params.GraphParam('qgg', True), ('Shared<int>&', 'dprop'), ('Shared<int>&', 'qprop')], [
                CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),

                CDecl(('Shared<float>', 'selectivity', '= qg.nnodes')),
                Invoke('calc_selectivity', ('gg', 'qgg', 'dprop.gpu_rd_ptr()', 'qprop.gpu_rd_ptr()', 'selectivity.gpu_wr_ptr()')),

                CDecl(('gpgraphlib::EdgeListGraph', 'tree', '')),
                CDecl(('std::vector<index_type>', 'tree_order', '')),
                CBlock(['build_tree(qg, selectivity.cpu_rd_ptr(), tree, tree_order)']),

                CDecl(('Shared<unsigned>', 'c_set', '= tree.nnodes()*g.nnodes')),
                CBlock(['c_set.zero_gpu()']),
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

                CDecl(('std::vector<std::vector<unsigned>>', 'solutions', '')),
                CBlock(['join_edges_gp(gg, qgg, qg, candidate_src, candidate_dst, solutions)']),

                CBlock(['EXPECT_EQ(1, solutions.size())']),
                CDecl(('std::vector<unsigned>', 'expected', ' = { 0, 1, 2, 5, 6, 7 }')),
                CBlock(['EXPECT_EQ(expected, solutions.at(0))']),
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
        test_ast = Module([
          test_gpsm.testcore.kernel_sizing(),
          test_gpsm.testcore.main(
              '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,6 }, { 6,1 }, { 1,5 }, { 5,1 }, { 2,5 }, { 5,2 }, { 2,6 }, { 6,2 }, { 5,6 }, { 6,5 }, { 6,7 }, { 7,6 }, { 6,3 }, { 3,6 }, { 3,7 }, { 7,3 }, { 3,4 }, { 4,3 }, { 7,4 }, { 4,7 }, { 4,8 }, { 8,4 } }',
              '{ 1, 0, 1, 1, 0, 0, 2, 2, 0 }',
              '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,4 }, { 4,1 }, { 1,3 }, { 3,1 }, { 2,4 }, { 4,2 }, { 2,3 }, { 3,2 }, { 3,4 }, { 4,3 }, { 4,5 }, { 5,4 } }',
              '{ 1, 0, 1, 0, 2, 2 }'),
          ])
        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

if __name__ == '__main__':
    unittest.main()
