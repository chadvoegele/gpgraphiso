import gg.compiler
from gg.ast import *

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

def main(dlist, dprop, qlist, qprop):
        k = Kernel("main", [], [
            CDecl(('std::list<std::pair<unsigned, unsigned>>', 'dlist','= %s' % dlist)),
            CDecl(('gpgraphlib::EdgeListGraph', 'delg', '= dlist')),
            CDecl(('CSRGraphTy', 'dg', '')),
            CBlock(['dg.nnodes = delg.nnodes()']),
            CBlock(['dg.nedges = delg.nedges()']),
            CBlock(['dg.allocOnHost()']),
            CBlock(['delg.setCSR(dg.row_start, dg.edge_dst)']),
            CDecl(('CSRGraphTy', 'dgg', '')),
            CBlock(('dg.copy_to_gpu(dgg)')),
            CDecl(('int', 'dprop_data[]', '= %s' % dprop)),
            CDecl(('Shared<int>', 'dprop', '= dg.nnodes')),
            CBlock(['memcpy(dprop.cpu_wr_ptr(), dprop_data, sizeof(dprop_data))']),
            CDecl(('std::list<std::pair<unsigned, unsigned>>', 'qlist','= %s' % qlist)),
            CDecl(('gpgraphlib::EdgeListGraph', 'qelg', '= qlist')),
            CDecl(('CSRGraphTy', 'qg', '')),
            CBlock(['qg.nnodes = qelg.nnodes()']),
            CBlock(['qg.nedges = qelg.nedges()']),
            CBlock(['qg.allocOnHost()']),
            CBlock(['qelg.setCSR(qg.row_start, qg.edge_dst)']),
            CBlock(('qg.copy_to_gpu(qgg)')),
            CDecl(('CSRGraphTy', 'qgg', '')),
            CDecl(('int', 'qprop_data[]', '= %s' % qprop)),
            CDecl(('Shared<int>', 'qprop', '= qg.nnodes')),
            CBlock(['memcpy(qprop.cpu_wr_ptr(), qprop_data, sizeof(qprop_data))']),
            CBlock(['gg_main(dg, dgg, qg, qgg, dprop, qprop)']),
            ],
            host=True,
            ret_type='int')
        return k
