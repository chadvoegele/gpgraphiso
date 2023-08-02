#pragma once

#include <vector>
#include <utility>
#include "gg.h"
#include "edgelist_graph.h"

void build_tree(CSRGraphTy qgraph, float* selectivity, gpgraphlib::EdgeListGraph& tree, std::vector<index_type>& tree_order);
__device__ bool is_candidate(CSRGraphTy dgraph, CSRGraphTy qgraph, int* dprop_ptr, int* qprop_ptr, index_type dv, index_type qv);
__host__ __device__ unsigned* index2d(unsigned* arr, unsigned nd, index_type x, index_type y);

template<typename T, typename D>
struct min_index : public std::binary_function<T, T, T> {
  D* score;
  min_index(D* score) : score(score) { }
  MGPU_HOST_DEVICE T operator()(T a, T b) {
    return score[a] < score[b] ? a : b;
  }
};
