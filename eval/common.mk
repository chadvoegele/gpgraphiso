# do not modify this file for local changes
# create a file <user>-common.mk or <user>-<hostname>-common.mk with overrides

BMK2=~/src/bmk2/
BMK2CFG=../bmk2cfg/
KTRUSS=../ktruss/ktruss
KTRUSS_WL=../ktruss/ktruss-wl
TRIANGLES=../ktruss/triangle
TRIANGLES_NC=../ktruss/tri_node_count
GALOIS=../../GaloisCpp/build/default/
CPU_KTRUSS=$(GALOIS)/exp/apps/ktruss
GR_CHALLENGE=../../graph_challenge/
CPU_TRIANGLES=$(GALOIS)/lonestar/triangles
CPU_MINITRI=$(GR_CHALLENGE)/SubgraphIsomorphism/triangle/code/cpp/code/linearAlgebra/serial
CPU_KTRUSS_REF=$(GR_CHALLENGE)/SubgraphIsomorphism/ktruss/code/

USER:=$(shell whoami)
HOST:=$(shell hostname -s)
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

ifneq ($(wildcard $(mkfile_dir)/$(USER)-$(HOST)-common.mk), )
USERINC:=$(mkfile_dir)/$(USER)-$(HOST)-common.mk
else
ifneq ($(wildcard $(mkfile_dir)/$(USER)-common.mk), )
USERINC:=$(mkfile_dir)/$(USER)-common.mk
endif
endif

$(info $(USERINC))

ifdef USERINC
include $(USERINC)
endif

