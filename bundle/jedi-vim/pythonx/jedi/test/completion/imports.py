# -----------------
# own structure
# -----------------

# do separate scopes
def scope_basic():
    from import_tree import mod1

    #? int()
    mod1.a

    #? []
    import_tree.a

    #? []
    import_tree.mod1

    import import_tree
    #? str()
    import_tree.a


def scope_pkg():
    import import_tree.mod1

    #? str()
    import_tree.a

    #? ['mod1']
    import_tree.mod1

    #? int()
    import_tree.mod1.a

def scope_nested():
    import import_tree.pkg.mod1

    #? str()
    import_tree.a

    #? list
    import_tree.pkg.a

    #? ['sqrt']
    import_tree.pkg.sqrt

    #? ['pkg']
    import_tree.p

    #? float()
    import_tree.pkg.mod1.a
    #? ['a', 'foobar', '__name__', '__package__', '__file__', '__doc__']
    a = import_tree.pkg.mod1.

    import import_tree.random
    #? set
    import_tree.random.a

def scope_nested2():
    """Multiple modules should be indexable, if imported"""
    import import_tree.mod1
    import import_tree.pkg
    #? ['mod1']
    import_tree.mod1
    #? ['pkg']
    import_tree.pkg

    # With the latest changes this completion also works, because submodules
    # are always included (some nested import structures lead to this,
    # typically).
    #? ['rename1']
    import_tree.rename1

def scope_from_import_variable():
    """
    All of them shouldn't work, because "fake" imports don't work in python
    without the use of ``sys.modules`` modifications (e.g. ``os.path`` see also
    github issue #213 for clarification.
    """
    a = 3
    #? 
    from import_tree.mod2.fake import a
    #? 
    from import_tree.mod2.fake import c

    #? 
    a
    #? 
    c

def scope_from_import_variable_with_parenthesis():
    from import_tree.mod2.fake import (
        a, foobarbaz
    )

    #? 
    a
    #? 
    foobarbaz
    # shouldn't complete, should still list the name though.
    #? ['foobarbaz']
    foobarbaz


def as_imports():
    from import_tree.mod1 import a as xyz
    #? int()
    xyz
    import not_existant, import_tree.mod1 as foo
    #? int()
    foo.a
    import import_tree.mod1 as bar
    #? int()
    bar.a


def broken_import():
    import import_tree.mod1
    #? import_tree.mod1
    from import_tree.mod1

    #? 25 import_tree.mod1
    import import_tree.mod1.
    #? 25 import_tree.mod1
    impo5t import_tree.mod1.foo
    #? 25 import_tree.mod1
    import import_tree.mod1.foo.
    #? 31 import_tree.mod1
    import json, import_tree.mod1.foo.

    # Cases with ;
    mod1 = 3
    #? 25 int()
    import import_tree; mod1.
    #? 38 import_tree.mod1
    import_tree; import import_tree.mod1.

    #! ['module json']
    from json


def test_import_priorities():
    """
    It's possible to overwrite import paths in an ``__init__.py`` file, by
    just assigining something there.

    See also #536.
    """
    from import_tree import the_pkg, invisible_pkg
    #? int()
    invisible_pkg
    # In real Python, this would be the module, but it's not, because Jedi
    # doesn't care about most stateful issues such as __dict__, which it would
    # need to, to do this in a correct way.
    #? int()
    the_pkg
    # Importing foo is still possible, even though inivisible_pkg got changed.
    #? float()
    from import_tree.invisible_pkg import foo


# -----------------
# std lib modules
# -----------------
import tokenize
#? ['tok_name']
tokenize.tok_name

from pyclbr import *

#? ['readmodule_ex']
readmodule_ex
import os

#? ['dirname']
os.path.dirname

from os.path import (
    expanduser
)

#? os.path.expanduser
expanduser

from itertools import (tee,
                       islice)
#? ['islice']
islice

from functools import (partial, wraps)
#? ['wraps']
wraps

from keyword import kwlist, \
                    iskeyword
#? ['kwlist']
kwlist

#? []
from keyword import not_existing1, not_existing2

from tokenize import io
tokenize.generate_tokens

import socket
#? 14 ['SocketIO']
socket.SocketIO

# -----------------
# builtins
# -----------------

import sys
#? ['prefix']
sys.prefix

#? ['append']
sys.path.append

from math import *
#? ['cos', 'cosh']
cos

def func_with_import():
    import time
    return time

#? ['sleep']
func_with_import().sleep

# -----------------
# relative imports
# -----------------

from .import_tree import mod1
#? int()
mod1.a

from ..import_tree import mod1
#? 
mod1.a

from .......import_tree import mod1
#? 
mod1.a

from .. import helpers
#? int()
helpers.sample_int

from ..helpers import sample_int as f
#? int()
f

from . import run
#? []
run.

from . import import_tree as imp_tree
#? str()
imp_tree.a

from . import datetime as mod1
#? []
mod1.

# self import
# this can cause recursions
from imports import *

# -----------------
# packages
# -----------------

from import_tree.mod1 import c
#? set
c

from import_tree import recurse_class1

#? ['a']
recurse_class1.C.a
# github #239 RecursionError
#? ['a']
recurse_class1.C().a

# -----------------
# Jedi debugging
# -----------------

# memoizing issues (check git history for the fix)
import not_existing_import

if not_existing_import:
    a = not_existing_import
else:
    a = not_existing_import
#? 
a

# -----------------
# module underscore descriptors
# -----------------

def underscore():
    import keyword
    #? ['__file__']
    keyword.__file__
    #? str()
    keyword.__file__

    # Does that also work for our own module?
    #? ['__file__']
    __file__


# -----------------
# complex relative imports #784
# -----------------
def relative():
    #? ['foobar']
    from import_tree.pkg.mod1 import foobar
    #? int()
    foobar
    return 1
