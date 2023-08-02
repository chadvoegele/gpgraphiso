import gg.compiler
from gg.ast import *
import gg.lib.wl
import gg.lib.graph
import os

# TODO: Many of these are not correct. Only those present in test have been implemented.
class Dumper(gg.ast.walkers.ASTWalker):
    tabbing = 0

    def print_ln(self, s):
        return ("    " * self.tabbing) + s

    def visit_Module(self, node):
        return [ self.print_ln("Module([") ] \
                + self.visit(node.stmts) \
                + [  self.print_ln("])") ]

    def begin_block(self):
        self.tabbing += 1

    def end_block(self):
        self.tabbing -= 1

    def visit_DoWhile(self, node):
        return [ self.print_ln("Do") ]  \
                + self.visit(node.stmts) \
                + [ self.print_ln("While (%s)" % (node.cond)) ]

    def visit_While(self, node):
        return [ self.print_ln("While(%s)" % (node.cond)) ] \
                + self.visit(node.stmts) \
                + [ self.print_ln("End While") ]

    def visit_Pipe(self, node):
        return [ self.print_ln("Pipe%s" % (" once" if node.once else "")) ] \
                + self.visit(node.stmts)

    def visit_Kernel(self, node):
        args_str = repr(node.args)
        args_str = args_str.replace("('+Graph+', 'graph')", 'graph.param()')
        return [ self.print_ln("Kernel('%s', %s," % (node.name, args_str)) ] \
                + [ self.print_ln("[") ] \
                + [ s for s in self.visit(node.stmts) ] \
                + [ self.print_ln("])") ]

    def visit_ForAll(self, node):
        return [ self.print_ln("ForAll('%s', %s," % (node.ndxvar_name, self.visit(node.iterator))) ] \
                + [ self.print_ln("[") ] \
                + [ s for s in self.visit(node.stmts) ] \
                + [ self.print_ln("])") ]

    def visit_For(self, node):
        return [ self.print_ln("For %s in %s" % (node.ndxvar_name, self.visit(node.iterator))) ] \
                + self.visit(node.stmts)

    def visit_If(self, node):
        return [ self.print_ln("If (%s) Then" % (node.cond,)) ] \
                + self.visit(node.true_stmts) \
                + self.visit(node.false_stmts)

    def visit_ReturnFromParallelFor(self, node):
        return [ self.print_ln("ReturnFromParallelFor(%s)" % (node.value)) ]

    def visit_Atomic(self, node):
        return [ self.print_ln("Atomic %s" % (node.lock,)) ] \
                + self.visit(node.stmts) \
                + [ self.print_ln("Else") ] \
                + self.visit(node.fail_stmts)

    def visit_Exclusive(self, node):
        return [ self.print_ln("Exclusive %s" % (node.to_lock,)) ] \
                + self.visit(node.stmts) \
                + [ self.print_ln("Else") ] \
                + self.visit(node.fail_stmts)

    def visit_Invoke(self, node):
        args = node.args.copy()
        if len(args) == 1:
            args.append('')
        quoted_args = [ "'" + a + "'" if not a == '' else a for a in args  ]
        return [ self.print_ln("Invoke('%s', (%s))" % (node.kernel, ",".join(quoted_args))) ]

    def visit_Iterate(self, node):
        if node.condition == "WL":
            output = [ self.print_ln("Iterate WL %s %s" % (node.kernel, node.kernel_args )) ]
        else:
            output = [ self.print_ln("Iterate %s %s %s" % (node.condition, node.kernel, node.kernel_args)) ]

        output = output + self.visit(node.stmts)
        return output

    def visit_Block(self, node):
        self.begin_block()
        outputs = []
        for s in node.stmts:
            output = self.visit(s)
            output[-1] = output[-1] + ','
            outputs.extend(output)
        self.end_block()
        return outputs

    def visit_CBlock(self, node):
        if isinstance(node, CDecl):
            return self.visit_CDecl(node)

        return [ self.print_ln('CBlock([') ] \
                + [ self.print_ln("'" + str(s) + "',") for s in node.stmts ] \
                + [ self.print_ln('])') ]

    def visit_CDecl(self, node):
        if any((node.symbol_flags[n]['is_global'] for n in node.symbol_flags)):
            name = 'CDeclGlobal'
        else:
            name = 'CDecl'
        return [ self.print_ln(name + '((') ] \
                + [ self.print_ln("'%s', '%s', '%s'" % (i[0], i[1], i[2])) for i in node.decls ] \
                + [ self.print_ln('))') ]

    def visit_MethodInvocation(self, node):
        return [ self.print_ln("%s.%s %s" % (node.obj_type, node.method, node.args)) ]

    def visit_WorklistIterator(self, node):
        return 'WL.items()'

    def visit_NodeIterator(self, node):
        return 'graph.nodes()'

    def visit_EdgeIterator(self, node):
        return 'graph.edges()'

    def visit(self, node):
        if isinstance(node, gg.lib.wl.WorklistIterator):
          return self.visit_WorklistIterator(node)
        elif isinstance(node, gg.lib.graph.NodeIterator):
          return self.visit_NodeIterator(node)
        elif isinstance(node, gg.lib.graph.EdgeIterator):
          return self.visit_EdgeIterator(node)

        return super(Dumper, self).visit(node)

def dump(ast):
    dumper = Dumper()
    return dumper.visit(ast)
