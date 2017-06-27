include ../common.mk

#tuxedo-gtx1080-gpu-metrics.csv tuxedo-gtx1080-gpu-na-metrics.csv tuxedo-gtx1080-pp.txt 
all: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv ktruss-rps.pdf ktruss-energy.pdf ktruss-reu.pdf ktruss-memusage.pdf

#%-gpu-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
#	../scripts/gcmetrics.py $^ -o $@

#%-gpu-na-metrics.csv: %.csv %-power.csv ../inputs-desc.csv
#	../scripts/gcmetrics.py --na $^ -o $@

%-cpu-metrics.csv: %.csv ../inputs-desc.csv
	../scripts/cpumetrics.py $^ -o $@

%-gal.csv: %.csv

ktruss-rps.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv dropInputs.txt
	../scripts/plot_rate_eps.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l julia -o $@ --di dropInputs.txt

ktruss-energy.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv dropInputs.txt
	../scripts/plot_energy.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l julia -o $@ -e --di dropInputs.txt


ktruss-reu.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv dropInputs.txt
	../scripts/plot_energy.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l julia -o $@ --di dropInputs.txt

ktruss-memusage.pdf: tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv dropInputs.txt
	../scripts/plot_memusage.py tuxedo-01-cpu-metrics.csv tuxedo-12-cpu-metrics.csv tuxedo-24-cpu-metrics.csv tuxedo-ref-julia-cpu-metrics.csv -l cpu-01 -l cpu-12 -l cpu-24 -l julia -o $@ --di dropInputs.txt
