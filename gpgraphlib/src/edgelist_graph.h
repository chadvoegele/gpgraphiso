#pragma once

#include <list>
#include <utility>

namespace gpgraphlib {
  class EdgeListGraph {
    public:
      EdgeListGraph();
      void addEdge(unsigned src, unsigned dst);
      unsigned nedges();
      unsigned nnodes();
      void setCSR(unsigned* row_start, unsigned* edge_dst);

    private:
      // Don't assume that these maintain order
      std::list<std::pair<unsigned, unsigned>> edges;
  };
}
