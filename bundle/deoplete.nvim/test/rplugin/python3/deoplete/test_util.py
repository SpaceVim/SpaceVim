import deoplete.util as util


def test_pos():
    assert util.bytepos2charpos('utf-8', 'foo bar', 3) == 3
    assert util.bytepos2charpos('utf-8', 'あああ', 3) == 1
    assert util.charpos2bytepos('utf-8', 'foo bar', 3) == 3
    assert util.charpos2bytepos('utf-8', 'あああ', 3) == 9


def test_custom():
    custom = {'source':{}}
    custom['source'] = {'_': {'mark': ''}, 'java': {'converters': []}}
    assert util.get_custom(custom, 'java', 'mark', 'foobar') == ''
    assert util.get_custom(custom, 'java', 'converters', 'foobar') == []
    assert util.get_custom(custom, 'foo', 'mark', 'foobar') == ''
    assert util.get_custom(custom, 'foo', 'converters', 'foobar') == 'foobar'


def test_globruntime():
    assert util.globruntime('/usr', 'bin') == ['/usr/bin']


def test_binary_search():
    assert util.binary_search_begin([], '') == -1
    assert util.binary_search_begin([{'word': 'abc'}], 'abc') == 0
    assert util.binary_search_begin([
        {'word': 'aaa'}, {'word': 'abc'},
    ], 'abc') == 1
    assert util.binary_search_begin([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'abc'},
    ], 'abc') == 2
    assert util.binary_search_begin([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'AbC'},
    ], 'abc') == 2
    assert util.binary_search_begin([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'abc'},
    ], 'b') == -1
    assert util.binary_search_begin([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'aac'}, {'word': 'abc'},
    ], 'aa') == 1

    assert util.binary_search_end([], '') == -1
    assert util.binary_search_end([{'word': 'abc'}], 'abc') == 0
    assert util.binary_search_end([
        {'word': 'aaa'}, {'word': 'abc'},
    ], 'abc') == 1
    assert util.binary_search_end([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'abc'},
    ], 'abc') == 2
    assert util.binary_search_end([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'abc'},
    ], 'b') == -1
    assert util.binary_search_end([
        {'word': 'a'}, {'word': 'aaa'}, {'word': 'aac'}, {'word': 'abc'},
    ], 'aa') == 2


def test_uniq_list_dict():
    assert util.uniq_list_dict([
        {'abbr': 'word', 'word': 'foobar'},
        {'word': 'bar'},
        {'word': 'foobar', 'abbr': 'word'},
        {'word': 'baz'},
    ]) == [
        {'word': 'foobar', 'abbr': 'word'},
        {'word': 'bar'},
        {'word': 'baz'}
    ]
