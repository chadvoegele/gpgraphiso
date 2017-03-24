#include <iostream>
#include "gg.h"

int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << "Usage: convert [input gr filename]" << std::endl;
    return 1;
  }

  std::string input(argv[1]);

  CSRGraph graph;
  graph.init();
  graph.read((char*)input.c_str());

  std::cout << graph.nnodes << " " << graph.nnodes << " " << graph.nedges << std::endl;

  for (int node = 0; node < graph.nnodes; node++) {
    for (int ei = graph.row_start[node]; ei < graph.row_start[node+1]; ei++) {
      int edge_dest = graph.edge_dst[ei];
      std::cout << node << " " << edge_dest << std::endl;
    }
  }

  return 0;
}
