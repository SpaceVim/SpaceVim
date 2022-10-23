# -----------------
# list comprehensions
# -----------------

# basics:

a = ['' for a in [1]]
#? str()
a[0]
#? ['insert']
a.insert

a = [a for a in [1]]
#? int()
a[0]

y = 1.0
# Should not leak.
[y for y in [3]]
#? float()
y

a = [a for a in (1, 2)]
#? int()
a[0]

a = [a for a,b in [(1,'')]]
#? int()
a[0]
a = [a for (a,b) in [(1,'')]]
#? int()
a[0]

arr = [1,'']
a = [a for a in arr]
#? int()
a[0]
#? str()
a[1]
#? int() str()
a[2]

a = [a if 1.0 else '' for a in [1] if [1.0]]
#? int() str()
a[0]

# name resolve should be correct
left, right = 'a', 'b'
left, right = [x for x in (left, right)]
#? str()
left

# with a dict literal
#? int()
[a for a in {1:'x'}][0]

# list comprehensions should also work in combination with functions
def _listen(arg):
    for x in arg:
        #? str()
        x

_listen(['' for x in [1]])
#?
([str for x in []])[0]

# -----------------
# nested list comprehensions
# -----------------

b = [a for arr in [[1, 1.0]] for a in arr]
#? int()
b[0]
#? float()
b[1]

b = [arr for arr in [[1, 1.0]] for a in arr]
#? int()
b[0][0]
#? float()
b[1][1]

b = [a for arr in [[1]] if '' for a in arr if '']
#? int()
b[0]

b = [b for arr in [[[1.0]]] for a in arr for b in a]
#? float()
b[0]

#? str()
[x for x in 'chr'][0]

# From GitHub #26
#? list()
a = [[int(v) for v in line.strip().split() if v] for line in ["123", str(), "123"] if line]
#? list()
a[0]
#? int()
a[0][0]

# From GitHub #1524
#?
[nothing for nothing, _ in [1]][0]

# -----------------
# generator comprehensions
# -----------------

left, right = (i for i in (1, ''))

#? int()
left
#? str()
right

gen = (i for i in (1,))

#? int()
next(gen)
#?
gen[0]

gen = (a for arr in [[1.0]] for a in arr)
#? float()
next(gen)

#? int()
(i for i in (1,)).send()

# issues with different formats
left, right = (i for i in
                       ('1', 2))
#? str()
left
#? int()
right

# -----------------
# name resolution in comprehensions.
# -----------------

def x():
    """Should not try to resolve to the if hio, which was a bug."""
    #? 22
    [a for a in h if hio]
    if hio: pass

# -----------------
# slices
# -----------------

#? list()
foo = [x for x in [1, '']][:1]
#? int()
foo[0]
#? str()
foo[1]

# -----------------
# In class
# -----------------

class X():
    def __init__(self, bar):
        self.bar = bar

    def foo(self):
        x = [a for a in self.bar][0]
        #? int()
        x
        return x

#? int()
X([1]).foo()

# -----------------
# dict comprehensions
# -----------------

#? int()
list({a - 1: 3 for a in [1]})[0]

d = {a - 1: b for a, b in {1: 'a', 3: 1.0}.items()}
#? int()
list(d)[0]
#? str() float()
d.values()[0]
#? str()
d[0]
#? float() str()
d[1]
#? float()
d[2]

# -----------------
# set comprehensions
# -----------------

#? set()
{a - 1 for a in [1]}

#? set()
{a for a in range(10)}

#? int()
[x for x in {a for a in range(10)}][0]

#? int()
{a for a in range(10)}.pop()
#? float() str()
{b for a in [[3.0], ['']] for b in a}.pop()

#? int()
next(iter({a for a in range(10)}))


#? int()
[a for a in {1, 2, 3}][0]

# -----------------
# syntax errors
# -----------------

# Issue #1146

#? ['list']
[int(str(x.value) for x in list

def reset_missing_bracket(): pass


# -----------------
# function calls
# -----------------

def foo(arg):
    return arg


x = foo(x for x in [1])

#? int()
next(x)
#?
x[0]

# While it's illegal to have more than one argument, when a generator
# expression is involved, it's still a valid parse tree and Jedi should still
# work (and especially not raise Exceptions). It's debatable wheter inferring
# values for invalid statements is a good idea, but not failing is a must.

#? int()
next(foo(x for x in [1], 1))

def bar(x, y):
    return y

#? str()
next(bar(x for x in [1], x for x in ['']))
