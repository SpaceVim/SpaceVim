# Okay
class X:
    pass
# Okay


def foo():
    pass


# Okay
# -*- coding: utf-8 -*-
class X:
    pass


# Okay
# -*- coding: utf-8 -*-
def foo():
    pass


# Okay
class X:

    def a():
        pass

    # comment
    def b():
        pass

    # This is a
    # ... multi-line comment

    def c():
        pass


# This is a
# ... multi-line comment

@some_decorator
class Y:

    def a():
        pass

    # comment

    def b():
        pass

    @property
    def c():
        pass


try:
    from nonexistent import Bar
except ImportError:
    class Bar(object):
        """This is a Bar replacement"""


def with_feature(f):
    """Some decorator"""
    wrapper = f
    if has_this_feature(f):
        def wrapper(*args):
            call_feature(args[0])
            return f(*args)
    return wrapper


try:
    next
except NameError:
    def next(iterator, default):
        for item in iterator:
            return item
        return default


def a():
    pass


class Foo():
    """Class Foo"""

    def b():

        pass


# comment
def c():
    pass


# comment


def d():
    pass

# This is a
# ... multi-line comment

# And this one is
# ... a second paragraph
# ... which spans on 3 lines


# Function `e` is below
# NOTE: Hey this is a testcase

def e():
    pass


def a():
    print

    # comment

    print

    print

# Comment 1

# Comment 2


# Comment 3

def b():

    pass


# Okay
def foo():
    pass


def bar():
    pass


class Foo(object):
    pass


class Bar(object):
    pass


if __name__ == '__main__':
    foo()
# Okay
classification_errors = None
# Okay
defined_properly = True
# Okay
defaults = {}
defaults.update({})


# Okay
def foo(x):
    classification = x
    definitely = not classification
