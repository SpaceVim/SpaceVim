vim-pydocstring
===============

.. image:: https://github.com/heavenshell/vim-pydocstring/workflows/build/badge.svg?branch=master
  :target: https://github.com/heavenshell/vim-pydocstring

.. image:: ./assets/vim-pydocstring.gif

vim-pydocstring is a generator for Python docstrings and is capable of automatically

* inserting one-line docstrings
* inserting multi-line docstrings

This plugin is heavily inspired by `phpdoc.vim <http://www.vim.org/scripts/script.php?script_id=1355>`_ and `sonictemplate.vim <https://github.com/mattn/sonictemplate-vim>`_.

Install
-------

Since version 2, vim-pydocstring requires `doq <https://pypi.org/project/doq/>`_.

You can install following command.

.. code::

  $ make install

Note
~~~~

Activated venv needs to be deactivated before install doq.

This can be automated with vim-plug.

.. code::

  Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }

If you want install doq manually, you can install from PyPi.

.. code::

  $ python3 -m venv ./venv
  $ ./venv/bin/pip3 install doq

Then set installed `doq <https://pypi.org/project/doq/>`_ path:

.. code::

  $ which doq
  let g:pydocstring_doq_path = path/to/doq

Note
~~~~

vim-pydocstring support Vim8.

Neovim works since v2.2.0, but if something wrong, send me pull requests to fix it.

If you want use old version checkout `1.0.0 <https://github.com/heavenshell/vim-pydocstring/releases/tag/1.0.0>`_

Basic usage
-----------

1. Move your cursor on a `def` or `class` keyword line,
2. type `:Pydocstring` and
3. watch a docstring template magically appear below the current line

Format all
----------

type `:PydocstringFormat` will insert all docstrings to current buffer.

Settings
--------

Pydocstring depends on ``shiftwidth`` if ``smarttab`` is set, otherwise
``softtabstop``.  For the latter, you need to set like ``set softtabstop=4``.

Example ``.vimrc``

.. code::

  autocmd FileType python setlocal tabstop=4 shiftwidth=4 smarttab expandtab

Or:

.. code::

  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

Pydocstring use ftplugin, so `filetype plugin on` required.

Key map
-------

If you want change default keymapping, set following to your `.vimrc`.

.. code::

  nmap <silent> <C-_> <Plug>(pydocstring)

Or, if you want disable default keymapping, you can set like following.

.. code::

  let g:pydocstring_enable_mapping = 0

Formatter
---------

You can set built-in formatter(Sphinx, Numpy, Google).

.. code::

  let g:pydocstring_formatter = 'numpy'


Custom template
---------------

You can set custom template. See `example <https://github.com/heavenshell/py-doq/tree/master/examples>`_.

.. code::

  let g:pydocstring_templates_path = '/path/to/custom/templates'

Exceptions
----------

If you want add exceptions to docstring, create custom template
and visual select source block and hit `:'<,'>Pydocstring` and then
excptions add to docstring.

.. code::

  def foo():
      """Summary of foo.

      Raises:
          Exception:
      """
      raise Exception('foo')

Ignore generate __init__ docstring
----------------------------------

If you want ignore to generate `__init__` docstring, you can set like following.

.. code::

  let g:pydocstring_ignore_init = 1

Thanks
------

The idea of venv installation is from `vim-lsp-settings <https://github.com/mattn/vim-lsp-settings>`_.
Highly applicate `@mattn <https://github.com/mattn/>`_ and all vim-lsp-settings contributors.
