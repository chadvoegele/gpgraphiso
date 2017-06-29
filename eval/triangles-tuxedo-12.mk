.PHONY: triangles-tuxedo-12
triangles-tuxedo-12: cpu-logs/triangles/tuxedo-12/p2p-Gnutella06_adj.sym.log cpu-logs/triangles/tuxedo-12/as20000102_adj.sym.log cpu-logs/triangles/tuxedo-12/com-lj.wgt32.sym.log cpu-logs/triangles/tuxedo-12/loc-gowalla_edges_adj.sym.log cpu-logs/triangles/tuxedo-12/amazon0505_adj.sym.log cpu-logs/triangles/tuxedo-12/loc-brightkite_edges_adj.sym.log cpu-logs/triangles/tuxedo-12/com-orkut.wgt32.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010512_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale20-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale23-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/amazon0601_adj.sym.log cpu-logs/triangles/tuxedo-12/disjoint_tri_sm.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010331_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella08_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale19-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/ca-AstroPh_adj.sym.log cpu-logs/triangles/tuxedo-12/com-youtube.wgt32.sym.log cpu-logs/triangles/tuxedo-12/flickrEdges_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010512_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella24_adj.sym.log cpu-logs/triangles/tuxedo-12/tri_sm.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010414_adj.sym.log cpu-logs/triangles/tuxedo-12/com-amazon.wgt32.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010505_adj.sym.log cpu-logs/triangles/tuxedo-12/facebook_combined_adj.sym.log cpu-logs/triangles/tuxedo-12/ca-HepTh_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010505_adj.sym.log cpu-logs/triangles/tuxedo-12/cit-HepPh_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale22-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/ca-GrQc_adj.sym.log cpu-logs/triangles/tuxedo-12/roadNet-TX_adj.sym.log cpu-logs/triangles/tuxedo-12/cit-Patents_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella25_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010526_adj.sym.log cpu-logs/triangles/tuxedo-12/amazon0302_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale21-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010407_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010421_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010331_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010519_adj.sym.log cpu-logs/triangles/tuxedo-12/com-dblp.wgt32.sym.log cpu-logs/triangles/tuxedo-12/soc-Epinions1_adj.sym.log cpu-logs/triangles/tuxedo-12/as-caida20071105_adj.sym.log cpu-logs/triangles/tuxedo-12/ktruss_example.sym.log cpu-logs/triangles/tuxedo-12/roadNet-PA_adj.sym.log cpu-logs/triangles/tuxedo-12/soc-Slashdot0902_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010428_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale18-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/rmat16.sym.tri.log cpu-logs/triangles/tuxedo-12/oregon2_010407_adj.sym.log cpu-logs/triangles/tuxedo-12/graph500-scale24-ef16_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella04_adj.sym.log cpu-logs/triangles/tuxedo-12/com-friendster.wgt32.sym.log cpu-logs/triangles/tuxedo-12/soc-Slashdot0811_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella30_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella05_adj.sym.log cpu-logs/triangles/tuxedo-12/complete5_sm.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010414_adj.sym.log cpu-logs/triangles/tuxedo-12/ca-HepPh_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella31_adj.sym.log cpu-logs/triangles/tuxedo-12/amazon0312_adj.sym.log cpu-logs/triangles/tuxedo-12/cit-HepTh_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010519_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010421_adj.sym.log cpu-logs/triangles/tuxedo-12/email-EuAll_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon2_010428_adj.sym.log cpu-logs/triangles/tuxedo-12/ca-CondMat_adj.sym.log cpu-logs/triangles/tuxedo-12/p2p-Gnutella09_adj.sym.log cpu-logs/triangles/tuxedo-12/email-Enron_adj.sym.log cpu-logs/triangles/tuxedo-12/roadNet-CA_adj.sym.log cpu-logs/triangles/tuxedo-12/oregon1_010526_adj.sym.log

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella06_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella06_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/as20000102_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge as20000102_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge com-lj.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-12/loc-gowalla_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge loc-gowalla_edges_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/amazon0505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge amazon0505_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/loc-brightkite_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge loc-brightkite_edges_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge com-orkut.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010512_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale20-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale20-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale23-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale23-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/amazon0601_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge amazon0601_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/disjoint_tri_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge disjoint_tri_sm.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010331_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella08_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella08_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale19-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale19-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/ca-AstroPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge ca-AstroPh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge com-youtube.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-12/flickrEdges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge flickrEdges_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010512_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella24_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella24_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/tri_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge tri_sm.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010414_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge com-amazon.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010505_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/facebook_combined_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge facebook_combined_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/ca-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge ca-HepTh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010505_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/cit-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge cit-HepPh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale22-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale22-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/ca-GrQc_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge ca-GrQc_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/roadNet-TX_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge roadNet-TX_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/cit-Patents_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge cit-Patents_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella25_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella25_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010526_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/amazon0302_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge amazon0302_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale21-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale21-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010407_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010421_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010331_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010519_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge com-dblp.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-12/soc-Epinions1_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge soc-Epinions1_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/as-caida20071105_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge as-caida20071105_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/ktruss_example.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge ktruss_example.sym

#RULE
cpu-logs/triangles/tuxedo-12/roadNet-PA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge roadNet-PA_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/soc-Slashdot0902_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge soc-Slashdot0902_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010428_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale18-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale18-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge rmat16.sym.tri

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010407_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/graph500-scale24-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge graph500-scale24-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella04_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella04_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge com-friendster.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-12/soc-Slashdot0811_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge soc-Slashdot0811_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella30_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella30_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella05_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella05_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge complete5_sm.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010414_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/ca-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge ca-HepPh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella31_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella31_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/amazon0312_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge amazon0312_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/cit-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge cit-HepTh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010519_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010421_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/email-EuAll_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge email-EuAll_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon2_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon2_010428_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/ca-CondMat_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge ca-CondMat_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/p2p-Gnutella09_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge p2p-Gnutella09_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/email-Enron_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge email-Enron_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/roadNet-CA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge roadNet-CA_adj.sym

#RULE
cpu-logs/triangles/tuxedo-12/oregon1_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=12 --mtcpulimit 12 --scan ../../GaloisCpp/build/default//lonestar/triangles --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/galois+edge oregon1_010526_adj.sym

