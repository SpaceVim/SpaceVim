# -----------------
# cursor position
# -----------------
#? 0 int
int()
#? 3 int
int()
#? 4 str
int(str)


# -----------------
# should not complete
# -----------------
#? []
.
#? []
str..
#? []
a(0):.
#? 2 []
0x0
#? []
1j
#? ['and', 'or', 'if', 'is', 'in', 'not']
1j 
x = None()
#?
x

# -----------------
# if/else/elif
# -----------------

if (random.choice([0, 1])):
    1
elif(random.choice([0, 1])):
    a = 3
else:
    a = ''
#? int() str()
a
def func():
    if random.choice([0, 1]):
        1
    elif(random.choice([0, 1])):
        a = 3
    else:
        a = ''
    #? int() str()
    return a
#? int() str()
func()

# -----------------
# keywords
# -----------------

#? list()
assert []

def focus_return():
    #? list()
    return []


# -----------------
# for loops
# -----------------

for a in [1,2]:
    #? int()
    a

for a1 in 1,"":
    #? int() str()
    a1

for a3, b3 in (1,""), (1,""), (1,""):
    #? int()
    a3
    #? str()
    b3
for (a3, b3) in (1,""), (1,""), (1,""):
    #? int()
    a3
    #? str()
    b3

for a4, (b4, c4) in (1,("", list)), (1,("", list)):
    #? int()
    a4
    #? str()
    b4
    #? list
    c4

a = []
for i in [1,'']:
    #? int() str()
    i
    a += [i]

#? int() str()
a[0]

for i in list([1,'']):
    #? int() str()
    i

#? int() str()
for x in [1,'']: x

a = []
b = [1.0,'']
for i in b:
    a += [i]

#? float() str()
a[0]

for i in [1,2,3]:
    #? int()
    i
else:
    i


# -----------------
# range()
# -----------------
for i in range(10):
    #? int()
    i

# -----------------
# ternary operator
# -----------------

a = 3
b = '' if a else set()
#? str() set()
b

def ret(a):
    return ['' if a else set()]

#? str() set()
ret(1)[0]
#? str() set()
ret()[0]

# -----------------
# global vars
# -----------------

def global_define():
    #? int()
    global global_var_in_func
    global_var_in_func = 3

#? int()
global_var_in_func

#? ['global_var_in_func']
global_var_in_f


def funct1():
    # From issue #610
    global global_dict_var
    global_dict_var = dict()
def funct2():
    #! ['global_dict_var', 'global_dict_var']
    global global_dict_var
    #? dict()
    global_dict_var


global_var_predefined = None

def init_global_var_predefined():
    global global_var_predefined
    if global_var_predefined is None:
        global_var_predefined = 3

#? int() None
global_var_predefined


def global_as_import():
    from import_tree import globals
    #? ['foo']
    globals.foo
    #? int()
    globals.foo


global r
r = r[r]
if r:
    r += r + 2
    #? int()
    r

# -----------------
# del
# -----------------

deleted_var = 3
del deleted_var
#?
deleted_var
#? []
deleted_var
#! []
deleted_var

# -----------------
# within docstrs
# -----------------

def a():
    """
    #? []
    global_define
    #?
    str
    """
    pass

#?
# str literals in comment """ upper

def completion_in_comment():
    #? ['Exception']
    # might fail because the comment is not a leaf: Exception
    pass

some_word
#? ['Exception']
# Very simple comment completion: Exception
# Commment after it

# -----------------
# magic methods
# -----------------

class A(object): pass
class B(): pass

#? ['__init__']
A.__init__
#? ['__init__']
B.__init__

#? ['__init__']
int().__init__

# -----------------
# comments
# -----------------

class A():
    def __init__(self):
        self.hello = {}  # comment shouldn't be a string
#? dict()
A().hello

# -----------------
# unicode
# -----------------
a = 'smörbröd'
#? str()
a
xyz = 'smörbröd.py'
if 1:
    #? str()
    xyz

#?
¹.

# -----------------
# exceptions
# -----------------
try:
    import math
except ImportError as i_a:
    #? ['i_a']
    i_a
    #? ImportError()
    i_a


class MyException(Exception):
    def __init__(self, my_attr):
        self.my_attr = my_attr

try:
    raise MyException(1)
except MyException as e:
    #? ['my_attr']
    e.my_attr
    #? 22 ['my_attr']
    for x in e.my_attr:
        pass

# -----------------
# params
# -----------------

my_param = 1
#? 9 str()
def foo1(my_param):
    my_param = 3.0
foo1("")

my_type = float()
#? 20 float()
def foo2(my_param: my_type):
    pass
foo2("")
#? 20 int()
def foo3(my_param=my_param):
    pass
foo3("")

some_default = ''
#? []
def foo(my_t
#? []
def foo(my_t, my_ty
#? ['some_default']
def foo(my_t=some_defa
#? ['some_default']
def foo(my_t=some_defa, my_t2=some_defa

#? ['my_type']
def foo(my_t: lala=some_defa, my_t2: my_typ
#? ['my_type']
def foo(my_t: lala=some_defa, my_t2: my_typ
#? []
def foo(my_t: lala=some_defa, my_t

#? []
lambda my_t
#? []
lambda my_, my_t
#? ['some_default']
lambda x=some_defa
#? ['some_default']
lambda y, x=some_defa

# Just make sure we're not in some weird parsing recovery after opening brackets
def  

# -----------------
# continuations
# -----------------

foo = \
1
#? int()
foo

# -----------------
# module attributes
# -----------------

# Don't move this to imports.py, because there's a star import.
#? str()
__file__
#? ['__file__']
__file__

#? str()
math.__file__
# Should not lead to errors
#?
math()

# -----------------
# with statements
# -----------------

with open('') as f:
    #? ['closed']
    f.closed
    for line in f:
        #? str() bytes()
        line

with open('') as f1, open('') as f2:
    #? ['closed']
    f1.closed
    #? ['closed']
    f2.closed


class Foo():
    def __enter__(self):
        return ''

#? 14 str()
with Foo() as f3:
    #? str()
    f3
#! 14 ['with Foo() as f3: f3']
with Foo() as f3:
    f3
#? 6 Foo
with Foo() as f3:
    f3

# -----------------
# Avoiding multiple definitions
# -----------------

some_array = ['', '']
#! ['def upper']
some_array[some_not_defined_index].upper
