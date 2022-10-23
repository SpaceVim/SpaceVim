"""
Some syntax errors are a bit complicated and need exact checking. Here we
gather some of the potentially dangerous ones.
"""

from __future__ import division

# With a dot it's not a future import anymore.
from .__future__ import absolute_import

'' ''
''r''u''
b'' BR''


for x in [1]:
    break
    continue

try:
    pass
except ZeroDivisionError:
    pass
    #: E722:0
except:
    pass

try:
    pass
    #: E722:0 E901:0
except:
    pass
except ZeroDivisionError:
    pass


r'\n'
r'\x'
b'\n'


a = 3


def x(b=a):
    global a


def x(*args, c=2, d):
    pass


def x(*, c=2, d):
    pass


def x(a, b=1, *args, c=2, d):
    pass


def x(a, b=1, *, c=2, d):
    pass


lambda *args, c=2, d: (c, d)
lambda *, c=2, d: (c, d)
lambda a, b=1, *args, c=2, d: (c, d)
lambda a, b=1, *, c=2, d: (c, d)


*foo, a = (1,)
*foo[0], a = (1,)
*[], a = (1,)


async def foo():
    await bar()
    #: E901
    yield from []
    return
    #: E901
    return ''


# With decorator it's a different statement.
@bla
async def foo():
    await bar()
    #: E901
    yield from []
    return
    #: E901
    return ''


foo: int = 4
(foo): int = 3
((foo)): int = 3
foo.bar: int
foo[3]: int


def glob():
    global x
    y: foo = x


def c():
    a = 3

    def d():
        class X():
            nonlocal a


def x():
    a = 3

    def y():
        nonlocal a


def x():
    def y():
        nonlocal a

    a = 3


def x():
    a = 3

    def y():
        class z():
            nonlocal a


def x(a):
    def y():
        nonlocal a


def x(a, b):
    def y():
        nonlocal b
        nonlocal a


def x(a):
    def y():
        def z():
            nonlocal a


def x():
    def y(a):
        def z():
            nonlocal a


a = *args, *args
error[(*args, *args)] = 3
*args, *args
