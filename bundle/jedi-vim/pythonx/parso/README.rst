###################################################################
parso - A Python Parser
###################################################################


.. image:: https://github.com/davidhalter/parso/workflows/Build/badge.svg?branch=master
    :target: https://github.com/davidhalter/parso/actions
    :alt: GitHub Actions build status

.. image:: https://coveralls.io/repos/github/davidhalter/parso/badge.svg?branch=master
    :target: https://coveralls.io/github/davidhalter/parso?branch=master
    :alt: Coverage Status

.. image:: https://pepy.tech/badge/parso
    :target: https://pepy.tech/project/parso
    :alt: PyPI Downloads

.. image:: https://raw.githubusercontent.com/davidhalter/parso/master/docs/_static/logo_characters.png

Parso is a Python parser that supports error recovery and round-trip parsing
for different Python versions (in multiple Python versions). Parso is also able
to list multiple syntax errors in your python file.

Parso has been battle-tested by jedi_. It was pulled out of jedi to be useful
for other projects as well.

Parso consists of a small API to parse Python and analyse the syntax tree.

A simple example:

.. code-block:: python

    >>> import parso
    >>> module = parso.parse('hello + 1', version="3.9")
    >>> expr = module.children[0]
    >>> expr
    PythonNode(arith_expr, [<Name: hello@1,0>, <Operator: +>, <Number: 1>])
    >>> print(expr.get_code())
    hello + 1
    >>> name = expr.children[0]
    >>> name
    <Name: hello@1,0>
    >>> name.end_pos
    (1, 5)
    >>> expr.end_pos
    (1, 9)

To list multiple issues:

.. code-block:: python

    >>> grammar = parso.load_grammar()
    >>> module = grammar.parse('foo +\nbar\ncontinue')
    >>> error1, error2 = grammar.iter_errors(module)
    >>> error1.message
    'SyntaxError: invalid syntax'
    >>> error2.message
    "SyntaxError: 'continue' not properly in loop"

Resources
=========

- `Testing <https://parso.readthedocs.io/en/latest/docs/development.html#testing>`_
- `PyPI <https://pypi.python.org/pypi/parso>`_
- `Docs <https://parso.readthedocs.org/en/latest/>`_
- Uses `semantic versioning <https://semver.org/>`_

Installation
============

    pip install parso

Future
======

- There will be better support for refactoring and comments. Stay tuned.
- There's a WIP PEP8 validator. It's however not in a good shape, yet.

Known Issues
============

- `async`/`await` are already used as keywords in Python3.6.
- `from __future__ import print_function` is not ignored.


Acknowledgements
================

- Guido van Rossum (@gvanrossum) for creating the parser generator pgen2
  (originally used in lib2to3).
- `Salome Schneider <https://www.crepes-schnaegg.ch/cr%C3%AApes-schn%C3%A4gg/kunst-f%C3%BCrs-cr%C3%AApes-mobil/>`_
  for the extremely awesome parso logo.


.. _jedi: https://github.com/davidhalter/jedi
