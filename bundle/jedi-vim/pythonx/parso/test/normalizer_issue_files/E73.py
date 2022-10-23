#: E731:4
f = lambda x: 2 * x
while False:
    #: E731:10
    foo = lambda y, z: 2 * x
# Okay
f = object()
f.method = lambda: 'Method'

f = {}
f['a'] = lambda x: x ** 2

f = []
f.append(lambda x: x ** 2)

lambda: 'no-op'
