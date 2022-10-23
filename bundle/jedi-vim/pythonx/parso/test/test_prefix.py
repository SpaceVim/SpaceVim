from itertools import zip_longest
from codecs import BOM_UTF8

import pytest

import parso

unicode_bom = BOM_UTF8.decode('utf-8')


@pytest.mark.parametrize(('string', 'tokens'), [
    ('', ['']),
    ('#', ['#', '']),
    (' # ', ['# ', '']),
    (' # \n', ['# ', '\n', '']),
    (' # \f\n', ['# ', '\f', '\n', '']),
    ('  \n', ['\n', '']),
    ('  \n ', ['\n', ' ']),
    (' \f ', ['\f', ' ']),
    (' \f ', ['\f', ' ']),
    (' \r\n', ['\r\n', '']),
    (' \r', ['\r', '']),
    ('\\\n', ['\\\n', '']),
    ('\\\r\n', ['\\\r\n', '']),
    ('\t\t\n\t', ['\n', '\t']),
])
def test_simple_prefix_splitting(string, tokens):
    tree = parso.parse(string)
    leaf = tree.children[0]
    assert leaf.type == 'endmarker'

    parsed_tokens = list(leaf._split_prefix())
    start_pos = (1, 0)
    for pt, expected in zip_longest(parsed_tokens, tokens):
        assert pt.value == expected

        # Calculate the estimated end_pos
        if expected.endswith('\n') or expected.endswith('\r'):
            end_pos = start_pos[0] + 1, 0
        else:
            end_pos = start_pos[0], start_pos[1] + len(expected) + len(pt.spacing)

        # assert start_pos == pt.start_pos
        assert end_pos == pt.end_pos
        start_pos = end_pos


@pytest.mark.parametrize(('string', 'types'), [
    ('# ', ['comment', 'spacing']),
    ('\r\n', ['newline', 'spacing']),
    ('\f', ['formfeed', 'spacing']),
    ('\\\n', ['backslash', 'spacing']),
    (' \t', ['spacing']),
    (' \t ', ['spacing']),
    (unicode_bom + ' # ', ['bom', 'comment', 'spacing']),
])
def test_prefix_splitting_types(string, types):
    tree = parso.parse(string)
    leaf = tree.children[0]
    assert leaf.type == 'endmarker'
    parsed_tokens = list(leaf._split_prefix())
    assert [t.type for t in parsed_tokens] == types


def test_utf8_bom():
    tree = parso.parse(unicode_bom + 'a = 1')
    expr_stmt = tree.children[0]
    assert expr_stmt.start_pos == (1, 0)

    tree = parso.parse(unicode_bom + '\n')
    endmarker = tree.children[0]
    parts = list(endmarker._split_prefix())
    assert [p.type for p in parts] == ['bom', 'newline', 'spacing']
    assert [p.start_pos for p in parts] == [(1, 0), (1, 0), (2, 0)]
    assert [p.end_pos for p in parts] == [(1, 0), (2, 0), (2, 0)]
