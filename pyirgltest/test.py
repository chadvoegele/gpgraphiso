import os
import io
import sys
import shutil
import subprocess
import tempfile
import itertools
import unittest
import itertools

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

def get_standard_temp_dir(f):
    return os.path.join(tempfile.gettempdir(), f)

def splice_asts(ast, test_ast):
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

      # TODO: Super hacky way to speed up tests.
      static_objects = [ 'mgpuutil.o', 'mgpucontext.o', 'graphml.o', 'edgelist_graph.o' ]
      for so in static_objects:
          so_path = get_standard_temp_dir(so)
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
      make_out = subprocess.run(make_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

      if not os.path.exists(os.path.join(working_dir, 'test')):
          os.chdir(restore_cd)
          raise Exception('make failed with %s' % (make_out.stderr))

      test_cmd = [os.path.join(working_dir, 'test')]
      test_out = subprocess.run(test_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

      parsed_result = parse_irgl_output(test_out.stdout)

      if parsed_result is None:
          raise Exception('failed to parse stdout=%s, stderr=%s' % (test_out.stdout, test_out.stderr))

      return parsed_result

    except Exception as e:
      print('Caught exception')
      return { 'passed': False, 'message': 'Exception %s' % pyirgltest.irgl_ast_repr.dump(e.args[0]) }

    finally:
      if os.getcwd() == working_dir:
          os.chdir(restore_cd)

      if use_dir is None:
          shutil.rmtree(working_dir)

def parse_irgl_output(out):
    out_lines = out.decode().split('\n')
    failure = [o for o in out_lines if o.find('Failure') > 0]
    result = {}
    result['passed'] = len(failure) == 0
    result['message'] = ' '.join([o for o in out_lines if o.find('Host memory') < 0])
    return result

class IrGLTest(unittest.TestCase):
    def run_test(self, ast, test_ast):
        spliced_ast = splice_asts(ast, test_ast)
        test_result = run_irgl(spliced_ast)
        self.assertTrue(test_result['passed'], msg=test_result['message'])

if __name__ == '__main__':
    unittest.main()
