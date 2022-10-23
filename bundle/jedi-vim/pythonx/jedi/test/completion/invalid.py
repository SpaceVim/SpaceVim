"""
This file is less about the results and much more about the fact, that no
exception should be thrown.

Basically this file could change depending on the current implementation. But
there should never be any errors.
"""

# wait until keywords are out of definitions (pydoc function).
#? 5 
's'()

#? []
str()).upper

# -----------------
# funcs
# -----------------
def asdf(a or b): # multiple param names
    return a

#? 
asdf(2)

asdf = ''

from a import (b
def blub():
    return 0
def wrong_indents():
    asdf = 3
     asdf
    asdf(
    # TODO this seems to be wrong now?
    #? int()
    asdf
def openbrace():
    asdf = 3
    asdf(
    #? int()
    asdf
    return 1

#? int()
openbrace()

blub([
#? int()
openbrace()

def indentfault():
    asd(
 indentback

#? []
indentfault().

def openbrace2():
    asd(
def normalfunc():
    return 1

#? int()
normalfunc()

# dots in param
def f(seq1...=None):
    return seq1
#?
f(1)

@
def test_empty_decorator():
    return 1

#? int()
test_empty_decorator()

def invalid_param(param=):
    #? 
    param
# -----------------
# flows
# -----------------

# first part not complete (raised errors)
if a
    a
else:
    #? ['AttributeError']
    AttributeError

try
#? ['AttributeError']
except AttributeError
    pass
finally:
    pass

#? ['isinstance']
if isi
try:
    except TypeError:
        #? str()
        str()

def break(): pass
# wrong ternary expression
a = ''
a = 1 if
#? str()
a

# No completions for for loops without the right syntax
for for_local in :
    for_local
#? []
for_local
#? 
for_local


# -----------------
# list comprehensions
# -----------------

a2 = [for a2 in [0]]
#? 
a2[0]

a3 = [for xyz in]
#? 
a3[0]

a3 = [a4 for in 'b']
#? 
a3[0]

a3 = [a4 for a in for x in y]
#? 
a3[0]

a = [for a in
def break(): pass

#? str()
a[0]

a = [a for a in [1,2]
def break(): pass
#? str()
a[0]

#? []
int()).real

# -----------------
# keywords
# -----------------

#! []
as

def empty_assert():
    x = 3
    assert
    #? int()
    x

import datetime as 


# -----------------
# statements
# -----------------

call = ''
invalid = .call
#? 
invalid

invalid = call?.call
#? str()
invalid

# comma
invalid = ,call
#? str()
invalid


# -----------------
# classes
# -----------------

class BrokenPartsOfClass():
    def foo(self):
        # This construct contains two places where Jedi with Python 3 can fail.
        # It should just ignore those constructs and still execute `bar`.
        pass
        if 2:
            try:
                pass
            except ValueError, e:
                raise TypeError, e
        else:
            pass

    def bar(self):
        self.x = 3
        return ''

#? str()
BrokenPartsOfClass().bar()
