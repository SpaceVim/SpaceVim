import pathlib

import pytest

from python_imports import (
    Error,
    ImportedName,
    Line,
    joined_lines,
    parse_line,
    parse_python_imports_cfg,
    strip_comments,
)


@pytest.mark.parametrize("line, expected", [
    ('import a', [ImportedName('', 'a', 'a')]),
    ('import a, b', [ImportedName('', 'a', 'a'), ImportedName('', 'b', 'b')]),
    ('import a as c, b', [
        ImportedName('', 'a', 'c'), ImportedName('', 'b', 'b')
    ]),
    ('from m import a', [ImportedName('m', 'a', 'a')]),
    ('from pkg.mod import a, b as c', [
        ImportedName('pkg.mod', 'a', 'a'),
        ImportedName('pkg.mod', 'b', 'c'),
    ]),
    ('from pkg.mod import (a, b as c, )', [
        ImportedName('pkg.mod', 'a', 'a'),
        ImportedName('pkg.mod', 'b', 'c'),
    ]),
])
def test_parse_line(line, expected):
    result = list(parse_line(line))
    assert result == expected


def test_parse_syntax_error():
    line = Line('import not right').with_location('<stdin>', 1)
    with pytest.raises(Error):
        parse_line(line)


def test_strip_comments():
    lines = [
        '# comment\n',
        ' \n'
        'import a\n',
        '  import b  \n',
        'import c  # \n',
        '\n',
    ]
    expected = [
        'import a',
        'import b',
        'import c',
    ]
    result = list(strip_comments(lines))
    assert result == expected


def test_joined_lines():
    lines = [Line(s).with_location('<stdin>', n) for n, s in enumerate([
        'import a',
        'from a import (b,',
        'c,',
        ')',
        'import b',
        'from c import (',
    ], 1)]
    expected = [
        'import a',
        'from a import (b, c, )',
        'import b',
        'from c import (',
    ]
    result = list(joined_lines(lines))
    assert result == expected


def test_parse_python_imports_cfg(vim, capsys):
    example_config = pathlib.Path(__file__).parents[1] / 'python-imports.cfg'
    parse_python_imports_cfg(example_config, verbose=True)
    assert capsys.readouterr().out == ""
    assert capsys.readouterr().err == ""
    assert (
        "let g:pythonImports['partial'] = 'functools'" in vim.executed_commands
    )


def test_parse_python_imports_cfg_very_verbose(vim, capsys):
    example_config = pathlib.Path(__file__).parents[1] / 'python-imports.cfg'
    parse_python_imports_cfg(example_config, verbose=2)
    assert ('partial from functools' in capsys.readouterr().out)
    assert capsys.readouterr().err == ""


def test_parse_python_imports_cfg_error_handling(tmp_path, capsys):
    example_config = tmp_path / 'python-imports.cfg'
    example_config.write_text('improt a\n')
    parse_python_imports_cfg(example_config, verbose=True)
    errors = capsys.readouterr().out.replace(
        str(example_config), 'python-imports.cfg')
    assert errors == (
        "Failed to load python-imports.cfg: could not parse line 1: improt a\n"
    )
