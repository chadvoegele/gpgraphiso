.PHONY: triangles-tuxedo-k80
triangles-tuxedo-k80: gpu-logs/triangles/tuxedo-k80/p2p-Gnutella06_adj.sym.log gpu-logs/triangles/tuxedo-k80/as20000102_adj.sym.log gpu-logs/triangles/tuxedo-k80/com-lj.wgt32.sym.log gpu-logs/triangles/tuxedo-k80/loc-gowalla_edges_adj.sym.log gpu-logs/triangles/tuxedo-k80/amazon0505_adj.sym.log gpu-logs/triangles/tuxedo-k80/loc-brightkite_edges_adj.sym.log gpu-logs/triangles/tuxedo-k80/com-orkut.wgt32.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010512_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale20-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale23-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/amazon0601_adj.sym.log gpu-logs/triangles/tuxedo-k80/disjoint_tri_sm.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010331_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella08_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale19-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/ca-AstroPh_adj.sym.log gpu-logs/triangles/tuxedo-k80/com-youtube.wgt32.sym.log gpu-logs/triangles/tuxedo-k80/flickrEdges_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010512_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella24_adj.sym.log gpu-logs/triangles/tuxedo-k80/tri_sm.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010414_adj.sym.log gpu-logs/triangles/tuxedo-k80/com-amazon.wgt32.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010505_adj.sym.log gpu-logs/triangles/tuxedo-k80/facebook_combined_adj.sym.log gpu-logs/triangles/tuxedo-k80/ca-HepTh_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010505_adj.sym.log gpu-logs/triangles/tuxedo-k80/cit-HepPh_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale22-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/ca-GrQc_adj.sym.log gpu-logs/triangles/tuxedo-k80/roadNet-TX_adj.sym.log gpu-logs/triangles/tuxedo-k80/cit-Patents_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella25_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010526_adj.sym.log gpu-logs/triangles/tuxedo-k80/amazon0302_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale21-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010407_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010421_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010331_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010519_adj.sym.log gpu-logs/triangles/tuxedo-k80/com-dblp.wgt32.sym.log gpu-logs/triangles/tuxedo-k80/soc-Epinions1_adj.sym.log gpu-logs/triangles/tuxedo-k80/as-caida20071105_adj.sym.log gpu-logs/triangles/tuxedo-k80/ktruss_example.sym.log gpu-logs/triangles/tuxedo-k80/roadNet-PA_adj.sym.log gpu-logs/triangles/tuxedo-k80/soc-Slashdot0902_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010428_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale18-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/rmat16.sym.tri.log gpu-logs/triangles/tuxedo-k80/oregon2_010407_adj.sym.log gpu-logs/triangles/tuxedo-k80/graph500-scale24-ef16_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella04_adj.sym.log gpu-logs/triangles/tuxedo-k80/com-friendster.wgt32.sym.log gpu-logs/triangles/tuxedo-k80/soc-Slashdot0811_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella30_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella05_adj.sym.log gpu-logs/triangles/tuxedo-k80/complete5_sm.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010414_adj.sym.log gpu-logs/triangles/tuxedo-k80/ca-HepPh_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella31_adj.sym.log gpu-logs/triangles/tuxedo-k80/amazon0312_adj.sym.log gpu-logs/triangles/tuxedo-k80/cit-HepTh_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010519_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010421_adj.sym.log gpu-logs/triangles/tuxedo-k80/email-EuAll_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon2_010428_adj.sym.log gpu-logs/triangles/tuxedo-k80/ca-CondMat_adj.sym.log gpu-logs/triangles/tuxedo-k80/p2p-Gnutella09_adj.sym.log gpu-logs/triangles/tuxedo-k80/email-Enron_adj.sym.log gpu-logs/triangles/tuxedo-k80/roadNet-CA_adj.sym.log gpu-logs/triangles/tuxedo-k80/oregon1_010526_adj.sym.log

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella06_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella06_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/as20000102_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl as20000102_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/com-lj.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl com-lj.wgt32.sym

#RULE
gpu-logs/triangles/tuxedo-k80/loc-gowalla_edges_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl loc-gowalla_edges_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/amazon0505_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl amazon0505_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/loc-brightkite_edges_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl loc-brightkite_edges_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/com-orkut.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl com-orkut.wgt32.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010512_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010512_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale20-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale20-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale23-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale23-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/amazon0601_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl amazon0601_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/disjoint_tri_sm.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl disjoint_tri_sm.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010331_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010331_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella08_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella08_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale19-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale19-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/ca-AstroPh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl ca-AstroPh_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/com-youtube.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl com-youtube.wgt32.sym

#RULE
gpu-logs/triangles/tuxedo-k80/flickrEdges_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl flickrEdges_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010512_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010512_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella24_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella24_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/tri_sm.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl tri_sm.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010414_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010414_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/com-amazon.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl com-amazon.wgt32.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010505_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010505_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/facebook_combined_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl facebook_combined_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/ca-HepTh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl ca-HepTh_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010505_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010505_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/cit-HepPh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl cit-HepPh_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale22-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale22-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/ca-GrQc_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl ca-GrQc_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/roadNet-TX_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl roadNet-TX_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/cit-Patents_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl cit-Patents_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella25_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella25_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010526_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010526_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/amazon0302_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl amazon0302_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale21-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale21-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010407_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010407_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010421_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010421_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010331_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010331_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010519_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010519_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/com-dblp.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl com-dblp.wgt32.sym

#RULE
gpu-logs/triangles/tuxedo-k80/soc-Epinions1_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl soc-Epinions1_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/as-caida20071105_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl as-caida20071105_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/ktruss_example.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl ktruss_example.sym

#RULE
gpu-logs/triangles/tuxedo-k80/roadNet-PA_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl roadNet-PA_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/soc-Slashdot0902_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl soc-Slashdot0902_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010428_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010428_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale18-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale18-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/rmat16.sym.tri.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl rmat16.sym.tri

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010407_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010407_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/graph500-scale24-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl graph500-scale24-ef16_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella04_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella04_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/com-friendster.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl com-friendster.wgt32.sym

#RULE
gpu-logs/triangles/tuxedo-k80/soc-Slashdot0811_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl soc-Slashdot0811_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella30_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella30_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella05_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella05_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/complete5_sm.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl complete5_sm.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010414_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010414_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/ca-HepPh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl ca-HepPh_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella31_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella31_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/amazon0312_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl amazon0312_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/cit-HepTh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl cit-HepTh_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010519_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010519_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010421_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010421_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/email-EuAll_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl email-EuAll_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon2_010428_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon2_010428_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/ca-CondMat_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl ca-CondMat_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/p2p-Gnutella09_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl p2p-Gnutella09_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/email-Enron_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl email-Enron_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/roadNet-CA_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl roadNet-CA_adj.sym

#RULE
gpu-logs/triangles/tuxedo-k80/oregon1_010526_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/triangle --max-output-bytes 0 --log $@ -v perf triangles/irgl oregon1_010526_adj.sym

