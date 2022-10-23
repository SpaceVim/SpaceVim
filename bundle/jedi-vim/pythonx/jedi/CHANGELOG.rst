.. :changelog:

Changelog
---------

Unreleased
++++++++++

0.18.1 (2021-11-17)
+++++++++++++++++++

- Implict namespaces are now a separate types in ``Name().type``
- Python 3.10 support
- Mostly bugfixes

0.18.0 (2020-12-25)
+++++++++++++++++++

- Dropped Python 2 and Python 3.5
- Using ``pathlib.Path()`` as an output instead of ``str`` in most places:
  - ``Project.path``
  - ``Script.path``
  - ``Definition.module_path``
  - ``Refactoring.get_renames``
  - ``Refactoring.get_changed_files``
- Functions with ``@property`` now return ``property`` instead of ``function``
  in ``Name().type``
- Started using annotations
- Better support for the walrus operator
- Project attributes are now read accessible
- Removed all deprecations

This is likely going to be the last minor release before 1.0.

0.17.2 (2020-07-17)
+++++++++++++++++++

- Added an option to pass environment variables to ``Environment``
- ``Project(...).path`` exists now
- Support for Python 3.9
- A few bugfixes

This will be the last release that supports Python 2 and Python 3.5.
``0.18.0`` will be Python 3.6+.

0.17.1 (2020-06-20)
+++++++++++++++++++

- Django ``Model`` meta class support
- Django Manager support (completion on Managers/QuerySets)
- Added Django Stubs to Jedi, thanks to all contributors of the
  `Django Stubs <https://github.com/typeddjango/django-stubs>`_ project
- Added ``SyntaxError.get_message``
- Python 3.9 support
- Bugfixes (mostly towards Generics)

0.17.0 (2020-04-14)
+++++++++++++++++++

- Added ``Project`` support. This allows a user to specify which folders Jedi
  should work with.
- Added support for Refactoring. The following refactorings have been
  implemented: ``Script.rename``, ``Script.inline``,
  ``Script.extract_variable`` and ``Script.extract_function``.
- Added ``Script.get_syntax_errors`` to display syntax errors in the current
  script.
- Added code search capabilities both for individual files and projects. The
  new functions are ``Project.search``, ``Project.complete_search``,
  ``Script.search`` and ``Script.complete_search``.
- Added ``Script.help`` to make it easier to display a help window to people.
  Now returns pydoc information as well for Python keywords/operators.  This
  means that on the class keyword it will now return the docstring of Python's
  builtin function ``help('class')``.
- The API documentation is now way more readable and complete. Check it out
  under https://jedi.readthedocs.io. A lot of it has been rewritten.
- Removed Python 3.4 support
- Many bugfixes

This is likely going to be the last minor version that supports Python 2 and
Python3.5. Bugfixes will be provided in 0.17.1+. The next minor/major version
will probably be Jedi 1.0.0.

0.16.0 (2020-01-26)
+++++++++++++++++++

- **Added** ``Script.get_context`` to get information where you currently are.
- Completions/type inference of **Pytest fixtures**.
- Tensorflow, Numpy and Pandas completions should now be about **4-10x faster**
  after the first time they are used.
- Dict key completions are working now. e.g. ``d = {1000: 3}; d[10`` will
  expand to ``1000``.
- Completion for "proxies" works now. These are classes that have a
  ``__getattr__(self, name)`` method that does a ``return getattr(x, name)``.
  after loading them initially.
- Goto on a function/attribute in a class now goes to the definition in its
  super class.
- Big **Script API Changes**:
    - The line and column parameters of ``jedi.Script`` are now deprecated
    - ``completions`` deprecated, use ``complete`` instead
    - ``goto_assignments`` deprecated, use ``goto`` instead
    - ``goto_definitions`` deprecated, use ``infer`` instead
    - ``call_signatures`` deprecated, use ``get_signatures`` instead
    - ``usages`` deprecated, use ``get_references`` instead
    - ``jedi.names`` deprecated, use ``jedi.Script(...).get_names()``
- ``BaseName.goto_assignments`` renamed to ``BaseName.goto``
- Add follow_imports to ``Name.goto``. Now its signature matches
  ``Script.goto``.
- **Python 2 support deprecated**. For this release it is best effort. Python 2
  has reached the end of its life and now it's just about a smooth transition.
  Bugs for Python 2 will not be fixed anymore and a third of the tests are
  already skipped.
- Removed ``settings.no_completion_duplicates``. It wasn't tested and nobody
  was probably using it anyway.
- Removed ``settings.use_filesystem_cache`` and
  ``settings.additional_dynamic_modules``, they have no usage anymore. Pretty
  much nobody was probably using them.

0.15.2 (2019-12-20)
+++++++++++++++++++

- Signatures are now detected a lot better
- Add fuzzy completions with ``Script(...).completions(fuzzy=True)``
- Files bigger than one MB (about 20kLOC) get cropped to avoid getting
  stuck completely.
- Many small Bugfixes
- A big refactoring around contexts/values

0.15.1 (2019-08-13)
+++++++++++++++++++

- Small bugfix and removal of a print statement

0.15.0 (2019-08-11)
+++++++++++++++++++

- Added file path completions, there's a **new** ``Completion.type`` now:
  ``path``. Example: ``'/ho`` -> ``'/home/``
- ``*args``/``**kwargs`` resolving. If possible Jedi replaces the parameters
  with the actual alternatives.
- Better support for enums/dataclasses
- When using Interpreter, properties are now executed, since a lot of people
  have complained about this. Discussion in #1299, #1347.

New APIs:

- ``Name.get_signatures() -> List[Signature]``. Signatures are similar to
  ``CallSignature``. ``Name.params`` is therefore deprecated.
- ``Signature.to_string()`` to format signatures.
- ``Signature.params -> List[ParamName]``, ParamName has the
  following additional attributes ``infer_default()``, ``infer_annotation()``,
  ``to_string()``, and ``kind``.
- ``Name.execute() -> List[Name]``, makes it possible to infer
  return values of functions.


0.14.1 (2019-07-13)
+++++++++++++++++++

- CallSignature.index should now be working a lot better
- A couple of smaller bugfixes

0.14.0 (2019-06-20)
+++++++++++++++++++

- Added ``goto_*(prefer_stubs=True)`` as well as ``goto_*(prefer_stubs=True)``
- Stubs are used now for type inference
- Typeshed is used for better type inference
- Reworked Name.full_name, should have more correct return values

0.13.3 (2019-02-24)
+++++++++++++++++++

- Fixed an issue with embedded Python, see https://github.com/davidhalter/jedi-vim/issues/870

0.13.2 (2018-12-15)
+++++++++++++++++++

- Fixed a bug that led to Jedi spawning a lot of subprocesses.

0.13.1 (2018-10-02)
+++++++++++++++++++

- Bugfixes, because tensorflow completions were still slow.

0.13.0 (2018-10-02)
+++++++++++++++++++

- A small release. Some bug fixes.
- Remove Python 3.3 support. Python 3.3 support has been dropped by the Python
  foundation.
- Default environments are now using the same Python version as the Python
  process. In 0.12.x, we used to load the latest Python version on the system.
- Added ``include_builtins`` as a parameter to usages.
- ``goto_assignments`` has a new ``follow_builtin_imports`` parameter that
  changes the previous behavior slightly.

0.12.1 (2018-06-30)
+++++++++++++++++++

- This release forces you to upgrade parso. If you don't, nothing will work
  anymore. Otherwise changes should be limited to bug fixes. Unfortunately Jedi
  still uses a few internals of parso that make it hard to keep compatibility
  over multiple releases. Parso >=0.3.0 is going to be needed.

0.12.0 (2018-04-15)
+++++++++++++++++++

- Virtualenv/Environment support
- F-String Completion/Goto Support
- Cannot crash with segfaults anymore
- Cleaned up import logic
- Understand async/await and autocomplete it (including async generators)
- Better namespace completions
- Passing tests for Windows (including CI for Windows)
- Remove Python 2.6 support

0.11.1 (2017-12-14)
+++++++++++++++++++

- Parso update - the caching layer was broken
- Better usages - a lot of internal code was ripped out and improved.

0.11.0 (2017-09-20)
+++++++++++++++++++

- Split Jedi's parser into a separate project called ``parso``.
- Avoiding side effects in REPL completion.
- Numpy docstring support should be much better.
- Moved the `settings.*recursion*` away, they are no longer usable.

0.10.2 (2017-04-05)
+++++++++++++++++++

- Python Packaging sucks. Some files were not included in 0.10.1.

0.10.1 (2017-04-05)
+++++++++++++++++++

- Fixed a few very annoying bugs.
- Prepared the parser to be factored out of Jedi.

0.10.0 (2017-02-03)
+++++++++++++++++++

- Actual semantic completions for the complete Python syntax.
- Basic type inference for ``yield from`` PEP 380.
- PEP 484 support (most of the important features of it). Thanks Claude! (@reinhrst)
- Added ``get_line_code`` to ``Name`` and ``Completion`` objects.
- Completely rewritten the type inference engine.
- A new and better parser for (fast) parsing diffs of Python code.

0.9.0 (2015-04-10)
++++++++++++++++++

- The import logic has been rewritten to look more like Python's. There is now
  an ``InferState.modules`` import cache, which resembles ``sys.modules``.
- Integrated the parser of 2to3. This will make refactoring possible. It will
  also be possible to check for error messages (like compiling an AST would give)
  in the future.
- With the new parser, the type inference also completely changed. It's now
  simpler and more readable.
- Completely rewritten REPL completion.
- Added ``jedi.names``, a command to do static analysis. Thanks to that
  sourcegraph guys for sponsoring this!
- Alpha version of the linter.


0.8.1 (2014-07-23)
+++++++++++++++++++

- Bugfix release, the last release forgot to include files that improve
  autocompletion for builtin libraries. Fixed.

0.8.0 (2014-05-05)
+++++++++++++++++++

- Memory Consumption for compiled modules (e.g. builtins, sys) has been reduced
  drastically. Loading times are down as well (it takes basically as long as an
  import).
- REPL completion is starting to become usable.
- Various small API changes. Generally this release focuses on stability and
  refactoring of internal APIs.
- Introducing operator precedence, which makes calculating correct Array
  indices and ``__getattr__`` strings possible.

0.7.0 (2013-08-09)
++++++++++++++++++

- Switched from LGPL to MIT license.
- Added an Interpreter class to the API to make autocompletion in REPL
  possible.
- Added autocompletion support for namespace packages.
- Add sith.py, a new random testing method.

0.6.0 (2013-05-14)
++++++++++++++++++

- Much faster parser with builtin part caching.
- A test suite, thanks @tkf.

0.5 versions (2012)
+++++++++++++++++++

- Initial development.
