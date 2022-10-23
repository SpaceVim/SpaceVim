"""
Test the typing library, with docstrings and annotations
"""
import typing
class B:
    pass

def we_can_has_sequence(p, q, r, s, t, u):
    """
    :type p: typing.Sequence[int]
    :type q: typing.Sequence[B]
    :type r: typing.Sequence[int]
    :type s: typing.Sequence["int"]
    :type t: typing.MutableSequence[dict]
    :type u: typing.List[float]
    """
    #? ["count"]
    p.c
    #? int()
    p[1]
    #? ["count"]
    q.c
    #? B()
    q[1]
    #? ["count"]
    r.c
    #? int()
    r[1]
    #? ["count"]
    s.c
    #? int()
    s[1]
    #? []
    s.a
    #? ["append"]
    t.a
    #? dict()
    t[1]
    #? ["append"]
    u.a
    #? float() list()
    u[1.0]
    #? float()
    u[1]

def iterators(ps, qs, rs, ts):
    """
    :type ps: typing.Iterable[int]
    :type qs: typing.Iterator[str]
    :type rs: typing.Sequence["ForwardReference"]
    :type ts: typing.AbstractSet["float"]
    """
    for p in ps:
        #? int()
        p
    #?
    next(ps)
    a, b = ps
    #? int()
    a
    ##? int()  --- TODO fix support for tuple assignment
    # https://github.com/davidhalter/jedi/pull/663#issuecomment-172317854
    # test below is just to make sure that in case it gets fixed by accident
    # these tests will be fixed as well the way they should be
    #?
    b

    for q in qs:
        #? str()
        q
    #? str()
    next(qs)
    for r in rs:
        #? ForwardReference()
        r
    #?
    next(rs)
    for t in ts:
        #? float()
        t

def sets(p, q):
    """
    :type p: typing.AbstractSet[int]
    :type q: typing.MutableSet[float]
    """
    #? []
    p.a
    #? ["add"]
    q.a

def tuple(p, q, r):
    """
    :type p: typing.Tuple[int]
    :type q: typing.Tuple[int, str, float]
    :type r: typing.Tuple[B, ...]
    """
    #? int()
    p[0]
    #? ['index']
    p.index
    #? int()
    q[0]
    #? str()
    q[1]
    #? float()
    q[2]
    #? B()
    r[0]
    #? B()
    r[1]
    #? B()
    r[2]
    #? B()
    r[10000]
    i, s, f = q
    #? int()
    i
    #? str()
    s
    #? float()
    f

class Key:
    pass

class Value:
    pass

def mapping(p, q, d, dd, r, s, t):
    """
    :type p: typing.Mapping[Key, Value]
    :type q: typing.MutableMapping[Key, Value]
    :type d: typing.Dict[Key, Value]
    :type dd: typing.DefaultDict[Key, Value]
    :type r: typing.KeysView[Key]
    :type s: typing.ValuesView[Value]
    :type t: typing.ItemsView[Key, Value]
    """
    #? []
    p.setd
    #? ["setdefault"]
    q.setd
    #? ["setdefault"]
    d.setd
    #? ["setdefault"]
    dd.setd
    #? Value()
    p[1]
    for key in p:
        #? Key()
        key
    for key in p.keys():
        #? Key()
        key
    for value in p.values():
        #? Value()
        value
    for item in p.items():
        #? Key()
        item[0]
        #? Value()
        item[1]
        (key, value) = item
        #? Key()
        key
        #? Value()
        value
    for key, value in p.items():
        #? Key()
        key
        #? Value()
        value
    for key, value in q.items():
        #? Key()
        key
        #? Value()
        value
    for key, value in d.items():
        #? Key()
        key
        #? Value()
        value
    for key, value in dd.items():
        #? Key()
        key
        #? Value()
        value
    for key in r:
        #? Key()
        key
    for value in s:
        #? Value()
        value
    for key, value in t:
        #? Key()
        key
        #? Value()
        value

def union(p, q, r, s, t):
    """
    :type p: typing.Union[int]
    :type q: typing.Union[int, int]
    :type r: typing.Union[int, str, "int"]
    :type s: typing.Union[int, typing.Union[str, "typing.Union['float', 'dict']"]]
    :type t: typing.Union[int, None]
    """
    #? int()
    p
    #? int()
    q
    #? int() str()
    r
    #? int() str() float() dict()
    s
    #? int() None
    t

def optional(p):
    """
    :type p: typing.Optional[int]
    Optional does not do anything special. However it should be recognised
    as being of that type. Jedi doesn't do anything with the extra into that
    it can be None as well
    """
    #? int() None
    p

class ForwardReference:
    pass

class TestDict(typing.Dict[str, int]):
    def setdud(self):
        pass

def testdict(x):
    """
    :type x: TestDict
    """
    #? ["setdud", "setdefault"]
    x.setd
    for key in x.keys():
        #? str()
        key
    for value in x.values():
        #? int()
        value

x = TestDict()
#? ["setdud", "setdefault"]
x.setd
for key in x.keys():
    #? str()
    key
for value in x.values():
    #? int()
    value

WrappingType = typing.NewType('WrappingType', str) # Chosen arbitrarily
y = WrappingType(0) # Per https://github.com/davidhalter/jedi/issues/1015#issuecomment-355795929
#? str()
y

def testnewtype(y):
    """
    :type y: WrappingType
    """
    #? str()
    y
    #? ["upper"]
    y.u

WrappingType2 = typing.NewType()

def testnewtype2(y):
    """
    :type y: WrappingType2
    """
    #?
    y
    #? []
    y.

# The type of a NewType is equivalent to the type of its underlying type.
MyInt = typing.NewType('MyInt', int)
x = type(MyInt)
#? type.mro
x.mro

PlainInt = int
y = type(PlainInt)
#? type.mro
y.mro

class TestDefaultDict(typing.DefaultDict[str, int]):
    def setdud(self):
        pass

def testdict(x):
    """
    :type x: TestDefaultDict
    """
    #? ["setdud", "setdefault"]
    x.setd
    for key in x.keys():
        #? str()
        key
    for value in x.values():
        #? int()
        value

x = TestDefaultDict()
#? ["setdud", "setdefault"]
x.setd
for key in x.keys():
    #? str()
    key
for value in x.values():
    #? int()
    value


"""
docstrings have some auto-import, annotations can use all of Python's
import logic
"""
import typing as t
def union2(x: t.Union[int, str]):
    #? int() str()
    x
from typing import Union
def union3(x: Union[int, str]):
    #? int() str()
    x

from typing import Union as U
def union4(x: U[int, str]):
    #? int() str()
    x

#? typing.Optional
typing.Optional[0]

# -------------------------
# Type Vars
# -------------------------

TYPE_VARX = typing.TypeVar('TYPE_VARX')
TYPE_VAR_CONSTRAINTSX = typing.TypeVar('TYPE_VAR_CONSTRAINTSX', str, int)
#? ['__class__']
TYPE_VARX.__clas
#! ["TYPE_VARX = typing.TypeVar('TYPE_VARX')"]
TYPE_VARX


class WithTypeVar(typing.Generic[TYPE_VARX]):
    def lala(self) -> TYPE_VARX:
        ...


def maaan(p: WithTypeVar[int]):
    #? int()
    p.lala()

def in_out1(x: TYPE_VARX) -> TYPE_VARX: ...

#? int()
in_out1(1)
#? str()
in_out1("")
#? str()
in_out1(str())
#?
in_out1()

def type_in_out1(x: typing.Type[TYPE_VARX]) -> TYPE_VARX: ...

#? int()
type_in_out1(int)
#? str()
type_in_out1(str)
#? float()
type_in_out1(float)
#?
type_in_out1()

def in_out2(x: TYPE_VAR_CONSTRAINTSX) -> TYPE_VAR_CONSTRAINTSX: ...

#? int()
in_out2(1)
#? str()
in_out2("")
#? str()
in_out2(str())
#? str() int()
in_out2()
# TODO this should actually be str() int(), because of the constraints.
#? float()
in_out2(1.0)

def type_in_out2(x: typing.Type[TYPE_VAR_CONSTRAINTSX]) -> TYPE_VAR_CONSTRAINTSX: ...

#? int()
type_in_out2(int)
#? str()
type_in_out2(str)
#? str() int()
type_in_out2()
# TODO this should actually be str() int(), because of the constraints.
#? float()
type_in_out2(float)

def ma(a: typing.Callable[[str], TYPE_VARX]) -> typing.Callable[[str], TYPE_VARX]:
    #? typing.Callable()
    return a

def mf(s: str) -> int:
    return int(s)

#? int()
ma(mf)('2')

def xxx(x: typing.Iterable[TYPE_VARX]) -> typing.Tuple[str, TYPE_VARX]: ...

#? str()
xxx([0])[0]
#? int()
xxx([0])[1]
#?
xxx([0])[2]

def call_pls() -> typing.Callable[[TYPE_VARX], TYPE_VARX]: ...
#? int()
call_pls()(1)

def call2_pls() -> typing.Callable[[str, typing.Callable[[int], TYPE_VARX]], TYPE_VARX]: ...
#? float()
call2_pls('')(1, lambda x: 3.0)

def call3_pls() -> typing.Callable[[typing.Callable[[int], TYPE_VARX]], typing.List[TYPE_VARX]]: ...
def the_callable() -> float: ...
#? float()
call3_pls()(the_callable)[0]

def call4_pls(fn: typing.Callable[..., TYPE_VARX]) -> typing.Callable[..., TYPE_VARX]:
    return ""

#? int()
call4_pls(lambda x: 1)()

# -------------------------
# TYPE_CHECKING
# -------------------------

if typing.TYPE_CHECKING:
    with_type_checking = 1
else:
    without_type_checking = 1.0
#? int()
with_type_checking
#?
without_type_checking

def foo(a: typing.List, b: typing.Dict, c: typing.MutableMapping) -> typing.Type[int]:
    #? ['append']
    a.appen
    #? list()
    a
    #?
    a[0]
    #? ['setdefault']
    b.setd
    #? ['setdefault']
    c.setd
    #? typing.MutableMapping()
    c
    #?
    c['asdf']
#? int
foo()

# -------------------------
# cast
# -------------------------

def cast_tests():
    x = 3.0
    y = typing.cast(int, x)
    #? int()
    y
    return typing.cast(str, x)


#? str()
cast_tests()


# -------------------------
# dynamic
# -------------------------

def dynamic_annotation(x: int):
    #? int()
    return x

#? int()
dynamic_annotation('')

# -------------------------
# TypeDict
# -------------------------

# python >= 3.8

class Foo(typing.TypedDict):
    foo: str
    bar: typing.List[float]
    an_int: int
    #! ['foo: str']
    foo
    #? str()
    foo
    #? int()
    an_int

def typed_dict_test_foo(arg: Foo):
    a_string = arg['foo']
    a_list_of_floats = arg['bar']
    an_int = arg['an_int']

    #? str()
    a_string
    #? list()
    a_list_of_floats
    #? float()
    a_list_of_floats[0]
    #? int()
    an_int

    #? ['isupper']
    a_string.isuppe
    #? ['pop']
    a_list_of_floats.po
    #? ['as_integer_ratio']
    an_int.as_integer_rati

#! ['class Foo']
d: Foo
#? str()
d['foo']
#? float()
d['bar'][0]
#?
d['baz']

#?
d.foo
#?
d.bar
#! []
d.foo

#? []
Foo.set
#? ['setdefault']
d.setdefaul
#? []
Foo.setdefaul

#? 5 ["'foo"]
d['fo']
#? 5 ['"bar"']
d["bar"]

class Bar(Foo):
    another_variable: int

    #? int()
    another_variable
    #?
    an_int

def typed_dict_test_foo(arg: Bar):
    #? str()
    arg['foo']
    #? list()
    arg['bar']
    #? float()
    arg['bar'][0]
    #? int()
    arg['an_int']
    #? int()
    arg['another_variable']
