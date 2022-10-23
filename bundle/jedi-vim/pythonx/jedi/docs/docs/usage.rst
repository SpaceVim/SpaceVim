.. include:: ../global.rst

Using Jedi
==========

|jedi| is can be used with a variety of :ref:`plugins <editor-plugins>`,
`language servers <language-servers>` and other software.
It is also possible to use |jedi| in the :ref:`Python shell or with IPython
<repl-completion>`.

Below you can also find a list of :ref:`recipes for type hinting <recipes>`.

.. _language-servers:

Language Servers
--------------

- `jedi-language-server <https://github.com/pappasam/jedi-language-server>`_
- `python-language-server <https://github.com/palantir/python-language-server>`_
- `anakin-language-server <https://github.com/muffinmad/anakin-language-server>`_

.. _editor-plugins:

Editor Plugins
--------------

Vim
~~~

- jedi-vim_
- YouCompleteMe_
- deoplete-jedi_

Visual Studio Code
~~~~~~~~~~~~~~~~~~

- `Python Extension`_

Emacs
~~~~~

- Jedi.el_
- elpy_
- anaconda-mode_

Sublime Text 2/3
~~~~~~~~~~~~~~~~

- SublimeJEDI_ (ST2 & ST3)
- anaconda_ (only ST3)

SynWrite
~~~~~~~~

- SynJedi_

TextMate
~~~~~~~~

- Textmate_ (Not sure if it's actually working)

Kate
~~~~

- Kate_ version 4.13+ `supports it natively
  <https://projects.kde.org/projects/kde/applications/kate/repository/entry/addons/kate/pate/src/plugins/python_autocomplete_jedi.py?rev=KDE%2F4.13>`__,
  you have to enable it, though.

Atom
~~~~

- autocomplete-python-jedi_

GNOME Builder
~~~~~~~~~~~~~

- `GNOME Builder`_ `supports it natively
  <https://git.gnome.org/browse/gnome-builder/tree/plugins/jedi>`__,
  and is enabled by default.

Gedit
~~~~~

- gedi_

Eric IDE
~~~~~~~~

- `Eric IDE`_ (Available as a plugin)

Web Debugger
~~~~~~~~~~~~

- wdb_

xonsh shell
~~~~~~~~~~~

Jedi is a preinstalled extension in `xonsh shell <https://xon.sh/contents.html>`_. 
Run the following command to enable:

::

    xontrib load jedi

and many more!

.. _repl-completion:

Tab Completion in the Python Shell
----------------------------------

Jedi is a dependency of IPython. Autocompletion in IPython is therefore
possible without additional configuration.

Here is an `example video <https://vimeo.com/122332037>`_ how REPL completion
can look like in a different shell.

There are two different options how you can use Jedi autocompletion in
your ``python`` interpreter. One with your custom ``$HOME/.pythonrc.py`` file
and one that uses ``PYTHONSTARTUP``.

Using ``PYTHONSTARTUP``
~~~~~~~~~~~~~~~~~~~~~~~

.. automodule:: jedi.api.replstartup

Using a Custom ``$HOME/.pythonrc.py``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. autofunction:: jedi.utils.setup_readline

.. _recipes:

Recipes
-------

Here are some tips on how to use |jedi| efficiently.


.. _type-hinting:

Type Hinting
~~~~~~~~~~~~

If |jedi| cannot detect the type of a function argument correctly (due to the
dynamic nature of Python), you can help it by hinting the type using
one of the docstring/annotation styles below. **Only gradual typing will
always work**, all the docstring solutions are glorified hacks and more
complicated cases will probably not work.

Official Gradual Typing (Recommended)
+++++++++++++++++++++++++++++++++++++

You can read a lot about Python's gradual typing system in the corresponding
PEPs like:

- `PEP 484 <https://www.python.org/dev/peps/pep-0484/>`_ as an introduction
- `PEP 526 <https://www.python.org/dev/peps/pep-0526/>`_ for variable annotations
- `PEP 589 <https://www.python.org/dev/peps/pep-0589/>`_ for ``TypeDict``
- There are probably more :)

Below you can find a few examples how you can use this feature.

Function annotations::

    def myfunction(node: ProgramNode, foo: str) -> None:
        """Do something with a ``node``.

        """
        node.| # complete here


Assignment, for-loop and with-statement type hints::

    import typing
    x: int = foo()
    y: typing.Optional[int] = 3

    key: str
    value: Employee
    for key, value in foo.items():
        pass

    f: Union[int, float]
    with foo() as f:
        print(f + 3)

PEP-0484 should be supported in its entirety. Feel free to open issues if that
is not the case. You can also use stub files.


Sphinx style
++++++++++++

http://www.sphinx-doc.org/en/stable/domains.html#info-field-lists

::

    def myfunction(node, foo):
        """
        Do something with a ``node``.

        :type node: ProgramNode
        :param str foo: foo parameter description
        """
        node.| # complete here

Epydoc
++++++

http://epydoc.sourceforge.net/manual-fields.html

::

    def myfunction(node):
        """
        Do something with a ``node``.

        @type node: ProgramNode
        """
        node.| # complete here

Numpydoc
++++++++

https://github.com/numpy/numpy/blob/master/doc/HOWTO_DOCUMENT.rst.txt

In order to support the numpydoc format, you need to install the `numpydoc
<https://pypi.python.org/pypi/numpydoc>`__ package.

::

    def foo(var1, var2, long_var_name='hi'):
        r"""
        A one-line summary that does not use variable names or the
        function name.

        ...

        Parameters
        ----------
        var1 : array_like
            Array_like means all those objects -- lists, nested lists,
            etc. -- that can be converted to an array. We can also
            refer to variables like `var1`.
        var2 : int
            The type above can either refer to an actual Python type
            (e.g. ``int``), or describe the type of the variable in more
            detail, e.g. ``(N,) ndarray`` or ``array_like``.
        long_variable_name : {'hi', 'ho'}, optional
            Choices in brackets, default first when optional.

        ...

        """
        var2.| # complete here

.. _jedi-vim: https://github.com/davidhalter/jedi-vim
.. _youcompleteme: https://valloric.github.io/YouCompleteMe/
.. _deoplete-jedi: https://github.com/zchee/deoplete-jedi
.. _Jedi.el: https://github.com/tkf/emacs-jedi
.. _elpy: https://github.com/jorgenschaefer/elpy
.. _anaconda-mode: https://github.com/proofit404/anaconda-mode
.. _sublimejedi: https://github.com/srusskih/SublimeJEDI
.. _anaconda: https://github.com/DamnWidget/anaconda
.. _SynJedi: http://uvviewsoft.com/synjedi/
.. _wdb: https://github.com/Kozea/wdb
.. _TextMate: https://github.com/lawrenceakka/python-jedi.tmbundle
.. _kate: https://kate-editor.org/
.. _autocomplete-python-jedi: https://atom.io/packages/autocomplete-python-jedi
.. _GNOME Builder: https://wiki.gnome.org/Apps/Builder/
.. _gedi: https://github.com/isamert/gedi
.. _Eric IDE: https://eric-ide.python-projects.org
.. _Python Extension: https://marketplace.visualstudio.com/items?itemName=ms-python.python
