/* -*- mode: c++ -*- */

#include <cuda.h>
#include <cstdio>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>

#include "gg.h"
#include "Timer.h"

#include "label.h"
#include "edgelist_graph.h"

int QUIET = 0;
char *DATA_GRAPH, *DATA_LABEL, *QUERY_GRAPH, *QUERY_LABEL, *OUTPUT;
unsigned long DISCOUNT_TIME_NS = 0;

extern int CUDA_DEVICE;

extern void gg_main(CSRGraphTy &, CSRGraphTy &, CSRGraphTy &, CSRGraphTy &, Shared<int>&, Shared<int>&);
extern const char *GGC_OPTIONS;

int load_graph_and_run_kernel(char *graph_file);
void output(CSRGraphTy &g, const char *output_file);

void kernel_sizing(CSRGraphTy & g, dim3 &blocks, dim3 &threads) {
  threads.x = 256;
  threads.y = threads.z = 1;

  blocks.x = ggc_get_nSM() * 8;
  blocks.y = blocks.z = 1;
}

void usage(int argc, char *argv[]) {
  fprintf(stderr, "usage: %s [-q] [-g gpunum] [-o output-file] data-graph.gr data-label.label query-graph.gr query-label.label\n", argv[0]);
}

void parse_args(int argc, char *argv[]) {
  int c;
  const char *opts = "g:qo:";

  while((c = getopt(argc, argv, opts)) != -1) {
    switch(c) {
    case 'q':
      QUIET = 1;
      break;
    case 'o':
      OUTPUT = optarg; //TODO: copy?
      break;
    case 'g':
      char *end;
      errno = 0;
      CUDA_DEVICE = strtol(optarg, &end, 10);
      if(errno != 0 || *end != '\0') {
        fprintf(stderr, "Invalid GPU device '%s'. An integer must be specified.\n", optarg);
        exit(EXIT_FAILURE);
      }
      break;
    case '?':
      usage(argc, argv);
      exit(EXIT_FAILURE);
    default:
      break;
    }
  }

  if (argc - optind == 4) {
    DATA_GRAPH = argv[optind];
    DATA_LABEL = argv[optind+1];
    QUERY_GRAPH = argv[optind+2];
    QUERY_LABEL = argv[optind+3];
  } else {
    usage(argc, argv);
    exit(EXIT_FAILURE);
  }
}

CSRGraphTy load_graph(char* graph) {
  CSRGraphTy g;

  char* ext = strrchr(graph, '.');
  if (!ext || ext == graph) {
    fprintf(stderr, "Unable to get graph file extension.\n");
    exit(EXIT_FAILURE);
  }

  if (!strcmp(".gr", ext)) {
    g.read(graph);

  } else if (!strcmp(".mtx", ext)) {
    gpgraphlib::EdgeListGraph elg = gpgraphlib::EdgeListGraph::fromMTXFile(graph);
    g.nnodes = elg.nnodes();
    g.nedges = elg.nedges();
    g.allocOnHost();
    elg.setCSR(g.row_start, g.edge_dst);

  } else {
    fprintf(stderr, "Unknown extension: %s\n. Supported: .gr, .mtx", ext);
    exit(EXIT_FAILURE);
  }

  return g;
}

int load_graph_and_run_kernel(char* data_graph, char* data_label, char* query_graph, char *query_label) {
  CSRGraphTy dg = load_graph(data_graph);
  CSRGraphTy dgg;
  dg.copy_to_gpu(dgg);
  gpgraphlib::LabelReader dlr = gpgraphlib::LabelReader::fromFilename(std::string(data_label));
  Shared<int> dprop = dg.nnodes;
  dlr.throwIfInvalid(dg.nnodes);
  int* dprop_cp = dprop.cpu_wr_ptr();
  dlr.setNodeProperties(dprop_cp);

  CSRGraphTy qg = load_graph(query_graph);
  CSRGraphTy qgg;
  qg.copy_to_gpu(qgg);
  gpgraphlib::LabelReader qlr = gpgraphlib::LabelReader::fromFilename(std::string(query_label));
  Shared<int> qprop = qg.nnodes;
  qlr.throwIfInvalid(qg.nnodes);
  int* qprop_cp = qprop.cpu_wr_ptr();
  qlr.setNodeProperties(qprop_cp);

  ggc::Timer k("gg_main");
  int *d;
  check_cuda(cudaMalloc(&d, sizeof(int) * 1));

  k.start();
  gg_main(dg, dgg, qg, qgg, dprop, qprop);
  check_cuda(cudaDeviceSynchronize());
  k.stop();
  k.print();
  fprintf(stderr, "Total time: %llu ms\n", k.duration_ms());
  fprintf(stderr, "Total time: %llu ns\n", k.duration());

  dgg.copy_to_cpu(dg);
  qgg.copy_to_cpu(qg);

  output(dg, OUTPUT);

  return EXIT_SUCCESS;
}

void output(CSRGraphTy &g, const char *output_file) {
  FILE *f;
  if(!output_file)
    return;
  if(strcmp(output_file, "-") == 0) {
    f = stdout;
  } else {
    f = fopen(output_file, "w");
  }
  check_fprintf(f, "%d\n", 1);
}

int main(int argc, char *argv[]) {
  CUDA_DEVICE = 0;  // default in case not set

  if(argc == 1) {
    usage(argc, argv);
    exit(1);
  }

  parse_args(argc, argv);
  printf("Data graph: %s, data labels: %s, query graph: %s, query_labels: %s\n", DATA_GRAPH, DATA_LABEL, QUERY_GRAPH, QUERY_LABEL);
  ggc_set_gpu_device(CUDA_DEVICE);
  int r = load_graph_and_run_kernel(DATA_GRAPH, DATA_LABEL, QUERY_GRAPH, QUERY_LABEL);
  return r;
}
