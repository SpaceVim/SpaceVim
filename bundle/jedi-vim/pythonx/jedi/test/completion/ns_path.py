import sys
import os
from os.path import dirname

sys.path.insert(0, os.path.join(dirname(__file__), 'namespace2'))
sys.path.insert(0, os.path.join(dirname(__file__), 'namespace1'))

#? ['mod1']
import pkg1.pkg2.mod1

#? ['mod2']
import pkg1.pkg2.mod2

#? ['mod1_name']
pkg1.pkg2.mod1.mod1_name

#? ['mod2_name']
pkg1.pkg2.mod2.mod2_name
