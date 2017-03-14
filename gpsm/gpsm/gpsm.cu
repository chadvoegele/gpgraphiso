#include <numeric>

const char* prog_opts = "";
const char* prog_usage = "";
const char* prog_args_usage = "";
void process_prog_opt(char c, char *optarg) { }
int process_prog_arg(int argc, char *argv[], int arg_start) {
  return 1;
}
extern int SKELAPP_RETVAL;
extern const char* OUTPUT;

struct Solution {
  unsigned* vertex_map;
  unsigned n_vertices;

  Solution(unsigned n_vertices) : n_vertices(n_vertices) {
    vertex_map = (unsigned*)malloc(sizeof(unsigned)*n_vertices);
  }

  ~Solution() {
    free(vertex_map);
  }

  Solution(const Solution& other) : n_vertices(other.n_vertices) {
    vertex_map = (unsigned*)malloc(sizeof(unsigned)*n_vertices);
    memcpy(vertex_map, other.vertex_map, sizeof(unsigned)*n_vertices);
  }
};

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

// TODO: No longer used by GPU impl. Move to CPU impl.
void build_candidate_edges(CSRGraphTy& dgraph, CSRGraphTy& qgraph, unsigned* c_set, std::vector<gpgraphlib::EdgeListGraph>& candidate_edges) {
  for (index_type qsrc = 0; qsrc != qgraph.nnodes; qsrc++) {
    for (index_type qe = qgraph.row_start[qsrc]; qe != qgraph.row_start[qsrc+1]; qe++) {
      index_type qdst = qgraph.edge_dst[qe];
      for (index_type dsrc = 0; dsrc != dgraph.nnodes; dsrc++) {
        unsigned* c_set_idx = index2d(c_set, dgraph.nnodes, qsrc, dsrc);
        if (*c_set_idx) {
          for (index_type de = dgraph.row_start[dsrc]; de != dgraph.row_start[dsrc+1]; de++) {
            index_type ddst = dgraph.edge_dst[de];
            c_set_idx = index2d(c_set, dgraph.nnodes, qdst, ddst);
            if (*c_set_idx) {
              candidate_edges.at(qe).addEdge(dsrc, ddst);
            }
          }
        }
      }
    }
  }
}

void join_edges(CSRGraphTy dgraph, CSRGraphTy qgraph, std::vector<gpgraphlib::EdgeListGraph>& candidate_edges, std::vector<Solution>& solutions) {
  unsigned* vertex_visited = (unsigned*)malloc(sizeof(unsigned)*qgraph.nnodes);
  memset(vertex_visited, 0, sizeof(unsigned)*qgraph.nnodes);
  unsigned* edge_visited = (unsigned*)malloc(sizeof(unsigned)*qgraph.nedges);
  memset(edge_visited, 0, sizeof(unsigned)*qgraph.nedges);
  unsigned* edge_score = (unsigned*)malloc(sizeof(unsigned)*qgraph.nedges);

  while (std::accumulate(edge_visited, edge_visited + qgraph.nedges, 0) != qgraph.nedges) {
    // TODO: Split this query edge selection into own function
    for (index_type qsrc = 0; qsrc != qgraph.nnodes; qsrc++) {
      for (index_type qe = qgraph.row_start[qsrc]; qe != qgraph.row_start[qsrc+1]; qe++) {
        index_type qdst = qgraph.edge_dst[qe];
        unsigned visited_score;
        if (edge_visited[qe]) {
          visited_score = 3;
        } else if (vertex_visited[qsrc] && vertex_visited[qdst]) {
          visited_score = 0;
        } else if (vertex_visited[qsrc] || vertex_visited[qdst]) {
          visited_score = 1;
        } else {
          visited_score = 2;
        }
        edge_score[qe] = visited_score*dgraph.nedges + candidate_edges[qe].nedges();
      }
    }

    index_type selected_qsrc, selected_qdst, selected_qe;
    unsigned min_edge_score = dgraph.nedges*4;  // upper bound for edge score
    for (index_type qsrc = 0; qsrc != qgraph.nnodes; qsrc++) {
      for (index_type qe = qgraph.row_start[qsrc]; qe != qgraph.row_start[qsrc+1]; qe++) {
        index_type qdst = qgraph.edge_dst[qe];
        if (edge_score[qe] < min_edge_score) {
          min_edge_score = edge_score[qe];
          selected_qsrc = qsrc;
          selected_qdst = qdst;
          selected_qe = qe;
        }
      }
    }

    // TODO: Move this merge step to own function
    unsigned count_visited_edges = std::accumulate(edge_visited, edge_visited + qgraph.nedges, 0);
    if (count_visited_edges == 0) {
      for (auto ce : candidate_edges[selected_qe]) {
        index_type csrc = std::get<0>(ce);
        index_type cdst = std::get<1>(ce);
        Solution soln(qgraph.nnodes);
        soln.vertex_map[selected_qsrc] = csrc;
        soln.vertex_map[selected_qdst] = cdst;
        solutions.push_back(soln);
      }
    } else {
      std::vector<Solution> new_solutions;
      for (Solution& ps : solutions) {
        for (auto ce : candidate_edges[selected_qe]) {
          index_type csrc = std::get<0>(ce);
          index_type cdst = std::get<1>(ce);
          // Could speed this up with array of size data_graph.nnodes OR with hashing
          bool csrc_mapped = false;
          bool cdst_mapped = false;
          for (size_t i = 0; i < ps.n_vertices; i++) {
            if (ps.vertex_map[i] == csrc) {
              csrc_mapped = true;
            }
            if (ps.vertex_map[i] == cdst) {
              cdst_mapped = true;
            }
          }
          if ((!vertex_visited[selected_qsrc] && !csrc_mapped || ps.vertex_map[selected_qsrc] == csrc) &&
            (!vertex_visited[selected_qdst] && !cdst_mapped || ps.vertex_map[selected_qdst] == cdst)) {
            Solution psn(ps);
            if (!vertex_visited[selected_qsrc]) {
              psn.vertex_map[selected_qsrc] = csrc;
            }
            if (!vertex_visited[selected_qdst]) {
              psn.vertex_map[selected_qdst] = cdst;
            }
            new_solutions.push_back(psn);
          }
        }
      }

      solutions = std::move(new_solutions);
    }

    vertex_visited[selected_qsrc] = 1;
    vertex_visited[selected_qdst] = 1;
    edge_visited[selected_qe] = 1;
  }

  free(edge_visited);
  free(vertex_visited);
  free(edge_score);
}
