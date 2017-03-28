import unittest

import gg.compiler
from gg.ast import *

import pyirgltest
import gpsm.gpsm
import test_gpsm

skip_tests = False

class GPSMTests(pyirgltest.test.IrGLTest):
    @staticmethod
    def gpsm_pub_graphs():
        g = [
            '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,6 }, { 6,1 }, { 1,5 }, { 5,1 }, { 2,5 }, { 5,2 }, { 2,6 }, { 6,2 }, { 5,6 }, { 6,5 }, { 6,7 }, { 7,6 }, { 6,3 }, { 3,6 }, { 3,7 }, { 7,3 }, { 3,4 }, { 4,3 }, { 7,4 }, { 4,7 }, { 4,8 }, { 8,4 } }',
            '{ 1, 0, 1, 1, 0, 0, 2, 2, 0 }',
            '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 1,4 }, { 4,1 }, { 1,3 }, { 3,1 }, { 2,4 }, { 4,2 }, { 2,3 }, { 3,2 }, { 3,4 }, { 4,3 }, { 4,5 }, { 5,4 } }',
            '{ 1, 0, 1, 0, 2, 2 }',
            ]
        return g

    def triangle_identity_graphs():
        g = [
            '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 0,2 }, { 2,0 } }',
            '{ 1, 1, 1 }',
            '{ { 0,1 }, { 1,0 }, { 1,2 }, { 2,1 }, { 0,2 }, { 2,0 } }',
            '{ 1, 1, 1 }',
            ]
        return g

    def selectivity_base(self, graphs, expected_selectivity):
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
                CDecl(('std::vector<float>', 'expected_selectivity_vec','= ' + expected_selectivity)),
                CBlock(['EXPECT_EQ(expected_selectivity_vec, selectivity_vec)']),
            ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(*graphs),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'selectivity1')
    def test_selectivity1(self):
        graphs = [
            '{ {0,1}, {0,2}, {1,0}, {1,4}, {1,3}, {2,0}, {2,3}, {2,4}, {3,1}, {3,2}, {3,5}, {4,2}, {4,1}, {4,5}, {5,3}, {5,4}, {6,4} }',
            '{ 5,1,9,9,1,5,9 }',
            '{ {0,1}, {0,2}, {1,0}, {1,3}, {2,0}, {2,3}, {3,1}, {3,2} }',
            '{ 5,1,9,1 }',
            ]
        expected_selectivity = '{ 1, 1, 2.0/3, 1 }'
        self.selectivity_base(graphs, expected_selectivity)

    @unittest.skipIf(skip_tests, 'selectivity1')
    def test_selectivity2(self):
        expected_selectivity = '{ 1.0/3, 1, 1, 3.0/4, 2, 1.0/2 }'
        self.selectivity_base(GPSMTests.gpsm_pub_graphs(), expected_selectivity)

    @unittest.skipIf(skip_tests, 'selectivity_idtri')
    def test_selectivity3(self):
        expected_selectivity = '{ 2.0/3, 2.0/3, 2.0/3 }'
        self.selectivity_base(GPSMTests.triangle_identity_graphs(), expected_selectivity)

    def spanning_base(self, graphs, expected_tree_order, expected_row_start, expected_edge_dst):
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

                CDecl(('std::vector<unsigned>', 'expected_tree_order','= ' + expected_tree_order)),
                CBlock(['EXPECT_EQ(expected_tree_order, tree_order)']),
                CDecl(('std::vector<unsigned>', 'row_start','(tree.nnodes()+1)')),
                CDecl(('std::vector<unsigned>', 'edge_dst','(tree.nedges())')),
                CBlock(['tree.setCSR(row_start.data(), edge_dst.data())']),
                CDecl(('std::vector<unsigned>', 'expected_row_start','= ' + expected_row_start)),
                CBlock(['EXPECT_EQ(expected_row_start, row_start)']),
                CDecl(('std::vector<unsigned>', 'expected_edge_dst','= ' + expected_edge_dst)),
                CBlock(['EXPECT_EQ(expected_edge_dst, edge_dst)']),
                ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(*graphs),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'spanning_test')
    def test_spanning_test(self):
        expected_tree_order = '{ 4, 1 }'
        expected_row_start = '{ 0, 1, 3, 4, 5, 9, 10 }'
        expected_edge_dst = '{ 1, 0, 4, 4, 4, 1, 2, 3, 5, 4 }'
        self.spanning_base(GPSMTests.gpsm_pub_graphs(), expected_tree_order, expected_row_start, expected_edge_dst)

    @unittest.skipIf(skip_tests, 'spanning_test_idtri')
    def test_spanning_test(self):
        expected_tree_order = '{ 0 }'
        expected_row_start = '{ 0, 2, 3, 4 }'
        expected_edge_dst = '{ 1, 2, 0, 0 }'
        self.spanning_base(GPSMTests.triangle_identity_graphs(), expected_tree_order, expected_row_start, expected_edge_dst)

    def candidate_vertices_base(self, graphs, expected_c_set_vec):
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
                CDecl(('std::vector<unsigned>', 'expected_c_set_vec','= ' + expected_c_set_vec)),
                CBlock(['EXPECT_EQ(c_set_vec, expected_c_set_vec)']),
                ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(*graphs),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'candidate vertices test')
    def test_candidate_vertices(self):
        expected_c_set_vec = [ '{',
            ' /*u1*/ 1, 0, 1, 0, 0, 0, 0, 0, 0,',
            ' /*u2*/ 0, 1, 0, 0, 0, 1, 0, 0, 0,',
            ' /*u3*/ 0, 0, 1, 1, 0, 0, 0, 0, 0,',
            ' /*u4*/ 0, 1, 0, 0, 0, 1, 0, 0, 0,',
            ' /*u5*/ 0, 0, 0, 0, 0, 0, 1, 0, 0,',
            ' /*u6*/ 0, 0, 0, 0, 0, 0, 0, 1, 0,',
            '}', ]
        self.candidate_vertices_base(GPSMTests.gpsm_pub_graphs(), ''.join(expected_c_set_vec))

    def candidate_edges_base(self, graphs, expected_candidate_edges):
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
                ]
                +
                [ s for i in range(0,len(expected_candidate_edges))
                    for s in [
                    CDecl(('gpgraphlib::EdgeListGraph', 'e%d' % i, '= ' + expected_candidate_edges[i])),
                    CBlock(['EXPECT_EQ(e%d, candidate_edges.at(%d))' % (i, i)]),
                  ]]
                ),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(*graphs),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'candidate edges test')
    def test_candidate_edges(self):
        graphs = GPSMTests.gpsm_pub_graphs()

        expected_candidate_edges = [
            '{ {0, 1}, {2, 1}, {2, 5} }',
            '{ {1, 0}, {1, 2}, {5, 2} }',
            '{ {1, 2}, {5, 2} }',
            '{ {1, 5}, {5, 1} }',
            '{ {1, 6}, {5, 6} }',
            '{ {2, 1}, {2, 5} }',
            '{ {2, 1}, {2,5} }',
            '{ {2, 6}, {3, 6} }',
            '{ {1, 5}, {5, 1} }',
            '{ {1, 2}, {5, 2} }',
            '{ {1, 6}, {5, 6} }',
            '{ {6, 1}, {6, 5} }',
            '{ {6, 2}, {6, 3} }',
            '{ {6, 1}, {6 ,5} }',
            '{ {6, 7} }',
            '{ {7, 6} }',
            ]
        self.candidate_edges_base(graphs, expected_candidate_edges)

    def join_edges_base(self, graphs, expected_solutions):
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

                CBlock(['EXPECT_EQ(%d, solutions.size())' % len(expected_solutions)]),
                ]
                +
                [ s for i in range(0,len(expected_solutions))
                    for s in [
                    CDecl(('std::vector<unsigned>', 'e%d' % i, '= ' + expected_solutions[i])),
                    CBlock(['EXPECT_EQ(e%d, solutions.at(%d))' % (i, i)]),
                  ]
                ]),
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(*graphs),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'join edges test')
    def test_join_edges(self):
        graphs = GPSMTests.gpsm_pub_graphs()
        expected_solutions = [
            '{ 0, 1, 2, 5, 6, 7 }'
        ]
        self.join_edges_base(graphs, expected_solutions)

    @unittest.skipIf(skip_tests, 'compile')
    def test_compile(self):
        test_ast = Module([
          test_gpsm.testcore.kernel_sizing(),
          test_gpsm.testcore.main(*GPSMTests.gpsm_pub_graphs()),
          ])
        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

if __name__ == '__main__':
    unittest.main()
