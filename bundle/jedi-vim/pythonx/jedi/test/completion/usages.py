"""
Renaming tests. This means search for references.
I always leave a little bit of space to add room for additions, because the
results always contain position informations.
"""
#< 4 (0,4), (3,0), (5,0), (12,4), (14,5), (15,0), (17,0), (19,0)
def abcd(): pass

#< 0 (-3,4), (0,0), (2,0), (9,4), (11,5), (12,0), (14,0), (16,0)
abcd.d.a.bsaasd.abcd.d

abcd
# unicode chars shouldn't be a problem.
x['smörbröd'].abcd

# With the new parser these statements are not recognized as stateents, because
# they are not valid Python.
if 1:
    abcd = 
else:
    (abcd) = 
abcd = 
#< (-17,4), (-14,0), (-12,0), (0,0), (2,0), (-2,0), (-3,5), (-5,4)
abcd

abcd = 5


Abc = 3

#< 6 (-3,0), (0,6), (2,4), (5,8), (17,0)
class Abc():
    #< (-5,0), (-2,6), (0,4), (2,8), (3,8), (15,0)
    Abc

    def Abc(self):
        Abc; self.c = 3

    #< 17 (0,16), (2,8)
    def a(self, Abc):
        #< 10 (-2,16), (0,8)
        Abc

    #< 19 (0,18), (2,8)
    def self_test(self):
        #< 12 (-2,18), (0,8)
        self.b

Abc.d.Abc


#< 4 (0,4), (5,1)
def blubi():
    pass


#< (-5,4), (0,1)
@blubi
def a(): pass


#< 0 (0,0), (1,0)
set_object_var = object()
set_object_var.var = 1

def func(a, b):
    a = 12
    #< 4 (0,4), (3,8)
    c = a
    if True:
        #< 8 (-3,4), (0,8)
        c = b

response = 5
#< 0 (-2,0), (0,0), (1,0), (2,0), (4,0)
response = HttpResponse(mimetype='application/pdf')
response['Content-Disposition'] = 'attachment; filename=%s.pdf' % id
response.write(pdf)
#< (-6,0), (-4,0), (-3,0), (-2,0), (0,0)
response


# -----------------
# imports
# -----------------
#< (0,7), (3,0)
import module_not_exists

#< (-3,7), (0,0)
module_not_exists


#< ('import_tree.rename1', 1,0), (0,24), (3,0), (6,17), ('import_tree.rename2', 4,17), (11,17), (14,17), ('imports', 72, 16)
from import_tree import rename1

#< (0,8), ('import_tree.rename1',3,0), ('import_tree.rename2',4,32), ('import_tree.rename2',6,0), (3,32), (8,32), (5,0)
rename1.abc

#< (-3,8), ('import_tree.rename1', 3,0), ('import_tree.rename2', 4,32), ('import_tree.rename2', 6,0), (0,32), (5,32), (2,0)
from import_tree.rename1 import abc
#< (-5,8), (-2,32), ('import_tree.rename1', 3,0), ('import_tree.rename2', 4,32), ('import_tree.rename2', 6,0), (0,0), (3,32)
abc

#< 20 ('import_tree.rename1', 1,0), ('import_tree.rename2', 4,17), (-11,24), (-8,0), (-5,17), (0,17), (3,17), ('imports', 72, 16)
from import_tree.rename1 import abc

#< (0, 32),
from import_tree.rename1 import not_existing

# Shouldn't raise an error or do anything weird.
from not_existing import *

# -----------------
# classes
# -----------------

class TestMethods(object):
    #< 8 (0,8), (2,13)
    def a_method(self):
        #< 13 (-2,8), (0,13)
        self.a_method()
        #< 13 (2,8), (0,13), (3,13)
        self.b_method()

    def b_method(self):
        self.b_method


class TestClassVar(object):
    #< 4 (0,4), (5,13), (7,21)
    class_v = 1
    def a(self):
        class_v = 1

        #< (-5,4), (0,13), (2,21)
        self.class_v
        #< (-7,4), (-2,13), (0,21)
        TestClassVar.class_v
        #< (0,8), (-7, 8)
        class_v

class TestInstanceVar():
    def a(self):
        #< 13 (4,13), (0,13)
        self._instance_var = 3

    def b(self):
        #< (-4,13), (0,13)
        self._instance_var
        # A call to self used to trigger an error, because it's also a trailer
        # with two children.
        self()


class NestedClass():
    def __getattr__(self, name):
        return self

# Shouldn't find a definition, because there's other `instance`.
#< (0, 14),
NestedClass().instance


# -----------------
# inheritance
# -----------------
class Super(object):
    #< 4 (0,4), (23,18), (25,13)
    base_class = 1
    #< 4 (0,4),
    class_var = 1

    #< 8 (0,8),
    def base_method(self):
        #< 13 (0,13), (20,13)
        self.base_var = 1
        #< 13 (0,13),
        self.instance_var = 1

    #< 8 (0,8),
    def just_a_method(self): pass


#< 20 (0,16), (-18,6)
class TestClass(Super):
    #< 4 (0,4),
    class_var = 1

    def x_method(self):

        #< (0,18), (2,13), (-23,4)
        TestClass.base_class
        #< (-2,18), (0,13), (-25,4)
        self.base_class
        #< (-20,13), (0,13)
        self.base_var
        #< (0, 18),
        TestClass.base_var


        #< 13 (5,13), (0,13)
        self.instance_var = 3

    #< 9 (0,8), 
    def just_a_method(self):
        #< (-5,13), (0,13)
        self.instance_var


# -----------------
# properties
# -----------------
class TestProperty:

    @property
    #< 10 (0,8), (5,13)
    def prop(self):
        return 1

    def a(self):
        #< 13 (-5,8), (0,13)
        self.prop

    @property
    #< 13 (0,8), (4,5), (6,8), (11,13)
    def rw_prop(self):
        return self._rw_prop

    #< 8 (-4,8), (0,5), (2,8), (7,13)
    @rw_prop.setter
    #< 8 (-6,8), (-2,5), (0,8), (5,13)
    def rw_prop(self, value):
        self._rw_prop = value

    def b(self):
        #< 13 (-11,8), (-7,5), (-5,8), (0,13)
        self.rw_prop

# -----------------
# *args, **kwargs
# -----------------
#< 11 (1,11), (0,8)
def f(**kwargs):
    return kwargs


# -----------------
# No result
# -----------------
if isinstance(j, int):
    #< (0, 4),
    j

# -----------------
# Dynamic Param Search
# -----------------

class DynamicParam():
    def foo(self):
        return

def check(instance):
    #< 13 (-5,8), (0,13)
    instance.foo()

check(DynamicParam())

# -----------------
# Compiled Objects
# -----------------

import _sre

# TODO reenable this, it's currently not working, because of 2/3
# inconsistencies in typeshed (_sre exists in typeshed/2, but not in
# typeshed/3).
##< 0 (-3,7), (0,0), ('_sre', None, None)
_sre

# -----------------
# on syntax
# -----------------

#< 0
import undefined

# -----------------
# comprehensions
# -----------------

#< 0 (0,0), (2,12)
x = 32
#< 12 (-2,0), (0,12)
[x for x in x]

#< 0 (0,0), (2,1), (2,12)
y = 32
#< 12 (-2,0), (0,1), (0,12)
[y for b in y]


#< 1 (0,1), (0,7)
[x for x in something]
#< 7 (0,1), (0,7)
[x for x in something]

z = 3
#< 1 (0,1), (0,10)
{z:1 for  z in something}
#< 10 (0,1), (0,10)
{z:1 for  z in something}

#< 8 (0,6), (0, 40)
[[x + nested_loopv2 for x in bar()] for nested_loopv2 in baz()]

#< 25 (0,20), (0, 65)
(("*" if abs(foo(x, nested_loopv1)) else " " for x in bar()) for nested_loopv1 in baz())


def whatever_func():
    zzz = 3
    if UNDEFINED:
        zzz = 5
        if UNDEFINED2:
            #< (3, 8), (4, 4), (0, 12), (-3, 8), (-5, 4)
            zzz
    else:
        #< (0, 8), (1, 4), (-3, 12), (-6, 8), (-8, 4)
        zzz
    zzz

# -----------------
# global
# -----------------

def global_usage1():
    #< (0, 4), (4, 11), (6, 4), (9, 8), (12, 4)
    my_global

def global_definition():
    #< (-4, 4), (0, 11), (2, 4), (5, 8), (8, 4)
    global my_global
    #< 4 (-6, 4), (-2, 11), (0, 4), (3, 8), (6, 4)
    my_global = 3
    if WHATEVER:
        #< 8 (-9, 4), (-5, 11), (-3, 4), (0, 8), (3, 4)
        my_global = 4

def global_usage2()
    my_global

def not_global(my_global):
    my_global

class DefinitelyNotGlobal:
    def my_global(self):
        def my_global(self):
            pass

# -----------------
# stubs
# -----------------

from stub_folder import with_stub
#< ('stub:stub_folder.with_stub', 5, 4), ('stub_folder.with_stub', 5, 4), (0, 10)
with_stub.stub_function
from stub_folder.with_stub_folder.nested_stub_only import in_stub_only
#< ('stub:stub_folder.with_stub_folder.nested_stub_only', 2, 4), ('stub:stub_folder.with_stub_folder.nested_stub_only', 4, 4), ('stubs', 64, 17), (-2, 58), (0, 0)
in_stub_only
from stub_folder.with_stub_folder.nested_with_stub import in_python
#< ('stub_folder.with_stub_folder.nested_with_stub', 1, 0), ('stubs', 68, 17), (-2, 58), (0, 0)
in_python
from stub_folder.with_stub_folder.nested_with_stub import in_both
#< ('stub_folder.with_stub_folder.nested_with_stub', 2, 0), ('stub:stub_folder.with_stub_folder.nested_with_stub', 2, 0), ('stubs', 66, 17), (-2, 58), (0, 0)
in_both

# -----------------
# across directories
# -----------------

#< 8 (0, 0), (3, 4), ('import_tree.references', 1, 21), ('import_tree.references', 5, 4)
usage_definition = 1
if False:
    #< 8 (-3, 0), (0, 4), ('import_tree.references', 1, 21), ('import_tree.references', 5, 4)
    usage_definition()

# -----------------
# stdlib stuff
# -----------------

import socket
#< (1, 21), (0, 7), ('socket', ..., 6), ('stub:socket', ..., 4), ('imports', ..., 7)
socket.SocketIO
some_socket = socket.SocketIO()
