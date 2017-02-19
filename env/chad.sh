BASE=$(readlink -f $(dirname $0))/..
export MAKEJOBS=6
export GGC_ROOT="$BASE/ggc"
export GPGRAPHISO_ROOT="$BASE"
export GPGRAPHLIB_ROOT="$BASE/gpgraphlib"
export PYTHONPATH="$BASE/gpsm:$GGC_ROOT/src:$BASE"
