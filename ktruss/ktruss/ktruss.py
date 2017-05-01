import gg.compiler
from gg.ast import *
import gg.lib.aol
from gg.types import RangeIterator

WL = gg.lib.wl.Worklist()
graph = gg.lib.graph.Graph('graph')

ast = Module([
    CBlock([cgen.Include("ktruss.h")]),
    CDecl(('unsigned', 'KTRUSS_K', '= 4')),
    CDecl(('int', 'CUDA_DEVICE', '= 0')),
    CDecl(('mgpu::ContextPtr', 'mgc', '')),
    Kernel('init_degree', [graph.param(), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      ForAll("node", graph.nodes(), [
        CDecl(('int', 'degree', '= graph.getOutDegree(node)')),
        CBlock('degrees[node] = degree'),
        If('degrees[node] < k - 1', [
          WL.push("node"),
        ]),
      ]),
    ]),
    Kernel('degree_filter_iter', [graph.param(), ('unsigned*', 'degrees'), ('unsigned', 'k')], [
      ForAll('wli', WL.items(), [
        CDecl(('int', 'src', '')),
        CDecl(('bool', 'pop', '')),
        WL.pop('pop', 'wli', 'src'),
        For('edge', graph.edges('src'), [
          CDecl(('int', 'dst', '= graph.getAbsDestination(edge)')),
          CDecl(('int', 'nnodes', '= graph.nnodes')),
          CBlock('atomicDec(&degrees[dst], nnodes)'),
          If('degrees[dst] < k - 1', [
            WL.push('dst'),
          ]),
          CBlock('atomicExch(&degrees[src], nnodes)'),
        ]),
      ]),
    ]),
    Kernel('degree_filter', [params.GraphParam('g', True), params.GraphParam('gg', True)], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock(['kernel_sizing(g, blocks, threads)']),
      CDecl(('Shared<unsigned>', 'degrees', '(g.nnodes)')),
      Pipe([
        Invoke('init_degree', ['gg', 'degrees.gpu_wr_ptr()', 'KTRUSS_K']),
        Pipe([
          Invoke('degree_filter_iter', ['gg', 'degrees.gpu_wr_ptr()', 'KTRUSS_K']),
        ]),
      ], wlinit=WLInit('4*g.nnodes'), once=True),
    ], host=True),
    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True)], [
        CFor(CDecl(('unsigned', 'i', ' = 0')), 'i < ktruss_nodes_vec.size()', 'i++', [
          CBlock('printf("ktruss node[%u]=%d\\n", i, ktruss_nodes_vec[i])'),
        ]),
    ]),
])
