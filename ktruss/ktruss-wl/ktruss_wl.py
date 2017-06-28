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
    #CDecl(('extern index_type', 'wlione_end', '')),  # for IrGL parsing
    #CDecl(('extern WorklistT', 'in_wl', '')),  # for IrGL parsing
    #CDecl(('extern WorklistT', 'out_wl', '')),  # for IrGL parsing
    Kernel('init_degree', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'vremoved'), ('unsigned*', 'eremoved'), ('unsigned', 'k')], [
      ForAll('src', graph.nodes(), [
        If('!vremoved[src]', [
          ForAll('edge', graph.edges('src'), [
            CDecl(('int', 'dst', '= graph.getAbsDestination(edge)')),
            If('!eremoved[edge]', [
              CBlock('outdegrees[src]++'),
              CBlock('atomicAdd(&indegrees[dst], 1U)'),
            ]),
          ]),
        ]),
      ]),
    ]),
    Kernel('mark_degree', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'vremoved'), ('unsigned', 'k'), ('unsigned*', 'removed_vertex')], [
      ForAll('src', graph.nodes(), [
        If('!vremoved[src] && (outdegrees[src] < k - 1 || indegrees[src] < k - 1)', [
          CBlock('vremoved[src] = 1'),
          CBlock('*removed_vertex = 1'),
        ]),
      ]),
    ]),
    Kernel('remove_orphaned_edges', [graph.param(), ('unsigned*', 'vremoved'), ('unsigned*', 'eremoved')], [
      ForAll('src', graph.nodes(), [
        ForAll('edge', graph.edges('src'), [
          CDecl(('int', 'dst', '= graph.getAbsDestination(edge)')),
          If('vremoved[src] || vremoved[dst]', [
            CBlock('eremoved[edge] = 1'),
          ]),
        ]),
      ]),
    ]),
    Kernel('degree_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('Shared<unsigned>&', 'outdegrees'), ('Shared<unsigned>&', 'indegrees'), ('Shared<unsigned>&', 'vremoved'), ('Shared<unsigned>&', 'eremoved')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('outdegrees.alloc(g.nnodes)'),
      CBlock('indegrees.alloc(g.nnodes)'),

      CDecl(('Shared<unsigned>', 'removed_vertex', '(1)')),
      CBlock('*removed_vertex.cpu_wr_ptr() = 1'),
      While('*removed_vertex.cpu_wr_ptr()', [
        CBlock('*removed_vertex.cpu_wr_ptr() = 0'),
        CBlock('outdegrees.zero_gpu()'),
        CBlock('indegrees.zero_gpu()'),
        Invoke('init_degree', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'k']),
        Invoke('mark_degree', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'k', 'removed_vertex.gpu_wr_ptr()']),
        Invoke('remove_orphaned_edges', ['gg', 'vremoved.gpu_rd_ptr()', 'eremoved.gpu_wr_ptr()']),
      ]),

      If('DEBUG', [
        CBlock('printf("ver:    ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", n)'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("outdeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", outdegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("indeg:  ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", indegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("vrem:   ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", vremoved.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
      ]),
    ], host=True),

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

    Kernel("intersect", [graph.param(), ('index_type', 'u'), ('index_type', 'v'), ('unsigned*', 'vremoved'), ('unsigned*', 'eremoved')], [
        CDecl(('index_type', 'u_start', '= graph.getFirstEdge(u)')),
        CDecl(('index_type', 'u_end', '= graph.getFirstEdge(u+1)')),
        CDecl(('index_type', 'v_start', '= graph.getFirstEdge(v)')),
        CDecl(('index_type', 'v_end', '= graph.getFirstEdge(v+1)')),
        CDecl(('index_type', 'u_it', '= u_start')),
        CDecl(('index_type', 'v_it', '= v_start')),
        CDecl(('index_type', 'a', '')),
        CDecl(('index_type', 'b', '')),
        CDecl(('int', 'count', '= 0')),
        While('u_it < u_end && v_it < v_end', [
            CBlock('a = graph.getAbsDestination(u_it)'),
            CBlock('b = graph.getAbsDestination(v_it)'),
            CDecl(('int', 'd', '= a - b')),
            If('d == 0 && !eremoved[u_it] && !eremoved[v_it]', [CBlock('count++')]),
            If('d <= 0', [CBlock('u_it++')]),
            If('d >= 0', [CBlock('v_it++')]),
        ]),
        CBlock('return count'),
    ], device=True, ret_type = 'unsigned int'),

    Kernel('init_triangles', [graph.param(), ('unsigned*', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned*', 'vremoved'), ('unsigned', 'k')], [
      ForAll("src", graph.nodes(), [
        If('!vremoved[src]', [
          ClosureHint(ForAll("edge", graph.edges("src"), [
            CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
            If('!vremoved[dst]', [
              CBlock('triangles[edge] = intersect(graph, dst, src, vremoved, eremoved)'),
            ]),
          ])),
        ]),
      ]),
    ]),

    Kernel('mark_triangles', [graph.param(), ('unsigned*', 'triangles'), ('unsigned*', 'eremoved'), ('unsigned*', 'vremoved'), ('unsigned', 'k'), ('unsigned*', 'removed_edge')], [
      ForAll("src", graph.nodes(), [
        If('!vremoved[src]', [
          ClosureHint(ForAll("edge", graph.edges("src"), [
            If('!eremoved[edge] && triangles[edge] < k-2', [
              CBlock('eremoved[edge] = 1'),
              CBlock('*removed_edge = 1'),
            ]),
          ])),
        ]),
      ]),
    ]),

    Kernel('edge_removal', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'eremoved'), ('unsigned*', 'vremoved')], [
      ForAll('src', graph.nodes(), [
        If('!vremoved[src]', [
          ClosureHint(ForAll('edge', graph.edges('src'), [
            CDecl(('index_type', 'dst', '= graph.getAbsDestination(edge)')),
            If('!vremoved[src] && !vremoved[dst] && eremoved[edge]', [
              CBlock('outdegrees[src]--'),
              CBlock('atomicSub(&indegrees[dst], 1U)'),
            ]),
          ])),
        ]),
      ]),
    ]),
    Kernel('remove_isolates', [graph.param(), ('unsigned*', 'outdegrees'), ('unsigned*', 'indegrees'), ('unsigned*', 'vremoved')], [
      ForAll('src', graph.nodes(), [
        If('!vremoved[src] && outdegrees[src] == 0 && indegrees[src] == 0', [
          CBlock('vremoved[src] = 1'),
        ]),
      ]),
    ]),

    Kernel('triangle_filter', [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('Shared<unsigned>&', 'outdegrees'), ('Shared<unsigned>&', 'indegrees'), ('Shared<unsigned>&', 'triangles'), ('Shared<unsigned>&', 'eremoved'), ('Shared<unsigned>&', 'vremoved'), ('unsigned*', 'n_ktruss_nodes'), ('unsigned*', 'n_ktruss_edges')], [
      CDecl(('dim3', 'blocks', '')),
      CDecl(('dim3', 'threads', '')),
      CBlock('kernel_sizing(g, blocks, threads)'),
      CBlock('triangles.alloc(g.nedges)'),
      CBlock('triangles.zero_gpu()'),

      If('DEBUG', [
        CBlock('printf("src: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CFor(CDecl(('unsigned', 'e', '= g.row_start[n]')), 'e < g.row_start[n+1]', 'e++', [
            CBlock('printf("%u ", n)'),
          ]),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("dst: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CFor(CDecl(('unsigned', 'e', '= g.row_start[n]')), 'e < g.row_start[n+1]', 'e++', [
            CBlock('printf("%u ", g.edge_dst[e])'),
          ]),
        ]),
        CBlock('printf("\\n")'),]
         ),

      CDecl(('Shared<unsigned>', 'removed_edge', '(1)')),
      CBlock('*removed_edge.cpu_wr_ptr() = 1'),
      While('*removed_edge.cpu_wr_ptr()', [
        CBlock('*removed_edge.cpu_wr_ptr() = 0'),
        Invoke('init_triangles', ['gg', 'triangles.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'vremoved.gpu_rd_ptr()', 'k']),
        Invoke('mark_triangles', ['gg', 'triangles.gpu_wr_ptr()', 'eremoved.gpu_wr_ptr()', 'vremoved.gpu_wr_ptr()', 'k', 'removed_edge.gpu_wr_ptr()']),
      ]),
      Invoke('edge_removal', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'eremoved.gpu_rd_ptr()', 'vremoved.gpu_rd_ptr()']),
      Invoke('remove_isolates', ['gg', 'outdegrees.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'vremoved.gpu_rd_ptr()']),

      If('DEBUG', [
        CBlock('printf("ver: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", n)'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("outdeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", outdegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
        CBlock('printf("indeg: ")'),
        CFor(CDecl(('unsigned', 'n', '= 0')), 'n < g.nnodes', 'n++', [
          CBlock('printf("%u ", indegrees.cpu_rd_ptr()[n])'),
        ]),
        CBlock('printf("\\n")'),
      ]),


      CDecl(('unsigned', 'n_nodes_removed', '= 0')),
      CBlock('mgpu::Reduce(vremoved.gpu_rd_ptr(), g.nnodes, 0U, mgpu::plus<unsigned>(), (unsigned*)0, &n_nodes_removed, *mgc);', parse=False),
      CBlock('*n_ktruss_nodes = g.nnodes - n_nodes_removed'),

      CDecl(('unsigned', 'n_edges_removed', '= 0')),
      CBlock('mgpu::Reduce(eremoved.gpu_rd_ptr(), g.nedges, 0U, mgpu::plus<unsigned>(), (unsigned*)0, &n_edges_removed, *mgc);', parse=False),
      CBlock('*n_ktruss_edges = g.nedges - n_edges_removed'),
    ], host=True),

    Kernel("place_edges_on_wl", [graph.param()],
           [
               ForAll("edge", RangeIterator("graph.nedges"),
                   [
                       WL.push("edge"),
                   ]
               ),
           ]
       ),

    Kernel("cull_edges_node_degree", [graph.param(), 
                                      ('unsigned *', 'src'),
                                      ('unsigned *', 'indegree'), 
                                      ('unsigned *', 'outdegree'),
                                      ('unsigned *', 'eremoved'),
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
                                  ('unsigned *', 'eremoved'),],
           [
               ForAll("wledge", WL.items(),
                      [
                          CDecl([("unsigned ", "u", ""),
                                 ("unsigned", "v", "")]),

                          CDecl([("int", "edge", ""),
                                 ("bool", "pop", "")]),

                          WL.pop("pop", "wledge", "edge"),

                          CBlock(['u = src[edge]',
                                  'v = graph.getAbsDestination(edge)']),

                          CBlock("triangles[edge] = intersect(graph, u, v, 0, eremoved)"),
                      ]
                  ),
           ]),

    Kernel("cull_edges_tri_count", [graph.param(), 
                                    ('unsigned *', 'src'),
                                    ('unsigned *', 'indegree'), 
                                    ('unsigned *', 'outdegree'),
                                    ('unsigned *', 'triangles'),
                                    ('unsigned *', 'eremoved'),
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
                          
                          If('triangles[edge] < k - 2', 
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
    

    Kernel("gg_main", [params.GraphParam('g', True), params.GraphParam('gg', True), ('unsigned', 'k'), ('char*', 'outputkind'), ('FILE*', 'outf')], [
      CDecl(('ggc::Timer', 'timer', '("gg_main")')),

      If('DEBUG', [
            CBlock('printf("# nodes: %u\\n", g.nnodes)'),
            CBlock('printf("# edges: %u\\n", g.nedges)'),
      ]),

      #CBlock(['mgc = mgpu::CreateCudaDevice(CUDA_DEVICE)'], parse=False),

      # not sure we require two
      CDecl(('Shared<unsigned>', 'outdegrees', '(g.nnodes)')),
      CDecl(('Shared<unsigned>', 'indegrees', '(g.nnodes)')),
      CDecl(('Shared<unsigned>', 'src', '(g.nedges)')),
      CDecl(('Shared<unsigned>', 'eremoved', '(g.nedges)')),
      CDecl(('Shared<bool>', 'update', '(1)')),
      CDecl(('Shared<unsigned>', 'triangles', '(g.nedges)')),

      CDecl(('unsigned', 'n_ktruss_nodes', '')),
      CDecl(('unsigned', 'n_ktruss_edges', '')),
 
      CBlock('timer.start()'),
      Invoke("preprocess", ['gg', 'src.gpu_wr_ptr()', 'indegrees.gpu_wr_ptr()', 'outdegrees.gpu_wr_ptr()']),
      #CBlock('gg.copy_to_cpu(g)'),
      CBlock("mgpu::SegSortPairsFromIndices(gg.edge_data, gg.edge_dst, gg.nedges, (const int *) gg.row_start + 1, gg.nnodes - 1, *mgc);", parse=False),

      CBlock('eremoved.zero_gpu()'),

      Pipe([
          Invoke("place_edges_on_wl", ['gg']),
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

          Pipe([
              CBlock("*(update.cpu_wr_ptr()) = false"),
              Invoke("count_tri_per_edge", ['gg', 'src.gpu_rd_ptr()',
                                                'indegrees.gpu_rd_ptr()',
                                                'outdegrees.gpu_rd_ptr()',
                                                'triangles.gpu_wr_ptr()',
                                                'eremoved.gpu_wr_ptr()']),
              Invoke("cull_edges_tri_count", ['gg', 
                                              'src.gpu_rd_ptr()',
                                              'indegrees.gpu_rd_ptr()',
                                              'outdegrees.gpu_rd_ptr()',
                                              'triangles.gpu_rd_ptr()',
                                              'eremoved.gpu_wr_ptr()',
                                              'update.gpu_wr_ptr()',
                                              'k']),
              # Invoke("cull_edges_node_degree", ['gg', 
              #                                   'src.gpu_rd_ptr()',
              #                                   'indegrees.gpu_rd_ptr()',
              #                                   'outdegrees.gpu_rd_ptr()',
              #                                   'eremoved.gpu_wr_ptr()',
              #                                   'update.gpu_wr_ptr()',
              #                                   'k']),
              If("!*(update.cpu_rd_ptr())", [CBlock("break")]),
              ]),

          #CBlock('printf("%u %u\\n", gg.nedges, pipe.in_wl().nitems())', parse=False),
      ], once=True, wlinit=WLInit("gg.nedges", [])),
        
      CDecl(('Shared<unsigned>', 'vremoved', '')),

      # CBlock('vremoved.alloc(g.nnodes)'),
      # CBlock('vremoved.zero_gpu()'),


      # CBlock('degree_filter(g, gg, k, outdegrees, indegrees, vremoved, eremoved)'),



      # CBlock('triangle_filter(g, gg, k, outdegrees, indegrees, triangles, eremoved, vremoved, &n_ktruss_nodes, &n_ktruss_edges)'),

      CBlock('timer.stop()'),
      CBlock('timer.print()'),

      CBlock('fprintf(stderr, "Total time: %llu ms\\n", timer.duration_ms())'),
      CBlock('fprintf(stderr, "Total time: %llu ns\\n", timer.duration())'),

      CBlock('gg.copy_to_cpu(g)'),
      CBlock('output(g, outputkind, outf, n_ktruss_nodes, n_ktruss_edges, eremoved.cpu_rd_ptr())'),        
    ]),
])
