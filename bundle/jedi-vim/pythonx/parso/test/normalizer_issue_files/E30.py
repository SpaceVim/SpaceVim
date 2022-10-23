#: E301+4
class X:

    def a():
        pass
    def b():
        pass


#: E301+5
class X:

    def a():
        pass
    # comment
    def b():
        pass


# -*- coding: utf-8 -*-
def a():
    pass


#: E302+1:0
"""Main module."""
def _main():
    pass


#: E302+1:0
foo = 1
def get_sys_path():
    return sys.path


#: E302+3:0
def a():
    pass

def b():
    pass


#: E302+5:0
def a():
    pass

# comment

def b():
    pass


#: E303+3:0
print



#: E303+3:0 E303+4:0
print




print
#: E303+3:0
print



# comment

print


#: E303+3 E303+6
def a():
    print


    # comment


    # another comment

    print


#: E302+2
a = 3
#: E304+1
@decorator

def function():
    pass


#: E303+3
# something



"""This class docstring comes on line 5.
It gives error E303: too many blank lines (3)
"""


#: E302+6
def a():
    print

    # comment

    # another comment
a()


#: E302+7
def a():
    print

    # comment

    # another comment

try:
    a()
except Exception:
    pass


#: E302+4
def a():
    print

# Two spaces before comments, too.
if a():
    a()


#: E301+2
def a():
    x = 1
    def b():
        pass


#: E301+2 E301+4
def a():
    x = 2
    def b():
        x = 1
        def c():
            pass


#: E301+2 E301+4 E301+5
def a():
    x = 1
    class C:
        pass
    x = 2
    def b():
        pass


#: E302+7
# Example from https://github.com/PyCQA/pycodestyle/issues/400
foo = 2


def main():
    blah, blah

if __name__ == '__main__':
    main()
