.PHONY: triangles-tuxedo-minitri
triangles-tuxedo-minitri: cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella06_adj.sym.log cpu-logs/triangles/tuxedo-minitri/as20000102_adj.sym.log cpu-logs/triangles/tuxedo-minitri/com-lj.wgt32.sym.log cpu-logs/triangles/tuxedo-minitri/loc-gowalla_edges_adj.sym.log cpu-logs/triangles/tuxedo-minitri/amazon0505_adj.sym.log cpu-logs/triangles/tuxedo-minitri/loc-brightkite_edges_adj.sym.log cpu-logs/triangles/tuxedo-minitri/com-orkut.wgt32.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010512_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale20-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale23-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/amazon0601_adj.sym.log cpu-logs/triangles/tuxedo-minitri/disjoint_tri_sm.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010331_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella08_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale19-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/ca-AstroPh_adj.sym.log cpu-logs/triangles/tuxedo-minitri/com-youtube.wgt32.sym.log cpu-logs/triangles/tuxedo-minitri/flickrEdges_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010512_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella24_adj.sym.log cpu-logs/triangles/tuxedo-minitri/tri_sm.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010414_adj.sym.log cpu-logs/triangles/tuxedo-minitri/com-amazon.wgt32.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010505_adj.sym.log cpu-logs/triangles/tuxedo-minitri/facebook_combined_adj.sym.log cpu-logs/triangles/tuxedo-minitri/ca-HepTh_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010505_adj.sym.log cpu-logs/triangles/tuxedo-minitri/cit-HepPh_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale22-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/ca-GrQc_adj.sym.log cpu-logs/triangles/tuxedo-minitri/roadNet-TX_adj.sym.log cpu-logs/triangles/tuxedo-minitri/cit-Patents_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella25_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010526_adj.sym.log cpu-logs/triangles/tuxedo-minitri/amazon0302_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale21-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010407_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010421_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010331_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010519_adj.sym.log cpu-logs/triangles/tuxedo-minitri/com-dblp.wgt32.sym.log cpu-logs/triangles/tuxedo-minitri/soc-Epinions1_adj.sym.log cpu-logs/triangles/tuxedo-minitri/as-caida20071105_adj.sym.log cpu-logs/triangles/tuxedo-minitri/ktruss_example.sym.log cpu-logs/triangles/tuxedo-minitri/roadNet-PA_adj.sym.log cpu-logs/triangles/tuxedo-minitri/soc-Slashdot0902_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010428_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale18-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/rmat16.sym.tri.log cpu-logs/triangles/tuxedo-minitri/oregon2_010407_adj.sym.log cpu-logs/triangles/tuxedo-minitri/graph500-scale24-ef16_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella04_adj.sym.log cpu-logs/triangles/tuxedo-minitri/com-friendster.wgt32.sym.log cpu-logs/triangles/tuxedo-minitri/soc-Slashdot0811_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella30_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella05_adj.sym.log cpu-logs/triangles/tuxedo-minitri/complete5_sm.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010414_adj.sym.log cpu-logs/triangles/tuxedo-minitri/ca-HepPh_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella31_adj.sym.log cpu-logs/triangles/tuxedo-minitri/amazon0312_adj.sym.log cpu-logs/triangles/tuxedo-minitri/cit-HepTh_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010519_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010421_adj.sym.log cpu-logs/triangles/tuxedo-minitri/email-EuAll_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon2_010428_adj.sym.log cpu-logs/triangles/tuxedo-minitri/ca-CondMat_adj.sym.log cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella09_adj.sym.log cpu-logs/triangles/tuxedo-minitri/email-Enron_adj.sym.log cpu-logs/triangles/tuxedo-minitri/roadNet-CA_adj.sym.log cpu-logs/triangles/tuxedo-minitri/oregon1_010526_adj.sym.log

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella06_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella06_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/as20000102_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri as20000102_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/com-lj.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri com-lj.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/loc-gowalla_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri loc-gowalla_edges_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/amazon0505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri amazon0505_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/loc-brightkite_edges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri loc-brightkite_edges_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/com-orkut.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri com-orkut.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010512_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale20-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale20-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale23-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale23-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/amazon0601_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri amazon0601_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/disjoint_tri_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri disjoint_tri_sm.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010331_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella08_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella08_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale19-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale19-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/ca-AstroPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri ca-AstroPh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/com-youtube.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri com-youtube.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/flickrEdges_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri flickrEdges_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010512_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010512_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella24_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella24_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/tri_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri tri_sm.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010414_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/com-amazon.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri com-amazon.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010505_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/facebook_combined_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri facebook_combined_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/ca-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri ca-HepTh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010505_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010505_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/cit-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri cit-HepPh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale22-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale22-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/ca-GrQc_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri ca-GrQc_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/roadNet-TX_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri roadNet-TX_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/cit-Patents_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri cit-Patents_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella25_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella25_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010526_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/amazon0302_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri amazon0302_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale21-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale21-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010407_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010421_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010331_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010331_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010519_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/com-dblp.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri com-dblp.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/soc-Epinions1_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri soc-Epinions1_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/as-caida20071105_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri as-caida20071105_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/ktruss_example.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri ktruss_example.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/roadNet-PA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri roadNet-PA_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/soc-Slashdot0902_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri soc-Slashdot0902_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010428_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale18-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale18-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/rmat16.sym.tri.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri rmat16.sym.tri

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010407_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010407_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/graph500-scale24-ef16_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri graph500-scale24-ef16_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella04_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella04_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/com-friendster.wgt32.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri com-friendster.wgt32.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/soc-Slashdot0811_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri soc-Slashdot0811_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella30_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella30_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella05_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella05_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/complete5_sm.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri complete5_sm.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010414_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010414_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/ca-HepPh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri ca-HepPh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella31_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella31_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/amazon0312_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri amazon0312_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/cit-HepTh_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri cit-HepTh_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010519_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010519_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010421_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010421_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/email-EuAll_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri email-EuAll_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon2_010428_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon2_010428_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/ca-CondMat_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri ca-CondMat_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/p2p-Gnutella09_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri p2p-Gnutella09_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/email-Enron_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri email-Enron_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/roadNet-CA_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri roadNet-CA_adj.sym

#RULE
cpu-logs/triangles/tuxedo-minitri/oregon1_010526_adj.sym.log: 
	$(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --varcfg t=01 --mtcpulimit 01 --scan ../../graph_challenge//SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial --max-output-bytes 0 --measure-energy --log $@ -v perf triangles/miniTri oregon1_010526_adj.sym

