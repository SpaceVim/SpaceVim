# -----------------
# Simple tests
# -----------------

import random

if random.choice([0, 1]):
    x = ''
else:
    x = 1
if random.choice([0, 1]):
    y = ''
else:
    y = 1

# A simple test
if x != 1:
    x.upper()
else:
    #! 2 attribute-error
    x.upper()
    pass

# This operation is wrong, because the types could be different.
#! 6 type-error-operation
z = x + y
# However, here we have correct types.
if x == y:
    z = x + y
else:
    #! 6 type-error-operation
    z = x + y


# TODO enable this one.
#x = 3
#if x != 1:
#    x.upper()

# -----------------
# With a function
# -----------------

def addition(a, b):
    if type(a) == type(b):
        # Might still be a type error, we might want to change this in the
        # future.
        #! 9 type-error-operation
        return a + b
    else:
        #! 9 type-error-operation
        return a + b

addition(1, 1)
addition(1.0, '')
