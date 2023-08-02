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
      static EdgeListGraph fromMTXFile(std::string filename);
      static EdgeListGraph fromMTXFileContents(std::string filecontents);
      void toMTXFile(std::string filename);
      std::string toMTXFileContents();
      void addEdge(unsigned src, unsigned dst);
      unsigned nedges();
      unsigned nnodes();
      void setCSR(unsigned* row_start, unsigned* edge_dst);
      EdgeListGraph makeSymmetric();
      std::list<std::pair<unsigned, unsigned>>::const_iterator begin() const { return edges.cbegin(); }
      std::list<std::pair<unsigned, unsigned>>::const_iterator end() const { return edges.cend(); }
      bool operator==(const EdgeListGraph& other) const;

    private:
      static std::list<std::pair<unsigned, unsigned>> parseMTX(std::istream& stream);
      void toMTX(std::ostream& stream);
      // Don't assume that these maintain order
      std::list<std::pair<unsigned, unsigned>> edges;
  };

  ::std::ostream& operator<<(::std::ostream& os, const EdgeListGraph& g);
}
