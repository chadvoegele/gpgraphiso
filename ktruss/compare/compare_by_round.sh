GPGRAPHISO_ROOT=${GPGRAPHISO_ROOT-$(dirname $(readlink -f ./compare.sh))/../..}
GRAPHCHALLENGE_ROOT=${GRAPHCHALLENGE_ROOT-${HOME}/code/graph_challenge}
INPUTS_ROOT=${INPUTS_ROOT-~/work/ggpu/inputs}
SNAP_INPUTS_ROOT=${SNAP_INPUTS_ROOT-~/work/ggpu/snap_inputs/}
grs=(
  "$GPGRAPHISO_ROOT/inputs/small/ktruss_example.sym.gr"
  "$INPUTS_ROOT/rmat/rmat12.sym.tri.gr"
  "$INPUTS_ROOT/rmat/rmat16.sym.tri.gr"
  "$INPUTS_ROOT/rmat/rmat20.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.CAL.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.FLA.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.NY.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.USA.sym.tri.gr"
  "$SNAP_INPUTS_ROOT/Amazon/com-amazon.sym.gr"
  "$SNAP_INPUTS_ROOT/DBLP/com-dblp.sym.gr"
  "$SNAP_INPUTS_ROOT/Friendster/com-friendster.sym.gr"
  "$SNAP_INPUTS_ROOT/Youtube/com-youtube.sym.gr"
  "$SNAP_INPUTS_ROOT/Orkut/com-orkut.sym.gr"
  "$SNAP_INPUTS_ROOT/LiveJournal/com-lj.sym.gr"
)
ks=(
  3
  4
)
PYTHONPATH="$GRAPHCHALLENGE_ROOT/grtools"
refktruss="$GRAPHCHALLENGE_ROOT/SubgraphIsomorphism/ktruss/code/python/runKtrussFromGr.py"
irgltrinode="$GPGRAPHISO_ROOT/ktruss/tri_node_count/test"
irglktruss="$GPGRAPHISO_ROOT/ktruss/ktruss/test"

for k in $ks
do
  for gr in $grs
  do
    echo "gr="$gr "k="$k
    if [ $k -eq 3 ]
    then
      timeout 60m $irgltrinode -o - $gr 2> /dev/null | grep 'triangle_nodes'
    fi
    PYTHONPATH=${PYTHONPATH} timeout 5m python2 $refktruss $gr $k 2>&1 | grep '# nodes in ktruss'
    timeout 60m $irglktruss -k $k -o - $gr 2> /dev/null | grep '# ktruss nodes:'
  done
done
