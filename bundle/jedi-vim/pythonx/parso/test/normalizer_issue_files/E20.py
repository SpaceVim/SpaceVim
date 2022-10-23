#: E201:5
spam( ham[1], {eggs: 2})
#: E201:9
spam(ham[ 1], {eggs: 2})
#: E201:14
spam(ham[1], { eggs: 2})

# Okay
spam(ham[1], {eggs: 2})


#: E202:22
spam(ham[1], {eggs: 2} )
#: E202:21
spam(ham[1], {eggs: 2 })
#: E202:10
spam(ham[1 ], {eggs: 2})
# Okay
spam(ham[1], {eggs: 2})

result = func(
    arg1='some value',
    arg2='another value',
)

result = func(
    arg1='some value',
    arg2='another value'
)

result = [
    item for item in items
    if item > 5
]

#: E203:9
if x == 4 :
    foo(x, y)
    x, y = y, x
if x == 4:
    #: E203:12 E702:13
    a = x, y ; x, y = y, x
if x == 4:
    foo(x, y)
    #: E203:12
    x, y = y , x
# Okay
if x == 4:
    foo(x, y)
    x, y = y, x
a[b1, :1] == 3
b = a[:, b1]
