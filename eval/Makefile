include common.mk

all: ktruss-inputs triangle-inputs ktruss-tuxedo-gtx1080.mk ktruss-tuxedo-k80.mk triangles-tuxedo-gtx1080.mk triangles-tuxedo-k80.mk ktruss-tuxedo-01.mk ktruss-tuxedo-12.mk ktruss-tuxedo-24.mk inputs-desc.csv triangles-tuxedo-gtx1080-power.mk

ktruss-inputs: $(BMK2CFG)/graph.bispec
	$(BMK2)/rsinfo.py -d $(BMK2CFG) --cfg default -o $@ --scan $(KTRUSS) -i inputs ktruss/irgl

triangle-inputs: $(BMK2CFG)/graph.bispec
	$(BMK2)/rsinfo.py -d $(BMK2CFG) --cfg default -o $@ --scan $(TRIANGLES) -i inputs triangles/irgl

.PHONY: setup

setup: cpu-logs gpu-logs cpu-logs/ktruss cpu-logs/triangles gpu-logs/ktruss gpu-logs/triangles

%-logs: 
	mkdir $@

%-logs/ktruss: %-logs
%-logs/triangles: %-logs
	mkdir $@

inputs-desc.csv: ktruss-inputs triangle-inputs
	PYTHONPATH=$(GR_CHALLENGE)/grtools/:$$PYTHONPATH scripts/desc_inputs.py $^ > $@

ktruss-tuxedo-gtx1080.mk: ktruss-inputs gpu-logs/ktruss/tuxedo-gtx1080 templates/gpu-expt.template
	scripts/gen_makefile.py $< ktruss/irgl tuxedo-gtx1080 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(KTRUSS) -v env_vars=

ktruss-tuxedo-k80.mk: ktruss-inputs gpu-logs/ktruss/tuxedo-k80 templates/gpu-expt.template
	scripts/gen_makefile.py $< ktruss/irgl tuxedo-k80 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(KTRUSS) -v env_vars="CUDA_VISIBLE_DEVICES=1"

triangles-tuxedo-gtx1080.mk: triangle-inputs gpu-logs/triangles/tuxedo-gtx1080 templates/gpu-expt.template
	scripts/gen_makefile.py $< triangles/irgl tuxedo-gtx1080 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(TRIANGLES) -v env_vars=

triangles-tuxedo-gtx1080-power.mk: triangle-inputs gpu-logs/triangles/tuxedo-gtx1080-power templates/gpu-expt-nvprof.template
	scripts/gen_makefile.py $< triangles/irgl tuxedo-gtx1080-power templates/gpu-expt-nvprof.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(TRIANGLES) -v env_vars= -v nvprof="--npsystem"

triangles-tuxedo-k80.mk: triangle-inputs gpu-logs/triangles/tuxedo-k80 templates/gpu-expt.template
	scripts/gen_makefile.py $< triangles/irgl tuxedo-k80 templates/gpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=triangles -v scandir=$(TRIANGLES) -v env_vars="CUDA_VISIBLE_DEVICES=1"

gpu-logs/triangles/%:
	mkdir $@

gpu-logs/ktruss/%:
	mkdir $@

ktruss-tuxedo-01.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-01 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspIm tuxedo-01 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=1

ktruss-tuxedo-12.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-12 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspIm tuxedo-12 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=12

ktruss-tuxedo-24.mk: ktruss-inputs cpu-logs/ktruss/tuxedo-24 templates/cpu-expt.template
	scripts/gen_makefile.py $< ktruss/galois+bspIm tuxedo-24 templates/cpu-expt.template $@ -t "{bmk}-{expt}" -v bmk=ktruss -v scandir=$(CPU_KTRUSS) -v threads=24

cpu-logs/ktruss/%:
	mkdir $@
