from codecs import BOM_UTF8

from parso.utils import (
    split_lines,
    parse_version_string,
    python_bytes_to_unicode,
)

import parso

import pytest


@pytest.mark.parametrize(
    ('string', 'expected_result', 'keepends'), [
        ('asd\r\n', ['asd', ''], False),
        ('asd\r\n', ['asd\r\n', ''], True),
        ('asd\r', ['asd', ''], False),
        ('asd\r', ['asd\r', ''], True),
        ('asd\n', ['asd', ''], False),
        ('asd\n', ['asd\n', ''], True),

        ('asd\r\n\f', ['asd', '\f'], False),
        ('asd\r\n\f', ['asd\r\n', '\f'], True),

        ('\fasd\r\n', ['\fasd', ''], False),
        ('\fasd\r\n', ['\fasd\r\n', ''], True),

        ('', [''], False),
        ('', [''], True),

        ('\n', ['', ''], False),
        ('\n', ['\n', ''], True),

        ('\r', ['', ''], False),
        ('\r', ['\r', ''], True),

        # Invalid line breaks
        ('a\vb', ['a\vb'], False),
        ('a\vb', ['a\vb'], True),
        ('\x1C', ['\x1C'], False),
        ('\x1C', ['\x1C'], True),
    ]
)
def test_split_lines(string, expected_result, keepends):
    assert split_lines(string, keepends=keepends) == expected_result


def test_python_bytes_to_unicode_unicode_text():
    source = (
        b"# vim: fileencoding=utf-8\n"
        b"# \xe3\x81\x82\xe3\x81\x84\xe3\x81\x86\xe3\x81\x88\xe3\x81\x8a\n"
    )
    actual = python_bytes_to_unicode(source)
    expected = source.decode('utf-8')
    assert actual == expected


def test_utf8_bom():
    unicode_bom = BOM_UTF8.decode('utf-8')

    module = parso.parse(unicode_bom)
    endmarker = module.children[0]
    assert endmarker.type == 'endmarker'
    assert unicode_bom == endmarker.prefix

    module = parso.parse(unicode_bom + 'foo = 1')
    expr_stmt = module.children[0]
    assert expr_stmt.type == 'expr_stmt'
    assert unicode_bom == expr_stmt.get_first_leaf().prefix


@pytest.mark.parametrize(
    ('code', 'errors'), [
        (b'# coding: wtf-12\nfoo', 'strict'),
        (b'# coding: wtf-12\nfoo', 'replace'),
        (b'# coding: wtf-12\r\nfoo', 'strict'),
        (b'# coding: wtf-12\r\nfoo', 'replace'),
        (b'# coding: wtf-12\rfoo', 'strict'),
        (b'# coding: wtf-12\rfoo', 'replace'),
    ]
)
def test_bytes_to_unicode_failing_encoding(code, errors):
    if errors == 'strict':
        with pytest.raises(LookupError):
            python_bytes_to_unicode(code, errors=errors)
    else:
        python_bytes_to_unicode(code, errors=errors)


@pytest.mark.parametrize(
    ('version_str', 'version'), [
        ('3', (3,)),
        ('3.6', (3, 6)),
        ('3.6.10', (3, 6)),
        ('3.10', (3, 10)),
        ('3.10a9', (3, 10)),
        ('3.10b9', (3, 10)),
        ('3.10rc9', (3, 10)),
    ]
)
def test_parse_version_string(version_str, version):
    parsed_version = parse_version_string(version_str)
    if len(version) == 1:
        assert parsed_version[0] == version[0]
    else:
        assert parsed_version == version
