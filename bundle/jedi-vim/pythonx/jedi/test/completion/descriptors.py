class RevealAccess(object):
    """
    A data descriptor that sets and returns values
    normally and prints a message logging their access.
    """
    def __init__(self, initval=None, name='var'):
        self.val = initval
        self.name = name

    def __get__(self, obj, objtype):
        print('Retrieving', self.name)
        return self.val

    def __set__(self, obj, val):
        print('Updating', self.name)
        self.val = val

    def just_a_method(self):
        pass

class C(object):
    x = RevealAccess(10, 'var "x"')
    #? RevealAccess()
    x
    #? ['just_a_method']
    x.just_a_method
    y = 5.0
    def __init__(self):
        #? int()
        self.x

        #? []
        self.just_a_method
        #? []
        C.just_a_method

m = C()
#? int()
m.x
#? float()
m.y
#? int()
C.x

#? []
m.just_a_method
#? []
C.just_a_method

# -----------------
# properties
# -----------------
class B():
    @property
    def r(self):
        return 1
    @r.setter
    def r(self, value):
        return ''
    def t(self):
        return ''
    p = property(t)

#? []
B().r().
#? int()
B().r

#? str()
B().p
#? []
B().p().

class PropClass():
    def __init__(self, a):
        self.a = a
    @property
    def ret(self):
        return self.a

    @ret.setter
    def ret(self, value):
        return 1.0

    def ret2(self):
        return self.a
    ret2 = property(ret2)

    @property
    def nested(self):
        """ causes recusions in properties, should work """
        return self.ret

    @property
    def nested2(self):
        """ causes recusions in properties, should not work """
        return self.nested2

    @property
    def join1(self):
        """ mutual recusion """
        return self.join2

    @property
    def join2(self):
        """ mutual recusion """
        return self.join1

#? str()
PropClass("").ret
#? []
PropClass().ret.

#? str()
PropClass("").ret2
#? 
PropClass().ret2

#? int()
PropClass(1).nested
#? []
PropClass().nested.

#? 
PropClass(1).nested2
#? []
PropClass().nested2.

#? 
PropClass(1).join1
# -----------------
# staticmethod/classmethod
# -----------------

class E(object):
    a = ''
    def __init__(self, a):
        self.a = a

    def f(x):
        return x
    f = staticmethod(f)
    #?
    f.__func

    @staticmethod
    def g(x):
        return x

    def s(cls, x):
        return x
    s = classmethod(s)

    @classmethod
    def t(cls, x):
        return x

    @classmethod
    def u(cls, x):
        return cls.a

e = E(1)
#? int()
e.f(1)
#? int()
E.f(1)
#? int()
e.g(1)
#? int()
E.g(1)

#? int()
e.s(1)
#? int()
E.s(1)
#? int()
e.t(1)
#? int()
E.t(1)

#? str()
e.u(1)
#? str()
E.u(1)

# -----------------
# Conditions
# -----------------

from functools import partial


class Memoize():
    def __init__(self, func):
        self.func = func

    def __get__(self, obj, objtype):
        if obj is None:
            return self.func

        return partial(self, obj)

    def __call__(self, *args, **kwargs):
        # We don't do caching here, but that's what would normally happen.
        return self.func(*args, **kwargs)


class MemoizeTest():
    def __init__(self, x):
        self.x = x

    @Memoize
    def some_func(self):
        return self.x


#? int()
MemoizeTest(10).some_func()
# Now also call the same function over the class (see if clause above).
#? float()
MemoizeTest.some_func(MemoizeTest(10.0))
