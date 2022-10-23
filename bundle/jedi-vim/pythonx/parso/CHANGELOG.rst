.. :changelog:

Changelog
---------

Unreleased
++++++++++

0.8.3 (2021-11-30)
++++++++++++++++++

- Add basic support for Python 3.11 and 3.12

0.8.2 (2021-03-30)
++++++++++++++++++

- Various small bugfixes

0.8.1 (2020-12-10)
++++++++++++++++++

- Various small bugfixes

0.8.0 (2020-08-05)
++++++++++++++++++

- Dropped Support for Python 2.7, 3.4, 3.5
- It's possible to use ``pathlib.Path`` objects now in the API
- The stubs are gone, we are now using annotations
- ``namedexpr_test`` nodes are now a proper class called ``NamedExpr``
- A lot of smaller refactorings

0.7.1 (2020-07-24)
++++++++++++++++++

- Fixed a couple of smaller bugs (mostly syntax error detection in
  ``Grammar.iter_errors``)

This is going to be the last release that supports Python 2.7, 3.4 and 3.5.

0.7.0 (2020-04-13)
++++++++++++++++++

- Fix a lot of annoying bugs in the diff parser. The fuzzer did not find
  issues anymore even after running it for more than 24 hours (500k tests).
- Small grammar change: suites can now contain newlines even after a newline.
  This should really not matter if you don't use error recovery. It allows for
  nicer error recovery.

0.6.2 (2020-02-27)
++++++++++++++++++

- Bugfixes
- Add Grammar.refactor (might still be subject to change until 0.7.0)

0.6.1 (2020-02-03)
++++++++++++++++++

- Add ``parso.normalizer.Issue.end_pos`` to make it possible to know where an
  issue ends

0.6.0 (2020-01-26)
++++++++++++++++++

- Dropped Python 2.6/Python 3.3 support
- del_stmt names are now considered as a definition
  (for ``name.is_definition()``)
- Bugfixes

0.5.2 (2019-12-15)
++++++++++++++++++

- Add include_setitem to get_definition/is_definition and get_defined_names (#66)
- Fix named expression error listing (#89, #90)
- Fix some f-string tokenizer issues (#93)

0.5.1 (2019-07-13)
++++++++++++++++++

- Fix: Some unicode identifiers were not correctly tokenized
- Fix: Line continuations in f-strings are now working

0.5.0 (2019-06-20)
++++++++++++++++++

- **Breaking Change** comp_for is now called sync_comp_for for all Python
  versions to be compatible with the Python 3.8 Grammar
- Added .pyi stubs for a lot of the parso API
- Small FileIO changes

0.4.0 (2019-04-05)
++++++++++++++++++

- Python 3.8 support
- FileIO support, it's now possible to use abstract file IO, support is alpha

0.3.4 (2019-02-13)
+++++++++++++++++++

- Fix an f-string tokenizer error

0.3.3 (2019-02-06)
+++++++++++++++++++

- Fix async errors in the diff parser
- A fix in iter_errors
- This is a very small bugfix release

0.3.2 (2019-01-24)
+++++++++++++++++++

- 20+ bugfixes in the diff parser and 3 in the tokenizer
- A fuzzer for the diff parser, to give confidence that the diff parser is in a
  good shape.
- Some bugfixes for f-string

0.3.1 (2018-07-09)
+++++++++++++++++++

- Bugfixes in the diff parser and keyword-only arguments

0.3.0 (2018-06-30)
+++++++++++++++++++

- Rewrote the pgen2 parser generator.

0.2.1 (2018-05-21)
+++++++++++++++++++

- A bugfix for the diff parser.
- Grammar files can now be loaded from a specific path.

0.2.0 (2018-04-15)
+++++++++++++++++++

- f-strings are now parsed as a part of the normal Python grammar. This makes
  it way easier to deal with them.

0.1.1 (2017-11-05)
+++++++++++++++++++

- Fixed a few bugs in the caching layer
- Added support for Python 3.7

0.1.0 (2017-09-04)
+++++++++++++++++++

- Pulling the library out of Jedi. Some APIs will definitely change.
