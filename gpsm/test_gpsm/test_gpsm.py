import unittest

import gg.compiler
from gg.ast import *

import pyirgltest
import gpsm.gpsm
import test_gpsm

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
            test_gpsm.testcore.kernel_sizing(),
            test_gpsm.testcore.main(
                '{ {0,1}, {0,2}, {1,0}, {1,4}, {1,3}, {2,0}, {2,3}, {2,4}, {3,1}, {3,2}, {3,5}, {4,2}, {4,1}, {4,5}, {5,3}, {5,4}, {6,4} }',
                '{ 5,1,9,9,1,5,9 }',
                '{ {0,1}, {0,2}, {1,0}, {1,3}, {2,0}, {2,3}, {3,1}, {3,2} }',
                '{ 5,1,9,1 }'),
            ])

        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

    def test_compile(self):
        test_ast = Module([test_gpsm.testcore.kernel_sizing()])
        ast = gpsm.gpsm.ast

        self.run_test(ast, test_ast)

if __name__ == '__main__':
    unittest.main()
