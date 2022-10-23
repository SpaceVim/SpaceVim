# -------------------------------------------------- simple-1
def test():
    #? 35 text {'new_name': 'a'}
    return test(100, (30 + b, c) + 1)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def test():
    #? 35 text {'new_name': 'a'}
    a = (30 + b, c) + 1
    return test(100, a)
# -------------------------------------------------- simple-2
def test():
    #? 25 text {'new_name': 'a'}
    return test(100, (30 + b, c) + 1)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def test():
    #? 25 text {'new_name': 'a'}
    a = 30 + b
    return test(100, (a, c) + 1)
# -------------------------------------------------- simple-3
foo = 3.1
#? 8 text {'new_name': 'bar'}
x = int(foo + 1)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
foo = 3.1
#? 8 text {'new_name': 'bar'}
bar = foo + 1
x = int(bar)
# -------------------------------------------------- simple-4
#? 13 text {'new_name': 'zzx.x'}
test(100, {1  |1: 2 + 3})
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 13 text {'new_name': 'zzx.x'}
zzx.x = 1  |1
test(100, {zzx.x: 2 + 3})
# -------------------------------------------------- multiline-1
def test():
    #? 30 text {'new_name': 'x'}
    return test(1, (30 + b, c) 
                            + 1)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def test():
    #? 30 text {'new_name': 'x'}
    x = (30 + b, c) 
                                + 1
    return test(1, x)
# -------------------------------------------------- multiline-2
def test():
    #? 25 text {'new_name': 'x'}
    return test(1, (30 + b, c) 
                            + 1)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
def test():
    #? 25 text {'new_name': 'x'}
    x = 30 + b
    return test(1, (x, c) 
                            + 1)
# -------------------------------------------------- for-param-error-1
#? 10 error {'new_name': 'x'}
def test(p1):
    return
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a name that defines something
# -------------------------------------------------- for-param-error-2
#? 12 error {'new_name': 'x'}
def test(p1= 3):
    return
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a "param"
# -------------------------------------------------- for-param-1
#? 12 text {'new_name': 'x'}
def test(p1=20):
    return
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 12 text {'new_name': 'x'}
x = 20
def test(p1=x):
    return
# -------------------------------------------------- for-something
#? 12 text {'new_name': 'x'}
def test(p1=20):
    return
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 12 text {'new_name': 'x'}
x = 20
def test(p1=x):
    return
# -------------------------------------------------- class-inheritance-1
#? 12 text {'new_name': 'x'}
class Foo(foo.Bar):
    pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 12 text {'new_name': 'x'}
x = foo.Bar
class Foo(x):
    pass
# -------------------------------------------------- class-inheritance-2
#? 16 text {'new_name': 'x'}
class Foo(foo.Bar):
    pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 16 text {'new_name': 'x'}
x = foo.Bar
class Foo(x):
    pass
# -------------------------------------------------- keyword-pass
#? 12 error {'new_name': 'x'}
def x(): pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a "simple_stmt"
# -------------------------------------------------- keyword-continue
#? 5 error {'new_name': 'x'}
continue
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a "simple_stmt"
# -------------------------------------------------- keyword-None
if 1:
    #? 4 text {'new_name': 'x'}
    None
# ++++++++++++++++++++++++++++++++++++++++++++++++++
if 1:
    #? 4 text {'new_name': 'x'}
    x = None
    x
# -------------------------------------------------- with-tuple
#? 4 text {'new_name': 'x'}
x +  1, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 4 text {'new_name': 'x'}
x = x +  1
x, 3
# -------------------------------------------------- range-1
#? 4 text {'new_name': 'x', 'until_column': 9}
y +  1, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 4 text {'new_name': 'x', 'until_column': 9}
x = y +  1, 3
x
# -------------------------------------------------- range-2
#? 1 text {'new_name': 'x', 'until_column': 3}
y +  1, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 1 text {'new_name': 'x', 'until_column': 3}
x = y +  1
x, 3
# -------------------------------------------------- range-3
#? 1 text {'new_name': 'x', 'until_column': 6}
y +  1, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 1 text {'new_name': 'x', 'until_column': 6}
x = y +  1
x, 3
# -------------------------------------------------- range-4
#? 1 text {'new_name': 'x', 'until_column': 1}
y +  1, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 1 text {'new_name': 'x', 'until_column': 1}
x = y
x +  1, 3
# -------------------------------------------------- addition-1
#? 4 text {'new_name': 'x', 'until_column': 9}
z = y + 1 + 2+ 3, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 4 text {'new_name': 'x', 'until_column': 9}
x = y + 1
z = x + 2+ 3, 3
# -------------------------------------------------- addition-2
#? 8 text {'new_name': 'x', 'until_column': 12}
z = y +1 + 2+ 3, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 8 text {'new_name': 'x', 'until_column': 12}
x = 1 + 2
z = y +x+ 3, 3
# -------------------------------------------------- addition-3
#? 10 text {'new_name': 'x', 'until_column': 14}
z = y + 1 + 2+ 3, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 10 text {'new_name': 'x', 'until_column': 14}
x = 1 + 2+ 3
z = y + x, 3
# -------------------------------------------------- addition-4
#? 13 text {'new_name': 'x', 'until_column': 17}
z = y + (1 + 2)+ 3, 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 13 text {'new_name': 'x', 'until_column': 17}
x = (1 + 2)+ 3
z = y + x, 3
# -------------------------------------------------- mult-add-1
#? 8 text {'new_name': 'x', 'until_column': 11}
z = foo(y+1*2+3, 3)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 8 text {'new_name': 'x', 'until_column': 11}
x = y+1
z = foo(x*2+3, 3)
# -------------------------------------------------- mult-add-2
#? 12 text {'new_name': 'x', 'until_column': 15}
z = foo(y+1*2+3)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 12 text {'new_name': 'x', 'until_column': 15}
x = 2+3
z = foo(y+1*x)
# -------------------------------------------------- mult-add-3
#? 9 text {'new_name': 'x', 'until_column': 13}
z = (y+1*2+3)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 9 text {'new_name': 'x', 'until_column': 13}
x = (y+1*2+3)
z = x
# -------------------------------------------------- extract-weird-1
#? 0 error {'new_name': 'x', 'until_column': 7}
foo = 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a "expr_stmt"
# -------------------------------------------------- extract-weird-2
#? 0 error {'new_name': 'x', 'until_column': 5}
def x():
    foo = 3
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a "funcdef"
# -------------------------------------------------- extract-weird-3
def x():
#? 4 error {'new_name': 'x', 'until_column': 8}
    if 1:
        pass
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a "if_stmt"
# -------------------------------------------------- extract-weird-4
#? 4 error {'new_name': 'x', 'until_column': 7}
x = foo = 4
# ++++++++++++++++++++++++++++++++++++++++++++++++++
Cannot extract a name that defines something
# -------------------------------------------------- keyword-None
#? 4 text {'new_name': 'x', 'until_column': 7}
yy = not foo or bar
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 4 text {'new_name': 'x', 'until_column': 7}
x = not foo
yy = x or bar
# -------------------------------------------------- augassign
yy = ()
#? 6 text {'new_name': 'x', 'until_column': 10}
yy += 3, 4
# ++++++++++++++++++++++++++++++++++++++++++++++++++
yy = ()
#? 6 text {'new_name': 'x', 'until_column': 10}
x = 3, 4
yy += x
# -------------------------------------------------- if-else
#? 9 text {'new_name': 'x', 'until_column': 22}
yy = foo(a if y else b)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 9 text {'new_name': 'x', 'until_column': 22}
x = a if y else b
yy = foo(x)
# -------------------------------------------------- lambda
#? 8 text {'new_name': 'x', 'until_column': 17}
y = foo(lambda x: 3, 5)
# ++++++++++++++++++++++++++++++++++++++++++++++++++
#? 8 text {'new_name': 'x', 'until_column': 17}
x = lambda x: 3
y = foo(x, 5)
