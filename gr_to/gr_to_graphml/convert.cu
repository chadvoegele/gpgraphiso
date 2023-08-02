#include <iostream>
#include <fstream>
#include "gg.h"

int main(int argc, char** argv) {
  if (argc != 3) {
    std::cerr << "Usage: convert [input gr filename] [output graphml filename]" << std::endl;
    return 1;
  }

  std::string input(argv[1]);
  std::string output(argv[2]);

  CSRGraph graph;
  graph.init();
  graph.read((char*)input.c_str());

  std::ofstream ofs(output.c_str());

  ofs << "<?xml version=\"1.0\"?>" << std::endl;
  ofs << "<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.1/graphml.xsd\">" << std::endl;
  ofs << "\t<graph id=\"G\" edgedefault=\"directed\">" << std::endl;

  for (int node = 0; node < graph.nnodes; node++) {
    ofs << "\t\t<node id=\"" << node << "\"></node>" << std::endl;
  }

  int edge_id = graph.nnodes;
  for (int node = 0; node < graph.nnodes; node++) {
    for (int ei = graph.row_start[node]; ei < graph.row_start[node+1]; ei++) {
      int edge_dest = graph.edge_dst[ei];
      ofs << "\t\t<edge id=\"" << edge_id << "\" source=\"" << node << "\" target=\"" << edge_dest << "\"></edge>" << std::endl;
      edge_id = edge_id + 1;
    }
  }

  ofs << "\t</graph>" << std::endl;
  ofs << "</graphml>" << std::endl;

  return 0;
}
