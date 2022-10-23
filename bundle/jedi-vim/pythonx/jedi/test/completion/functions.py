def x():
    return

#? None
x()

def array(first_param):
    #? ['first_param']
    first_param
    return list()

#? []
array.first_param
#? []
array.first_param.
func = array
#? []
func.first_param

#? list()
array()

#? ['array']
arr


def inputs(param):
    return param

#? list
inputs(list)

def variable_middle():
    var = 3
    return var

#? int()
variable_middle()

def variable_rename(param):
    var = param
    return var

#? int()
variable_rename(1)

def multi_line_func(a, # comment blabla

                    b):
    return b

#? str()
multi_line_func(1,'')

def multi_line_call(b):
    return b


multi_line_call(
#? int()
  b=1)


# nothing after comma
def asdf(a):
    return a

x = asdf(a=1,
    )
#? int()
x

# -----------------
# double execution
# -----------------
def double_exe(param):
    return param

#? str()
variable_rename(double_exe)("")

# -> shouldn't work (and throw no error)
#? []
variable_rename(list())().
#? []
variable_rename(1)().

# -----------------
# recursions (should ignore)
# -----------------
def recursion(a, b):
    if a:
        return b
    else:
        return recursion(a+".", b+1)

# Does not also return int anymore, because we now support operators in simple cases.
#? float()
recursion("a", 1.0)

def other(a):
    return recursion2(a)

def recursion2(a):
    if random.choice([0, 1]):
        return other(a)
    else:
        if random.choice([0, 1]):
            return recursion2("")
        else:
            return a

#? int() str()
recursion2(1)

# -----------------
# ordering
# -----------------

def a():
    #? int()
    b()
    return b()

def b():
    return 1

#? int()
a()

# -----------------
# keyword arguments
# -----------------

def func(a=1, b=''):
    return a, b

exe = func(b=list, a=tuple)
#? tuple
exe[0]

#? list
exe[1]

# -----------------
# default arguments
# -----------------

#? int()
func()[0]
#? str()
func()[1]
#? float()
func(1.0)[0]
#? str()
func(1.0)[1]


#? float()
func(a=1.0)[0]
#? str()
func(a=1.0)[1]
#? int()
func(b=1.0)[0]
#? float()
func(b=1.0)[1]
#? list
func(a=list, b=set)[0]
#? set
func(a=list, b=set)[1]


def func_default(a, b=1):
    return a, b


def nested_default(**kwargs):
    return func_default(**kwargs)

#? float()
nested_default(a=1.0)[0]
#? int()
nested_default(a=1.0)[1]
#? str()
nested_default(a=1.0, b='')[1]

# Defaults should only work if they are defined before - not after.
def default_function(a=default):
    #?
    return a

#?
default_function()

default = int()

def default_function(a=default):
    #? int()
    return a

#? int()
default_function()

def default(a=default):
    #? int()
    a

# -----------------
# closures
# -----------------
def a():
    l = 3
    def func_b():
        l = ''
        #? str()
        l
    #? ['func_b']
    func_b
    #? int()
    l

# -----------------
# *args
# -----------------

def args_func(*args):
    #? tuple()
    return args

exe = args_func(1, "")
#? int()
exe[0]
#? str()
exe[1]

# illegal args (TypeError)
#?
args_func(*1)[0]
# iterator
#? int()
args_func(*iter([1]))[0]

# different types
e = args_func(*[1 if UNDEFINED else "", {}])
#? int() str()
e[0]
#? dict()
e[1]

_list = [1,""]
exe2 = args_func(_list)[0]

#? str()
exe2[1]

exe3 = args_func([1,""])[0]

#? str()
exe3[1]

def args_func(arg1, *args):
    return arg1, args

exe = args_func(1, "", list)
#? int()
exe[0]
#? tuple()
exe[1]
#? list
exe[1][1]


# In a dynamic search, both inputs should be given.
def simple(a):
    #? int() str()
    return a
def xargs(*args):
    return simple(*args)

xargs(1)
xargs('')


# *args without a self symbol
def memoize(func):
    def wrapper(*args, **kwargs):
        return func(*args, **kwargs)
    return wrapper


class Something():
    @memoize
    def x(self, a, b=1):
        return a

#? int()
Something().x(1)


# -----------------
# ** kwargs
# -----------------
def kwargs_func(**kwargs):
    #? ['keys']
    kwargs.keys
    #? dict()
    return kwargs

exe = kwargs_func(a=3,b=4.0)
#? dict()
exe
#? int()
exe['a']
#? float()
exe['b']
#? int() float()
exe['c']

a = 'a'
exe2 = kwargs_func(**{a:3,
                      'b':4.0})

#? int()
exe2['a']
#? float()
exe2['b']
#? int() float()
exe2['c']

exe3 = kwargs_func(**{k: v for k, v in [(a, 3), ('b', 4.0)]})

# Should resolve to the same as 2 but jedi is not smart enough yet
# Here to make sure it doesn't result in crash though
#? 
exe3['a']

#? 
exe3['b']

#? 
exe3['c']

# -----------------
# *args / ** kwargs
# -----------------

def func_without_call(*args, **kwargs):
    #? tuple()
    args
    #? dict()
    kwargs

def fu(a=1, b="", *args, **kwargs):
    return a, b, args, kwargs

exe = fu(list, 1, "", c=set, d="")

#? list
exe[0]
#? int()
exe[1]
#? tuple()
exe[2]
#? str()
exe[2][0]
#? dict()
exe[3]
#? set
exe[3]['c']


def kwargs_iteration(**kwargs):
    return kwargs

for x in kwargs_iteration(d=3):
    #? float()
    {'d': 1.0, 'c': '1'}[x]


# -----------------
# nested *args
# -----------------
def function_args(a, b, c):
    return b

def nested_args(*args):
    return function_args(*args)

def nested_args2(*args, **kwargs):
    return nested_args(*args)

#? int()
nested_args('', 1, 1.0, list)
#? []
nested_args('').

#? int()
nested_args2('', 1, 1.0)
#? []
nested_args2('').

# -----------------
# nested **kwargs
# -----------------
def nested_kw(**kwargs1):
    return function_args(**kwargs1)

def nested_kw2(**kwargs2):
    return nested_kw(**kwargs2)

# invalid command, doesn't need to return anything
#? 
nested_kw(b=1, c=1.0, list)
#? int()
nested_kw(b=1)
# invalid command, doesn't need to return anything
#?  
nested_kw(d=1.0, b=1, list)
#? int()
nested_kw(a=3.0, b=1)
#? int()
nested_kw(b=1, a=r"")
#? []
nested_kw(1, '').
#? []
nested_kw(a='').

#? int()
nested_kw2(b=1)
#? int()
nested_kw2(b=1, c=1.0)
#? int()
nested_kw2(c=1.0, b=1)
#? []
nested_kw2('').
#? []
nested_kw2(a='').
#? []
nested_kw2('', b=1).

# -----------------
# nested *args/**kwargs
# -----------------
def nested_both(*args, **kwargs):
    return function_args(*args, **kwargs)

def nested_both2(*args, **kwargs):
    return nested_both(*args, **kwargs)

# invalid commands, may return whatever.
#? list
nested_both('', b=1, c=1.0, list)
#? list
nested_both('', c=1.0, b=1, list)

#? []
nested_both('').

#? int()
nested_both2('', b=1, c=1.0)
#? int()
nested_both2('', c=1.0, b=1)
#? []
nested_both2('').

# -----------------
# nested *args/**kwargs with a default arg
# -----------------
def function_def(a, b, c):
    return a, b

def nested_def(a, *args, **kwargs):
    return function_def(a, *args, **kwargs)

def nested_def2(*args, **kwargs):
    return nested_def(*args, **kwargs)

#? str()
nested_def2('', 1, 1.0)[0]
#? str()
nested_def2('', b=1, c=1.0)[0]
#? str()
nested_def2('', c=1.0, b=1)[0]
#? int()
nested_def2('', 1, 1.0)[1]
#? int()
nested_def2('', b=1, c=1.0)[1]
#? int()
nested_def2('', c=1.0, b=1)[1]
#? []
nested_def2('')[1].

# -----------------
# magic methods
# -----------------
def a(): pass
#? ['__closure__']
a.__closure__
