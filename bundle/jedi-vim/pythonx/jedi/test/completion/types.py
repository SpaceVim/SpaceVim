# -----------------
# non array
# -----------------

#? ['imag']
int.imag

#? []
int.is_integer

#? ['is_integer']
float.is_int

#? ['is_integer']
1.0.is_integer

#? ['upper']
"".upper

#? ['upper']
r"".upper

# strangely this didn't work, because the = is used for assignments
#? ['upper']
"=".upper
a = "="
#? ['upper']
a.upper


# -----------------
# lists
# -----------------
arr = []
#? ['append']
arr.app

#? ['append']
list().app
#? ['append']
[].append

arr2 = [1,2,3]
#? ['append']
arr2.app

#? int()
arr.count(1)

x = []
#?
x.pop()
x = [3]
#? int()
x.pop()
x = []
x.append(1.0)
#? float()
x.pop()

# -----------------
# dicts
# -----------------
dic = {}

#? ['copy', 'clear']
dic.c

dic2 = dict(a=1, b=2)
#? ['pop', 'popitem']
dic2.p
#? ['popitem']
{}.popitem

dic2 = {'asdf': 3}
#? ['popitem']
dic2.popitem

#? int()
dic2['asdf']

d = {'a': 3, 1.0: list}

#? int() list
d.values()[0]
##? int() list
dict(d).values()[0]

#? str()
d.items()[0][0]
#? int()
d.items()[0][1]

(a, b), = {a:1 for a in [1.0]}.items()
#? float()
a
#? int()
b

# -----------------
# tuples
# -----------------
tup = ('',2)

#? ['count']
tup.c

tup2 = tuple()
#? ['index']
tup2.i
#? ['index']
().i

tup3 = 1,""
#? ['index']
tup3.index

tup4 = 1,""
#? ['index']
tup4.index

# -----------------
# set
# -----------------
set_t = {1,2}

#? ['clear', 'copy']
set_t.c

set_t2 = set()

#? ['clear', 'copy']
set_t2.c

# -----------------
# pep 448 unpacking generalizations
# -----------------

d = {'a': 3}
dc = {v: 3 for v in ['a']}

#? dict()
{**d}

#? dict()
{**dc}

#? str()
{**d, "b": "b"}["b"]

#? str()
{**dc, "b": "b"}["b"]

# Should resolve to int() but jedi is not smart enough yet
# Here to make sure it doesn't result in crash though
#? 
{**d}["a"]

# Should resolve to int() but jedi is not smart enough yet
# Here to make sure it doesn't result in crash though
#? 
{**dc}["a"]

s = {1, 2, 3}

#? set()
{*s}

#? set()
{*s, 4, *s}

s = {1, 2, 3}
# Should resolve to int() but jedi is not smart enough yet
# Here to make sure it doesn't result in crash though
#? 
{*s}.pop()

#? int()
{*s, 4}.pop()

# Should resolve to int() but jedi is not smart enough yet
# Here to make sure it doesn't result in crash though
#? 
[*s][0]

#? int()
[*s, 4][0]
