.. include:: ../global.rst

Features and Limitations
========================

Jedi's main API calls and features are:

- Autocompletion: :meth:`.Script.complete`; It's also possible to get it
  working in :ref:`your REPL (IPython, etc.) <repl-completion>`
- Goto/Type Inference: :meth:`.Script.goto` and :meth:`.Script.infer`
- Static Analysis: :meth:`.Script.get_names` and :meth:`.Script.get_syntax_errors`
- Refactorings: :meth:`.Script.rename`, :meth:`.Script.inline`,
  :meth:`.Script.extract_variable` and :meth:`.Script.extract_function`
- Code Search: :meth:`.Script.search` and :meth:`.Project.search`

Basic Features
--------------

- Python 3.6+ support
- Ignores syntax errors and wrong indentation
- Can deal with complex module / function / class structures
- Great ``virtualenv``/``venv`` support
- Works great with Python's :ref:`type hinting <type-hinting>`,
- Understands stub files
- Can infer function arguments for sphinx, epydoc and basic numpydoc docstrings
- Is overall a very solid piece of software that has been refined for a long
  time. Bug reports are very welcome and are usually fixed within a few weeks.


Supported Python Features
-------------------------

|jedi| supports many of the widely used Python features:

- builtins
- returns, yields, yield from
- tuple assignments / array indexing / dictionary indexing / star unpacking
- with-statement / exception handling
- ``*args`` / ``**kwargs``
- decorators / lambdas / closures
- generators / iterators
- descriptors: property / staticmethod / classmethod / custom descriptors
- some magic methods: ``__call__``, ``__iter__``, ``__next__``, ``__get__``,
  ``__getitem__``, ``__init__``
- ``list.append()``, ``set.add()``, ``list.extend()``, etc.
- (nested) list comprehensions / ternary expressions
- relative imports
- ``getattr()`` / ``__getattr__`` / ``__getattribute__``
- function annotations
- simple/typical ``sys.path`` modifications
- ``isinstance`` checks for if/while/assert
- namespace packages (includes ``pkgutil``, ``pkg_resources`` and PEP420 namespaces)
- Django / Flask / Buildout support
- Understands Pytest fixtures


Limitations
-----------

In general Jedi's limit is quite high, but for very big projects or very
complex code, sometimes Jedi intentionally stops type inference, to avoid
hanging for a long time.

Additionally there are some Python patterns Jedi does not support. This is
intentional and below should be a complete list:

- Arbitrary metaclasses: Some metaclasses like enums and dataclasses are
  reimplemented in Jedi to make them work. Most of the time stubs are good
  enough to get type inference working, even when metaclasses are involved.
- ``setattr()``, ``__import__()``
- Writing to some dicts: ``globals()``, ``locals()``, ``object.__dict__``
- Manipulations of instances outside the instance variables without using
  methods 

Performance Issues
~~~~~~~~~~~~~~~~~~

Importing ``numpy`` can be quite slow sometimes, as well as loading the
builtins the first time. If you want to speed things up, you could preload
libriaries in |jedi|, with :func:`.preload_module`. However, once loaded, this
should not be a problem anymore.  The same is true for huge modules like
``PySide``, ``wx``, ``tensorflow``, ``pandas``, etc.

Jedi does not have a very good cache layer. This is probably the biggest and
only architectural `issue <https://github.com/davidhalter/jedi/issues/1059>`_ in
Jedi. Unfortunately it is not easy to change that. Dave Halter is thinking
about rewriting Jedi in Rust, but it has taken Jedi more than 8 years to reach
version 1.0, a rewrite will probably also take years.

Security
--------

For :class:`.Script`
~~~~~~~~~~~~~~~~~~~~

Security is an important topic for |jedi|. By default, no code is executed
within Jedi. As long as you write pure Python, everything is inferred
statically. If you enable ``load_unsafe_extensions=True`` for your
:class:`.Project` and you use builtin modules (``c_builtin``) Jedi will execute
those modules. If you don't trust a code base, please do not enable that
option. It might lead to arbitrary code execution.

For :class:`.Interpreter`
~~~~~~~~~~~~~~~~~~~~~~~~~

If you want security for :class:`.Interpreter`, ``do not`` use it. Jedi does
execute properties and in general is not very careful to avoid code execution.
This is intentional: Most people trust the code bases they have imported,
because at that point a malicious code base would have had code execution
already.
