if isinstance(i, str):
    #? str()
    i

if isinstance(j, (str, int)):
    #? str() int()
    j

while isinstance(k, (str, int)):
    #? str() int()
    k

if not isinstance(k, (str, int)):
    #? 
    k

while not isinstance(k, (str, int)):
    #? 
    k

assert isinstance(ass, int)
#? int()
ass

assert isinstance(ass, str)
assert not isinstance(ass, int)

if 2:
    #? str()
    ass

# -----------------
# invalid arguments
# -----------------

if isinstance(wrong, str()):
    #?
    wrong

# -----------------
# in functions
# -----------------

import datetime


def fooooo(obj):
    if isinstance(obj, datetime.datetime):
        #? datetime.datetime()
        obj


def fooooo2(obj):
    if isinstance(obj, datetime.date):
        return obj
    else:
        return 1

a
# In earlier versions of Jedi, this returned both datetime and int, but now
# Jedi does flow checks and realizes that the top return isn't executed.
#? int()
fooooo2('')


def isinstance_func(arr):
    for value in arr:
        if isinstance(value, dict):
            # Shouldn't fail, even with the dot.
            #? 17 dict()
            value.
        elif isinstance(value, int):
            x = value
            #? int()
            x

# -----------------
# Names with multiple indices.
# -----------------

class Test():
    def __init__(self, testing):
        if isinstance(testing, str):
            self.testing = testing
        else:
            self.testing = 10

    def boo(self):
        if isinstance(self.testing, str):
            # TODO this is wrong, it should only be str.
            #? str() int()
            self.testing
            #? Test()
            self

# -----------------
# Syntax
# -----------------

#?
isinstance(1, int())

# -----------------
# more complicated arguments
# -----------------

def ayyyyyye(obj):
    if isinstance(obj.obj, str):
        #?
        obj.obj
        #?
        obj
