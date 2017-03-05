#pragma once

#include <list>
#include <utility>

namespace gpgraphlib {
  class EdgeListGraph {
    public:
      EdgeListGraph();
      EdgeListGraph(std::list<std::pair<unsigned, unsigned>> edges);
      void addEdge(unsigned src, unsigned dst);
      unsigned nedges();
      unsigned nnodes();
      void setCSR(unsigned* row_start, unsigned* edge_dst);
      std::list<std::pair<unsigned, unsigned>>::iterator begin() { return edges.begin(); }
      std::list<std::pair<unsigned, unsigned>>::iterator end() { return edges.end(); }

    private:
      // Don't assume that these maintain order
      std::list<std::pair<unsigned, unsigned>> edges;
  };
}
