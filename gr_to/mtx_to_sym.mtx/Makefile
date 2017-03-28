GPGRAPHLIB_ROOT?=../../gpgraphlib
INCLUDES=-I$(GPGRAPHLIB_ROOT)/src
EXTRAFLAGS=-O3 -DCSRG_TEX
CXXFLAGS=--std=c++11
ARCH=sm_35

convert: convert.cu $(GPGRAPHLIB_ROOT)/src/edgelist_graph.cu
	nvcc ${INCLUDES} -arch ${ARCH} $(CXXFLAGS) ${EXTRAFLAGS} -o $@ $^
