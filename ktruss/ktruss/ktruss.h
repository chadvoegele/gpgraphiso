#pragma once
#include <utility>

template<typename T, typename D>
struct max_index : public std::binary_function<T, T, T> {
  D* score;
  max_index(D* score) : score(score) { }
  MGPU_HOST_DEVICE T operator()(T a, T b) {
    return score[a] > score[b] ? a : b;
  }
};
