"""
This is used for dynamic object completion.
Jedi tries to guess param types with a backtracking approach.
"""
def func(a, default_arg=2):
    #? int()
    default_arg
    #? int() str()
    return a

#? int()
func(1)

func

int(1) + (int(2))+ func('')

# Again the same function, but with another call.
def func(a):
    #? float()
    return a

func(1.0)

# Again the same function, but with no call.
def func(a):
    #? 
    return a

def func(a):
    #? float()
    return a
str(func(1.0))

# -----------------
# *args, **args
# -----------------
def arg(*args):
    #? tuple()
    args
    #? int()
    args[0]

arg(1,"")
# -----------------
# decorators
# -----------------
def def_func(f):
    def wrapper(*args, **kwargs):
        return f(*args, **kwargs)
    return wrapper

@def_func
def func(c):
    #? str()
    return c

#? str()
func("something")

@def_func
def func(c=1):
    #? float()
    return c

func(1.0)

def tricky_decorator(func):
    def wrapper(*args):
        return func(1, *args)

    return wrapper


@tricky_decorator
def func(a, b):
    #? int()
    a
    #? float()
    b

func(1.0)

# Needs to be here, because in this case func is an import -> shouldn't lead to
# exceptions.
import sys as func
func.sys

# -----------------
# classes
# -----------------

class A():
    def __init__(self, a):
        #? str()
        a

A("s")

class A():
    def __init__(self, a):
        #? int()
        a
        self.a = a

    def test(self, a):
        #? float()
        a
        self.c = self.test2()

    def test2(self):
        #? int()
        return self.a

    def test3(self):
        #? int()
        self.test2()
        #? int()
        self.c

A(3).test(2.0)
A(3).test2()


def from_class(x):
    #?
    x

from UNDEFINED import from_class

class Foo(from_class(1),):
    pass

# -----------------
# comprehensions
# -----------------

def from_comprehension(foo):
    #? int() float()
    return foo

[from_comprehension(1.0) for n in (1,)]
[from_comprehension(n) for n in (1,)]

# -----------------
# lambdas
# -----------------

#? int()
x_lambda = lambda x: x

x_lambda(1)

class X():
    #? str()
    x_method = lambda self, a: a


X().x_method('')
