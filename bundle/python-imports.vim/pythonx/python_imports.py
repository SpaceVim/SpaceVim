"""
" HACK to make it possible to reload this by sourcing it in vim
py3 import importlib; importlib.reload(python_imports)
finish
"""
import re
import os
from typing import NamedTuple, Iterable, Optional

import vim


DEFAULT_CONFIG_FILE = os.path.expanduser('~/.vim/python-imports.cfg')

WS = r'\s+'
MAYBE_WS = r'\s*'
DOTTEDNAME = r'[a-zA-Z_.][a-zA-Z_0-9.]*'
NAME = r'[a-zA-Z_][a-zA-Z_0-9]*'
NAMEWITHALIAS = NAME + r'(?:' + WS + 'as' + WS + NAME + ')?'
NAMELIST = NAMEWITHALIAS + r'(?:' + MAYBE_WS + r',' + MAYBE_WS + NAMEWITHALIAS + r')*'
# technically this allows unbalanced parens like 'import (aaaa' or 'import a, b)';
# I don't care
NAMES = r'[(]?' + MAYBE_WS + '(?P<names>' + NAMELIST + r')' + MAYBE_WS + r',?' + MAYBE_WS + r'[)]?'
MODNAME = r'(?P<modname>' + DOTTEDNAME + r')'

# technically 'import (a, b, c)' should not be allowed; I don't care
IMPORT_RX = re.compile(r'^import' + WS + NAMES + r'$')
# technically 'from foo import(a, b, c)' should be allowed without whitespace
# before the (, but I don't care
FROM_IMPORT_RX = re.compile(r'^from' + WS + MODNAME + WS + r'import' + WS + NAMES + r'$')


class Error(Exception):
    """Syntax error in the config file."""


class Line(str):
    """Line that remembers its source location."""

    filename = None
    lineno = None

    def with_location(self, filename: Optional[str], lineno: Optional[int]) -> 'Line':
        self.filename = filename
        self.lineno = lineno
        return self

    def with_same_location_as(self, line: 'Line') -> 'Line':
        self.filename = line.filename
        self.lineno = line.lineno
        return self


class ImportedName(NamedTuple):
    """Information about the canonical location of an import."""

    modname: str    # fully qualified module (or package) name (can be blank)
    name: str       # name of the importable thing
    alias: str      # alias to give to the importable thing (often same as `name`)

    @property
    def has_alias(self) -> bool:
        return self.alias != self.name

    def __str__(self) -> str:
        bits = [self.name]
        if self.has_alias:
            bits.append(f"as {self.alias}")
        if self.modname:
            bits.append(f"from {self.modname}")
        return " ".join(bits)


def parse_names(names: str, modname: str = '') -> Iterable[ImportedName]:
    """Parse a list of imported names.

    The grammar is::

        names ::= <name> [as <alias>] [, <names>]

    """
    for name in names.split(','):
        bits = name.split()
        # it's either [name] or [name, 'as', alias], and the following works
        # for both
        yield ImportedName(modname, bits[0], bits[-1])


def parse_line(line: Line) -> Iterable[ImportedName]:
    """Parse an import configuration line.

    The grammar is::

        line ::= import <names>
               | from <modname> import <names>

    """
    m = IMPORT_RX.match(line)
    if m:
        return parse_names(m.group('names'))
    m = FROM_IMPORT_RX.match(line)
    if m:
        modname = m.group('modname')
        return parse_names(m.group('names'), modname)
    raise Error(f'could not parse line {line.lineno}: {line}')


def strip_comments(lines: Iterable[str], filename: Optional[str] = None) -> Iterable[Line]:
    """Strip whitespace and comments and return nonblank lines."""
    for n, line in enumerate(lines, 1):
        line = line.partition('#')[0].strip()
        if line:
            yield Line(line).with_location(filename, n)


def joined_lines(lines: Iterable[Line]) -> Iterable[Line]:
    """Join lines until parentheses match."""
    balance = 0
    buffer = []
    for line in lines:
        buffer.append(line)
        balance += line.count('(') - line.count(')')
        if balance == 0:
            yield Line(' '.join(buffer)).with_same_location_as(buffer[0])
            del buffer[:]
    if buffer:
        # this is unbalanced, but let's let the next level report the error
        yield Line(' '.join(buffer)).with_same_location_as(buffer[0])


def parse_python_imports_cfg(filename: str = DEFAULT_CONFIG_FILE, verbose: bool = False) -> None:
    """Parse python-imports.cfg if it exists.

    Stores the parsed configuration directly in vim's g:pythonImports and g:pythonImportAliases
    global variables, which must exist and be defined as dictionaries.
    """
    try:
        with open(filename) as f:
            for line in joined_lines(strip_comments(f, filename)):
                for name in parse_line(line):
                    if verbose >= 2:
                        print(name)
                    vim.command("let g:pythonImports['%s'] = '%s'" % (name.name, name.modname))
                    if name.has_alias:
                        vim.command("let g:pythonImportAliases['%s'] = '%s'"
                                    % (name.alias, name.name))
                    continue
    except (Error, IOError) as e:
        if verbose:
            print("Failed to load %s: %s" % (filename, e))
