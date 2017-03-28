#include <iostream>
#include "edgelist_graph.h"

int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << "Usage: convert [input mtx filename]" << std::endl;
    return 1;
  }

  std::string input(argv[1]);

  gpgraphlib::EdgeListGraph el = gpgraphlib::EdgeListGraph::fromMTXFile(input);
  gpgraphlib::EdgeListGraph symel = el.makeSymmetric();
  std::cout << symel.toMTXFileContents();

  return 0;
}
