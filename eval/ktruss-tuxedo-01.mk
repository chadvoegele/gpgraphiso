.PHONY: ktruss-tuxedo-01
ktruss-tuxedo-01: cpu-logs/ktruss/tuxedo-01/p2p-Gnutella06_adj.sym.log cpu-logs/ktruss/tuxedo-01/as20000102_adj.sym.log cpu-logs/ktruss/tuxedo-01/com-lj.wgt32.sym.log cpu-logs/ktruss/tuxedo-01/loc-gowalla_edges_adj.sym.log cpu-logs/ktruss/tuxedo-01/amazon0505_adj.sym.log cpu-logs/ktruss/tuxedo-01/loc-brightkite_edges_adj.sym.log cpu-logs/ktruss/tuxedo-01/com-orkut.wgt32.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010512_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale20-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale23-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/amazon0601_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010331_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella08_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale19-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/ca-AstroPh_adj.sym.log cpu-logs/ktruss/tuxedo-01/com-youtube.wgt32.sym.log cpu-logs/ktruss/tuxedo-01/flickrEdges_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010512_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella24_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010414_adj.sym.log cpu-logs/ktruss/tuxedo-01/com-amazon.wgt32.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010505_adj.sym.log cpu-logs/ktruss/tuxedo-01/facebook_combined_adj.sym.log cpu-logs/ktruss/tuxedo-01/ca-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010505_adj.sym.log cpu-logs/ktruss/tuxedo-01/cit-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale22-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/ca-GrQc_adj.sym.log cpu-logs/ktruss/tuxedo-01/roadNet-TX_adj.sym.log cpu-logs/ktruss/tuxedo-01/cit-Patents_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella25_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010526_adj.sym.log cpu-logs/ktruss/tuxedo-01/amazon0302_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale21-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010407_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010421_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010331_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010519_adj.sym.log cpu-logs/ktruss/tuxedo-01/com-dblp.wgt32.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella05_adj.sym.log cpu-logs/ktruss/tuxedo-01/as-caida20071105_adj.sym.log cpu-logs/ktruss/tuxedo-01/roadNet-PA_adj.sym.log cpu-logs/ktruss/tuxedo-01/soc-Slashdot0902_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010428_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale18-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/rmat16.sym.tri.log cpu-logs/ktruss/tuxedo-01/oregon2_010407_adj.sym.log cpu-logs/ktruss/tuxedo-01/graph500-scale24-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella04_adj.sym.log cpu-logs/ktruss/tuxedo-01/com-friendster.wgt32.sym.log cpu-logs/ktruss/tuxedo-01/soc-Slashdot0811_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella30_adj.sym.log cpu-logs/ktruss/tuxedo-01/soc-Epinions1_adj.sym.log cpu-logs/ktruss/tuxedo-01/complete5_sm.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010414_adj.sym.log cpu-logs/ktruss/tuxedo-01/ca-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella31_adj.sym.log cpu-logs/ktruss/tuxedo-01/amazon0312_adj.sym.log cpu-logs/ktruss/tuxedo-01/cit-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010519_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010421_adj.sym.log cpu-logs/ktruss/tuxedo-01/email-EuAll_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon2_010428_adj.sym.log cpu-logs/ktruss/tuxedo-01/ca-CondMat_adj.sym.log cpu-logs/ktruss/tuxedo-01/p2p-Gnutella09_adj.sym.log cpu-logs/ktruss/tuxedo-01/email-Enron_adj.sym.log cpu-logs/ktruss/tuxedo-01/roadNet-CA_adj.sym.log cpu-logs/ktruss/tuxedo-01/oregon1_010526_adj.sym.log

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella06_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella06_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/as20000102_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm as20000102_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-lj.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-01/loc-gowalla_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm loc-gowalla_edges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/amazon0505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/loc-brightkite_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm loc-brightkite_edges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-orkut.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010512_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale20-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale20-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale23-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale23-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/amazon0601_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0601_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010331_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella08_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella08_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale19-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale19-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/ca-AstroPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-AstroPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-youtube.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-01/flickrEdges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm flickrEdges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010512_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella24_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella24_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010414_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-amazon.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/facebook_combined_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm facebook_combined_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/ca-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/cit-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm cit-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale22-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale22-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/ca-GrQc_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-GrQc_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/roadNet-TX_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm roadNet-TX_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/cit-Patents_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm cit-Patents_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella25_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella25_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010526_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/amazon0302_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0302_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale21-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale21-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010407_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010421_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010331_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010519_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-dblp.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella05_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella05_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/as-caida20071105_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm as-caida20071105_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/roadNet-PA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm roadNet-PA_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/soc-Slashdot0902_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm soc-Slashdot0902_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010428_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale18-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale18-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm rmat16.sym.tri

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010407_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/graph500-scale24-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm graph500-scale24-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella04_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella04_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm com-friendster.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-01/soc-Slashdot0811_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm soc-Slashdot0811_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella30_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella30_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/soc-Epinions1_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm soc-Epinions1_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm complete5_sm.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010414_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/ca-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella31_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella31_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/amazon0312_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm amazon0312_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/cit-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm cit-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010519_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010421_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/email-EuAll_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm email-EuAll_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon2_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon2_010428_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/ca-CondMat_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm ca-CondMat_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/p2p-Gnutella09_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm p2p-Gnutella09_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/email-Enron_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm email-Enron_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/roadNet-CA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm roadNet-CA_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-01/oregon1_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --scan ../../GaloisCpp/build/default//exp/apps/ktruss --log $@ -v perf ktruss/galois+bspIm oregon1_010526_adj.sym

