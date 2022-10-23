# For assignment expressions / named expressions / walrus operators / whatever
# they are called.

# python >= 3.8
b = (a:=1, a)

#? int()
b[0]
#?
b[1]

# Should not fail
b = ('':=1,)

#? int()
b[0]

def test_assignments():
    match = ''
    #? str()
    match
    #? 8 int()
    if match := 1:
        #? int()
        match
    #? int()
    match

def test_assignments2():
    class Foo:
        match = ''
    #? str()
    Foo.match
    #? 13 int()
    if Foo.match := 1:
        #? str()
        Foo.match
    #? str()
    Foo.match

    #?
    y
    #? 16 str()
    if y := Foo.match:
        #? str()
        y
    #? str()
    y

    #? 8 str()
    if z := Foo.match:
        pass
