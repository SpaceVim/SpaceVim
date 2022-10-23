# -----------------
# normal arguments (no keywords)
# -----------------


def simple(a):
    return a

simple(1)
#! 6 type-error-too-few-arguments
simple()
#! 10 type-error-too-many-arguments
simple(1, 2)


#! 10 type-error-too-many-arguments
simple(1, 2, 3)

# -----------------
# keyword arguments
# -----------------

simple(a=1)
#! 7 type-error-keyword-argument
simple(b=1)
#! 10 type-error-too-many-arguments
simple(1, a=1)


def two_params(x, y):
    return y


two_params(y=2, x=1)
two_params(1, y=2)

#! 11 type-error-multiple-values
two_params(1, x=2)
#! 17 type-error-too-many-arguments
two_params(1, 2, y=3)

# -----------------
# default arguments
# -----------------

def default(x, y=1, z=2):
    return x

#! 7 type-error-too-few-arguments
default()
default(1)
default(1, 2)
default(1, 2, 3)
#! 17 type-error-too-many-arguments
default(1, 2, 3, 4)

default(x=1)

# -----------------
# class arguments
# -----------------

class Instance():
    def __init__(self, foo):
        self.foo = foo

Instance(1).foo
Instance(foo=1).foo

#! 12 type-error-too-many-arguments
Instance(1, 2).foo
#! 8 type-error-too-few-arguments
Instance().foo
