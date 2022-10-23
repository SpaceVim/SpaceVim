#: E721:3
if type(res) == type(42):
    pass
#: E721:3
if type(res) != type(""):
    pass

import types

if res == types.IntType:
    pass

import types

#: E721:3
if type(res) is not types.ListType:
    pass
#: E721:7 E721:35
assert type(res) == type(False) or type(res) == type(None)
#: E721:7
assert type(res) == type([])
#: E721:7
assert type(res) == type(())
#: E721:7
assert type(res) == type((0,))
#: E721:7
assert type(res) == type((0))
#: E721:7
assert type(res) != type((1,))
#: E721:7
assert type(res) is type((1,))
#: E721:7
assert type(res) is not type((1,))

# Okay
#: E402
import types

if isinstance(res, int):
    pass
if isinstance(res, str):
    pass
if isinstance(res, types.MethodType):
    pass

#: E721:3 E721:25
if type(a) != type(b) or type(a) == type(ccc):
    pass
#: E721
type(a) != type(b)
#: E721
1 != type(b)
#: E721
type(b) != 1
1 != 1

try:
    pass
#: E722
except:
    pass
try:
    pass
except Exception:
    pass
#: E722
except:
    pass
# Okay
fake_code = """"
try:
    do_something()
except:
    pass
"""
try:
    pass
except Exception:
    pass
