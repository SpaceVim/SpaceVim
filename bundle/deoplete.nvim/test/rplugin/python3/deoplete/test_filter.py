import deoplete.util as util
from deoplete.filter.converter_remove_overlap import overlap_length


def test_fuzzy_escapse():
    assert util.fuzzy_escape('foo', 0) == 'f[^f]*o[^o]*o[^o]*'
    assert util.fuzzy_escape('foo', 1) == 'f[^f]*o[^o]*o[^o]*'
    assert util.fuzzy_escape('Foo', 1) == 'F[^F]*[oO].*[oO].*'


def test_overlap_length():
    assert overlap_length('foo bar', 'bar baz') == 3
    assert overlap_length('foobar', 'barbaz') == 3
    assert overlap_length('foob', 'baz') == 1
    assert overlap_length('foobar', 'foobar') == 6
    assert overlap_length('тест', 'ст') == len('ст')


def test_charwidth():
    assert util.charwidth('f') == 1
    assert util.charwidth('あ') == 2


def test_strwidth():
    assert util.strwidth('foo bar') == 7
    assert util.strwidth('あいうえ') == 8
    assert util.strwidth('fooあい') == 7


def test_truncate():
    assert util.truncate('foo bar', 3) == 'foo'
    assert util.truncate('fooあい', 5) == 'fooあ'
    assert util.truncate('あいうえ', 4) == 'あい'
    assert util.truncate('fooあい', 4) == 'foo'


def test_skipping():
    assert util.truncate_skipping('foo bar', 3, '..', 3) == '..bar'
    assert util.truncate_skipping('foo bar', 6, '..', 3) == 'f..bar'
    assert util.truncate_skipping('fooあい', 5, '..', 3) == 'f..い'
    assert util.truncate_skipping('あいうえ', 6, '..', 2) == 'あ..え'
