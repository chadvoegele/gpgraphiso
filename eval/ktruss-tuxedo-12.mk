.PHONY: ktruss-tuxedo-12
ktruss-tuxedo-12: cpu-logs/ktruss/tuxedo-12/complete5_sm.sym.log cpu-logs/ktruss/tuxedo-12/com-dblp.wgt32.sym.log cpu-logs/ktruss/tuxedo-12/com-amazon.wgt32.sym.log cpu-logs/ktruss/tuxedo-12/com-orkut.wgt32.sym.log cpu-logs/ktruss/tuxedo-12/rmat16.sym.tri.log cpu-logs/ktruss/tuxedo-12/com-youtube.wgt32.sym.log cpu-logs/ktruss/tuxedo-12/com-friendster.wgt32.sym.log cpu-logs/ktruss/tuxedo-12/com-lj.wgt32.sym.log

#RULE
cpu-logs/ktruss/tuxedo-12/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm complete5_sm.sym

#RULE
cpu-logs/ktruss/tuxedo-12/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-dblp.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-12/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-amazon.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-12/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-orkut.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-12/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm rmat16.sym.tri

#RULE
cpu-logs/ktruss/tuxedo-12/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-youtube.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-12/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-friendster.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-12/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-lj.wgt32.sym

