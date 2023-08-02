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

  std::cout << graph.nnodes << " " << graph.nnodes << std::endl;

  for (int node = 1; node <= graph.nnodes; node++) {
    std::cout << node << " 1" << std::endl;
  }

  return 0;
}
