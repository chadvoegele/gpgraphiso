import os
import io
import sys
import shutil
import subprocess
import tempfile
import itertools
import unittest

import gg.compiler
from gg.ast import *

import pyirgltest.irgl_ast_repr

class capture_stdout_stderr:
    def __init__(self, stdout, stderr):
        self.stdout = stdout
        self.stderr = stderr

    def __enter__(self):
        sys.stdout = self.stdout
        sys.stderr = self.stderr

    def __exit__(self, *_):
        sys.stdout = sys.__stdout__
        sys.stderr = sys.__stderr__

def get_local_path(f):
    return os.path.join(os.path.dirname(__file__), f)

def get_temp_dir():
    return tempfile.mkdtemp(prefix='pyirgltest_')

def get_object_cache_dir(f):
    return os.path.join(tempfile.gettempdir(), 'pyirgltestcache', f)

def splice_asts(ast, test_ast):
    # Something in below causes ast to be modified...
    ast = ast.clone()
    concat_stmts = ast.stmts.stmts + test_ast.stmts.stmts
    kernel_names = [c.name for c in concat_stmts if type(c) == gg.ast.Kernel]
    kernel_counts = dict([(name, len([x for x in g])) for (name, g) in itertools.groupby(kernel_names)])

    dedup_stmts = []
    for stmt in concat_stmts:
        if type(stmt) != gg.ast.Kernel:
            dedup_stmts.append(stmt)
            continue

        kernel_counts[stmt.name] = kernel_counts[stmt.name] - 1
        if kernel_counts[stmt.name] == 0:
            dedup_stmts.append(stmt)

    spliced_ast = gg.ast.Module(dedup_stmts)

    return spliced_ast

def default_compiler_options():
    options = gg.compiler.CompilerOptions(backend='cuda')
    options.np_schedulers = []
    options.unroll = []
    options.instrument = []
    return options

def run_irgl(ast, use_dir=None):
    try:
      if use_dir is None:
          working_dir = get_temp_dir()
      else:
          working_dir = use_dir
      restore_cd = os.getcwd()
      os.chdir(working_dir)  # Ideally wouldn't do this but can't turn off the *.dot files

      kernel_cu_path = os.path.join(working_dir, 'kernel.cu')

      static_objects = [ 'mgpuutil.o', 'mgpucontext.o', 'graphml.o', 'edgelist_graph.o' ]
      for so in static_objects:
          so_path = get_object_cache_dir(so)
          if os.path.exists(so_path):
              shutil.copy(so_path, working_dir)
          else:
              print('Consider adding %s to speed up tests.' % so_path)

      shutil.copy(get_local_path('Makefile'), working_dir)

      comp_stdout = io.StringIO()
      comp_stderr = io.StringIO()
      with capture_stdout_stderr(comp_stdout, comp_stderr):
          comp = gg.compiler.Compiler()
          if not comp.compile(ast, kernel_cu_path, default_compiler_options()):
              raise Exception('IrGL compilation failed')

      makeflags = os.getenv('MAKEFLAGS')
      make_cmd = ['make', '-C', working_dir] + ([makeflags] if makeflags else [])
      if sys.version_info.major == 3:
          make_out = subprocess.run(make_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      else:
          make_out = subprocess.Popen(make_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
          make_out.wait()

      if not os.path.exists(os.path.join(working_dir, 'test')):
          os.chdir(restore_cd)
          raise Exception('make failed with %s' % (make_out.stderr.decode()))

      test_cmd = [os.path.join(working_dir, 'test')]
      if sys.version_info.major == 3:
          test_out = subprocess.run(test_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      else:
          test_out = subprocess.Popen(test_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
          test_out.wait()

      if not test_out.returncode == 0:
          raise Exception('test failed with return code: %d. stdout: %s\nstderr: %s' % (test_out.returncode, test_out.stdout.decode(), test_out.stderr.decode()))

      cache_dir = get_object_cache_dir('')
      if not os.path.exists(cache_dir):
          os.mkdir(cache_dir)

      for so in static_objects:
          so_path_cache = get_object_cache_dir(so)
          so_path_build = os.path.join(working_dir, so)
          if os.path.exists(so_path_build) and not os.path.exists(so_path_cache):
              shutil.copy(so_path_build, so_path_cache)
              print('Copied %s to %s to speed up tests.' % (so_path_build, so_path_cache))

      parsed_result = parse_irgl_output(test_out.stdout)

      if parsed_result is None:
          raise Exception('failed to parse stdout=%s, stderr=%s' % (test_out.stdout, test_out.stderr))

      return parsed_result

    except Exception as e:
      print('Caught exception')
      earg = e.args[0]
      message = earg if type(earg) == str else pyirgltest.irgl_ast_repr.dump(earg)
      return { 'passed': False, 'message': 'Exception %s\nIrGL stdout %s\nIrGL stderr %s' % (message, comp_stdout.getvalue(), comp_stderr.getvalue()) }

    finally:
      if os.getcwd() == working_dir:
          os.chdir(restore_cd)

      if use_dir is None:
          shutil.rmtree(working_dir)

def parse_irgl_output(out):
    if sys.version_info.major == 3:
        out_lines = out.decode().split('\n')
    else:
        out_lines = [ l.decode().rstrip() for l in out.readlines() ]
    failure = [o for o in out_lines if o.find('Failure') > 0]
    result = {}
    result['passed'] = len(failure) == 0
    result['message'] = '\n' + '\n'.join([o for o in out_lines if o.find('Host memory') < 0])
    return result

class IrGLTest(unittest.TestCase):
    def run_test(self, ast, test_ast):
        spliced_ast = splice_asts(ast, test_ast)
        test_result = run_irgl(spliced_ast)
        self.assertTrue(test_result['passed'], msg=test_result['message'])

if __name__ == '__main__':
    unittest.main()
