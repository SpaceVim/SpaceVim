Overview
--------
Vim script to help adding import statements in Python modules.

You need to have a tags file built (``:!ctags -R --extra=+f .``, be sure to use
`exuberant-ctags <http://ctags.sourceforge.net/>`_ or `Universal
Ctags <https://ctags.io/>`_). You can use `Gutentags
<https://github.com/ludovicchabant/vim-gutentags>`__ plugin for
automatic tags management.

Type ``:ImportName [<name>]`` to add an import statement at the top of the file.

Type ``:ImportNameHere [<name>]`` to add an import statement above the current
line.

Without an argument, these insert an import statement for the name under the
cursor.

Since this plugin is not very smart, it leaves the cursor on the newly inserted
line so you can see what it changed and fix it if the import ended up in the
wrong place or uses the wrong syntax.  Use ``''`` or `````` to jump back.  If
you don't like this, you can use ``:ImportName!``/``:ImportNameHere!`` to
avoid moving the cursor.

I use the following mappings to import the name under cursor with a single
keystroke::

  map <F5>    :ImportName<CR>
  map <C-F5>  :ImportNameHere<CR>

Needs Vim 7.0, preferably built with Python 3 support.  (It will still work
without Python, but functionality will be degraded, e.g. the configuration file
will be ignored.)

Integrates with `ALE <https://github.com/dense-analysis/ale>`_ to apply
``isort`` formatting automatically (this can be turned off by adding
``:let g:pythonImportsUseAleFix = 0`` to your .vimrc).

Tested on Linux only.


Installation
------------

I recommend `vim-plug <https://github.com/junegunn/vim-plug>`_ ::

  call plug#begin()
  ...
  Plug 'mgedmin/python-imports.vim'
  ...
  call plug#end()


Configuration
-------------

In addition to the ``tags`` file (and builtin logic for recognizing standard
library modules), you can define your favourite imports in a file called
``~/.vim/python-imports.cfg``.  That file should contain Python import
statements like ::

    import module1, module2 as alias, module3
    from package.module import name1, name2 as alias2, name3
    from package.module import (name1,
       name2 as alias2, name3,
    )

This file is ignored if your Vim has no +python3 support.

Additionally there are some Vim variables you can set.

**g:pythonImports** is a dictionary mapping names to modules/packages from
which they can be imported.  E.g. ::

    let g:pythonImports = get(g:, 'pythonImports', {})
    let g:pythonImports['defaultdict'] = 'collections'

will make ``:ImportName defaultdict`` insert ``from collections import defaultdict``.
You can ask for top-level module imports by using an empty string as the
containing package::

    let g:pythonImports['sqlalchemy'] = ''

will make ``:ImportName sqlalchemy`` insert ``import sqlalchemy``

**g:pythonImportAliases** is a dictionary mapping aliases to original names.  E.g. ::

    let g:pythonImports['sqlalchemy'] = ''
    let g:pythonImportAliasess['sa'] = 'sqlalchemy'

will make ``:ImportName sa`` insert ``import sqlalchemy as sa``.

**g:pythonImportsUseAleFix** makes ``:ImportName`` run ``:ALEFix isort`` after
inserting the import, so the imports get a chance to be correctly sorted and formatted.
This works great if you use `ALE <https://github.com/dense-analysis/ale>`_ and
`isort <https://pycqa.github.io/isort/>`_.

**g:pythonPaths** is documented in the next section.

There are also the following variables that you're not expected to need to override:

- **g:pythonBuiltinModules** (autodetected if possible, falls back to a
  dictionary matching Python 3.6) is a dictionary that has all the builtin
  modules so they can be recognized and imports for them can be created.

- **g:pythonExtModuleSuffix** (autodected if possible, falls back to ".so"), used to
  detect standard library modules that exist as .so files on disk.

- **g:pythonStdlibPath** (autodetected if possible), used to detect standard library modules
  that exist as .py or .so files on disk.


Special Paths
-------------

Aside from the project root path, some projects auto-import its sub-folders also
in the Python path (e.g. ``apps`` or ``conf`` folders) which is usually done to
avoid repetitive or lengthy import names. For instance,
a project that is located in ``~/my_project`` could have an ``apps`` folder
which has this logical structure ::

    from apps.alpha import bravo
    from apps.charlie import delta

But, the project team might decide to auto-import the ``apps`` folder
in the environment setup, so that the code will have this import format
for convenience ::

    from alpha import bravo
    from charlie import delta

To resolve these special imports correctly, the ``pythonPaths`` global variable
could be used ::

    let g:pythonPaths = [
        \ expand('~/my_project/apps'),
        \ expand('~/my_project/conf'),
        \ ]

Note that the ``expand()`` is used here so that the Home directory (``~``)
will be interpreted correctly.


Copyright
---------

``python-imports.vim`` was written by Marius Gedminas <marius@gedmin.as>.
Licence: MIT.
