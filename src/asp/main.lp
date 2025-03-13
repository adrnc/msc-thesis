#script (python)

from clingo.symbol import Number

class Context:
    def inc(self, x):
        return Number(x.number + 1)

    def seq(self, x, y):
        return [x, y]

def main(prg):
    prg.ground([("base", [])], context=Context())
    prg.solve()

#end.

p(@inc(10)).
q(@seq(1,2)).
