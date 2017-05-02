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
    def degree_filter_runner(self, graph_input, expected_degrees):
        graph = gg.lib.graph.Graph("graph")

        test_ast = Module([
            CBlock([cgen.Include('edgelist_graph.h')]),
            CBlock([cgen.Include('gtest/gtest.h')]),
            Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True)], [
                CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),
                CDecl(('Shared<unsigned>', 'degrees', '')),
                CBlock('degree_filter(g, gg, degrees)'),
                CDecl(('std::vector<int>', 'degrees_vec', '')),
                CDecl(('unsigned*', 'degrees_ptr', '= degrees.cpu_rd_ptr()')),
                CBlock(['degrees_vec.assign(degrees_ptr, degrees_ptr + g.nnodes)']),
                CDecl(('std::vector<int>', 'expected_degrees_vec', '= %s' % expected_degrees)),
                CBlock(['EXPECT_EQ(expected_degrees_vec, degrees_vec)']),
                ]),
            kernel_sizing(),
            main(graph_input),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'degree_filtering_test0')
    def test_count_triangle_edges0(self):
        graph_input = '{ {0, 1}, {0, 3}, {0, 4}, {1, 2}, {1, 5}, {2, 3}, {2, 4}, {3, 5}, {4, 5}, {4, 6}, {4, 7}, {5, 6}, {5, 7}, {6, 7}, {6, 8}, {7, 8}, {8, 9} }'
        #                     0 1 2 3 4 5 6 7 8 9
        expected_degrees = '{ 3,3,3,3,5,5,3,3,0,0 }'
        self.degree_filter_runner(graph_input, expected_degrees)

if __name__ == '__main__':
    unittest.main()
