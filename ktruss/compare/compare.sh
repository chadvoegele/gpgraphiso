GPGRAPHISO_ROOT=${GPGRAPHISO_ROOT-$(dirname $(readlink -f ./compare.sh))/../..}
GRAPHCHALLENGE_ROOT=${GRAPHCHALLENGE_ROOT-${HOME}/code/graph_challenge}
INPUTS_ROOT=${INPUTS_ROOT-~/work/ggpu/inputs}
grs=(
  "$GPGRAPHISO_ROOT/inputs/small/ktruss_example.sym.gr"
  "$INPUTS_ROOT/rmat/rmat12.sym.tri.gr"
  "$INPUTS_ROOT/rmat/rmat16.sym.tri.gr"
  "$INPUTS_ROOT/rmat/rmat20.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.CAL.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.FLA.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.NY.sym.tri.gr"
  "$INPUTS_ROOT/road/USA-road-d.USA.sym.tri.gr"
)
PYTHONPATH="$GRAPHCHALLENGE_ROOT/grtools"
reftri="$GRAPHCHALLENGE_ROOT/SubgraphIsomorphism/triangle/code/python/runTriangleFromGr.py"
refktruss="$GRAPHCHALLENGE_ROOT/SubgraphIsomorphism/ktruss/code/python/runKtrussFromGr.py"
irgltri="$GPGRAPHISO_ROOT/ggc/gensrc/triangles/test"
irglktruss="$GPGRAPHISO_ROOT/ktruss/ktruss/test"
for gr in $grs
do
  echo $gr
  PYTHONPATH=${PYTHONPATH} timeout 1m python2 $reftri $gr 2>&1 | grep 'number of triangles'
  timeout 1m $irgltri -o - $gr 2> /dev/null | grep 'triangles: '
  PYTHONPATH=${PYTHONPATH} timeout 1m python2 $refktruss $gr 2>&1 | grep '# nodes in ktruss'
  timeout 1m $irglktruss -o - $gr 2> /dev/null | grep 'total_ktruss_nodes'
done
