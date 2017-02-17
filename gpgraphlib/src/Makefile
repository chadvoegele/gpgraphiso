NVCC=nvcc
ARCH=sm_35
CXXFLAGS=--std=c++11
EXTRAFLAGS=-g -O3 -DCSRG_TEX

INCLUDES=-I. `pkg-config --cflags libxml-2.0`

SRC=$(wildcard *.cu)
OBJS=$(patsubst %.cu,%.o,$(SRC))

NVCCFLAGS+=-D_FORCE_INLINES -L /usr/lib/x86_64-linux-gnu/ -Xptxas

all: $(OBJS)

$(OBJS) : %.o: %.cu
	$(NVCC) -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) -c $(INCLUDES) $< -o $@

clean:
	@for OBJ in $(OBJS); do [ -f $${OBJ} ] && rm $${OBJ} || true; done
