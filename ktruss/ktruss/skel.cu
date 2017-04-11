/* -*- mode: c++ -*- */

#include <cuda.h>
#include <cstdio>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>

#include "gg.h"
#include "Timer.h"

extern void gg_main(CSRGraphTy &, CSRGraphTy &);
extern void output(CSRGraphTy &, const char *output_file);
extern const char *GGC_OPTIONS;

int QUIET = 0;
char *INPUT, *OUTPUT;
extern unsigned long DISCOUNT_TIME_NS;

unsigned long DISCOUNT_TIME_NS = 0;
int SKELAPP_RETVAL = 0;

extern int CUDA_DEVICE;

void kernel_sizing(CSRGraphTy & g, dim3 &blocks, dim3 &threads) {
  threads.x = 256;
  threads.y = threads.z = 1;

  blocks.x = ggc_get_nSM() * 8;
  blocks.y = blocks.z = 1;
}

int load_graph_and_run_kernel(char *graph_file) {
  CSRGraphTy g, gg;

  ggc::Timer k("gg_main");
  fprintf(stderr, "OPTIONS: %s\n", GGC_OPTIONS);
  g.read(graph_file);

  g.copy_to_gpu(gg);

  int *d;
  check_cuda(cudaMalloc(&d, sizeof(int) * 1));

  k.start();
  gg_main(g, gg);
  check_cuda(cudaDeviceSynchronize());
  k.stop();
  k.print();
  fprintf(stderr, "Total time: %llu ms\n", k.duration_ms());
  fprintf(stderr, "Total time: %llu ns\n", k.duration());

  if(DISCOUNT_TIME_NS > 0) {
    fprintf(stderr, "Total time (discounted): %llu ns\n", k.duration() - DISCOUNT_TIME_NS);
  }

  gg.copy_to_cpu(g);

  return SKELAPP_RETVAL;
}

void usage(int argc, char *argv[])
{
  fprintf(stderr, "usage: %s [-q] [-g gpunum] [-o output-file] input_graph.gr\n", argv[0]);
}

void parse_args(int argc, char *argv[])
{
  int c;
  const char *opts = "g:qo:";

  while((c = getopt(argc, argv, opts)) != -1) {
    switch(c)
      {
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
