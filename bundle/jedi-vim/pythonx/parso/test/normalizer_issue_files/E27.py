# Okay
from u import (a, b)
from v import c, d
#: E221:13
from w import  (e, f)
#: E275:13
from w import(e, f)
#: E275:29
from importable.module import(e, f)
try:
    #: E275:33
    from importable.module import(e, f)
except ImportError:
    pass
# Okay
True and False
#: E221:8
True and  False
#: E221:4
True  and False
#: E221:2
if   1:
    pass
# Syntax Error, no indentation
#: E903+1
if   1:
pass
#: E223:8
True and		False
#: E223:4 E223:9
True		and	False
#: E221:5
a and  b
#: E221:5
1 and  b
#: E221:5
a and  2
#: E221:1 E221:6
1  and  b
#: E221:1 E221:6
a  and  2
#: E221:4
this  and False
#: E223:5
a and	b
#: E223:1
a		and b
#: E223:4 E223:9
this		and	False
