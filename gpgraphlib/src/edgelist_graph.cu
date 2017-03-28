#include "edgelist_graph.h"

#include <fstream>
#include <sstream>
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

  EdgeListGraph EdgeListGraph::fromMTXFile(std::string filename) {
    std::ifstream fs(filename);
    if (!fs.is_open()) {
      throw std::runtime_error("failed to open " + filename);
    }
    EdgeListGraph elg(parseMTX(fs));
    return elg;
  }

  EdgeListGraph EdgeListGraph::fromMTXFileContents(std::string filecontents) {
    std::istringstream ss(filecontents);
    EdgeListGraph elg(parseMTX(ss));
    return elg;
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

  std::list<std::pair<unsigned, unsigned>> EdgeListGraph::parseMTX(std::istream& stream) {
    std::list<std::pair<unsigned, unsigned>> el;
    int nnodes, nedges;
    if (!(stream >> nnodes && stream >> nnodes && stream >> nedges)) {
      throw std::runtime_error("Failed to read label header.");
    }

    unsigned min_node = UINT_MAX, max_node = 0;
    unsigned src, dst;
    while (stream >> src && stream >> dst) {
      el.push_back(std::make_pair(src, dst));
      min_node = src < min_node ? src : min_node;
      min_node = dst < min_node ? dst : min_node;
      max_node = src > max_node ? src : max_node;
      max_node = dst > max_node ? dst : max_node;
    }

    if (max_node - min_node + 1 != nnodes) {
      throw std::runtime_error("Mismatch between header # nodes and actual # of nodes.");
    }

    if (el.size() != nedges) {
      throw std::runtime_error("Mismatch between header # edges and actual # of edges.");
    }

    // Always index graph starting from 0.
    std::list<std::pair<unsigned, unsigned>> el0;

    for (auto& e : el) {
      std::tie(src, dst) = e;
      el0.push_back(std::make_pair(src - min_node, dst - min_node));
    }

    return el0;
  }

  void EdgeListGraph::toMTXFile(std::string filename) {
    std::ofstream fs(filename);
    if (!fs.is_open()) {
      throw std::runtime_error("failed to open " + filename);
    }
    toMTX(fs);
  }

  std::string EdgeListGraph::toMTXFileContents() {
    std::ostringstream ss;
    toMTX(ss);
    return ss.str();
  }

  void EdgeListGraph::toMTX(std::ostream& stream) {
    stream << nnodes() << " " << nnodes() << " " << nedges() << std::endl;
    unsigned src, dst;
    for (auto& e : edges) {
      std::tie(src, dst) = e;
      stream << 1+src << " " << 1+dst << std::endl;
    }
  }

  EdgeListGraph EdgeListGraph::makeSymmetric() {
    std::list<std::pair<unsigned, unsigned>> symel;

    unsigned src, dst;
    for (auto& e : edges) {
      std::tie(src, dst) = e;
      symel.push_back(std::make_pair(src, dst));
      symel.push_back(std::make_pair(dst, src));
    }
    symel.sort();
    symel.unique();

    EdgeListGraph symelg(symel);
    return symelg;
  }
}
