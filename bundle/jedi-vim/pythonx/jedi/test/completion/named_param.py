"""
Named Params:
>>> def a(abc): pass
...
>>> a(abc=3)  # <- this stuff (abc)
"""

def a(abc):
    pass

#? 5 ['abc=']
a(abc)


def a(*some_args, **some_kwargs):
    pass

#? 11 []
a(some_args)

#? 13 []
a(some_kwargs)

def multiple(foo, bar):
    pass

#? 17 ['bar=']
multiple(foo, bar)

#? ['bar=']
multiple(foo, bar

my_lambda = lambda lambda_param: lambda_param + 1
#? 22 ['lambda_param=']
my_lambda(lambda_param)

# __call__ / __init__
class Test(object):
    def __init__(self, hello_other):
        pass

    def __call__(self, hello):
        pass

    def test(self, blub):
        pass

#? 10 ['hello_other=']
Test(hello=)
#? 12 ['hello=']
Test()(hello=)
#? 11 []
Test()(self=)
#? 16 []
Test().test(self=)
#? 16 ['blub=']
Test().test(blub=)

# builtins

#? 12 []
any(iterable=)


def foo(xyz):
    pass

#? 7 ['xyz=']
@foo(xy)
def x(): pass

#? 7 ['xyz=']
foo(xyz)
# No completion should be possible if it's not a simple name
#? 17 []
x = " "; foo(x.xyz)
#? 17 []
x = " "; foo([xyz)
#? 20 []
x = " "; foo(z[f,xyz)
#? 18 []
x = " "; foo(z[xyz)
#? 20 []
x = " "; foo(xyz[xyz)
#? 20 []
x = " "; foo(xyz[(xyz)

#? 8 ['xyz=']
@foo(xyz)
def x(): pass

@str
#? 8 ['xyz=']
@foo(xyz)
def x(): pass

# -----------------
# Only keyword arguments are valid
# -----------------

def x(bam, *, bar, baz):
    pass
def y(bam, *bal, bar, baz, **bag):
    pass
def z(bam, bar=2, *, bas=1):
    pass

#? 7 ['bar=', 'baz=']
x(1, ba)

#? 14 ['baz=']
x(1, bar=2, ba)
#? 7 ['bar=', 'baz=']
x(1, ba, baz=3)
#? 14 ['baz=']
x(1, bar=2, baz=3)
#? 7 ['BaseException']
x(basee)
#? 22 ['bar=', 'baz=']
x(1, 2, 3, 4, 5, 6, bar=2)

#? 14 ['baz=']
y(1, bar=2, ba)
#? 7 ['bar=', 'BaseException', 'baz=']
y(1, ba, baz=3)
#? 14 ['baz=']
y(1, bar=2, baz=3)
#? 7 ['BaseException']
y(basee)
#? 22 ['bar=', 'BaseException', 'baz=']
y(1, 2, 3, 4, 5, 6, bar=2)

#? 11 ['bar=', 'bas=']
z(bam=1, bar=2, bas=3)
#? 8 ['BaseException', 'bas=']
z(1, bas=2)
#? 12 ['BaseException']
z(1, bas=bas)

#? 19 ['dict']
z(1, bas=bas, **dic)
#? 18 ['dict']
z(1, bas=bas, *dic)
