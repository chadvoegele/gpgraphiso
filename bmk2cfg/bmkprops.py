import bmk2

# This applies to IrGL
PERF_RE = "^Total time: (?P<time_ns>.*) ns$"
PERF_DISCOUNTED_RE = r"^Total time \(discounted\): (?P<time_ns>.*) ns$"

class graph_bmk(bmk2.Binary):
    def __init__(self):
        self.props = graph_bmk_props(self.bmk, self.variant)
        
    def get_id(self):
        return "%s/%s" % (self.bmk, self.variant)

class graph_bmk_props(bmk2.Properties):
    def __init__(self, bmk, variant):
        self.bmk = bmk
        self.variant = variant

def makevar(cls, variant, perf_title, flag = None):
    x = cls(variant)
    x.variant_flag = ("-%s" % (variant,)) if flag is None else flag
    x.perf_title = perf_title
    return x
