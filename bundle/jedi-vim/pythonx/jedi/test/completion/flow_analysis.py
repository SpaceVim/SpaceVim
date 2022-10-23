# -----------------
# First a few name resolution things
# -----------------

x = 3
if NOT_DEFINED:
    x = ''
#? 6 int()
elif x:
    pass
else:
    #? int()
    x

x = 1
try:
    x = ''
#? 8 int() str()
except x:
    #? 5 int() str()
    x
    x = 1.0
else:
    #? 5 int() str()
    x
    x = list
finally:
    #? 5 int() str() float() list
    x
    x = tuple

if False:
    with open("") as defined_in_false:
        #? ['flush']
        defined_in_false.flu

# -----------------
# Return checks
# -----------------

def foo(x):
    if 1.0:
        return 1
    else:
        return ''

#? int()
foo(1)


#  Exceptions are not analyzed. So check both if branches
def try_except(x):
    try:
        if 0:
            return 1
        else:
            return ''
    except AttributeError:
        return 1.0

#? float() str()
try_except(1)


#  Exceptions are not analyzed. So check both if branches
def try_except(x):
    try:
        if 0:
            return 1
        else:
            return ''
    except AttributeError:
        return 1.0

#? float() str()
try_except(1)

def test_function():
    a = int(input())
    if a % 2 == 0:
        return True
    return "False"

#? bool() str()
test_function()

# -----------------
# elif
# -----------------

def elif_flows1(x):
    if False:
        return 1
    elif True:
        return 1.0
    else:
        return ''

#? float()
elif_flows1(1)


def elif_flows2(x):
    try:
        if False:
            return 1
        elif 0:
            return 1.0
        else:
            return ''
    except ValueError:
        return set

#? str() set
elif_flows2(1)


def elif_flows3(x):
    try:
        if True:
            return 1
        elif 0:
            return 1.0
        else:
            return ''
    except ValueError:
        return set

#? int() set
elif_flows3(1)

# -----------------
# mid-difficulty if statements
# -----------------
def check(a):
    if a is None:
        return 1
    return ''
    return set

#? int()
check(None)
#? str()
check('asb')

a = list
if 2 == True:
    a = set
elif 1 == True:
    a = 0

#? int()
a
if check != 1:
    a = ''
#? int() str()
a
if check == check:
    a = list
#? list
a
if check != check:
    a = set
else:
    a = dict
#? dict
a
if not (check is not check):
    a = 1
#? int()
a


# -----------------
# name resolution
# -----------------

a = list
def elif_name(x):
    try:
        if True:
            a = 1
        elif 0:
            a = 1.0
        else:
            return ''
    except ValueError:
        a = x
    return a

#? int() set
elif_name(set)

if 0:
    a = ''
else:
    a = int

#? int
a

# -----------------
# isinstance
# -----------------

class A(): pass

def isinst(x):
    if isinstance(x, A):
        return dict
    elif isinstance(x, int) and x == 1 or x is True:
        return set
    elif isinstance(x, (float, reversed)):
        return list
    elif not isinstance(x, str):
        return tuple
    return 1

#? dict
isinst(A())
#? set
isinst(True)
#? set
isinst(1)
#? tuple
isinst(2)
#? list
isinst(1.0)
#? tuple
isinst(False)
#? int()
isinst('')

# -----------------
# flows that are not reachable should be able to access parent scopes.
# -----------------

foobar = ''

if 0:
    within_flow = 1.0
    #? float()
    within_flow
    #? str()
    foobar
    if 0:
        nested = 1
        #? int()
        nested
        #? float()
        within_flow
        #? str()
        foobar
    #?
    nested

if False:
    in_false = 1
    #? ['in_false']
    in_false

# -----------------
# True objects like modules
# -----------------

class X():
    pass
if X:
    a = 1
else:
    a = ''
#? int()
a


# -----------------
# Recursion issues
# -----------------

def possible_recursion_error(filename):
    if filename == 'a':
        return filename
    # It seems like without the brackets there wouldn't be a RecursionError.
    elif type(filename) == str:
        return filename


if NOT_DEFINED:
    s = str()
else:
    s = str()
#? str()
possible_recursion_error(s)


# -----------------
# In combination with imports
# -----------------

from import_tree import flow_import

if 1 == flow_import.env:
    a = 1
elif 2 == flow_import.env:
    a = ''
elif 3 == flow_import.env:
    a = 1.0

#? int() str()
a
