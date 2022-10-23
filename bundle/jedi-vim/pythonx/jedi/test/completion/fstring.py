# python >= 3.6

class Foo:
    bar = 1

#? 10 int()
f'{Foo.bar}'
#? 10 ['bar']
f'{Foo.bar}'
#? 10 int()
Fr'{Foo.bar'
#? 10 ['bar']
Fr'{Foo.bar'
#? int()
Fr'{Foo.bar
#? ['bar']
Fr'{Foo.bar
#? ['Exception']
F"{Excepti

#? 8 Foo
Fr'a{Foo.bar'
#? str()
Fr'sasdf'

#? 7 str()
Fr'''sasdf''' + ''

#? ['upper']
f'xyz'.uppe


#? 3 []
f'f'

# Github #1248
#? int()
{"foo": 1}[f"foo"]
