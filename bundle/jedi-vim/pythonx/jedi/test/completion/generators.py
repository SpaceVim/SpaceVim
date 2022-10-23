# -----------------
# yield statement
# -----------------
def gen():
    if random.choice([0, 1]):
        yield 1
    else:
        yield ""

gen_exe = gen()
#? int() str()
next(gen_exe)

#? int() str() list
next(gen_exe, list)


def gen_ret(value):
    yield value

#? int()
next(gen_ret(1))

#? []
next(gen_ret()).

# generators infer to true if cast by bool.
a = ''
if gen_ret():
    a = 3
#? int()
a


# -----------------
# generators should not be indexable
# -----------------
def get(param):
    if random.choice([0, 1]):
        yield 1
    else:
        yield ""

#? []
get()[0].

# -----------------
# __iter__
# -----------------
for a in get():
    #? int() str()
    a


class Get():
    def __iter__(self):
        if random.choice([0, 1]):
            yield 1
        else:
            yield ""

b = []
for a in Get():
    #? int() str()
    a
    b += [a]

#? list()
b
#? int() str()
b[0]

g = iter(Get())
#? int() str()
next(g)

g = iter([1.0])
#? float()
next(g)

x, y = Get()
#? int() str()
x
#? int() str()
x

class Iter:
    def __iter__(self):
        yield ""
        i = 0
        while True:
            v = 1
            yield v
            i += 1
a, b, c = Iter()
#? str() int()
a
#? str() int()
b
#? str() int()
c


# -----------------
# __next__
# -----------------
class Counter:
    def __init__(self, low, high):
        self.current = low
        self.high = high

    def __iter__(self):
        return self

    def next(self):
        """ need to have both __next__ and next, because of py2/3 testing """
        return self.__next__()

    def __next__(self):
        if self.current > self.high:
            raise StopIteration
        else:
            self.current += 1
            return self.current - 1


for c in Counter(3, 8):
    #? int()
    print c


# -----------------
# tuple assignments
# -----------------
def gen():
    if random.choice([0,1]):
        yield 1, ""
    else:
        yield 2, 1.0


a, b = next(gen())
#? int()
a
#? str() float()
b


def simple():
    if random.choice([0, 1]):
        yield 1
    else:
        yield ""

a, b = simple()
#? int() str()
a
# For now this is ok.
#? int() str()
b


def simple2():
    yield 1
    yield ""

a, b = simple2()
#? int()
a
#? str()
b

a, = (a for a in [1])
#? int()
a

# -----------------
# More complicated access
# -----------------

# `close` is a method wrapper.
#? ['__call__']
gen().close.__call__

#? 
gen().throw()

#? ['co_consts']
gen().gi_code.co_consts

#? []
gen.gi_code.co_consts

# `send` is also a method wrapper.
#? ['__call__']
gen().send.__call__

#? tuple()
gen().send()

#? 
gen()()

# -----------------
# empty yield
# -----------------

def x():
    yield

#? None
next(x())
#? gen()
x()

def x():
    for i in range(3):
        yield

#? None
next(x())

# -----------------
# yield in expression
# -----------------

def x():
     a= [(yield 1)]

#? int()
next(x())

# -----------------
# statements
# -----------------
def x():
    foo = yield
    #?
    foo

# -----------------
# yield from
# -----------------

def yield_from():
    yield from iter([1])

#? int()
next(yield_from())

def yield_from_multiple():
    yield from iter([1])
    yield str()
    return 2.0

x, y = yield_from_multiple()
#? int()
x
#? str()
y

def test_nested():
    x = yield from yield_from_multiple()
    #? float()
    x
    yield x

x, y, z = test_nested()
#? int()
x
#? str()
y
# For whatever reason this is currently empty
#? float()
z


def test_in_brackets():
    x = 1 + (yield from yield_from_multiple())
    #? float()
    x

    generator = (1 for 1 in [1])
    x = yield from generator
    #? None
    x
    x = yield from 1
    #?
    x
    x = yield from [1]
    #? None
    x


# -----------------
# Annotations
# -----------------

from typing import Iterator

def annotation1() -> float:
    yield 1

def annotation2() -> Iterator[float]:
    yield 1


#?
next(annotation1())
#? float()
next(annotation2())


# annotations should override generator inference
#? float()
annotation1()
