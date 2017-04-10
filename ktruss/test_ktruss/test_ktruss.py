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
    @unittest.skipIf(skip_tests, 'count_triangle_edges1')
    def test_count_triangle_edges1(self):
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
                CDecl(('std::vector<int>', 'expected_triangle_count', '= { 1,2,1,1,1,2,1,0,0,1,0,0,1,1 } ')),
                CBlock(['EXPECT_EQ(expected_triangle_count, triangle_count_vec)']),
                ]),
            kernel_sizing(),
            main('{ { 0,1 }, { 0,2 }, { 0,5 }, { 1,0 }, { 1,2 }, { 2,0 }, { 2,1 }, { 2,3 }, { 2,4 }, { 2,5 }, { 3,2 }, { 4,2 }, { 5,0 }, { 5,2 } }'),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

    @unittest.skipIf(skip_tests, 'max_ktruss')
    def test_max_ktruss(self):
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
                CBlock(['EXPECT_EQ(4, max_ktruss_size)']),
                CDecl(('std::vector<int>', 'ktruss_nodes_vec', '(max_ktruss_nodes.nitems())')),
                CBlock(['ktruss_nodes_vec.assign(max_ktruss_nodes.list.cpu_rd_ptr(), max_ktruss_nodes.list.cpu_rd_ptr()+max_ktruss_nodes.nitems())']),
                CDecl(('std::vector<int>', 'expected_ktruss_nodes', '= { 0,1,2,5 } ')),
                CBlock(['EXPECT_EQ(expected_ktruss_nodes, ktruss_nodes_vec)']),
                ]),
            kernel_sizing(),
            main('{ { 0,1 }, { 0,2 }, { 0,5 }, { 1,0 }, { 1,2 }, { 2,0 }, { 2,1 }, { 2,3 }, { 2,4 }, { 2,5 }, { 3,2 }, { 4,2 }, { 5,0 }, { 5,2 } }'),
            ])
        ast = ktruss.ktruss.ast
        self.run_test(ast, test_ast)

if __name__ == '__main__':
    unittest.main()
