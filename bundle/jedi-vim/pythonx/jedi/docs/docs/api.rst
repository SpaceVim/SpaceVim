.. include:: ../global.rst

API Overview
============

.. note:: This documentation is mostly for Plugin developers, who want to
   improve their editors/IDE with Jedi.

.. _api:

The API consists of a few different parts:

- The main starting points for complete/goto: :class:`.Script` and
  :class:`.Interpreter`. If you work with Jedi you want to understand these
  classes first.
- :ref:`API Result Classes <api-classes>`
- :ref:`Python Versions/Virtualenv Support <environments>` with functions like
  :func:`.find_system_environments` and :func:`.find_virtualenvs`
- A way to work with different :ref:`Folders / Projects <projects>`
- Helpful functions: :func:`.preload_module` and :func:`.set_debug_function`

The methods that you are most likely going to use to work with Jedi are the
following ones:

.. currentmodule:: jedi

.. autosummary::
   :nosignatures:

    Script.complete
    Script.goto
    Script.infer
    Script.help
    Script.get_signatures
    Script.get_references
    Script.get_context
    Script.get_names
    Script.get_syntax_errors
    Script.rename
    Script.inline
    Script.extract_variable
    Script.extract_function
    Script.search
    Script.complete_search
    Project.search
    Project.complete_search

Script
------

.. autoclass:: jedi.Script
    :members:

Interpreter
-----------
.. autoclass:: jedi.Interpreter
    :members:

.. _projects:

Projects
--------

.. automodule:: jedi.api.project

.. autofunction:: jedi.get_default_project
.. autoclass:: jedi.Project
    :members:

.. _environments:

Environments
------------

.. automodule:: jedi.api.environment

.. autofunction:: jedi.find_system_environments
.. autofunction:: jedi.find_virtualenvs
.. autofunction:: jedi.get_system_environment
.. autofunction:: jedi.create_environment
.. autofunction:: jedi.get_default_environment
.. autoexception:: jedi.InvalidPythonEnvironment
.. autoclass:: jedi.api.environment.Environment
    :members:

Helper Functions
----------------

.. autofunction:: jedi.preload_module
.. autofunction:: jedi.set_debug_function

Errors
------

.. autoexception:: jedi.InternalError
.. autoexception:: jedi.RefactoringError

Examples
--------

Completions
~~~~~~~~~~~

.. sourcecode:: python

   >>> import jedi
   >>> code = '''import json; json.l'''
   >>> script = jedi.Script(code, path='example.py')
   >>> script
   <Script: 'example.py' <SameEnvironment: 3.9.0 in /usr>>
   >>> completions = script.complete(1, 19)
   >>> completions
   [<Completion: load>, <Completion: loads>]
   >>> completions[1]
   <Completion: loads>
   >>> completions[1].complete
   'oads'
   >>> completions[1].name
   'loads'

Type Inference / Goto
~~~~~~~~~~~~~~~~~~~~~

.. sourcecode:: python

    >>> import jedi
    >>> code = '''\
    ... def my_func():
    ...     print 'called'
    ... 
    ... alias = my_func
    ... my_list = [1, None, alias]
    ... inception = my_list[2]
    ... 
    ... inception()'''
    >>> script = jedi.Script(code)
    >>>
    >>> script.goto(8, 1)
    [<Name full_name='__main__.inception', description='inception = my_list[2]'>]
    >>>
    >>> script.infer(8, 1)
    [<Name full_name='__main__.my_func', description='def my_func'>]

References
~~~~~~~~~~

.. sourcecode:: python

    >>> import jedi
    >>> code = '''\
    ... x = 3
    ... if 1 == 2:
    ...     x = 4
    ... else:
    ...     del x'''
    >>> script = jedi.Script(code)
    >>> rns = script.get_references(5, 8)
    >>> rns
    [<Name full_name='__main__.x', description='x = 3'>,
     <Name full_name='__main__.x', description='x = 4'>,
     <Name full_name='__main__.x', description='del x'>]
    >>> rns[1].line
    3
    >>> rns[1].column
    4

Deprecations
------------

The deprecation process is as follows:

1. A deprecation is announced in any release.
2. The next major release removes the deprecated functionality.
