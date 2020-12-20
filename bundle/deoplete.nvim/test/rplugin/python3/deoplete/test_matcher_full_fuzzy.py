from deoplete.filter.matcher_full_fuzzy import Filter
from test_matcher_fuzzy import _ctx


def test_matcher_full_fuzzy():
    f = Filter(None)

    assert f.name == 'matcher_full_fuzzy'
    assert f.description == 'full fuzzy matcher'

    ctx = _ctx('')
    assert f.filter(ctx) == [
        { 'word': 'foobar' },
        { 'word': 'afoobar' },
        { 'word': 'fooBar' },
        { 'word': 'afooBar' },
        { 'word': 'Foobar' },
        { 'word': 'aFoobar' },
        { 'word': 'FooBar' },
        { 'word': 'aFooBar' },
    ]

    ctx = _ctx('FOBR')
    assert f.filter(ctx) == [
        { 'word': 'foobar' },
        { 'word': 'afoobar' },
        { 'word': 'fooBar' },
        { 'word': 'afooBar' },
        { 'word': 'Foobar' },
        { 'word': 'aFoobar' },
        { 'word': 'FooBar' },
        { 'word': 'aFooBar' },
    ]

    ctx = _ctx('foBr', ignorecase=False)
    assert f.filter(ctx) == [
        { 'word': 'fooBar' },
        { 'word': 'afooBar' },
        { 'word': 'FooBar' },
        { 'word': 'aFooBar' },
    ]

    ctx = _ctx('fobr', camelcase=False)
    assert f.filter(ctx) == [
        { 'word': 'foobar' },
        { 'word': 'afoobar' },
        { 'word': 'fooBar' },
        { 'word': 'afooBar' },
        { 'word': 'Foobar' },
        { 'word': 'aFoobar' },
        { 'word': 'FooBar' },
        { 'word': 'aFooBar' },
    ]

    ctx = _ctx('fobr', ignorecase=False, camelcase=False)
    assert f.filter(ctx) == [
        { 'word': 'foobar' },
        { 'word': 'afoobar' },
    ]
