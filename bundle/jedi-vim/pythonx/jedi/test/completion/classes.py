def find_class():
    """ This scope is special, because its in front of TestClass """
    #? ['ret']
    TestClass.ret
    if 1:
        #? ['ret']
        TestClass.ret

class FindClass():
    #? []
    TestClass.ret
    if a:
        #? []
        TestClass.ret

    def find_class(self):
        #? ['ret']
        TestClass.ret
        if 1:
            #? ['ret']
            TestClass.ret

#? []
FindClass().find_class.self
#? []
FindClass().find_class.self.find_class

# set variables, which should not be included, because they don't belong to the
# class
second = 1
second = ""
class TestClass(object):
    var_class = TestClass(1)
    self.pseudo_var = 3

    def __init__(self2, first_param, second_param, third=1.0):
        self2.var_inst = first_param
        self2.second = second_param
        self2.first = first_param
        self2.first.var_on_argument = 5
        a = 3

    def var_func(self):
        return 1

    def get_first(self):
        # traversal
        self.second_new = self.second
        return self.var_inst

    def values(self):
        self.var_local = 3
        #? ['var_class', 'var_func', 'var_inst', 'var_local']
        self.var_
        #?
        var_local

    def ret(self, a1):
        # should not know any class functions!
        #? []
        values
        #?
        values
        #? ['return']
        ret
        return a1

# should not work
#? []
var_local
#? []
var_inst
#? []
var_func

# instance
inst = TestClass(1)

#? ['var_class', 'var_func', 'var_inst', 'var_local']
inst.var

#? ['var_class', 'var_func']
TestClass.var

#? int()
inst.var_local
#? []
TestClass.var_local.
#?
TestClass.pseudo_var
#?
TestClass().pseudo_var

#? int()
TestClass().ret(1)
# Should not return int(), because we want the type before `.ret(1)`.
#? 11 TestClass()
TestClass().ret(1)
#? int()
inst.ret(1)

myclass = TestClass(1, '', 3.0)
#? int()
myclass.get_first()
#? []
myclass.get_first.real

# too many params
#? int()
TestClass(1,1,1).var_inst

# too few params
#? int()
TestClass(1).first
#? []
TestClass(1).second.

# complicated variable settings in class
#? str()
myclass.second
#? str()
myclass.second_new

# multiple classes / ordering
ints = TestClass(1, 1.0)
strs = TestClass("", '')
#? float()
ints.second
#? str()
strs.second

#? ['var_class']
TestClass.var_class.var_class.var_class.var_class

# operations (+, *, etc) shouldn't be InstanceElements - #246
class A():
    def __init__(self):
        self.addition = 1 + 2
#? int()
A().addition

# should also work before `=`
#? 8 int()
A().addition = None
#? 8 int()
A(1).addition = None
#? 1 A
A(1).addition = None
a = A()
#? 8 int()
a.addition = None


# -----------------
# inheritance
# -----------------

class Base(object):
    def method_base(self):
        return 1

class SuperClass(Base):
    class_super = 3
    def __init__(self):
        self.var_super = ''
    def method_super(self):
        self.var2_super = list

class Mixin(SuperClass):
    def method_mixin(self):
        return int

#? 20 SuperClass
class SubClass(SuperClass):
    class_sub = 3
    def __init__(self):
        self.var_sub = ''
    def method_sub(self):
        self.var_sub = list
        return tuple

instance = SubClass()

#? ['method_base', 'method_sub', 'method_super']
instance.method_
#? ['var2_super', 'var_sub', 'var_super']
instance.var
#? ['class_sub', 'class_super']
instance.class_

#? ['method_base', 'method_sub', 'method_super']
SubClass.method_
#? []
SubClass.var
#? ['class_sub', 'class_super']
SubClass.class_

# -----------------
# inheritance of builtins
# -----------------

class Base(str):
    pass

#? ['upper']
Base.upper
#? ['upper']
Base().upper

# -----------------
# dynamic inheritance
# -----------------

class Angry(object):
    def shout(self):
        return 'THIS IS MALARKEY!'

def classgetter():
    return Angry

class Dude(classgetter()):
    def react(self):
        #? ['shout']
        self.s

# -----------------
# multiple inheritance # 1071
# -----------------

class FactorMixin(object):
    FACTOR_1 = 0.1

class Calc(object):
    def sum(self, a, b):
        self.xxx = 3
        return a + b

class BetterCalc(Calc, FactorMixin):
    def multiply_factor(self, a):
        return a * self.FACTOR_1

calc = BetterCalc()
#? ['sum']
calc.sum
#? ['multiply_factor']
calc.multip
#? ['FACTOR_1']
calc.FACTOR_1
#? ['xxx']
calc.xxx

# -----------------
# __call__
# -----------------

class CallClass():
    def __call__(self):
        return 1

#? int()
CallClass()()

# -----------------
# variable assignments
# -----------------

class V:
    def __init__(self, a):
        self.a = a

    def ret(self):
        return self.a

    d = b
    b = ret
    if 1:
        c = b

#? int()
V(1).b()
#? int()
V(1).c()
#?
V(1).d()
# Only keywords should be possible to complete.
#? ['is', 'in', 'not', 'and', 'or', 'if']
V(1).d() 


# -----------------
# ordering
# -----------------
class A():
    def b(self):
        #? int()
        a_func()
        #? str()
        self.a_func()
        return a_func()

    def a_func(self):
        return ""

def a_func():
    return 1

#? int()
A().b()
#? str()
A().a_func()

# -----------------
# nested classes
# -----------------
class A():
    class B():
        pass
    def b(self):
        return 1.0

#? float()
A().b()

class A():
    def b(self):
        class B():
            def b(self):
                return []
        return B().b()

#? list()
A().b()

# -----------------
# ducktyping
# -----------------

def meth(self):
    return self.a, self.b

class WithoutMethod():
    a = 1
    def __init__(self):
        self.b = 1.0
    def blub(self):
        return self.b
    m = meth

class B():
    b = ''

a = WithoutMethod().m()
#? int()
a[0]
#? float()
a[1]

#? float()
WithoutMethod.blub(WithoutMethod())
#? str()
WithoutMethod.blub(B())

# -----------------
# __getattr__ / getattr() / __getattribute__
# -----------------

#? str().upper
getattr(str(), 'upper')
#? str.upper
getattr(str, 'upper')

# some strange getattr calls
#?
getattr(str, 1)
#?
getattr()
#?
getattr(str)
#?
getattr(getattr, 1)
#?
getattr(str, [])


class Base():
    def ret(self, b):
        return b

class Wrapper():
    def __init__(self, obj):
        self.obj = obj

    def __getattr__(self, name):
        return getattr(self.obj, name)

class Wrapper2():
    def __getattribute__(self, name):
        return getattr(Base(), name)

#? int()
Wrapper(Base()).ret(3)
#? ['ret']
Wrapper(Base()).ret
#? int()
Wrapper(Wrapper(Base())).ret(3)
#? ['ret']
Wrapper(Wrapper(Base())).ret

#? int()
Wrapper2(Base()).ret(3)

class GetattrArray():
    def __getattr__(self, name):
        return [1]

#? int()
GetattrArray().something[0]
#? []
GetattrArray().something

class WeirdGetattr:
    class __getattr__():
        pass

#? []
WeirdGetattr().something


# -----------------
# private vars
# -----------------
class PrivateVar():
    def __init__(self):
        self.__var = 1
        #? int()
        self.__var
        #? ['__var']
        self.__var

    def __private_func(self):
        return 1

    #? int()
    __private_func()

    def wrap_private(self):
        return self.__private_func()
#? []
PrivateVar().__var
#?
PrivateVar().__var
#? []
PrivateVar().__private_func
#? []
PrivateVar.__private_func
#? int()
PrivateVar().wrap_private()


class PrivateSub(PrivateVar):
    def test(self):
        #? []
        self.__var

    def wrap_private(self):
        #? []
        self.__var

#? []
PrivateSub().__var

# -----------------
# super
# -----------------
class Super(object):
    a = 3
    def return_sup(self):
        return 1
SuperCopy = Super

class TestSuper(Super):
    #?
    super()
    def test(self):
        #? SuperCopy()
        super()
        #? ['a']
        super().a
        if 1:
            #? SuperCopy()
            super()
        def a():
            #?
            super()

    def return_sup(self):
        #? int()
        return super().return_sup()

#? int()
TestSuper().return_sup()


Super = 3

class Foo():
    def foo(self):
        return 1
# Somehow overwriting the same name caused problems (#1044)
class Foo(Foo):
    def foo(self):
        #? int()
        super().foo()

# -----------------
# if flow at class level
# -----------------
class TestX(object):
    def normal_method(self):
        return 1

    if True:
        def conditional_method(self):
            var = self.normal_method()
            #? int()
            var
            return 2

    def other_method(self):
        var = self.conditional_method()
        #? int()
        var

# -----------------
# mro method
# -----------------

class A(object):
    a = 3

#? ['mro']
A.mro
#? []
A().mro


# -----------------
# mro resolution
# -----------------

class B(A()):
    b = 3

#?
B.a
#?
B().a
#? int()
B.b
#? int()
B().b


# -----------------
# With import
# -----------------

from import_tree.classes import Config2, BaseClass

class Config(BaseClass):
    """#884"""

#? Config2()
Config.mode

#? int()
Config.mode2


# -----------------
# Nested class/def/class
# -----------------
class Foo(object):
    a = 3
    def create_class(self):
        class X():
            a = self.a
            self.b = 3.0
        return X

#? int()
Foo().create_class().a
#? float()
Foo().b

class Foo(object):
    def comprehension_definition(self):
        return [1 for self.b in [1]]

#? int()
Foo().b

# -----------------
# default arguments
# -----------------

default = ''
class DefaultArg():
    default = 3
    def x(self, arg=default):
        #? str()
        default
        return arg
    def y(self):
        return default

#? int()
DefaultArg().x()
#? str()
DefaultArg().y()
#? int()
DefaultArg.x()
#? str()
DefaultArg.y()


# -----------------
# Error Recovery
# -----------------

from import_tree.pkg.base import MyBase

class C1(MyBase):
    def f3(self):
        #! 13 ['def f1']
        self.f1() . # hey'''
        #? 13 MyBase.f1
        self.f1() . # hey'''

# -----------------
# With a very weird __init__
# -----------------

class WithWeirdInit:
    class __init__:
        def __init__(self, a):
            self.a = a

    def y(self):
        return self.a


#?
WithWeirdInit(1).y()
