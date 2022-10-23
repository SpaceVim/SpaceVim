####################################################################################
Jedi - an awesome autocompletion, static analysis and refactoring library for Python
####################################################################################

.. image:: http://isitmaintained.com/badge/open/davidhalter/jedi.svg
    :target: https://github.com/davidhalter/jedi/issues
    :alt: The percentage of open issues and pull requests

.. image:: http://isitmaintained.com/badge/resolution/davidhalter/jedi.svg
    :target: https://github.com/davidhalter/jedi/issues
    :alt: The resolution time is the median time an issue or pull request stays open.

.. image:: https://github.com/davidhalter/jedi/workflows/ci/badge.svg?branch=master
    :target: https://github.com/davidhalter/jedi/actions
    :alt: Tests

.. image:: https://pepy.tech/badge/jedi
    :target: https://pepy.tech/project/jedi
    :alt: PyPI Downloads


Jedi is a static analysis tool for Python that is typically used in
IDEs/editors plugins. Jedi has a focus on autocompletion and goto
functionality. Other features include refactoring, code search and finding
references.

Jedi has a simple API to work with. There is a reference implementation as a
`VIM-Plugin <https://github.com/davidhalter/jedi-vim>`_. Autocompletion in your
REPL is also possible, IPython uses it natively and for the CPython REPL you
can install it. Jedi is well tested and bugs should be rare.

Jedi can currently be used with the following editors/projects:

- Vim (jedi-vim_, YouCompleteMe_, deoplete-jedi_, completor.vim_)
- `Visual Studio Code`_ (via `Python Extension <https://marketplace.visualstudio.com/items?itemName=ms-python.python>`_)
- Emacs (Jedi.el_, company-mode_, elpy_, anaconda-mode_, ycmd_)
- Sublime Text (SublimeJEDI_ [ST2 + ST3], anaconda_ [only ST3])
- TextMate_ (Not sure if it's actually working)
- Kate_ version 4.13+ supports it natively, you have to enable it, though.  [`see
  <https://projects.kde.org/projects/kde/applications/kate/repository/show?rev=KDE%2F4.13>`_]
- Atom_ (autocomplete-python-jedi_)
- `GNOME Builder`_ (with support for GObject Introspection)
- Gedit (gedi_)
- wdb_ - Web Debugger
- `Eric IDE`_ (Available as a plugin)
- `IPython 6.0.0+ <https://ipython.readthedocs.io/en/stable/whatsnew/version6.html>`_
- `xonsh shell <https://xon.sh/contents.html>`_ has `jedi extension <https://xon.sh/xontribs.html#jedi>`_

and many more!

There are a few language servers that use Jedi:

- `jedi-language-server <https://github.com/pappasam/jedi-language-server>`_
- `python-language-server <https://github.com/palantir/python-language-server>`_
- `anakin-language-server <https://github.com/muffinmad/anakin-language-server>`_

Here are some pictures taken from jedi-vim_:

.. image:: https://github.com/davidhalter/jedi/raw/master/docs/_screenshots/screenshot_complete.png

Completion for almost anything:

.. image:: https://github.com/davidhalter/jedi/raw/master/docs/_screenshots/screenshot_function.png

Documentation:

.. image:: https://github.com/davidhalter/jedi/raw/master/docs/_screenshots/screenshot_pydoc.png


Get the latest version from `github <https://github.com/davidhalter/jedi>`_
(master branch should always be kind of stable/working).

Docs are available at `https://jedi.readthedocs.org/en/latest/
<https://jedi.readthedocs.org/en/latest/>`_. Pull requests with enhancements
and/or fixes are awesome and most welcome. Jedi uses `semantic versioning
<https://semver.org/>`_.

If you want to stay **up-to-date** with releases, please **subscribe** to this
mailing list: https://groups.google.com/g/jedi-announce. To subscribe you can
simply send an empty email to ``jedi-announce+subscribe@googlegroups.com``.

Issues & Questions
==================

You can file issues and questions in the `issue tracker
<https://github.com/davidhalter/jedi/>`. Alternatively you can also ask on
`Stack Overflow <https://stackoverflow.com/questions/tagged/python-jedi>`_ with
the label ``python-jedi``.

Installation
============

`Check out the docs <https://jedi.readthedocs.org/en/latest/docs/installation.html>`_.

Features and Limitations
========================

Jedi's features are listed here:
`Features <https://jedi.readthedocs.org/en/latest/docs/features.html>`_.

You can run Jedi on Python 3.6+ but it should also
understand code that is older than those versions. Additionally you should be
able to use `Virtualenvs <https://jedi.readthedocs.org/en/latest/docs/api.html#environments>`_
very well.

Tips on how to use Jedi efficiently can be found `here
<https://jedi.readthedocs.org/en/latest/docs/features.html#recipes>`_.

API
---

You can find a comprehensive documentation for the
`API here <https://jedi.readthedocs.org/en/latest/docs/api.html>`_.

Autocompletion / Goto / Documentation
-------------------------------------

There are the following commands:

- ``jedi.Script.goto``
- ``jedi.Script.infer``
- ``jedi.Script.help``
- ``jedi.Script.complete``
- ``jedi.Script.get_references``
- ``jedi.Script.get_signatures``
- ``jedi.Script.get_context``

The returned objects are very powerful and are really all you might need.

Autocompletion in your REPL (IPython, etc.)
-------------------------------------------

Jedi is a dependency of IPython. Autocompletion in IPython with Jedi is
therefore possible without additional configuration.

Here is an `example video <https://vimeo.com/122332037>`_ how REPL completion
can look like.
For the ``python`` shell you can enable tab completion in a `REPL
<https://jedi.readthedocs.org/en/latest/docs/usage.html#tab-completion-in-the-python-shell>`_.

Static Analysis
---------------

For a lot of forms of static analysis, you can try to use
``jedi.Script(...).get_names``. It will return a list of names that you can
then filter and work with. There is also a way to list the syntax errors in a
file: ``jedi.Script.get_syntax_errors``.


Refactoring
-----------

Jedi supports the following refactorings:

- ``jedi.Script.inline``
- ``jedi.Script.rename``
- ``jedi.Script.extract_function``
- ``jedi.Script.extract_variable``

Code Search
-----------

There is support for module search with ``jedi.Script.search``, and project
search for ``jedi.Project.search``. The way to search is either by providing a
name like ``foo`` or by using dotted syntax like ``foo.bar``. Additionally you
can provide the API type like ``class foo.bar.Bar``. There are also the
functions ``jedi.Script.complete_search`` and ``jedi.Project.complete_search``.

Development
===========

There's a pretty good and extensive `development documentation
<https://jedi.readthedocs.org/en/latest/docs/development.html>`_.

Testing
=======

The test suite uses ``pytest``::

    pip install pytest

If you want to test only a specific Python version (e.g. Python 3.8), it is as
easy as::

    python3.8 -m pytest

For more detailed information visit the `testing documentation
<https://jedi.readthedocs.org/en/latest/docs/testing.html>`_.

Acknowledgements
================

Thanks a lot to all the
`contributors <https://jedi.readthedocs.org/en/latest/docs/acknowledgements.html>`_!


.. _jedi-vim: https://github.com/davidhalter/jedi-vim
.. _youcompleteme: https://github.com/ycm-core/YouCompleteMe
.. _deoplete-jedi: https://github.com/zchee/deoplete-jedi
.. _completor.vim: https://github.com/maralla/completor.vim
.. _Jedi.el: https://github.com/tkf/emacs-jedi
.. _company-mode: https://github.com/syohex/emacs-company-jedi
.. _elpy: https://github.com/jorgenschaefer/elpy
.. _anaconda-mode: https://github.com/proofit404/anaconda-mode
.. _ycmd: https://github.com/abingham/emacs-ycmd
.. _sublimejedi: https://github.com/srusskih/SublimeJEDI
.. _anaconda: https://github.com/DamnWidget/anaconda
.. _wdb: https://github.com/Kozea/wdb
.. _TextMate: https://github.com/lawrenceakka/python-jedi.tmbundle
.. _Kate: https://kate-editor.org
.. _Atom: https://atom.io/
.. _autocomplete-python-jedi: https://atom.io/packages/autocomplete-python-jedi
.. _GNOME Builder: https://wiki.gnome.org/Apps/Builder
.. _Visual Studio Code: https://code.visualstudio.com/
.. _gedi: https://github.com/isamert/gedi
.. _Eric IDE: https://eric-ide.python-projects.org
