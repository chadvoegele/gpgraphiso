include ../common.mk

all:  cpu_by_gpu.csv



cpu_by_gpu.csv: tuxedo-gtx1080.csv tuxedo-12.csv 
	$(BMK2)/ps/norm.py -k bmk -k input -m time_ns_avg --rs _cpu $^ -o $@
