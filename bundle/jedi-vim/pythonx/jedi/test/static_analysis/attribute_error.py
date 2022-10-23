class Cls():
    class_attr = ''
    def __init__(self, input):
        self.instance_attr = 3
        self.input = input

    def f(self):
        #! 12 attribute-error
        return self.not_existing

    def undefined_object(self, obj):
        """
        Uses an arbitrary object and performs an operation on it, shouldn't
        be a problem.
        """
        obj.arbitrary_lookup

    def defined_lookup(self, obj):
        """
        `obj` is defined by a call into this function.
        """
        obj.upper
        #! 4 attribute-error
        obj.arbitrary_lookup

    #! 13 name-error
    class_attr = a

Cls(1).defined_lookup('')

c = Cls(1)
c.class_attr
Cls.class_attr
#! 4 attribute-error
Cls.class_attr_error
c.instance_attr
#! 2 attribute-error
c.instance_attr_error


c.something = None

#! 12 name-error
something = a
something

# -----------------
# Unused array variables should still raise attribute errors.
# -----------------

# should not raise anything.
for loop_variable in [1, 2]:
    #! 4 name-error
    x = undefined
    loop_variable

#! 28 name-error
for loop_variable in [1, 2, undefined]:
    pass

#! 7 attribute-error
[1, ''.undefined_attr]


def return_one(something):
    return 1

#! 14 attribute-error
return_one(''.undefined_attribute)

#! 12 name-error
[r for r in undefined]

#! 1 name-error
[undefined for r in [1, 2]]

[r for r in [1, 2]]

# some random error that showed up
class NotCalled():
    def match_something(self, param):
        seems_to_need_an_assignment = param
        return [value.match_something() for value in []]

# -----------------
# decorators
# -----------------

#! 1 name-error
@undefined_decorator
def func():
    return 1

# -----------------
# operators
# -----------------

string = '%s %s' % (1, 2)

# Shouldn't raise an error, because `string` is really just a string, not an
# array or something.
string.upper

# -----------------
# imports
# -----------------

# Star imports and the like in modules should not cause attribute errors in
# this module.
import import_tree

import_tree.a
import_tree.b
