.PHONY: ktruss-tuxedo-ref-julia
ktruss-tuxedo-ref-julia: cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella06_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/as20000102_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/com-lj.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-julia/loc-gowalla_edges_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/amazon0505_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/loc-brightkite_edges_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/com-orkut.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010512_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale20-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale23-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/amazon0601_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010331_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella08_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale19-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/ca-AstroPh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/com-youtube.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-julia/flickrEdges_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010512_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella24_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010414_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/com-amazon.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010505_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/facebook_combined_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/ca-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010505_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/cit-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale22-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/ca-GrQc_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/roadNet-TX_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/cit-Patents_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella25_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010526_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/amazon0302_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale21-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010407_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010421_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010331_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010519_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/com-dblp.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella05_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/as-caida20071105_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/roadNet-PA_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/soc-Slashdot0902_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010428_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale18-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/rmat16.sym.tri.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010407_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale24-ef16_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella04_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/com-friendster.wgt32.sym.log cpu-logs/ktruss/tuxedo-ref-julia/soc-Slashdot0811_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella30_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/soc-Epinions1_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/complete5_sm.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010414_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/ca-HepPh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella31_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/amazon0312_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/cit-HepTh_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010519_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010421_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/email-EuAll_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010428_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/ca-CondMat_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella09_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/email-Enron_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/roadNet-CA_adj.sym.log cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010526_adj.sym.log

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella06_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella06_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/as20000102_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia as20000102_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia com-lj.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/loc-gowalla_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia loc-gowalla_edges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/amazon0505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia amazon0505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/loc-brightkite_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia loc-brightkite_edges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia com-orkut.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010512_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale20-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale20-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale23-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale23-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/amazon0601_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia amazon0601_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010331_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella08_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella08_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale19-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale19-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/ca-AstroPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia ca-AstroPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia com-youtube.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/flickrEdges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia flickrEdges_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010512_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella24_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella24_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010414_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia com-amazon.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/facebook_combined_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia facebook_combined_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/ca-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia ca-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010505_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/cit-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia cit-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale22-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale22-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/ca-GrQc_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia ca-GrQc_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/roadNet-TX_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia roadNet-TX_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/cit-Patents_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia cit-Patents_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella25_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella25_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010526_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/amazon0302_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia amazon0302_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale21-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale21-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010407_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010421_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010331_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010519_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia com-dblp.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella05_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella05_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/as-caida20071105_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia as-caida20071105_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/roadNet-PA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia roadNet-PA_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/soc-Slashdot0902_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia soc-Slashdot0902_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010428_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale18-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale18-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia rmat16.sym.tri

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010407_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/graph500-scale24-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia graph500-scale24-ef16_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella04_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella04_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia com-friendster.wgt32.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/soc-Slashdot0811_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia soc-Slashdot0811_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella30_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella30_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/soc-Epinions1_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia soc-Epinions1_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia complete5_sm.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010414_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/ca-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia ca-HepPh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella31_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella31_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/amazon0312_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia amazon0312_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/cit-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia cit-HepTh_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010519_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010421_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/email-EuAll_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia email-EuAll_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon2_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon2_010428_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/ca-CondMat_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia ca-CondMat_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/p2p-Gnutella09_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia p2p-Gnutella09_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/email-Enron_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia email-Enron_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/roadNet-CA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia roadNet-CA_adj.sym

#RULE
cpu-logs/ktruss/tuxedo-ref-julia/oregon1_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=1 --mtcpulimit 1 --scan ../../graph_challenge//SubgraphIsomorphism/ktruss/code//julia --max-output-bytes 0 --measure-energy --log $@ -v perf ktruss/ref+julia oregon1_010526_adj.sym

