/* -*- mode: c++ */

#include <gg.h>
#include "ktruss.h"

void output(CSRGraphTy &g, const char *outputkind, FILE *outf, unsigned n_ktruss_nodes, unsigned n_ktruss_edges, unsigned *edge_removed) {
  if(strstr(outputkind, "counts")) {
      fprintf(outf, "# ktruss nodes: %u\\n", n_ktruss_nodes);
      fprintf(outf, "# ktruss edges: %u\\n", n_ktruss_edges);
  }
	
  if(strstr(outputkind, "edges")){
    for(unsigned n = 0; n < g.nnodes; n++) {
      for(unsigned e = g.row_start[n]; e < g.row_start[n+1]; e++) {
	if(!edge_removed[e] && n < g.edge_dst[e]) {
	  fprintf(outf, "%d %d\n", n, g.edge_dst[e]);
	}
      }
    }
  }
}

