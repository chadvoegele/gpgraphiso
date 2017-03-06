#pragma once

#include <list>
#include <utility>
#include <iostream>
#include <initializer_list>

namespace gpgraphlib {
  class EdgeListGraph {
    public:
      EdgeListGraph();
      EdgeListGraph(std::list<std::pair<unsigned, unsigned>> edges);
      EdgeListGraph(std::initializer_list<std::initializer_list<unsigned>> l);
      void addEdge(unsigned src, unsigned dst);
      unsigned nedges();
      unsigned nnodes();
      void setCSR(unsigned* row_start, unsigned* edge_dst);
      std::list<std::pair<unsigned, unsigned>>::const_iterator begin() const { return edges.cbegin(); }
      std::list<std::pair<unsigned, unsigned>>::const_iterator end() const { return edges.cend(); }
      bool operator==(const EdgeListGraph& other) const;

    private:
      // Don't assume that these maintain order
      std::list<std::pair<unsigned, unsigned>> edges;
  };

  ::std::ostream& operator<<(::std::ostream& os, const EdgeListGraph& g);
}
