#include "edgelist_graph.h"

#include <vector>
#include <tuple>

namespace gpgraphlib {
  EdgeListGraph::EdgeListGraph() {
  }

  EdgeListGraph::EdgeListGraph(std::list<std::pair<unsigned, unsigned>> edges) : edges(edges) {
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
      { return me.first < other.first; });

    std::list<std::pair<unsigned, unsigned>>::iterator edgeIterator = edges.begin();

    for (unsigned n = 0; n < nnodes(); n++) {
      for (; edgeIterator != edges.end() && edgeIterator->first == n; edgeIterator++) {
          edge_dst[ei] = edgeIterator->second;
          ei = ei + 1;
      }

      row_start[1+n] = ei;
    }
  }
}
