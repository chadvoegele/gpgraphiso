#pragma once
#include <utility>
#include "device/ctasearch.cuh"

template<typename T, typename D>
struct max_index : public std::binary_function<T, T, T> {
  D* score;
  max_index(D* score) : score(score) { }
  MGPU_HOST_DEVICE T operator()(T a, T b) {
    return score[a] > score[b] ? a : b;
  }
};

__device__ index_type findBackEdge(CSRGraphTy& gg, index_type src, index_type dst, unsigned int* valid_edges) {
  index_type begin = gg.row_start[dst] + valid_edges[dst];
  index_type end = gg.row_start[dst+1];
  unsigned count = end - begin;
  index_type backidx = begin + mgpu::BinarySearch<mgpu::MgpuBoundsUpper>(&gg.edge_dst[begin], count, src, mgpu::less_equal<index_type>());

  if (gg.edge_dst[backidx] != src) {
    printf("Did not find right back edge\n."); // TODO: fail hard here?
  }

  return backidx;
}
