#!/usr/bin/env python3
from typing import ClassVar, List

print(1, 2)


# Annotated function (Issue #29)
def foo(x: int) -> int:
    return x + 1


# Annotated variables #575
CONST: int = 42


class Class:
    cls_var: ClassVar[str]

    def m(self):
        xs: List[int] = []


# True and False are keywords in Python 3 and therefore need a space.
#: E275:13 E275:14
norman = True+False


#: E302+3:0
def a():
    pass

async def b():
    pass


# Okay
async def add(a: int = 0, b: int = 0) -> int:
    return a + b


# Previously E251 four times
#: E221:5
async  def add(a: int = 0, b: int = 0) -> int:
    return a + b


# Previously just E272+1:5 E272+4:5
#: E302+3 E221:5 E221+3:5
async  def x():
    pass

async  def x(y: int = 1):
    pass


#: E704:16
async def f(x): return 2


a[b1, :] == a[b1, ...]


# Annotated Function Definitions
# Okay
def munge(input: AnyStr, sep: AnyStr = None, limit=1000,
          extra: Union[str, dict] = None) -> AnyStr:
    pass


#: E225:24 E225:26
def x(b: tuple = (1, 2))->int:
    return a + b


#: E252:11 E252:12 E231:8
def b(a:int=1):
    pass


if alpha[:-i]:
    *a, b = (1, 2, 3)


# Named only arguments
def foo(*, asdf):
    pass


def foo2(bar, *, asdf=2):
    pass
