# -----------------
# normal decorators
# -----------------

def decorator(func):
    def wrapper(*args):
        return func(1, *args)
    return wrapper

@decorator
def decorated(a,b):
    return a,b

exe = decorated(set, '')

#? set
exe[1]

#? int()
exe[0]

# more complicated with args/kwargs
def dec(func):
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper

@dec
def fu(a, b, c, *args, **kwargs):
    return a, b, c, args, kwargs

exe = fu(list, c=set, b=3, d='')

#? list
exe[0]
#? int()
exe[1]
#? set
exe[2]
#? []
exe[3][0].
#? str()
exe[4]['d']


exe = fu(list, set, 3, '', d='')

#? str()
exe[3][0]

# -----------------
# multiple decorators
# -----------------
def dec2(func2):
    def wrapper2(first_arg, *args2, **kwargs2):
        return func2(first_arg, *args2, **kwargs2)
    return wrapper2

@dec2
@dec
def fu2(a, b, c, *args, **kwargs):
    return a, b, c, args, kwargs

exe = fu2(list, c=set, b=3, d='str')

#? list
exe[0]
#? int()
exe[1]
#? set
exe[2]
#? []
exe[3][0].
#? str()
exe[4]['d']


# -----------------
# Decorator is a class
# -----------------
def same_func(func):
    return func

class Decorator(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, *args, **kwargs):
        return self.func(1, *args, **kwargs)

@Decorator
def nothing(a,b,c):
    return a,b,c

#? int()
nothing("")[0]
#? str()
nothing("")[1]


@same_func
@Decorator
def nothing(a,b,c):
    return a,b,c

#? int()
nothing("")[0]

class MethodDecoratorAsClass():
    class_var = 3
    @Decorator
    def func_without_self(arg, arg2):
        return arg, arg2

    @Decorator
    def func_with_self(self, arg):
        return self.class_var

#? int()
MethodDecoratorAsClass().func_without_self('')[0]
#? str()
MethodDecoratorAsClass().func_without_self('')[1]
#? 
MethodDecoratorAsClass().func_with_self(1)


class SelfVars():
    """Init decorator problem as an instance, #247"""
    @Decorator
    def __init__(self):
        """
        __init__ decorators should be ignored when looking up variables in the
        class.
        """
        self.c = list

    @Decorator
    def shouldnt_expose_var(not_self):
        """
        Even though in real Python this shouldn't expose the variable, in this
        case Jedi exposes the variable, because these kind of decorators are
        normally descriptors, which SHOULD be exposed (at least 90%).
        """
        not_self.b = 1.0

    def other_method(self):
        #? float()
        self.b
        #? list
        self.c

# -----------------
# not found decorators (are just ignored)
# -----------------
@not_found_decorator
def just_a_func():
    return 1

#? int()
just_a_func()

#? ['__closure__']
just_a_func.__closure__


class JustAClass:
    @not_found_decorator2
    def a(self):
        return 1

#? ['__call__']
JustAClass().a.__call__
#? int()
JustAClass().a()
#? ['__call__']
JustAClass.a.__call__
#? int()
JustAClass.a()

# -----------------
# illegal decorators
# -----------------

class DecoratorWithoutCall():
    def __init__(self, func):
        self.func = func

@DecoratorWithoutCall
def f():
    return 1

# cannot be resolved - should be ignored
@DecoratorWithoutCall(None)
def g():
    return 1

#? 
f()
#? int()
g()


class X():
    @str
    def x(self):
        pass

    def y(self):
        #? str()
        self.x
        #?
        self.x()


def decorator_var_args(function, *args):
    return function(*args)

@decorator_var_args
def function_var_args(param):
    return param

#? int()
function_var_args(1)

# -----------------
# method decorators
# -----------------

def dec(f):
    def wrapper(s):
        return f(s)
    return wrapper

class MethodDecorators():
    _class_var = 1
    def __init__(self):
        self._method_var = ''

    @dec
    def constant(self):
        return 1.0

    @dec
    def class_var(self):
        return self._class_var

    @dec
    def method_var(self):
        return self._method_var

#? float()
MethodDecorators().constant()
#? int()
MethodDecorators().class_var()
#? str()
MethodDecorators().method_var()


class Base():
    @not_existing
    def __init__(self):
        pass
    @not_existing
    def b(self):
        return ''
    @dec
    def c(self):
        return 1

class MethodDecoratorDoesntExist(Base):
    """#272 github: combination of method decorators and super()"""
    def a(self):
        #? 
        super().__init__()
        #? str()
        super().b()
        #? int()
        super().c()
        #? float()
        self.d()

    @doesnt_exist
    def d(self):
        return 1.0

# -----------------
# others
# -----------------
def memoize(function):
        def wrapper(*args):
            if random.choice([0, 1]):
                pass
            else:
                rv = function(*args)
                return rv
        return wrapper

@memoize
def follow_statement(stmt):
    return stmt

# here we had problems with the else clause, because the parent was not right.
#? int()
follow_statement(1)

# -----------------
# class decorators
# -----------------

# class decorators should just be ignored
@should_ignore
class A():
    x = 3
    def ret(self):
        return 1

#? int()
A().ret()
#? int()
A().x


# -----------------
# On decorator completions
# -----------------

import abc
#? ['abc']
@abc

#? ['abstractmethod']
@abc.abstractmethod

# -----------------
# Goto
# -----------------
x = 1

#! 5 []
@x.foo()
def f(): pass

#! 1 ['x = 1']
@x.foo()
def f(): pass
