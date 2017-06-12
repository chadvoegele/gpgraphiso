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

def main(glist, k):
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
            CBlock(['gg_main(g, gg, %d)' % k]),
            ],
            host=True,
            ret_type='int')
        return k

class KTrussTests(pyirgltest.test.IrGLTest):
    def degree_filter_runner(self, graph_input, k, expected_vremoved, expected_eremoved):
        graph = gg.lib.graph.Graph("graph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k')], [
                CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
                Invoke("preprocess", ['gg']),
                CBlock('gg.copy_to_cpu(g)'),
                CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc);", parse=False),
                CDecl(('Shared<unsigned>', 'outdegrees', '')),
                CDecl(('Shared<unsigned>', 'indegrees', '')),
                CDecl(('Shared<unsigned>', 'vremoved', '')),
                CBlock('vremoved.alloc(g.nnodes)'),
                CBlock('vremoved.zero_gpu()'),
                CDecl(('Shared<unsigned>', 'eremoved', '')),
                CBlock('eremoved.alloc(g.nedges)'),
                CBlock('eremoved.zero_gpu()'),
                CBlock('degree_filter(g, gg, k, outdegrees, indegrees, vremoved, eremoved)'),
                CDecl(('std::vector<int>', 'vremoved_vec', '')),
                CDecl(('unsigned*', 'vremoved_ptr', '= vremoved.cpu_rd_ptr()')),
                CBlock(['vremoved_vec.assign(vremoved_ptr, vremoved_ptr + g.nnodes)']),
                CDecl(('std::vector<int>', 'expected_vremoved_vec', '= %s' % expected_vremoved)),
                CBlock(['EXPECT_EQ(expected_vremoved_vec, vremoved_vec)']),
                CDecl(('std::vector<int>', 'eremoved_vec', '')),
                CDecl(('unsigned*', 'eremoved_ptr', '= eremoved.cpu_rd_ptr()')),
                CBlock(['eremoved_vec.assign(eremoved_ptr, eremoved_ptr + g.nedges)']),
                CDecl(('std::vector<int>', 'expected_eremoved_vec', '= %s' % expected_eremoved)),
                CBlock(['EXPECT_EQ(expected_eremoved_vec, eremoved_vec)']),
                ]),
            kernel_sizing(),
            main(graph_input, k),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'degree_filtering_test0')
    def test_degree_filtering_test0(self):
        graph_input = '{ {0, 1}, {0, 3}, {0, 4}, {1, 2}, {1, 3}, {1, 5}, {2, 3}, {2, 4}, {3, 5}, {4, 5}, {4, 6}, {4, 7}, {5, 6}, {5, 7}, {6, 7}, {6, 8}, {7, 8}, {8, 9} }'
        expected_vremoved = '{ 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 }'
        #                 idx: 0 1 2 3 4 5 6 7 8 9 1011121314151617181920212223242526272829303132333435
        #                 src: 0 0 0 1 1 1 1 2 2 2 3 3 3 3 4 4 4 4 4 5 5 5 5 5 6 6 6 6 7 7 7 7 8 8 8 9
        #                 dst: 1 3 4 3 5 0 2 1 3 4 5 0 1 2 5 0 2 6 7 1 3 4 6 7 4 5 7 8 4 5 6 8 6 7 9 8
        expected_eremoved = '{ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1 }'
        self.degree_filter_runner(graph_input, 4, expected_vremoved, expected_eremoved)

    def triangle_filter_runner(self, graph_input, k, expected_n_ktruss_nodes, expected_n_ktruss_edges):
        graph = gg.lib.graph.Graph("graph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k')], [
                CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
                Invoke("preprocess", ['gg']),
                CBlock('gg.copy_to_cpu(g)'),
                CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc);", parse=False),
                CDecl(('Shared<unsigned>', 'outdegrees', '')),
                CDecl(('Shared<unsigned>', 'indegrees', '')),
                CDecl(('Shared<unsigned>', 'vremoved', '')),
                CBlock('vremoved.alloc(g.nnodes)'),
                CBlock('vremoved.zero_gpu()'),
                CDecl(('Shared<unsigned>', 'eremoved', '')),
                CBlock('eremoved.alloc(g.nedges)'),
                CBlock('eremoved.zero_gpu()'),
                CBlock('degree_filter(g, gg, k, outdegrees, indegrees, vremoved, eremoved)'),
                CDecl(('Shared<unsigned>', 'triangles', '')),
                CDecl(('unsigned', 'n_ktruss_nodes', '')),
                CDecl(('unsigned', 'n_ktruss_edges', '')),
                CBlock('triangle_filter(g, gg, k, outdegrees, indegrees, triangles, eremoved, vremoved, &n_ktruss_nodes, &n_ktruss_edges)'),
                CBlock(['EXPECT_EQ(%d, n_ktruss_nodes)' % expected_n_ktruss_nodes]),
                CBlock(['EXPECT_EQ(%d, n_ktruss_edges)' % expected_n_ktruss_edges]),
                ]),
            kernel_sizing(),
            main(graph_input, k),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'triangle_filtering_test0')
    def test_triangle_edges0(self):
        graph_input = '{ {0, 1}, {0, 3}, {0, 4}, {1, 2}, {1, 3}, {1, 5}, {2, 3}, {2, 4}, {3, 5}, {4, 5}, {4, 6}, {4, 7}, {5, 6}, {5, 7}, {6, 7}, {6, 8}, {7, 8}, {8, 9} }'
        expected_n_ktruss_nodes = 4
        expected_n_ktruss_edges = 12
        self.triangle_filter_runner(graph_input, 4, expected_n_ktruss_nodes, expected_n_ktruss_edges)

if __name__ == '__main__':
    unittest.main()
