import gg.compiler
from gg.ast import *
from gg.ast.params import *
import gg.lib.aol
from gg.types import RangeIterator

WL = gg.lib.wl.Worklist()
graph = gg.lib.graph.Graph('graph')

ast = Module([
    CBlock([cgen.Include("ktruss.h", system=False)]),
    CBlock([cgen.Include("kernels/segmentedsort.cuh")]),
    CBlock([cgen.Include("kernels/reduce.cuh")]),
    CDecl(('const int', 'DEBUG', '=0')),

    Kernel("preprocess", [graph.param(), 
                          ('unsigned *', 'src'),
                          ('unsigned *', 'indegree'), 
                          ('unsigned *', 'outdegree')], 
           [
               ForAll("node", graph.nodes(), [
                   CDecl(('int', 'degree', '= graph.getOutDegree(node)')),

                   CBlock(['indegree[node] = degree',
                           'outdegree[node] = degree']),

                   ClosureHint(ForAll("edge", graph.edges("node"), [
                       CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
                       #    CDecl(('int', 'dst_degree', '= graph.getOutDegree(dst)')),

                       CBlock(["src[edge] = node"]),
                       CBlock(["graph.edge_data[edge] = dst"]),
                   ])),
        ])
    ]),

    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned*', 'vremoved'), ('unsigned char*', 'eremoved'), ('unsigned', 'k')], [
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= graph.getFirstEdge(u+1)')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= graph.getFirstEdge(v+1)')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        CDecl(('int', 'count', '= 0')),
        While('u_it < u_end && v_it < v_end && count < k', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d == 0 && !eremoved[u_it] && !eremoved[v_it]', [CBlock('count++')]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
        CBlock('return count'),
    ], device=True, ret_type = 'unsigned int'),

    Kernel("place_edges_on_wl", [graph.param()],
           [
               If('tid == 0', [CBlock('*out_wl.dindex = graph.nedges', parse=False)]),
               ForAll("edge", RangeIterator("graph.nedges"),
                   [
                       CBlock('out_wl.push_id(edge, edge)', parse=False),
                       If("0", [WL.push("edge")]),
                   ]
               ),
           ]
       ),

    Kernel("cull_edges_node_degree", [graph.param(), 
                                      ('unsigned *', 'src'),
                                      ('unsigned *', 'indegree'), 
                                      ('unsigned *', 'outdegree'),
                                      ('unsigned char*', 'eremoved'),
                                      ('bool *', 'edge_removed'),
                                      ('unsigned ', 'k')],
           [
               CDecl(('bool', 'er', ' = false')),
               ForAll("wledge", WL.items(),
                      [
                          CDecl([("unsigned ", "u", ""),
                                 ("unsigned", "v", "")]),

                          CDecl([("int", "edge", ""),
                                 ("bool", "pop", "")]),

                          WL.pop("pop", "wledge", "edge"),

                          CBlock("assert(eremoved[edge] == 0)"),

                          CBlock(['u = src[edge]',
                                  'v = graph.getAbsDestination(edge)']),
                          
                          If('outdegree[u] < k - 1 || indegree[v] < k - 1', 
                             [
                                 CBlock("eremoved[edge] = 1"),
                                 CBlock("er = true"),
                                 CBlock(["atomicSub(outdegree + u, 1)",
                                         "atomicSub(indegree + v, 1)"])
                             ],
                             [CBlock("eremoved[edge] = 0"),
                              WL.push("edge"),]
                         )
                      ]
                  ),
               If("er", [CBlock("*edge_removed = true")]),
           ]),

    Kernel("count_tri_per_edge", [graph.param(), 
                                  ('unsigned *', 'src'), 
                                  ('unsigned *', 'indegree'), 
                                  ('unsigned *', 'outdegree'),
                                  ('unsigned *', 'triangles'),
                                  ('unsigned char *', 'eremoved'),
                                  ('bool *', 'edge_removed'),
                                  ('unsigned', 'k')],
           [
               CDecl(('bool', 'er', ' = false')),
               ForAll("wledge", WL.items(),
                      [
                          CDecl([("unsigned ", "u", ""),
                                 ("unsigned", "v", ""),
                                 ('unsigned', 'count', "= 0")]),

                          CDecl([("int", "edge", ""),
                                 ("bool", "pop", "")]),

                          WL.pop("pop", "wledge", "edge"),

                          CBlock(['u = src[edge]',
                                  'v = graph.getAbsDestination(edge)']),

                          If("outdegree[u] < k - 1 || indegree[v] < k - 1",
                             [CBlock("count = 0")],
                             [CBlock("count = intersect(graph, u, v, 0, eremoved, k - 2)")]
                         ),

                          If('count < k - 2', 
                             [
                                                          
                                 CBlock(['u = src[edge]',
                                         'v = graph.getAbsDestination(edge)']),
                                 CBlock("eremoved[edge] = 1"),
                                 CBlock("er = true"),
                                 CBlock(["atomicSub(outdegree + u, 1)",
                                         "atomicSub(indegree + v, 1)"])
                             ],
                             [CBlock("eremoved[edge] = 0"),
                              WL.push("edge"),])

                      ]
                      ),
               If("er", [CBlock("*edge_removed = true")]),
           ]),

    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), 
                       ('unsigned', 'k'), 
                       ('Shared<unsigned char>&', 'eremoved'),
                       ('unsigned &', 'n_ktruss_nodes'),
                       ('unsigned &', 'n_ktruss_edges')], [
      # not sure we require two
      CDecl(('Shared<unsigned>', 'outdegrees', '(g.nnodes)')),
      CDecl(('Shared<unsigned>', 'indegrees', '(g.nnodes)')),

      CDecl(('Shared<unsigned>', 'src', '(g.nedges)')),
      CDecl(('Shared<bool>', 'update', '(1)')),
      CDecl(('Shared<unsigned>', 'triangles', '(g.nedges)')),

      # this version does not calculate these n_ktruss_nodes and n_ktruss_edges
 
      Invoke("preprocess", ['gg', 'src.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'outdegrees.gpu_wr_ptr()']),

      CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc)", parse=False),

      CBlock('eremoved.zero_gpu()'),

      Pipe([
          Invoke("place_edges_on_wl", ['gg']),
          Pipe([
              Pipe([
                  CBlock("*(update.cpu_wr_ptr()) = false"),
                  Invoke("cull_edges_node_degree", ['gg', 
                                                    'src.gpu_rd_ptr()',
                                                    'indegrees.gpu_rd_ptr()',
                                                    'outdegrees.gpu_rd_ptr()',
                                                    'eremoved.gpu_wr_ptr()',
                                                    'update.gpu_wr_ptr()',
                                                    'k']),
                  If("!*(update.cpu_rd_ptr())", [CBlock("break")]),
              ]),

              Invoke("count_tri_per_edge", ['gg', 'src.gpu_rd_ptr()',
                                            'indegrees.gpu_rd_ptr()',
                                            'outdegrees.gpu_rd_ptr()',
                                            'triangles.gpu_wr_ptr()',
                                            'eremoved.gpu_wr_ptr()',
                                            'update.gpu_wr_ptr()',
                                            'k']),
              If("!*(update.cpu_rd_ptr())", [CBlock("break")]),
          ]),

          #CBlock('printf("%u %u\\n", gg.nedges, pipe.in_wl().nitems())', parse=False),
          CBlock('dump_memory_info("end")')
      ], once=True, wlinit=WLInit("gg.nedges", [])),
    ]),
])
