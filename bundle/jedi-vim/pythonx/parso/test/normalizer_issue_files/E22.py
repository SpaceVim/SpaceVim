a = 12 + 3
#: E221:5 E229:8
b = 4  + 5
#: E221:1
x             = 1
#: E221:1
y             = 2
long_variable = 3
#: E221:4
x[0]          = 1
#: E221:4
x[1]          = 2
long_variable = 3
#: E221:8 E229:19
x = f(x)          + 1
y = long_variable + 2
#: E221:8 E229:19
z = x[0]          + 3
#: E221+2:13
text = """
    bar
    foo %s"""  % rofl
# Okay
x = 1
y = 2
long_variable = 3


#: E221:7
a = a +  1
b = b + 10
#: E221:3
x =            -1
#: E221:3
y =            -2
long_variable = 3
#: E221:6
x[0] =          1
#: E221:6
x[1] =          2
long_variable = 3


#: E223+1:1
foobart = 4
a	= 3  # aligned with tab


#: E223:4
a +=	1
b += 1000


#: E225:12
submitted +=1
#: E225:9
submitted+= 1
#: E225:3
c =-1
#: E229:7
x = x /2 - 1
#: E229:11
c = alpha -4
#: E229:10
c = alpha- 4
#: E229:8
z = x **y
#: E229:14
z = (x + 1) **y
#: E229:13
z = (x + 1)** y
#: E227:14
_1kB = _1MB >>10
#: E227:11
_1kB = _1MB>> 10
#: E225:1 E225:2 E229:4
i=i+ 1
#: E225:1 E225:2 E229:5
i=i +1
#: E225:1 E225:2
i=i+1
#: E225:3
i =i+1
#: E225:1
i= i+1
#: E229:8
c = (a +b)*(a - b)
#: E229:7
c = (a+ b)*(a - b)

z = 2//30
c = (a+b) * (a-b)
x = x*2 - 1
x = x/2 - 1
# TODO whitespace should be the other way around according to pep8.
x = x / 2-1

hypot2 = x*x + y*y
c = (a + b)*(a - b)


def halves(n):
    return (i//2 for i in range(n))


#: E227:11 E227:13
_1kB = _1MB>>10
#: E227:11 E227:13
_1MB = _1kB<<10
#: E227:5 E227:6
a = b|c
#: E227:5 E227:6
b = c&a
#: E227:5 E227:6
c = b^a
#: E228:5 E228:6
a = b%c
#: E228:9 E228:10
msg = fmt%(errno, errmsg)
#: E228:25 E228:26
msg = "Error %d occurred"%errno

#: E228:7
a = b %c
a = b % c

# Okay
i = i + 1
submitted += 1
x = x * 2 - 1
hypot2 = x * x + y * y
c = (a + b) * (a - b)
_1MiB = 2 ** 20
_1TiB = 2**30
foo(bar, key='word', *args, **kwargs)
baz(**kwargs)
negative = -1
spam(-1)
-negative
func1(lambda *args, **kw: (args, kw))
func2(lambda a, b=h[:], c=0: (a, b, c))
if not -5 < x < +5:
    #: E227:12
    print >>sys.stderr, "x is out of range."
print >> sys.stdout, "x is an integer."
x = x / 2 - 1


def squares(n):
    return (i**2 for i in range(n))


ENG_PREFIXES = {
    -6: "\u03bc",  # Greek letter mu
    -3: "m",
}
