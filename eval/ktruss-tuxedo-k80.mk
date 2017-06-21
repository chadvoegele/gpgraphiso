.PHONY: ktruss-tuxedo-k80
ktruss-tuxedo-k80: gpu-logs/ktruss/tuxedo-k80/as20000102_adj.sym.log gpu-logs/ktruss/tuxedo-k80/com-lj.wgt32.sym.log gpu-logs/ktruss/tuxedo-k80/amazon0505_adj.sym.log gpu-logs/ktruss/tuxedo-k80/com-orkut.wgt32.sym.log gpu-logs/ktruss/tuxedo-k80/graph500-scale23-ef16_adj.sym.log gpu-logs/ktruss/tuxedo-k80/amazon0601_adj.sym.log gpu-logs/ktruss/tuxedo-k80/graph500-scale19-ef16_adj.sym.log gpu-logs/ktruss/tuxedo-k80/com-youtube.wgt32.sym.log gpu-logs/ktruss/tuxedo-k80/flickrEdges_adj.sym.log gpu-logs/ktruss/tuxedo-k80/com-amazon.wgt32.sym.log gpu-logs/ktruss/tuxedo-k80/facebook_combined_adj.sym.log gpu-logs/ktruss/tuxedo-k80/cit-HepPh_adj.sym.log gpu-logs/ktruss/tuxedo-k80/graph500-scale22-ef16_adj.sym.log gpu-logs/ktruss/tuxedo-k80/email-EuAll_adj.sym.log gpu-logs/ktruss/tuxedo-k80/as-caida20071105_adj.sym.log gpu-logs/ktruss/tuxedo-k80/ca-GrQc_adj.sym.log gpu-logs/ktruss/tuxedo-k80/com-dblp.wgt32.sym.log gpu-logs/ktruss/tuxedo-k80/ca-AstroPh_adj.sym.log gpu-logs/ktruss/tuxedo-k80/graph500-scale18-ef16_adj.sym.log gpu-logs/ktruss/tuxedo-k80/rmat16.sym.tri.log gpu-logs/ktruss/tuxedo-k80/cit-Patents_adj.sym.log gpu-logs/ktruss/tuxedo-k80/com-friendster.wgt32.sym.log gpu-logs/ktruss/tuxedo-k80/ca-HepTh_adj.sym.log gpu-logs/ktruss/tuxedo-k80/complete5_sm.sym.log gpu-logs/ktruss/tuxedo-k80/email-Enron_adj.sym.log gpu-logs/ktruss/tuxedo-k80/ca-HepPh_adj.sym.log gpu-logs/ktruss/tuxedo-k80/ca-CondMat_adj.sym.log gpu-logs/ktruss/tuxedo-k80/cit-HepTh_adj.sym.log gpu-logs/ktruss/tuxedo-k80/amazon0302_adj.sym.log gpu-logs/ktruss/tuxedo-k80/amazon0312_adj.sym.log gpu-logs/ktruss/tuxedo-k80/graph500-scale21-ef16_adj.sym.log gpu-logs/ktruss/tuxedo-k80/graph500-scale20-ef16_adj.sym.log

#RULE
gpu-logs/ktruss/tuxedo-k80/as20000102_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl as20000102_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/com-lj.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-lj.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/amazon0505_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl amazon0505_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/com-orkut.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-orkut.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/graph500-scale23-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl graph500-scale23-ef16_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/amazon0601_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl amazon0601_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/graph500-scale19-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl graph500-scale19-ef16_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/com-youtube.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-youtube.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/flickrEdges_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl flickrEdges_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/com-amazon.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-amazon.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/facebook_combined_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl facebook_combined_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/cit-HepPh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl cit-HepPh_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/graph500-scale22-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl graph500-scale22-ef16_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/email-EuAll_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl email-EuAll_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/as-caida20071105_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl as-caida20071105_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/ca-GrQc_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl ca-GrQc_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/com-dblp.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-dblp.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/ca-AstroPh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl ca-AstroPh_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/graph500-scale18-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl graph500-scale18-ef16_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/rmat16.sym.tri.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl rmat16.sym.tri

#RULE
gpu-logs/ktruss/tuxedo-k80/cit-Patents_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl cit-Patents_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/com-friendster.wgt32.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-friendster.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/ca-HepTh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl ca-HepTh_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/complete5_sm.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl complete5_sm.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/email-Enron_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl email-Enron_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/ca-HepPh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl ca-HepPh_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/ca-CondMat_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl ca-CondMat_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/cit-HepTh_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl cit-HepTh_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/amazon0302_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl amazon0302_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/amazon0312_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl amazon0312_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/graph500-scale21-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl graph500-scale21-ef16_adj.sym

#RULE
gpu-logs/ktruss/tuxedo-k80/graph500-scale20-ef16_adj.sym.log:
	CUDA_VISIBLE_DEVICES=1 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl graph500-scale20-ef16_adj.sym

