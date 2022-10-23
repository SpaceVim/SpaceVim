import os
import sys

import pytest


class SomeClass:
    class SomeClass:
        def twice(self, a):
            something = os
            return something

    def twice(self, b):
        pass

    def some_function():
        pass


@pytest.mark.parametrize(
    'string, descriptions, kwargs', [
        # No completions
        ('SomeClass', ['class SomeClass'], {}),
        ('SomeClass', ['class SomeClass', 'class SomeClass.SomeClass'], dict(all_scopes=True)),
        ('Some', [], dict(all_scopes=True)),
        ('os', ['module os'], {}),
        ('sys', ['module sys'], {}),
        ('sys.path', ['statement sys.path'], {}),
        ('sys.exit', ['function sys.exit'], {}),
        ('something', [], {}),
        ('something', ['statement SomeClass.SomeClass.twice.something'], dict(all_scopes=True)),

        # Completions
        ('class Some', ['class SomeClass', 'class SomeClass.SomeClass'],
         dict(all_scopes=True, complete=True)),
        ('class Some', ['class SomeClass'], dict(complete=True)),
        ('Some', ['class SomeClass', 'class SomeClass.SomeClass',
                  'statement SomeClass.SomeClass.twice.something',
                  'function SomeClass.some_function'], dict(all_scopes=True, complete=True)),
        ('some', ['class SomeClass', 'class SomeClass.SomeClass',
                  'statement SomeClass.SomeClass.twice.something',
                  'function SomeClass.some_function'], dict(all_scopes=True, complete=True)),

        # Fuzzy
        ('class Smelss', ['class SomeClass'], dict(complete=True, fuzzy=True)),
        ('class Smelss', ['class SomeClass', 'class SomeClass.SomeClass'],
         dict(complete=True, fuzzy=True, all_scopes=True)),

        # Nested
        ('SomeClass.SomeClass', ['class SomeClass.SomeClass'],
         dict(all_scopes=True)),
        ('SomeClass.SomeClass.twice', ['function SomeClass.SomeClass.twice'],
         dict(all_scopes=True)),
        ('SomeClass.SomeClass.twice.__call__', ['function types.FunctionType.__call__'],
         dict(all_scopes=True)),
        ('SomeClass.SomeClass.twice.something', [], dict(all_scopes=True)),
        ('SomeClass.twice', ['function SomeClass.twice', 'function SomeClass.SomeClass.twice'],
         dict(all_scopes=True)),

        # Nested completions
        ('SomeClass.twi', ['function SomeClass.twice', 'function SomeClass.SomeClass.twice'],
         dict(all_scopes=True, complete=True)),

        # Fuzzy unfortunately doesn't work
        ('SomeCl.twice', [], dict(all_scopes=True, complete=True, fuzzy=True)),
    ]
)
def test_simple_search(Script, string, descriptions, kwargs):
    if kwargs.pop('complete', False) is True:
        defs = Script(path=__file__).complete_search(string, **kwargs)
    else:
        defs = Script(path=__file__).search(string, **kwargs)
    this_mod = 'test.test_api.test_search.'
    assert [d.type + ' ' + d.full_name.replace(this_mod, '') for d in defs] == descriptions


@pytest.mark.parametrize(
    'string, completions, fuzzy, all_scopes', [
        ('SomeCl', ['ass'], False, False),
        ('SomeCl', [None], True, False),
        ('twic', [], False, False),
        ('some_f', [], False, False),
        ('twic', ['e', 'e'], False, True),
        ('some_f', ['unction'], False, True),
    ]
)
def test_complete_search(Script, string, completions, fuzzy, all_scopes):
    defs = Script(path=__file__).complete_search(string, fuzzy=fuzzy, all_scopes=all_scopes)
    assert [d.complete for d in defs] == completions
