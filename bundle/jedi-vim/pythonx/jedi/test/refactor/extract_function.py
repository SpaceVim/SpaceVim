# -------------------------------------------------- in-module-0
global_var = 3
def x():
    foo = 3.1
    #? 11 text {'new_name': 'bar'}
    x = int(foo + 1 + global_var)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
global_var = 3
def bar(foo):
    return int(foo + 1 + global_var)


def x():
    foo = 3.1
    #? 11 text {'new_name': 'bar'}
    x = bar(foo)
# -------------------------------------------------- in-module-1
glob = 3
#? 11 text {'new_name': 'a'}
test(100, (glob.a + b, c) + 1)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
glob = 3
#? 11 text {'new_name': 'a'}
def a(b):
    return glob.a + b


test(100, (a(b), c) + 1)
# -------------------------------------------------- in-module-2
#? 0 text {'new_name': 'ab'}
100 + 1 * 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 0 text {'new_name': 'ab'}
def ab():
    return 100 + 1 * 2


ab()
# -------------------------------------------------- in-function-1
def f(x):
#? 11 text {'new_name': 'ab'}
    return x + 1 * 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def ab(x):
    return x + 1 * 2


def f(x):
#? 11 text {'new_name': 'ab'}
    return ab(x)
# -------------------------------------------------- in-function-with-dec
@classmethod
def f(x):
#? 11 text {'new_name': 'ab'}
    return x + 1 * 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def ab(x):
    return x + 1 * 2


@classmethod
def f(x):
#? 11 text {'new_name': 'ab'}
    return ab(x)
# -------------------------------------------------- in-method-1
class X:
    def z(self): pass

    def f(x, b):
        #? 11 text {'new_name': 'ab'}
        return x + b * 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
class X:
    def z(self): pass

    def ab(x, b):
        return x + b * 2

    def f(x, b):
        #? 11 text {'new_name': 'ab'}
        return x.ab(b)
# -------------------------------------------------- in-method-2
glob1 = 1
class X:
    def g(self): pass

    def f(self, b, c):
        #? 11 text {'new_name': 'ab'}
        return self.g() or self.f(b) ^ glob1 & b
# ++++++++++++++++++++++++++++++++++++++++++++++++++
glob1 = 1
class X:
    def g(self): pass

    def ab(self, b):
        return self.g() or self.f(b) ^ glob1 & b

    def f(self, b, c):
        #? 11 text {'new_name': 'ab'}
        return self.ab(b)
# -------------------------------------------------- in-method-order
class X:
    def f(self, b, c):
        #? 18 text {'new_name': 'b'}
        return b | self.a
# ++++++++++++++++++++++++++++++++++++++++++++++++++
class X:
    def b(self, b):
        return b | self.a

    def f(self, b, c):
        #? 18 text {'new_name': 'b'}
        return self.b(b)
# -------------------------------------------------- in-classmethod-1
class X:
    @classmethod
    def f(x):
        #? 16 text {'new_name': 'ab'}
        return 25
# ++++++++++++++++++++++++++++++++++++++++++++++++++
class X:
    @classmethod
    def ab(x):
        return 25

    @classmethod
    def f(x):
        #? 16 text {'new_name': 'ab'}
        return x.ab()
# -------------------------------------------------- in-staticmethod-1
class X(int):
    @staticmethod
    def f(x):
        #? 16 text {'new_name': 'ab'}
        return 25 | 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def ab():
    return 25 | 3

class X(int):
    @staticmethod
    def f(x):
        #? 16 text {'new_name': 'ab'}
        return ab()
# -------------------------------------------------- in-class-1
class Ya():
    a = 3
    #? 11 text {'new_name': 'f'}
    c = a + 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def f(a):
    return a + 2


class Ya():
    a = 3
    #? 11 text {'new_name': 'f'}
    c = f(a)
# -------------------------------------------------- in-closure
def x(z):
    def y(x):
        #? 15 text {'new_name': 'f'}
        return -x * z
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def f(x, z):
    return -x * z


def x(z):
    def y(x):
        #? 15 text {'new_name': 'f'}
        return f(x, z)
# -------------------------------------------------- with-range-1
#? 0 text {'new_name': 'a', 'until_line': 4}
v1 = 3
v2 = 2
x = test(v1 + v2 * v3)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 0 text {'new_name': 'a', 'until_line': 4}
def a(test, v3):
    v1 = 3
    v2 = 2
    x = test(v1 + v2 * v3)
    return x


x = a(test, v3)
# -------------------------------------------------- with-range-2
#? 2 text {'new_name': 'a', 'until_line': 6, 'until_column': 4}
#foo
v1 = 3
v2 = 2
x, y = test(v1 + v2 * v3)
#raaaa
y
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 2 text {'new_name': 'a', 'until_line': 6, 'until_column': 4}
def a(test, v3):
    #foo
    v1 = 3
    v2 = 2
    x, y = test(v1 + v2 * v3)
    #raaaa
    return y


y = a(test, v3)
y
# -------------------------------------------------- with-range-3
#foo
#? 2 text {'new_name': 'a', 'until_line': 5, 'until_column': 4}
v1 = 3
v2 = 2
x, y = test(v1 + v2 * v3)
#raaaa
y
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#foo
#? 2 text {'new_name': 'a', 'until_line': 5, 'until_column': 4}
def a(test, v3):
    v1 = 3
    v2 = 2
    x, y = test(v1 + v2 * v3)
    return y


y = a(test, v3)
#raaaa
y
# -------------------------------------------------- with-range-func-1
import os
# comment1
@dec
# comment2
def x(v1):
    #foo
    #? 2 text {'new_name': 'a', 'until_line': 9, 'until_column': 5}
    v2 = 2
    if 1:
        x, y = os.listdir(v1 + v2 * v3)
    #bar
    return x, y
# ++++++++++++++++++++++++++++++++++++++++++++++++++
import os
# comment1
def a(v1, v3):
    v2 = 2
    if 1:
        x, y = os.listdir(v1 + v2 * v3)
    return x, y


@dec
# comment2
def x(v1):
    #foo
    #? 2 text {'new_name': 'a', 'until_line': 9, 'until_column': 5}
    x, y = a(v1, v3)
    #bar
    return x, y
# -------------------------------------------------- with-range-func-2
import os
# comment1
# comment2
def x(v1):
    #? 2 text {'new_name': 'a', 'until_line': 10, 'until_column': 0}
    #foo
    v2 = 2
    if 1:
        x, y = os.listdir(v1 + v2 * v3)
    #bar
    return y
x
# ++++++++++++++++++++++++++++++++++++++++++++++++++
import os
# comment1
# comment2
def a(v1, v3):
    #foo
    v2 = 2
    if 1:
        x, y = os.listdir(v1 + v2 * v3)
    #bar
    return y


def x(v1):
    #? 2 text {'new_name': 'a', 'until_line': 10, 'until_column': 0}
    y = a(v1, v3)
    return y
x
# -------------------------------------------------- with-range-func-3
def x(v1):
    #? 2 text {'new_name': 'func', 'until_line': 6, 'until_column': 4}
    #foo
    v2 = 2
    x = v1 * 2
    y = 3
    #bar
    return x
x
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def func(v1):
    #foo
    v2 = 2
    x = v1 * 2
    return x


def x(v1):
    #? 2 text {'new_name': 'func', 'until_line': 6, 'until_column': 4}
    x = func(v1)
    y = 3
    #bar
    return x
x
# -------------------------------------------------- in-class-range-1
class X1:
    #? 9 text {'new_name': 'f', 'until_line': 4}
    a = 3
    c = a + 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def f():
    a = 3
    c = a + 2
    return c


class X1:
    #? 9 text {'new_name': 'f', 'until_line': 4}
    c = f()
# -------------------------------------------------- in-method-range-1
glob1 = 1
class X:
    # ha
    def g(self): pass

    # haha
    def f(self, b, c):
        #? 11 text {'new_name': 'ab', 'until_line': 12, 'until_column': 28}
        #foo
        local1 = 3
        local2 = 4
        x= self.g() or self.f(b) ^ glob1 & b is local1
        # bar
# ++++++++++++++++++++++++++++++++++++++++++++++++++
glob1 = 1
class X:
    # ha
    def g(self): pass

    # haha
    def ab(self, b):
        #foo
        local1 = 3
        local2 = 4
        x= self.g() or self.f(b) ^ glob1 & b is local1
        return x

    def f(self, b, c):
        #? 11 text {'new_name': 'ab', 'until_line': 12, 'until_column': 28}
        x = self.ab(b)
        # bar
# -------------------------------------------------- in-method-range-2
glob1 = 1
class X:
    # comment

    def f(self, b, c):
        #? 11 text {'new_name': 'ab', 'until_line': 11, 'until_column': 10}
        #foo
        local1 = 3
        local2 = 4
        return local1 * glob1 * b
        # bar
# ++++++++++++++++++++++++++++++++++++++++++++++++++
glob1 = 1
class X:
    # comment

    def ab(self, b):
        #foo
        local1 = 3
        local2 = 4
        return local1 * glob1 * b
        # bar

    def f(self, b, c):
        #? 11 text {'new_name': 'ab', 'until_line': 11, 'until_column': 10}
        return self.ab(b)
# -------------------------------------------------- in-method-range-3
glob1 = 1
class X:
    def f(self, b, c):
        local1, local2 = 3, 4
        #foo
        #? 11 text {'new_name': 'ab', 'until_line': 7, 'until_column': 29}
        return local1 & glob1 & b
        # bar
    local2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
glob1 = 1
class X:
    def ab(self, local1, b):
        return local1 & glob1 & b

    def f(self, b, c):
        local1, local2 = 3, 4
        #foo
        #? 11 text {'new_name': 'ab', 'until_line': 7, 'until_column': 29}
        return self.ab(local1, b)
        # bar
    local2
# -------------------------------------------------- in-method-no-param
glob1 = 1
class X:
    def f():
        #? 11 text {'new_name': 'ab', 'until_line': 5, 'until_column': 22}
        return glob1 + 2
# ++++++++++++++++++++++++++++++++++++++++++++++++++
glob1 = 1
class X:
    def ab():
        return glob1 + 2

    def f():
        #? 11 text {'new_name': 'ab', 'until_line': 5, 'until_column': 22}
        return ab()
# -------------------------------------------------- random-return-1
def x():
    #? 0 error {'new_name': 'ab', 'until_line': 5, 'until_column': 10}
    if x:
        return 1
    return 1
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Can only extract return statements if they are at the end.
# -------------------------------------------------- random-return-2
def x():
    #? 0 error {'new_name': 'ab', 'until_line': 5, 'until_column': 10}
    #
    return
    pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Can only extract return statements if they are at the end.
# -------------------------------------------------- random-yield-1
def x():
    #? 0 error {'new_name': 'ab', 'until_line': 5, 'until_column': 10}
    #
    if (yield 1):
        return
    pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract yield statements.
# -------------------------------------------------- random-yield-2
def x():
    #? 0 error {'new_name': 'ab', 'until_line': 4, 'until_column': 10}
    #
    try:
        yield
    finally:
        pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract yield statements.
