import jedi
from jedi import debug

def test_simple():
    jedi.set_debug_function()
    debug.speed('foo')
    debug.dbg('bar')
    debug.warning('baz')
    jedi.set_debug_function(None, False, False, False)
