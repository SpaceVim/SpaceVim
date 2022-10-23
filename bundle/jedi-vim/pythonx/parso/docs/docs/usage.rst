.. include:: ../global.rst

Usage
=====

|parso| works around grammars. You can simply create Python grammars by calling
:py:func:`parso.load_grammar`. Grammars (with a custom tokenizer and custom parser trees)
can also be created by directly instantiating :py:func:`parso.Grammar`. More information
about the resulting objects can be found in the :ref:`parser tree documentation
<parser-tree>`.

The simplest way of using parso is without even loading a grammar
(:py:func:`parso.parse`):

.. sourcecode:: python

   >>> import parso
   >>> parso.parse('foo + bar')
   <Module: @1-1>

Loading a Grammar
-----------------

Typically if you want to work with one specific Python version, use:

.. autofunction:: parso.load_grammar

Grammar methods
---------------

You will get back a grammar object that you can use to parse code and find
issues in it:

.. autoclass:: parso.Grammar
    :members:
    :undoc-members:


Error Retrieval
---------------

|parso| is able to find multiple errors in your source code. Iterating through
those errors yields the following instances:

.. autoclass:: parso.normalizer.Issue
    :members:
    :undoc-members:


Utility
-------

|parso| also offers some utility functions that can be really useful:

.. autofunction:: parso.parse
.. autofunction:: parso.split_lines
.. autofunction:: parso.python_bytes_to_unicode


Used By
-------

- jedi_ (which is used by IPython and a lot of editor plugins).
- mutmut_ (mutation tester)


.. _jedi: https://github.com/davidhalter/jedi
.. _mutmut: https://github.com/boxed/mutmut
