# -----------------
# normal
# -----------------
a = ""
a = 1

#? int()
a
#? []
a.append

a = list

b = 1; b = ""
#? str()
b

# temp should not be accessible before definition
#? []
temp

a = 1
temp = b;
b = a
a = temp
#? int()
b
#? int()
b
#? str()
a

a = tuple
if 1:
    a = list

#? ['append']
a.append
#? ['index']
a.index

# -----------------
# tuples exchanges
# -----------------
a, b = 1, ""
#? int()
a
#? str()
b

b, a = a, b
#? int()
b
#? str()
a

b, a = a, b
#? int()
a
#? str()
b

# -----------------
# function
# -----------------
def a(a=3):
    #? int()
    a
    #? []
    a.func
    return a

#? int()
a(2)
#? []
a(2).func

a_param = 3
def func(a_param):
    # should not be int
    #? []
    a_param.

from os import path


# should not return a function, because `a` is a function above
def f(b, a): return a
#? []
f(b=3).

# -----------------
# closure
# -----------------

def x():
    a = 0

    def x():
        return a

    a = 3.0
    return x()

#? float()
x()

# -----------------
# class
# -----------------
class A(object):
    a = ""
    a = 3
    #? int()
    a
    a = list()
    def __init__(self):
        self.b = ""

    def before(self):
        self.b = 3
        # TODO should this be so? include entries after cursor?
        #? int() str() list
        self.b
        self.b = list

        self.a = 1
        #? str() int()
        self.a

        #? ['after']
        self.after

        self.c = 3
        #? int()
        self.c

    def after(self):
        self.a = ''

    c = set()

#? list()
A.a

a = A()
#? ['after']
a.after
#? []
a.upper
#? []
a.append
#? []
a.real

#? str() int()
a.a

a = 3
class a():
    def __init__(self, a):
        self.a = a

#? float()
a(1.0).a
#? 
a().a

# -----------------
# imports
# -----------------

math = 3
import math
#? ['cosh']
math.cosh
#? []
math.real

math = 3
#? int()
math
#? []
math.cos

# do the same for star imports
cosh = 3
from math import *
# cosh doesn't work, but that's not a problem, star imports should be at the
# start of EVERY script!
cosh.real

cosh = 3
#? int()
cosh
