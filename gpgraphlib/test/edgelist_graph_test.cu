#include <gtest/gtest.h>

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
