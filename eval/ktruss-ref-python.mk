.PHONY: ktruss-tuxedo-ref-python
ktruss-tuxedo-ref-python: cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella06_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/as20000102_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/com-lj.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-python/loc-gowalla_edges_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/amazon0505_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/loc-brightkite_edges_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/com-orkut.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010512_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale20-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale23-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/amazon0601_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010331_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella08_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale19-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/ca-AstroPh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/com-youtube.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-python/flickrEdges_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010512_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella24_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010414_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/com-amazon.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010505_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/facebook_combined_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/ca-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010505_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/cit-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale22-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/ca-GrQc_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/roadNet-TX_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/cit-Patents_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella25_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010526_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/amazon0302_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale21-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010407_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010421_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010331_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010519_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/com-dblp.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella05_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/as-caida20071105_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/roadNet-PA_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/soc-Slashdot0902_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010428_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale18-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/rmat16.sym.tri.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010407_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/graph500-scale24-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella04_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/com-friendster.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-python/soc-Slashdot0811_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella30_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/soc-Epinions1_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/complete5_sm.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010414_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/ca-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella31_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/amazon0312_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/cit-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010519_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010421_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/email-EuAll_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon2_010428_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/ca-CondMat_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella09_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/email-Enron_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/roadNet-CA_adj.sym.log cpu-logs/ktruss/tuxedo-ref-python/oregon1_010526_adj.sym.log

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella06_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella06_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/as20000102_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python as20000102_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python com-lj.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/loc-gowalla_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python loc-gowalla_edges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/amazon0505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python amazon0505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/loc-brightkite_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python loc-brightkite_edges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python com-orkut.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010512_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale20-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale20-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale23-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale23-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/amazon0601_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python amazon0601_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010331_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella08_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella08_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale19-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale19-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/ca-AstroPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python ca-AstroPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python com-youtube.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/flickrEdges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python flickrEdges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010512_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella24_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella24_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010414_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python com-amazon.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/facebook_combined_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python facebook_combined_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/ca-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python ca-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/cit-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python cit-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale22-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale22-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/ca-GrQc_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python ca-GrQc_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/roadNet-TX_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python roadNet-TX_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/cit-Patents_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python cit-Patents_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella25_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella25_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010526_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/amazon0302_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python amazon0302_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale21-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale21-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010407_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010421_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010331_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010519_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python com-dblp.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella05_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella05_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/as-caida20071105_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python as-caida20071105_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/roadNet-PA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python roadNet-PA_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/soc-Slashdot0902_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python soc-Slashdot0902_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010428_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale18-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale18-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python rmat16.sym.tri

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010407_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/graph500-scale24-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python graph500-scale24-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella04_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella04_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python com-friendster.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/soc-Slashdot0811_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python soc-Slashdot0811_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella30_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella30_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/soc-Epinions1_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python soc-Epinions1_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python complete5_sm.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010414_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/ca-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python ca-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella31_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella31_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/amazon0312_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python amazon0312_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/cit-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python cit-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010519_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010421_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/email-EuAll_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python email-EuAll_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon2_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon2_010428_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/ca-CondMat_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python ca-CondMat_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/p2p-Gnutella09_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python p2p-Gnutella09_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/email-Enron_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python email-Enron_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/roadNet-CA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python roadNet-CA_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-python/oregon1_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//python --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+python oregon1_010526_adj.sym

