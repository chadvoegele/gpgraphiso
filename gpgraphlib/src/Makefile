NVCC=nvcc
ARCH=sm_35
EXTRAFLAGS=-g -O3 -DCSRG_TEX

INCLUDES=-I. `pkg-config --cflags libxml-2.0`

SRC=$(wildcard *.cu)
OBJS=$(patsubst %.cu,%.o,$(SRC))

NVCCFLAGS+=-D_FORCE_INLINES -L /usr/lib/x86_64-linux-gnu/ -Xptxas

$(OBJS) : %.o: %.cu
	$(NVCC) -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) -c $(INCLUDES) $< -o $@

clean:
	@[ -f $(OBJS) ] && rm $(OBJS) || true

all: $(OBJS)
