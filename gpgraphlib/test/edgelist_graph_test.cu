#include <gtest/gtest.h>
#include <sstream>

#include "edgelist_graph.h"

using namespace gpgraphlib;

TEST(edgelist_graph, nedges_nnodes1) {
  EdgeListGraph elg;
  EXPECT_EQ(0, elg.nedges());
  EXPECT_EQ(0, elg.nnodes());
}

TEST(edgelist_graph, nedges_nnodes2) {
  EdgeListGraph elg;
  elg.addEdge(0, 1);
  elg.addEdge(1, 2);
  elg.addEdge(1, 3);
  elg.addEdge(2, 0);
  elg.addEdge(3, 0);
  EXPECT_EQ(5, elg.nedges());
  EXPECT_EQ(4, elg.nnodes());
}

TEST(edgelist_graph, csr_test) {
  EdgeListGraph elg;
  elg.addEdge(0, 1);
  elg.addEdge(1, 3);
  elg.addEdge(1, 2);
  elg.addEdge(2, 0);
  elg.addEdge(5, 0);
  EXPECT_EQ(5, elg.nedges());
  EXPECT_EQ(6, elg.nnodes());

  std::vector<unsigned> row_start(elg.nnodes()+1);
  std::vector<unsigned> edge_dst(elg.nedges());
  elg.setCSR(row_start.data(), edge_dst.data());

  std::vector<unsigned> expected_row_start = { 0, 1, 3, 4, 4, 4, 5 };
  EXPECT_EQ(expected_row_start, row_start);

  std::vector<unsigned> expected_edge_dst = { 1, 2, 3, 0, 0 };
  EXPECT_EQ(expected_edge_dst, edge_dst);
}

TEST(edgelist_graph, tostring_test) {
  EdgeListGraph elg;
  elg.addEdge(0, 1);
  elg.addEdge(1, 3);
  elg.addEdge(1, 2);
  elg.addEdge(2, 0);
  elg.addEdge(5, 0);
  EXPECT_EQ(5, elg.nedges());
  EXPECT_EQ(6, elg.nnodes());

  std::stringstream ss;
  ss << elg;
  EXPECT_EQ("{(0->1), (1->3), (1->2), (2->0), (5->0)}", ss.str());
}

TEST(edgelist_graph, eq_test) {
  EdgeListGraph elg;
  elg.addEdge(0, 1);
  elg.addEdge(1, 3);
  elg.addEdge(1, 2);

  EdgeListGraph elg2;
  elg2.addEdge(0, 1);
  elg2.addEdge(1, 3);
  elg2.addEdge(1, 2);

  EXPECT_EQ(elg, elg2);
}

TEST(edgelist_graph, initializer_test) {
  EdgeListGraph elg;
  elg.addEdge(0, 1);
  elg.addEdge(1, 3);
  elg.addEdge(1, 2);

  EdgeListGraph elg2 = { {0, 1}, {1, 3}, {1, 2} };
  EXPECT_EQ(elg, elg2);
}

TEST(edgelist_graph, from_mtx_test) {
  std::string c = "4 4 5\n1 2\n2 1\n3 1\n4 1\n4 2\n";
  EdgeListGraph elg = EdgeListGraph::fromMTXFileContents(c);
  EdgeListGraph expected_elg = { {0, 1}, {1, 0}, {2, 0}, {3, 0}, {3, 1} };
  EXPECT_EQ(expected_elg, elg);
}

TEST(edgelist_graph, to_mtx_test) {
  EdgeListGraph elg = { {0, 1}, {1, 0}, {2, 0}, {3, 0}, {3, 1} };
  std::string contents = elg.toMTXFileContents();
  std::string expected_contents = "4 4 5\n1 2\n2 1\n3 1\n4 1\n4 2\n";
  EXPECT_EQ(expected_contents, contents);
}

TEST(edgelist_graph, symmetric_test) {
  EdgeListGraph elg = { {0, 1}, {1, 0}, {2, 0}, {3, 0}, {3, 1} };
  EdgeListGraph expected_sym_elg = { {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 3}, {2, 0}, {3, 0}, {3, 1} };
  EdgeListGraph sym_elg = elg.makeSymmetric();
  EXPECT_EQ(expected_sym_elg, sym_elg);
}
