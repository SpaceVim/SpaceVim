a = 3  # type: str
#? str()
a

b = 3  # type: str but I write more
#? int()
b

c = 3  # type: str # I comment more
#? str()
c

d = "It should not read comments from the next line"
# type: int
#? str()
d

# type: int
e = "It should not read comments from the previous line"
#? str()
e

class BB: pass

def test(a, b):
    a = a  # type: BB
    c = a  # type: str
    d = a
    # type: str
    e = a                 # type: str           # Should ignore long whitespace

    #? BB()
    a
    #? str()
    c
    #? BB()
    d
    #? str()
    e

class AA:
    class BB:
        pass

def test(a):
    # type: (AA.BB) -> None
    #? AA.BB()
    a

def test(a):
    # type: (AA.BB,) -> None
    #? AA.BB()
    a

a,b = 1, 2 # type: str, float
#? str()
a
#? float()
b

class Employee:
    pass

from typing import List, Tuple
x = []   # type: List[Employee]
#? Employee()
x[1]
x, y, z = [], [], []  # type: List[int], List[int], List[str]
#? int()
y[2]
x, y, z = [], [], []  # type: (List[float], List[float], List[BB])
for zi in z:
    #? BB()
    zi

x = [
   1,
   2,
]  # type: List[str]

#? str()
x[1]


for bar in foo():  # type: str
    #? str()
    bar

for bar, baz in foo():  # type: int, float
    #? int()
    bar
    #? float()
    baz

for bar, baz in foo():
    # type: str, str
    """ type hinting on next line should not work """
    #?
    bar
    #?
    baz

with foo():  # type: int
    ...

with foo() as f:  # type: str
    #? str()
    f

with foo() as f:
    # type: str
    """ type hinting on next line should not work """
    #?
    f

aaa = some_extremely_long_function_name_that_doesnt_leave_room_for_hints() \
    # type: float # We should be able to put hints on the next line with a \
#? float()
aaa

# Test instance methods
class Dog:
    def __init__(self, age, friends, name):
        # type: (int, List[Tuple[str, Dog]], str) -> None
        #? int()
        self.age = age
        self.friends = friends

        #? Dog()
        friends[0][1]

        #? str()
        self.name = name

    def friend_for_name(self, name):
        # type: (str) -> Dog
        for (friend_name, friend) in self.friends:
            if friend_name == name:
                return friend
        raise ValueError()

    def bark(self):
        pass

buddy = Dog(UNKNOWN_NAME1, UNKNOWN_NAME2, UNKNOWN_NAME3)
friend = buddy.friend_for_name('buster')
# type of friend is determined by function return type
#! 9 ['def bark']
friend.bark()

friend = buddy.friends[0][1]
# type of friend is determined by function parameter type
#! 9 ['def bark']
friend.bark()

# type is determined by function parameter type following nested generics
#? str()
friend.name

# Mypy comment describing function return type.
def annot():
    # type: () -> str
    pass

#? str()
annot()

# Mypy variable type annotation.
x = UNKNOWN_NAME2  # type: str

#? str()
x

class Cat(object):
    def __init__(self, age, friends, name):
        # type: (int, List[Dog], str) -> None
        self.age = age
        self.friends = friends
        self.name = name

cat = Cat(UNKNOWN_NAME4, UNKNOWN_NAME5, UNKNOWN_NAME6)
#? str()
cat.name


# Check potential errors
def x(a, b):
    # type: ([) -> a
    #?
    a
def x(a, b):
    # type: (1) -> a
    #?
    a
def x(a, b, c):
    # type: (str) -> a
    #?
    b
    #?
    c
