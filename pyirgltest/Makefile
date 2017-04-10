GGC_ROOT?=../ggc
GPGRAPHLIB_ROOT?=../gpgraphlib
GPGRAPHISO_ROOT?=..

GGC:=$(GGC_ROOT)/src/ggc
CXXFLAGS=--std=c++11
GGCFLAGS:=

INCLUDES=-I$(GGC_ROOT)/rt/include -I$(GGC_ROOT)/rt/include/mgpu/include -I$(GPGRAPHLIB_ROOT)/src -I$(GPGRAPHISO_ROOT)/gpsm/gpsm -I$(GPGRAPHISO_ROOT)/ktruss/ktruss `pkg-config --cflags libxml-2.0 gtest`
LIBDIR=$(GGC_ROOT)/rt/lib
LIBS=-lggrt -lcurand `pkg-config --libs libxml-2.0 gtest`
ARCH=sm_35
EXTRAFLAGS=-g -O3 -DCSRG_TEX
COMPRESS_LIBS=-lz
NVCCFLAGS+=-D_FORCE_INLINES -L /usr/lib/x86_64-linux-gnu/ -Xptxas -v

all: test

mgpucontext.o: $(GGC_ROOT)/rt/include/mgpu/src/mgpucontext.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

mgpuutil.o: $(GGC_ROOT)/rt/include/mgpu/src/mgpuutil.cpp
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

graphml.o: $(GPGRAPHLIB_ROOT)/src/graphml.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

edgelist_graph.o: $(GPGRAPHLIB_ROOT)/src/edgelist_graph.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

gpsm.o: $(GPGRAPHISO_ROOT)/gpsm/gpsm/gpsm.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

%.o: %.cu
	nvcc -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) $(INCLUDES) $< -o $@

test: kernel.o mgpucontext.o mgpuutil.o graphml.o edgelist_graph.o
	nvcc -g $(EXTRAFLAGS) -arch $(ARCH) $(CXXFLAGS) $(NVCCFLAGS) $(INCLUDES) -L$(LIBDIR)  -o $@ $^ $(LIBS) -lcudadevrt $(COMPRESS_LIBS)

clean:
	rm *.dot kernel.cu mgpucontext.o mgpuutil.o kernel.o test graphml.o edgelist_graph.o
