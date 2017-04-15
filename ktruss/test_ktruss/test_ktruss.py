import unittest

import gg.compiler
from gg.ast import *

import pyirgltest
import ktruss.ktruss
import test_ktruss

skip_tests = False

def kernel_sizing():
    k = Kernel('kernel_sizing', [params.GraphParam('g', True), ('dim3&', 'blocks'), ('dim3&', 'threads')], [
        CBlock([
            ('threads.x = 256'),
            ('threads.y = threads.z = 1'),
            ('blocks.x = ggc_get_nSM() * 8'),
            ('blocks.y = blocks.z = 1'),
            ])
        ],
        host=True)
    return k

def main(glist):
        k = Kernel("main", [], [
            CDecl(('gpgraphlib::EdgeListGraph', 'elg', '= %s' % glist)),
            CBlock('elg = elg.makeSymmetric()'),
            CDecl(('CSRGraphTy', 'g', '')),
            CBlock(['g.nnodes = elg.nnodes()']),
            CBlock(['g.nedges = elg.nedges()']),
            CBlock(['g.allocOnHost()']),
            CBlock(['elg.setCSR(g.row_start, g.edge_dst)']),
            CDecl(('CSRGraphTy', 'gg', '')),
            CBlock(('g.copy_to_gpu(gg)')),
            CBlock(['gg_main(g, gg)']),
            ],
            host=True,
            ret_type='int')
        return k

class KTrussTests(pyirgltest.test.IrGLTest):
    def count_triangle_edges_runner(self, graph_input, expected_triangle_count):
        graph = gg.lib.graph.Graph("graph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True)], [
                CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
                CDecl(('Shared<int>', 'count', '(g.nedges)')),
                CBlock(['count_triangle_edges(g, gg, count)']),
                CDecl(('std::vector<int>', 'triangle_count_vec', '')),
                CDecl(('int*', 'count_ptr', '= count.cpu_rd_ptr()')),
                CBlock(['triangle_count_vec.assign(count_ptr, count_ptr + g.nedges)']),
                CDecl(('std::vector<int>', 'expected_triangle_count', '= %s' % expected_triangle_count)),
                CBlock(['EXPECT_EQ(expected_triangle_count, triangle_count_vec)']),
                ]),
            kernel_sizing(),
            main(graph_input),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'count_triangle_edges0')
    def test_count_triangle_edges0(self):
        graph_input = '{{ 0, 1 }, { 0, 2 }, { 1, 2 }}'
        #                       src: 0 0 1 1 2 2
        #                       dst: 1 2 2 0 0 1
        expected_triangle_count = '{ 1,1,1,0,0,0 }'
        self.count_triangle_edges_runner(graph_input, expected_triangle_count)

    @unittest.skipIf(skip_tests, 'count_triangle_edges1')
    def test_count_triangle_edges1(self):
        graph_input = '{ { 0,1 }, { 0,2 }, { 0,5 }, { 1,0 }, { 1,2 }, { 2,0 }, { 2,1 }, { 2,3 }, { 2,4 }, { 2,5 }, { 3,2 }, { 4,2 }, { 5,0 }, { 5,2 } }'
        #                       src: 0 0 0 1 1 2 2 2 2 2 3 4 5 5
        #                       dst: 2 1 5 0 2 0 1 3 4 5 2 2 0 2
        #                    valid?: x     x x           x x x x
        expected_triangle_count = '{ 2,0,0,1,1,0,0,0,0,0,0,0,1,1 }'
        self.count_triangle_edges_runner(graph_input, expected_triangle_count)

    @unittest.skipIf(skip_tests, 'count_triangle_edges2')
    def test_count_triangle_edges2(self):
        graph_input = '{{ 0,1 }, { 0,2 }, { 1,2 }, { 2,3 }, { 3,4 }, { 5,6 }, { 2,5 }, { 2,7 }, { 5,7 }, { 7,8 }, { 7,9 }, { 8,9 }, { 9,10 }, { 10,11 }, { 10,12 }, { 10,13 }, { 11,12 }, { 11,13 }, { 12,13 }, { 13,14 }, { 14,15 },}'
        #                      src: 0 0 1 1 2 2 2 2 2 3 3 4 5 5 5 6 7 7 7 7 8 8 9 9 9 A A A A B B B C C C D D D D E E F
        #                      dst: 1 2 2 0 0 1 3 5 7 2 4 3 2 7 6 5 2 5 8 9 7 9 7 A 8 D 9 B C A C D A D B A B C E C F E
        #                   valid?: x x x             x   x x x   x x       x x x x   x       x x x x x           x   x
        expected_triangle_count = '{1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,1,1,1,0,0,2,0,0,0,2,2,2,2,2,0,0,0,0,0,0,0,0 }'
        self.count_triangle_edges_runner(graph_input, expected_triangle_count)

    def max_ktruss_test_runner(self, graph_input, expected_max_ktruss_size, expected_max_ktruss_nodes):
        graph = gg.lib.graph.Graph("graph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True)], [
                CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
                CDecl(('Shared<int>', 'count', '(g.nedges)')),
                CBlock(['count_triangle_edges(g, gg, count)']),
                CDecl(('int', 'max_ktruss_size', '')),
                CDecl(('AppendOnlyList', 'max_ktruss_nodes', '(g.nnodes)')),
                CBlock(['maximal_ktruss(g, gg, count, max_ktruss_size, max_ktruss_nodes)']),
                CBlock(['EXPECT_EQ(%s, max_ktruss_size)' % expected_max_ktruss_size]),
                CDecl(('std::vector<int>', 'ktruss_nodes_vec', '(max_ktruss_nodes.nitems())')),
                CBlock(['ktruss_nodes_vec.assign(max_ktruss_nodes.list.cpu_rd_ptr(), max_ktruss_nodes.list.cpu_rd_ptr()+max_ktruss_nodes.nitems())']),
                CDecl(('std::vector<int>', 'expected_ktruss_nodes', '= %s' % expected_max_ktruss_nodes)),
                CBlock(['EXPECT_EQ(expected_ktruss_nodes, ktruss_nodes_vec)']),
                ]),
            kernel_sizing(),
            main(graph_input),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'max_ktruss0')
    def test_max_ktruss0(self):
        graph = '{{ 0, 1 }, { 0, 2 }, { 1, 2 }}'
        expected_max_ktruss_size = '3'
        expected_max_ktruss_nodes = '{ 0,1,2 }'
        self.max_ktruss_test_runner(graph, expected_max_ktruss_size, expected_max_ktruss_nodes)

    @unittest.skipIf(skip_tests, 'max_ktruss1')
    def test_max_ktruss1(self):
        graph = '{ { 0,1 }, { 0,2 }, { 0,5 }, { 1,0 }, { 1,2 }, { 2,0 }, { 2,1 }, { 2,3 }, { 2,4 }, { 2,5 }, { 3,2 }, { 4,2 }, { 5,0 }, { 5,2 } }'
        expected_max_ktruss_size = '4'
        expected_max_ktruss_nodes = '{ 0,1,2,5 }'
        self.max_ktruss_test_runner(graph, expected_max_ktruss_size, expected_max_ktruss_nodes)

    @unittest.skipIf(skip_tests, 'max_ktruss2')
    def test_max_ktruss2(self):
        graph = '{{ 0,1 }, { 0,2 }, { 1,2 }, { 2,3 }, { 3,4 }, { 5,6 }, { 2,5 }, { 2,7 }, { 5,7 }, { 7,8 }, { 7,9 }, { 8,9 }, { 9,10 }, { 10,11 }, { 10,12 }, { 10,13 }, { 11,12 }, { 11,13 }, { 12,13 }, { 13,14 }, { 14,15 },}'
        expected_max_ktruss_size = '7'
        expected_max_ktruss_nodes = '{ 0,1,2,5,7,8,9 }'
        self.max_ktruss_test_runner(graph, expected_max_ktruss_size, expected_max_ktruss_nodes)

    @unittest.skipIf(skip_tests, 'max_ktruss3')
    def test_max_ktruss3(self):
        graph = '{ { 0,1 }, { 0,2 }, { 0,3 }, { 0,4 }, { 1,0 }, { 1,2 }, { 1,3 }, { 1,4 }, { 2,0 }, { 2,1 }, { 2,3 }, { 2,4 }, { 3,0 }, { 3,1 }, { 3,2 }, { 3,4 }, { 4,0 }, { 4,1 }, { 4,2 }, { 4,3 }, }'
        expected_max_ktruss_size = '5'
        expected_max_ktruss_nodes = '{ 0,1,2,3,4 }'
        self.max_ktruss_test_runner(graph, expected_max_ktruss_size, expected_max_ktruss_nodes)

if __name__ == '__main__':
    unittest.main()
