GGC_ROOT?=../../ggc
GPGRAPHLIB_ROOT?=../../gpgraphlib
GPGRAPHISO_ROOT?=../..

GGC:=$(GGC_ROOT)/src/ggc
CXXFLAGS=--std=c++11
GGCFLAGS:=

INCLUDES=-I$(GGC_ROOT)/rt/include -I$(GGC_ROOT)/rt/include/mgpu/include -I$(GPGRAPHLIB_ROOT)/src -I$(GPGRAPHISO_ROOT)/ktruss/ktruss
LIBDIR=$(GGC_ROOT)/rt/lib
LIBS=-lggrt -lcurand
ARCH=sm_35
EXTRAFLAGS=-g -O3 -DCSRG_TEX
COMPRESS_LIBS=-lz
NVCCFLAGS+=-D_FORCE_INLINES -L /usr/lib/x86_64-linux-gnu/ -Xptxas -v

all: test test-nontex

mgpucontext.o: $(GGC_ROOT)/rt/include/mgpu/src/mgpucontext.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

mgpuutil.o: $(GGC_ROOT)/rt/include/mgpu/src/mgpuutil.cpp
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

edgelist_graph.o: $(GPGRAPHLIB_ROOT)/src/edgelist_graph.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

support.o: ktruss_support.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

kernel.cu: ktruss_wl.py
	$(GGC_ROOT)/src/ggc -o kernel.cu $<

kernel-nontex.cu: ktruss_wl.py
	$(GGC_ROOT)/src/ggc --cuda-worklist basic --cuda-graph basic -o $@ $<

%.o: %.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

skel-nontex.o: skel.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

support-nontex.o: ktruss_support.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

test: skel.o kernel.o mgpucontext.o mgpuutil.o edgelist_graph.o support.o
	nvcc -g $(EXTRAFLAGS) -arch $(ARCH) $(CXXFLAGS) $(NVCCFLAGS) $(INCLUDES) -L$(LIBDIR)  -o $@ $^ $(LIBS) -lcudadevrt $(COMPRESS_LIBS)

test-nontex: skel-nontex.o kernel-nontex.o mgpucontext.o mgpuutil.o edgelist_graph.o support-nontex.o
	nvcc -g $(EXTRAFLAGS) -arch $(ARCH) $(CXXFLAGS) $(NVCCFLAGS) $(INCLUDES) -L$(LIBDIR)  -o $@ $^ $(LIBS) -lcudadevrt $(COMPRESS_LIBS)

clean:
	rm kernel.cu mgpucontext.o mgpuutil.o kernel.o test edgelist_graph.o skel.o
