/* -*- mode: c++ -*- */

#include <cuda.h>
#include <cstdio>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>

#include "gg.h"
#include "Timer.h"
#include "edgelist_graph.h"

extern void gg_main(CSRGraphTy &, CSRGraphTy &, unsigned, char*, FILE*);

FILE* OUTF = 0;
int QUIET = 0;
char *INPUT, *OUTPUT;
const char* OUTPUTKIND_DEFAULT = "counts|edges";
char* OUTPUTKIND = (char*)OUTPUTKIND_DEFAULT;
unsigned ktruss_k = 3;

int SKELAPP_RETVAL = 0;
mgpu::ContextPtr mgc;

int CUDA_DEVICE;

void kernel_sizing(CSRGraphTy & g, dim3 &blocks, dim3 &threads) {
  threads.x = 256;
  threads.y = threads.z = 1;

  blocks.x = ggc_get_nSM() * 8;
  blocks.y = blocks.z = 1;
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

int load_graph_and_run_kernel(char *graph_file) {
  CSRGraphTy g = load_graph(graph_file);
  CSRGraphTy gg;

  int *d;
  check_cuda(cudaMalloc(&d, sizeof(int) * 1));

  g.copy_to_gpu(gg);
  gg_main(g, gg, ktruss_k, OUTPUTKIND, OUTF);
  check_cuda(cudaDeviceSynchronize());

  return SKELAPP_RETVAL;
}

void usage(int argc, char *argv[])
{
  fprintf(stderr, "usage: %s [-q] [-g gpunum] [-o output-file] [-k #] [-p output-kind] input_graph.gr\n", argv[0]);
  fprintf(stderr, "       output-kind=\"edges|counts\"\n", argv[0]);
}

void parse_args(int argc, char *argv[])
{
  int c;
  const char *opts = "g:qo:k:p:";

  while((c = getopt(argc, argv, opts)) != -1) {
    switch(c)
      {
      case 'q':
	QUIET = 1;
	break;
      case 'o':
	OUTPUT = optarg; //TODO: copy?
	if (!OUTF) {
	  if (strcmp(OUTPUT, "-") == 0) {
	    OUTF = stdout;
	  } else {
	    OUTF = fopen(OUTPUT, "w");
	  }
	}
	break;
      case 'k':
	ktruss_k = atoi(optarg); //TODO: copy?
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
      case 'p':
	OUTPUTKIND = optarg;
	break;
      case '?':
	usage(argc, argv);
	exit(EXIT_FAILURE);
      default:
	break;
    }
  }

  INPUT = argv[optind];

  if(optind+1 != argc) {
    usage(argc, argv);
    exit(EXIT_FAILURE);
  }
}

int main(int argc, char *argv[]) {
  if(argc == 1) {
    usage(argc, argv);
    exit(1);
  }

  parse_args(argc, argv);
  ggc_set_gpu_device(CUDA_DEVICE);
  mgc = mgpu::CreateCudaDevice(CUDA_DEVICE);
  printf("Using GPU: %s\n", mgc->DeviceString().c_str());
  int r = load_graph_and_run_kernel(INPUT);
  return r;
}
