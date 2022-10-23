"""
Jedi issues warnings for possible errors if ``__getattr__``,
``__getattribute__`` or ``setattr`` are used.
"""

# -----------------
# __getattr*__
# -----------------


class Cls():
    def __getattr__(self, name):
        return getattr(str, name)


Cls().upper

#! 6 warning attribute-error
Cls().undefined


class Inherited(Cls):
    pass

Inherited().upper

#! 12 warning attribute-error
Inherited().undefined

# -----------------
# setattr
# -----------------


class SetattrCls():
    def __init__(self, dct):
        # Jedi doesn't even try to understand such code
        for k, v in dct.items():
            setattr(self, k, v)

        self.defined = 3

c = SetattrCls({'a': 'b'})
c.defined
#! 2 warning attribute-error
c.undefined
