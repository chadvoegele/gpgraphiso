import bmk2

# This applies to IrGL
PERF_RE = "^Total time: (?P<time_ns>.*) ns$"
PERF_DISCOUNTED_RE = r"^Total time \(discounted\): (?P<time_ns>.*) ns$"
GALOIS_PERF_RE = r"^\(NULL\),.*, Time,0,0,(?P<time_ms>[0-9]+)$"

class graph_bmk(bmk2.Binary):
    def __init__(self):
        self.props = graph_bmk_props(self.bmk, self.variant)
        
    def get_id(self):
        return "%s/%s" % (self.bmk, self.variant)

    def apply_config(self, config):
        self.config = config

class graph_bmk_props(bmk2.Properties):
    def __init__(self, bmk, variant):
        self.bmk = bmk
        self.variant = variant

def makevar(cls, variant, perf_title, flag = None):
    x = cls(variant)
    x.variant_flag = ("-%s" % (variant,)) if flag is None else flag
    x.perf_title = perf_title
    return x

def get_ktruss_checker(bmkinput, trussNum, output='@output', oflag = bmk2.AT_TEMPORARY_INPUT, path = None):
    import os
    ec = bmk2.BasicRunSpec()

    if path is not None:
        p1 = os.path.join(path, "verifyKTruss")
        if os.path.exists(p1):
            ec.set_binary(p1, "verifyKTruss")
        else:
            ec.set_binary("", "verifyKTruss", in_path = True)

    else:
        ec.set_binary("", "verifyKTruss", in_path = True)

    if trussNum == 'max':
        trussNum = int(bmkinput.props.ktruss_max)
    else:
        trussNum = int(trussNum)
        
    ec.set_arg(bmkinput.props.file, bmk2.AT_INPUT_FILE)
    ec.set_arg('-trussFile=@output', oflag)
    ec.set_arg('-trussNum=%d' % (trussNum), bmk2.AT_OPAQUE)
    ec.set_arg('-trussNodes=%s' % (getattr(bmkinput.props, 'ktruss_%d_nodes' % (trussNum,))))
    ec.set_arg('-trussEdges=%s' % (getattr(bmkinput.props, 'ktruss_%d_edges' % (trussNum,))))

    #ec.set_arg(output, oflag)

    return trussNum, ec
