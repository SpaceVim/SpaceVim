#: E401:7
import os, sys
# Okay
import os
import sys

from subprocess import Popen, PIPE

from myclass import MyClass
from foo.bar.yourclass import YourClass

import myclass
import foo.bar.yourclass
# All Okay from here until the definition of VERSION
__all__ = ['abc']

import foo
__version__ = "42"

import foo
__author__ = "Simon Gomizelj"

import foo
try:
    import foo
except ImportError:
    pass
else:
    hello('imported foo')
finally:
    hello('made attempt to import foo')

import bar
VERSION = '1.2.3'

#: E402
import foo
#: E402
import foo
