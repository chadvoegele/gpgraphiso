#include "edgelist_graph.h"

#include <vector>
#include <tuple>

namespace gpgraphlib {
  EdgeListGraph::EdgeListGraph() {
  }

  EdgeListGraph::EdgeListGraph(std::list<std::pair<unsigned, unsigned>> edges) : edges(edges) {
  }

  EdgeListGraph::EdgeListGraph(std::initializer_list<std::initializer_list<unsigned>> l) {
    for (auto e : l) {
      if (e.size() != 2) {
        throw std::runtime_error("EdgeListGraph initializer must be list of pairs.");
      }

      unsigned i=0, src, dst;
      for (auto v : e) {
        if (i == 0) {
          src = v;
        } else if (i == 1) {
          dst = v;
        }
        i++;
      }

      addEdge(src, dst);
    }
  }

  void EdgeListGraph::addEdge(unsigned src, unsigned dst) {
    edges.push_back(std::make_pair(src, dst));
  }

  unsigned EdgeListGraph::nedges() {
    return edges.size();
  }

  // Assume nodes start at index 0
  unsigned EdgeListGraph::nnodes() {
    unsigned nnodes = 0;
    for (auto edge : edges) {
      nnodes = edge.first > nnodes ? edge.first : nnodes;
      nnodes = edge.second > nnodes ? edge.second : nnodes;
    }
    return edges.size() == 0 ? 0 : nnodes + 1;
  }

  void EdgeListGraph::setCSR(unsigned* row_start, unsigned* edge_dst) {
    row_start[0] = 0;
    unsigned ei = 0;

    edges.sort([](std::pair<unsigned, unsigned>& me, std::pair<unsigned, unsigned>& other)
      { return me.first < other.first || (me.first == other.first && me.second < other.second ); });

    std::list<std::pair<unsigned, unsigned>>::iterator edgeIterator = edges.begin();

    for (unsigned n = 0; n < nnodes(); n++) {
      for (; edgeIterator != edges.end() && edgeIterator->first == n; edgeIterator++) {
          edge_dst[ei] = edgeIterator->second;
          ei = ei + 1;
      }

      row_start[1+n] = ei;
    }
  }

  bool EdgeListGraph::operator==(const EdgeListGraph& other) const {
    return edges == other.edges;
  }

  ::std::ostream& operator<<(::std::ostream& os, const EdgeListGraph& g) {
    os << "{";
    bool first_iter = true;
    for (auto& e : g) {
      if (!first_iter) {
        os << ", ";
      }
      os << "(" << std::get<0>(e) << "->" << std::get<1>(e) << ")";
      first_iter = false;
    }
    os << "}";
    return os;
  }
}
