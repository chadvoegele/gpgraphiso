NVCC=nvcc
ARCH=sm_35
EXTRAFLAGS=-g -O3 -DCSRG_TEX

INCLUDES=-I../src `pkg-config --cflags libxml-2.0 gtest`
LIBS=`pkg-config --libs libxml-2.0 gtest`

TEST_SRC=$(wildcard *.cu)
TEST_OBJS=$(patsubst %.cu,%.o,$(TEST_SRC))

SRC=$(wildcard ../src/*.cu)
OBJS=$(patsubst %.cu,%.o,$(SRC))

NVCCFLAGS+=-D_FORCE_INLINES -L /usr/lib/x86_64-linux-gnu/ -Xptxas

all: test_main

$(TEST_OBJS) : %.o: %.cu
	$(NVCC) -dc -arch $(ARCH) $(CXXFLAGS) $(EXTRAFLAGS) $(NVCCFLAGS) -c $(INCLUDES) $< -o $@

test_main: $(TEST_OBJS) $(OBJS)
	nvcc -g $(EXTRAFLAGS) -arch $(ARCH) $(CXXFLAGS) $(NVCCFLAGS) $(INCLUDES) -o $@ $^ $(LIBS) -lcudadevrt $(COMPRESS_LIBS)

clean:
	@[ -f ./test_main ] && rm test_main || true
	@[ -f $(TEST_OBJS) ] && rm $(TEST_OBJS) || true
