"""
Code that might cause recursion issues (or has caused in the past).
"""

def Recursion():
    def recurse(self):
        self.a = self.a
        self.b = self.b.recurse()

#?
Recursion().a

#?
Recursion().b


class X():
    def __init__(self):
        self.recursive = [1, 3]

    def annoying(self):
        self.recursive = [self.recursive[0]]

    def recurse(self):
        self.recursive = [self.recursive[1]]

#? int()
X().recursive[0]


def to_list(iterable):
    return list(set(iterable))


def recursion1(foo):
    return to_list(to_list(foo)) + recursion1(foo)

#? int()
recursion1([1,2])[0]


class FooListComp():
    def __init__(self):
        self.recursive = [1]

    def annoying(self):
        self.recursive = [x for x in self.recursive]


#? int()
FooListComp().recursive[0]


class InstanceAttributeIfs:
    def b(self):
        self.a1 = 1
        self.a2 = 1

    def c(self):
        self.a2 = ''

    def x(self):
        self.b()

        if self.a1 == 1:
            self.a1 = self.a1 + 1
        if self.a2 == UNDEFINED:
            self.a2 = self.a2 + 1

        #? int()
        self.a1
        #? int() str()
        self.a2

#? int()
InstanceAttributeIfs().a1
#? int() str()
InstanceAttributeIfs().a2



class A:
    def a(self, b):
        for x in [self.a(i) for i in b]:
            #?
            x

class B:
    def a(self, b):
        for i in b:
            for i in self.a(i):
                #?
                yield i


foo = int
foo = foo  # type: foo
#? int
foo

while True:
    bar = int
    bar = bar  # type: bar
    #? int()
    bar


class Comprehension:
    def __init__(self, foo):
        self.foo = foo

    def update(self):
        self.foo = (self.foo,)


#? int() tuple()
Comprehension(1).foo[0]
