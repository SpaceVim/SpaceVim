# goto command tests are different in syntax

definition = 3
#! 0 ['a = definition']
a = definition

#! []
b
#! ['a = definition']
a

b = a
c = b
#! ['c = b']
c

cd = 1
#! 1 ['cd = c']
cd = c
#! 0 ['cd = e']
cd = e

#! ['module math']
import math
#! ['module math']
math

#! ['module math']
b = math
#! ['b = math']
b

#! 18 ['foo = 10']
foo = 10;print(foo)

# -----------------
# classes
# -----------------
class C(object):
    x = 3
    def b(self):
        #! ['b = math']
        b
        #! ['def b']
        self.b
        #! 14 ['def b']
        self.b()
        #! 14 ['def b']
        self.b.
        #! 11 ['param self']
        self.b
        #! ['x = 3']
        self.x
        #! 14 ['x = 3']
        self.x.
        return 1

    #! ['def b']
    b

#! ['b = math']
b

#! ['def b']
C.b
#! ['def b']
C().b
#! 0 ['class C']
C().b
#! 0 ['class C']
C().b

D = C
#! ['def b']
D.b
#! ['def b']
D().b

#! 0 ['D = C']
D().b
#! 0 ['D = C']
D().b

def c():
    return ''

#! ['def c']
c
#! 0 ['def c']
c()


class ClassVar():
    x = 3

#! ['x = 3']
ClassVar.x
#! ['x = 3']
ClassVar().x

# before assignments
#! 10 ['x = 3']
ClassVar.x = ''
#! 12 ['x = 3']
ClassVar().x = ''

# Recurring use of the same var name, github #315
def f(t=None):
    #! 9 ['param t=None']
    t = t or 1


class X():
    pass

#! 3 []
X(foo=x)


# Multiple inheritance
class Foo:
    def foo(self):
        print("foo")
class Bar:
    def bar(self):
        print("bar")
class Baz(Foo, Bar):
    def baz(self):
        #! ['def foo']
        super().foo
        #! ['def bar']
        super().bar
        #! ['instance Foo']
        super()

# -----------------
# imports
# -----------------

#! ['module import_tree']
import import_tree
#! ["a = ''"]
import_tree.a

#! ['module mod1']
import import_tree.mod1
#! ['module mod1']
from import_tree.mod1
#! ['a = 1']
import_tree.mod1.a

#! ['module pkg']
import import_tree.pkg
#! ['a = list']
import_tree.pkg.a

#! ['module mod1']
import import_tree.pkg.mod1
#! ['a = 1.0']
import_tree.pkg.mod1.a
#! ["a = ''"]
import_tree.a

#! ['module mod1']
from import_tree.pkg import mod1
#! ['a = 1.0']
mod1.a

#! ['module mod1']
from import_tree import mod1
#! ['a = 1']
mod1.a

#! ['a = 1.0']
from import_tree.pkg.mod1 import a

#! ['module os']
from .imports import os

#! ['some_variable = 1']
from . import some_variable

# -----------------
# anonymous classes
# -----------------
def func():
    class A():
        def b(self):
            return 1
    return A()

#! 8 ['def b']
func().b()

# -----------------
# on itself
# -----------------

#! 7 ['class ClassDef']
class ClassDef():
    """ abc """
    pass

# -----------------
# params
# -----------------

param = ClassDef
#! 8 ['param param']
def ab1(param): pass
#! 9 ['param param']
def ab2(param): pass
#! 11 ['param = ClassDef']
def ab3(a=param): pass

ab1(ClassDef);ab2(ClassDef);ab3(ClassDef)

# -----------------
# for loops
# -----------------

for i in range(1):
    #! ['for i in range(1): i']
    i

for key, value in [(1,2)]:
    #! ['for key, value in [(1,2)]: key']
    key

#! 4 ['for y in [1]: y']
for y in [1]:
    #! ['for y in [1]: y']
    y

# -----------------
# decorator
# -----------------
def dec(dec_param=3):
    pass

#! 8 ['param dec_param=3']
@dec(dec_param=5)
def y():
    pass

class ClassDec():
    def class_func(func):
        return func

#! 14 ['def class_func']
@ClassDec.class_func
def x():
    pass

#! 2 ['class ClassDec']
@ClassDec.class_func
def z():
    pass
