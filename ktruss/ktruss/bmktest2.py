import bmk2
from bmkprops import graph_bmk, PERF_RE, get_ktruss_checker
import os

class KtrussIrgl(graph_bmk):
    bmk = "ktruss"
    variant = "irgl"

    def filter_inputs(self, inputs):
        def finput(x):
            if not "symmetric" in x.props.flags: return False
            if x.props.format == 'bin/galois': return True

            return False

        return filter(finput, inputs)

    def get_run_spec(self, bmkinput):
        x = bmk2.RunSpec(self, bmkinput)        

        k, ec = get_ktruss_checker(bmkinput, self.config['k'])

        if hasattr(bmkinput.props, 'nontex') and (int(bmkinput.props.nontex) == 1):
            x.set_binary(self.props._cwd, 'test-nontex')
        else:
            x.set_binary(self.props._cwd, 'test')

        x.set_arg(bmkinput.props.file, bmk2.AT_INPUT_FILE)

        # TODO: set GPU 
        # x.set_arg('-g=%d' % (k,), bmk2.AT_OPAQUE)

        x.set_arg('-k', bmk2.AT_OPAQUE)
        x.set_arg(str(k), bmk2.AT_OPAQUE)

        x.set_arg("-p", bmk2.AT_OPAQUE)
        x.set_arg('edges', bmk2.AT_OPAQUE)

        x.set_arg("-o", bmk2.AT_OPAQUE)
        x.set_arg('@output', bmk2.AT_TEMPORARY_OUTPUT)

        x.set_checker(bmk2.ExternalChecker(ec))

        x.set_perf(bmk2.PerfRE(PERF_RE))
        return x

BINARIES = [KtrussIrgl()]
