include common.mk

all: ktruss-inputs triangle-inputs ktruss-tuxedo-gtx1080.mk ktruss-tuxedo-gtx1080-power.mk ktruss-tuxedo-k80.mk triangles-tuxedo-gtx1080.mk triangles-tuxedo-k80.mk ktruss-tuxedo-01.mk ktruss-tuxedo-12.mk ktruss-tuxedo-24.mk inputs-desc.csv triangles-tuxedo-gtx1080-power.mk triangles-tuxedo-12.mk triangles-tuxedo-24.mk triangles-tuxedo-01.mk $(CPU_TRIANGLES)/bmktest2.py triangles-tuxedo-minitri.mk ktruss-ref-python.mk ktruss-ref-julia.mk ktruss-tuxedo-24-ctt.mk

ktruss-inputs: $(BMK2CFG)/graph.bispec
	$(BMK2)/rsinfo.py -d $(BMK2CFG) --cfg default -o $@ --scan $(KTRUSS) -i inputs ktruss/irgl

triangle-inputs: $(BMK2CFG)/graph.bispec
	$(BMK2)/rsinfo.py -d $(BMK2CFG) --cfg default -o $@ --scan $(TRIANGLES) -i inputs triangles/irgl

.PHONY: setup

setup: cpu-logs gpu-logs cpu-logs/ktruss cpu-logs/triangles gpu-logs/ktruss gpu-logs/triangles

%-logs: 
	mkdir -p $@

%-logs/ktruss: %-logs
%-logs/triangles: %-logs
	mkdir -p $@

inputs-desc.csv: ktruss-inputs triangle-inputs max-degree
	PYTHONPATH=$(GR_CHALLENGE)/grtools/:$$PYTHONPATH scripts/desc_inputs.py -m max-degree ktruss-inputs triangle-inputs > $@

ktruss-tuxedo-gtx1080.mk: ktruss-inputs gpu-logs/ktruss/tuxedo-gtx1080 templates/gpu-expt.template
	scripts/gen_makefile.py $< ktruss/irgl+wl tuxedo-gtx1080 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(KTRUSS_WL) -v env_vars=

ktruss-tuxedo-k80.mk: ktruss-inputs gpu-logs/ktruss/tuxedo-k80 templates/gpu-expt.template
	scripts/gen_makefile.py $< ktruss/irgl+wl tuxedo-k80 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(KTRUSS_WL) -v env_vars="CUDA_VISIBLE_DEVICES=1"

ktruss-tuxedo-gtx1080-power.mk: ktruss-inputs gpu-logs/ktruss/tuxedo-gtx1080-power templates/gpu-expt-nvprof.template
	scripts/gen_makefile.py $< ktruss/irgl+wl tuxedo-gtx1080-power templates/gpu-expt-nvprof.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(KTRUSS_WL) -v env_vars= -v nvprof="--npsystem"

triangles-tuxedo-gtx1080.mk: triangle-inputs gpu-logs/triangles/tuxedo-gtx1080 templates/gpu-expt.template
	scripts/gen_makefile.py $< triangles/irgl tuxedo-gtx1080 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(TRIANGLES) -v env_vars=

triangles-tuxedo-gtx1080-power.mk: triangle-inputs gpu-logs/triangles/tuxedo-gtx1080-power templates/gpu-expt-nvprof.template
	scripts/gen_makefile.py $< triangles/irgl tuxedo-gtx1080-power templates/gpu-expt-nvprof.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(TRIANGLES) -v env_vars= -v nvprof="--npsystem"

triangles-tuxedo-k80.mk: triangle-inputs gpu-logs/triangles/tuxedo-k80 templates/gpu-expt.template
	scripts/gen_makefile.py $< triangles/irgl tuxedo-k80 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(TRIANGLES) -v env_vars="CUDA_VISIBLE_DEVICES=1"

gpu-logs/triangles/%:
	mkdir -p $@

cpu-logs/triangles/%:
	mkdir -p $@

gpu-logs/ktruss/%:
	mkdir -p $@

ktruss-tuxedo-01.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-01 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspIm tuxedo-01 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=1

ktruss-tuxedo-12.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-12 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspIm tuxedo-12 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=12

ktruss-tuxedo-24.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-24 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspIm tuxedo-24 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=24

ktruss-tuxedo-24-ctt.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-24 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspCoreThenTruss tuxedo-24-ctt templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=24


ktruss-ref-python.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-ref-python templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/ref+python tuxedo-ref-python templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS_REF)/python -v threads=1

ktruss-ref-julia.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-ref-julia templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/ref+julia tuxedo-ref-julia templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS_REF)/julia -v threads=1


triangles-tuxedo-24.mk: triangle-inputs cpu-logs/triangles/tuxedo-24 templates/cpu-expt.template
	scripts/gen_makefile.py $< triangles/galois+edge tuxedo-24 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(CPU_TRIANGLES) -v threads=24

triangles-tuxedo-12.mk: triangle-inputs cpu-logs/triangles/tuxedo-12 templates/cpu-expt.template
	scripts/gen_makefile.py $< triangles/galois+edge tuxedo-12 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(CPU_TRIANGLES) -v threads=12

triangles-tuxedo-01.mk: triangle-inputs cpu-logs/triangles/tuxedo-01 templates/cpu-expt.template
	scripts/gen_makefile.py $< triangles/galois+edge tuxedo-01 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(CPU_TRIANGLES) -v threads=01


triangles-tuxedo-minitri.mk: triangle-inputs cpu-logs/triangles/tuxedo-minitri templates/cpu-expt.template
	scripts/gen_makefile.py $< triangles/miniTri tuxedo-minitri templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(CPU_MINITRI) -v threads=01

cpu-logs/ktruss/%:
	mkdir -p $@

# copy, so as not to mess up lonestar
$(CPU_TRIANGLES)/bmktest2.py: bmktest2-cpu-triangles.py
	cp $< $@
