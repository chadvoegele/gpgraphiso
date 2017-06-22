DSTDIR=.
GGC=../../ggc/src/ggc
# 0.79
#GGCFLAGS= --opt np --npf 8  

# 0.79
#GGCFLAGS= --opt np --nps fg --npf 8

# 0.84, with road networks suffering
#GGCFLAGS= --opt np --nps tb --nps wp

# 0.84
#GGCFLAGS= --opt np --nps tb --nps wp

# 0.81
#GGCFLAGS= --opt np --nps wp --nps fg --npf 8

# 0.78
GGCFLAGS= --opt np --nps tb --nps fg --npf 8

triangles: $(DSTDIR)/kernel.cu $(DSTDIR)/support.cu $(DSTDIR)/bmktest2.py $(DSTDIR)/kernel-nontex.cu

$(DSTDIR)/kernel.cu: triangles.py 
	$(GGC) $(GGCFLAGS) -o $@ $<

$(DSTDIR)/kernel-nontex.cu: triangles.py 
	$(GGC) $(GGCFLAGS) --cuda-worklist basic --cuda-graph basic -o $@ $<

$(DSTDIR)/support.cu: 
	ln -sf tri_support.cu $@ 

clean:
	rm -f $(DSTDIR)/kernel.cu $(DSTDIR)/kernel-nontex.cu
