
import sys
import os
from os.path import dirname

sys.path.insert(0, '../../jedi')
sys.path.append(os.path.join(dirname(__file__), 'thirdparty'))

# modifications, that should fail:
# syntax err
sys.path.append('a' +* '/thirdparty')

#? ['inference']
import inference

#? ['inference_state_function_cache']
inference.inference_state_fu

# Those don't work because dirname and abspath are not properly understood.
#? ['jedi_']
import jedi_

#? ['el']
jedi_.el
