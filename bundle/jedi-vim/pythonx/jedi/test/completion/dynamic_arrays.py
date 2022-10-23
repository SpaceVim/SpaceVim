"""
Checking for ``list.append`` and all the other possible array modifications.
"""
# -----------------
# list.append
# -----------------
arr = []
for a in [1,2]:
    arr.append(a);

arr.append  # should not cause an exception
arr.append()  # should not cause an exception

#? int()
arr[10]

arr = [tuple()]
for a in [1,2]:
    arr.append(a);

#? int() tuple()
arr[10]
#? int()
arr[10].index()

arr = list([])
arr.append(1)
#? int()
arr[0]

# -----------------
# list.insert
# -----------------
arr = [""]
arr.insert(0, 1.0)

# on exception due to this, please!
arr.insert(0)
arr.insert()

#? float() str()
arr[10]

for a in arr:
    #? float() str()
    a

#? float() str()
list(arr)[10]

# -----------------
# list.extend / set.update
# -----------------

arr = [1.0]
arr.extend([1,2,3])
arr.extend([])
arr.extend("")
arr.extend(list)  # should ignore

#? float() int() str()
arr[100]

a = set(arr)
a.update(list(["", 1]))

#? float() int() str()
list(a)[0]
# -----------------
# set/list initialized as functions
# -----------------

st = set()
st.add(1)

#? int()
for s in st: s

lst = list()
lst.append(1)

#? int()
for i in lst: i

# -----------------
# renames / type changes
# -----------------
arr = []
arr2 = arr
arr2.append('')
#? str()
arr2[0]


lst = [1]
lst.append(1.0)
s = set(lst)
s.add("ahh")
lst = list(s)
lst.append({})

#? dict() int() float() str()
lst[0]

# should work with tuple conversion, too.
#? dict() int() float() str()
tuple(lst)[0]

# but not with an iterator
#? 
iter(lst)[0]

# -----------------
# complex including +=
# -----------------
class C(): pass
class D(): pass
class E(): pass
lst = [1]
lst.append(1.0)
lst += [C()]
s = set(lst)
s.add("")
s += [D()]
lst = list(s)
lst.append({})
lst += [E()]

#? dict() int() float() str() C() D() E()
lst[0]

# -----------------
# functions
# -----------------

def arr_append(arr4, a):
    arr4.append(a)

def add_to_arr(arr2, a):
    arr2.append(a)
    return arr2

def app(a):
    arr3.append(a)

arr3 = [1.0]
res = add_to_arr(arr3, 1)
arr_append(arr3, 'str')
app(set())

#? float() str() int() set()
arr3[10]

#? float() str() int() set()
res[10]

# -----------------
# returns, special because the module dicts are not correct here.
# -----------------
def blub():
    a = []
    a.append(1.0)
    #? float()
    a[0]
    return a

#? float()
blub()[0]

# list with default
def blub():
    a = list([1])
    a.append(1.0)
    return a

#? int() float()
blub()[0]

# empty list
def blub():
    a = list()
    a.append(1.0)
    return a
#? float()
blub()[0]

# with if
def blub():
    if 1:
        a = []
        a.append(1.0)
        return a

#? float()
blub()[0]

# with else clause
def blub():
    if random.choice([0, 1]):
         1
    else:
        a = []
        a.append(1)
        return a

#? int()
blub()[0]
# -----------------
# returns, the same for classes
# -----------------
class C():
    def blub(self, b):
        if 1:
            a = []
            a.append(b)
            return a

    def blub2(self):
        """ mapper function """
        a = self.blub(1.0)
        #? float()
        a[0]
        return a

    def literal_arr(self, el):
        self.a = []
        self.a.append(el)
        #? int()
        self.a[0]
        return self.a

    def list_arr(self, el):
        self.b = list([])
        self.b.append(el)
        #? float()
        self.b[0]
        return self.b

#? int()
C().blub(1)[0]
#? float()
C().blub2(1)[0]

#? int()
C().a[0]
#? int()
C().literal_arr(1)[0]

#? float()
C().b[0]
#? float()
C().list_arr(1.0)[0]

# -----------------
# array recursions
# -----------------

a = set([1.0])
a.update(a)
a.update([1])

#? float() int()
list(a)[0]

def first(a):
    b = []
    b.append(a)
    b.extend(second(a))
    return list(b)

def second(a):
    b = []
    b.extend(first(a))
    return list(b)

#? float()
first(1.0)[0]

def third():
    b = []
    b.extend
    extend()
    b.extend(first())
    return list(b)
#? 
third()[0]


# -----------------
# set.add
# -----------------
st = {1.0}
for a in [1,2]:
    st.add(a)

st.append('')  # lists should not have an influence

st.add  # should not cause an exception
st.add()

st = {1.0}
st.add(1)
lst = list(st)

lst.append('')

#? float() int() str()
lst[0]

# -----------------
# list setitem
# -----------------

some_lst = [int]
some_lst[3] = str
#? int
some_lst[0]
#? str
some_lst[3]
#? int str
some_lst[2]

some_lst[0] = tuple
#? tuple
some_lst[0]
#? int str tuple
some_lst[1]

some_lst2 = list([1])
some_lst2[3] = ''
#? int() str()
some_lst2[0]
#? str()
some_lst2[3]
#? int() str()
some_lst2[2]

some_lst3 = []
some_lst3[0] = 3
some_lst3[:] = ''  # Is ignored for now.
#? int()
some_lst3[0]
# -----------------
# set setitem/other modifications (should not work)
# -----------------

some_set = {int}
some_set[3] = str
#? int
some_set[0]
#? int
some_set[3]

something = object()
something[3] = str
#? 
something[0]
#?
something[3]

# -----------------
# dict setitem
# -----------------

some_dct = {'a': float, 1: int}
some_dct['x'] = list
some_dct['y'] = tuple
#? list
some_dct['x']
#? int float list tuple
some_dct['unknown']
#? float
some_dct['a']

some_dct = dict({'a': 1, 1: ''})
#? int() str()
some_dct['la']
#? int()
some_dct['a']

some_dct['x'] = list
some_dct['y'] = tuple
#? list
some_dct['x']
#? int() str() list tuple
some_dct['unknown']
k = 'a'
#? int()
some_dct[k]

some_other_dct = dict(some_dct, c=set)
#? int()
some_other_dct['a']
#? list
some_other_dct['x']
#? set
some_other_dct['c']
