const char* prog_opts = "";
const char* prog_usage = "";
const char* prog_args_usage = "";
void process_prog_opt(char c, char *optarg) { }
int process_prog_arg(int argc, char *argv[], int arg_start) {
  return 1;
}
extern int SKELAPP_RETVAL;
extern const char* OUTPUT;

void build_tree(CSRGraphTy qgraph, float* selectivity, gpgraphlib::EdgeListGraph& tree, std::vector<index_type>& tree_order) {
  std::vector<std::tuple<index_type, index_type, float>> worklist;
  std::vector<unsigned> add_to_tree(qgraph.nnodes);
  std::fill(add_to_tree.begin(), add_to_tree.end(), 1);

  for (index_type n = 0; n != qgraph.nnodes; n++) {
    for (index_type e = qgraph.row_start[n]; e != qgraph.row_start[n+1]; e++) {
      worklist.push_back(std::make_tuple(n,qgraph.edge_dst[e],selectivity[n]+selectivity[qgraph.edge_dst[e]]));
    }
  }

  while (!worklist.empty()) {
    std::sort(worklist.begin(), worklist.end(), [](std::tuple<index_type, index_type, float>& me, std::tuple<index_type, index_type, float>& other) {
      return std::get<2>(me) < std::get<2>(other);
    });
    index_type next_node = std::get<0>(worklist.back());
    index_type next_dst = std::get<1>(worklist.back());
    worklist.pop_back();

    if (tree.nnodes() == 0) {
      next_node = selectivity[next_node] > selectivity[next_dst] ? next_node : next_dst;
      worklist.clear();
    }

    if (!add_to_tree[next_dst]) {
      continue;
    }

    tree_order.push_back(next_node);
    add_to_tree[next_node] = 0;
    for (index_type e = qgraph.row_start[next_node]; e != qgraph.row_start[next_node+1]; e++) {
      if (add_to_tree[qgraph.edge_dst[e]]) {
        tree.addEdge(next_node, qgraph.edge_dst[e]);
        tree.addEdge(qgraph.edge_dst[e], next_node);
        add_to_tree[qgraph.edge_dst[e]] = 0;
        for(index_type e2 = qgraph.row_start[qgraph.edge_dst[e]]; e2 != qgraph.row_start[qgraph.edge_dst[e]+1]; e2++) {
          if (add_to_tree[qgraph.edge_dst[e2]]) {
            worklist.push_back(std::make_tuple(qgraph.edge_dst[e],qgraph.edge_dst[e2],selectivity[qgraph.edge_dst[e]]+selectivity[qgraph.edge_dst[e2]]));
          }
        }
      }
    }
  }
}

__host__ __device__ unsigned* index2d(unsigned* arr, unsigned nd, index_type x, index_type y) {
  return arr + x*nd + y;
}

__device__ bool is_candidate(CSRGraphTy dgraph, CSRGraphTy qgraph, int* dprop_ptr, int* qprop_ptr, index_type dv, index_type qv) {
  return dprop_ptr[dv] == qprop_ptr[qv] && (qgraph).getOutDegree(qv) <= (dgraph).getOutDegree(dv);
}
