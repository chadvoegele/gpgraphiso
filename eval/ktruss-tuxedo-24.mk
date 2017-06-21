.PHONY: ktruss-tuxedo-24
ktruss-tuxedo-24: cpu-logs/ktruss/tuxedo-24/as20000102_adj.sym.log cpu-logs/ktruss/tuxedo-24/com-lj.wgt32.sym.log cpu-logs/ktruss/tuxedo-24/amazon0505_adj.sym.log cpu-logs/ktruss/tuxedo-24/com-orkut.wgt32.sym.log cpu-logs/ktruss/tuxedo-24/graph500-scale23-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-24/amazon0601_adj.sym.log cpu-logs/ktruss/tuxedo-24/graph500-scale19-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-24/com-youtube.wgt32.sym.log cpu-logs/ktruss/tuxedo-24/flickrEdges_adj.sym.log cpu-logs/ktruss/tuxedo-24/com-amazon.wgt32.sym.log cpu-logs/ktruss/tuxedo-24/facebook_combined_adj.sym.log cpu-logs/ktruss/tuxedo-24/cit-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-24/graph500-scale22-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-24/email-EuAll_adj.sym.log cpu-logs/ktruss/tuxedo-24/as-caida20071105_adj.sym.log cpu-logs/ktruss/tuxedo-24/ca-GrQc_adj.sym.log cpu-logs/ktruss/tuxedo-24/com-dblp.wgt32.sym.log cpu-logs/ktruss/tuxedo-24/ca-AstroPh_adj.sym.log cpu-logs/ktruss/tuxedo-24/graph500-scale18-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-24/rmat16.sym.tri.log cpu-logs/ktruss/tuxedo-24/cit-Patents_adj.sym.log cpu-logs/ktruss/tuxedo-24/com-friendster.wgt32.sym.log cpu-logs/ktruss/tuxedo-24/ca-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-24/complete5_sm.sym.log cpu-logs/ktruss/tuxedo-24/email-Enron_adj.sym.log cpu-logs/ktruss/tuxedo-24/ca-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-24/ca-CondMat_adj.sym.log cpu-logs/ktruss/tuxedo-24/cit-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-24/amazon0302_adj.sym.log cpu-logs/ktruss/tuxedo-24/amazon0312_adj.sym.log cpu-logs/ktruss/tuxedo-24/graph500-scale21-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-24/graph500-scale20-ef16_adj.sym.log

#RULE
cpu-logs/ktruss/tuxedo-24/as20000102_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm as20000102_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-lj.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-24/amazon0505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-orkut.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-24/graph500-scale23-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale23-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/amazon0601_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0601_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/graph500-scale19-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale19-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-youtube.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-24/flickrEdges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm flickrEdges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-amazon.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-24/facebook_combined_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm facebook_combined_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/cit-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm cit-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/graph500-scale22-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale22-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/email-EuAll_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm email-EuAll_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/as-caida20071105_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm as-caida20071105_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/ca-GrQc_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-GrQc_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-dblp.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-24/ca-AstroPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-AstroPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/graph500-scale18-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale18-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm rmat16.sym.tri

#RULE
cpu-logs/ktruss/tuxedo-24/cit-Patents_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm cit-Patents_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-friendster.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-24/ca-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm complete5_sm.sym

#RULE
cpu-logs/ktruss/tuxedo-24/email-Enron_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm email-Enron_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/ca-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/ca-CondMat_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-CondMat_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/cit-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm cit-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/amazon0302_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0302_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/amazon0312_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0312_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/graph500-scale21-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale21-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-24/graph500-scale20-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=24 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale20-ef16_adj.sym

