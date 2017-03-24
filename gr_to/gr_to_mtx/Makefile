INCLUDES=-I../../ggc/rt/include -I../../ggc/rt/include/mgpu/include
LIBDIR=../../ggc/rt/lib
LIBS=-lggrt -lcurand -lcudadevrt -lz
EXTRAFLAGS=-g -O3 -DCSRG_TEX
ARCH=sm_35

convert: convert.cu
	nvcc ${INCLUDES} -L${LIBDIR} ${LIBS} -arch ${ARCH} ${EXTRAFLAGS} -o $@ $<
