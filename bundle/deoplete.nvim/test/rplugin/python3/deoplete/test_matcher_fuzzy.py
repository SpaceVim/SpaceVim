from deoplete.filter.matcher_fuzzy import Filter


def _ctx(complete_str, ignorecase=True, camelcase=True):
    _candidates = [
        { 'word': 'foobar' },
        { 'word': 'afoobar' },
        { 'word': 'fooBar' },
        { 'word': 'afooBar' },
        { 'word': 'Foobar' },
        { 'word': 'aFoobar' },
        { 'word': 'FooBar' },
        { 'word': 'aFooBar' },
    ]

    return {
        'complete_str' : complete_str,
        'ignorecase'   : ignorecase,
        'camelcase'    : camelcase,
        'is_sorted'    : False,
        'candidates'   : _candidates
    }


def test_matcher_fuzzy():
    f = Filter(None)

    assert f.name == 'matcher_fuzzy'
    assert f.description == 'fuzzy matcher'

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
        { 'word': 'fooBar' },
        { 'word': 'Foobar' },
        { 'word': 'FooBar' },
    ]

    ctx = _ctx('foBr', ignorecase=False)
    assert f.filter(ctx) == [
        { 'word': 'fooBar' },
        { 'word': 'FooBar' },
    ]

    ctx = _ctx('fobr', camelcase=False)
    assert f.filter(ctx) == [
        { 'word': 'foobar' },
        { 'word': 'fooBar' },
        { 'word': 'Foobar' },
        { 'word': 'FooBar' },
    ]

    ctx = _ctx('fobr', ignorecase=False, camelcase=False)
    assert f.filter(ctx) == [
        { 'word': 'foobar' },
    ]
