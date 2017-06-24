import bmk2
from bmkprops import graph_bmk, GALOIS_PERF_RE

class trianglesBase(graph_bmk):
	bmk = 'triangles'
	variant = 'galois+node'
        algo = "nodeiterator"

	def filter_inputs(self, inputs):
		return [x for x in inputs if x.props.format == 'bin/galois' and ("triangle" in x.props.flags or hasattr(x.props, "triangles"))]

	def get_run_spec(self, bmkinput):
		x = bmk2.RunSpec(self, bmkinput)

                t = int(self.config['t'])

                x.set_binary(self.props._cwd, 'triangles')
		x.set_arg("-algo=%s" % (self.algo,), bmk2.AT_OPAQUE)
		x.set_arg(bmkinput.props.file, bmk2.AT_INPUT_FILE)
                x.set_arg("-t=%d" % (t,), bmk2.AT_OPAQUE)
		x.set_checker(bmk2.REChecker('^NumTriangles: %s$' % (bmkinput.props.triangles)))
		x.set_perf(bmk2.PerfRE(GALOIS_PERF_RE))
		return x

class trianglesNode(trianglesBase):
	bmk = 'triangles'
	variant = 'galois+node'
        algo = "nodeiterator"

class trianglesEdge(trianglesBase):
	bmk = 'triangles'
	variant = 'galois+edge'
        algo = "edgeiterator"

#triangles sample.sym,USA-road-d.NY.sym,rmat12.sym,2d-2e20.sym,USA-road-d.USA.sym,USA-road-d.CAL.sym,USA-road-d.FLA.sym,rmat20.sym,rmat10.sym,rmat22.sym
BINARIES = [trianglesNode(), trianglesEdge()]

