.PHONY: ktruss-tuxedo-gtx1080
ktruss-tuxedo-gtx1080: gpu-logs/ktruss/tuxedo-gtx1080/complete5_sm.sym.log gpu-logs/ktruss/tuxedo-gtx1080/com-dblp.wgt32.sym.log gpu-logs/ktruss/tuxedo-gtx1080/com-amazon.wgt32.sym.log gpu-logs/ktruss/tuxedo-gtx1080/com-orkut.wgt32.sym.log gpu-logs/ktruss/tuxedo-gtx1080/rmat16.sym.tri.log gpu-logs/ktruss/tuxedo-gtx1080/com-youtube.wgt32.sym.log gpu-logs/ktruss/tuxedo-gtx1080/com-friendster.wgt32.sym.log gpu-logs/ktruss/tuxedo-gtx1080/com-lj.wgt32.sym.log

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/complete5_sm.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl complete5_sm.sym

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/com-dblp.wgt32.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-dblp.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/com-amazon.wgt32.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-amazon.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/com-orkut.wgt32.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-orkut.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/rmat16.sym.tri.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl rmat16.sym.tri

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/com-youtube.wgt32.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-youtube.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/com-friendster.wgt32.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-friendster.wgt32.sym

#RULE
gpu-logs/ktruss/tuxedo-gtx1080/com-lj.wgt32.sym.log:
	 $(BMK2)/test2.py -d $(BMK2CFG) --cfg default --varcfg k=max --scan ../ktruss/ktruss --log $@ -v perf ktruss/irgl com-lj.wgt32.sym

