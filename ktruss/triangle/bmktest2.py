import bmk2
from bmkprops import graph_bmk, PERF_RE

class triangles(graph_bmk):
	bmk = 'triangles'
	variant = 'irgl'

	def filter_inputs(self, inputs):
		return [x for x in inputs if x.props.format == 'bin/galois' and ("triangle" in x.props.flags or hasattr(x.props, "triangles"))]

	def get_run_spec(self, bmkinput):
		x = bmk2.RunSpec(self, bmkinput)
                if hasattr(bmkinput.props, 'nontex') and (int(bmkinput.props.nontex) == 1):
                        x.set_binary(self.props._cwd, 'test_nontex')
                else:
                        x.set_binary(self.props._cwd, 'test')

		x.set_arg(bmkinput.props.file, bmk2.AT_INPUT_FILE)
		x.set_checker(bmk2.REChecker('^triangles: %s$' % (bmkinput.props.triangles)))
		x.set_perf(bmk2.PerfRE(PERF_RE))
		return x

#triangles sample.sym,USA-road-d.NY.sym,rmat12.sym,2d-2e20.sym,USA-road-d.USA.sym,USA-road-d.CAL.sym,USA-road-d.FLA.sym,rmat20.sym,rmat10.sym,rmat22.sym
BINARIES = [triangles()]

