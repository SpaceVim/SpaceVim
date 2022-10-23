.. include:: ../global.rst

Installation and Configuration
==============================

.. warning:: Most people will want to install Jedi as a submodule/vendored and
   not through pip/system wide. The reason for this is that it makes sense that
   the plugin that uses Jedi has always access to it. Otherwise Jedi will not
   work properly when virtualenvs are activated. So please read the
   documentation of your editor/IDE plugin to install Jedi.

   For plugin developers, Jedi works best if it is always available. Vendoring
   is a pretty good option for that.

You can either include |jedi| as a submodule in your text editor plugin (like
jedi-vim_ does by default), or you can install it systemwide.

.. note:: This just installs the |jedi| library, not the :ref:`editor plugins
    <editor-plugins>`. For information about how to make it work with your
    editor, refer to the corresponding documentation.


The normal way
--------------

Most people use Jedi with a :ref:`editor plugins<editor-plugins>`. Typically
you install Jedi by installing an editor plugin. No necessary steps are needed.
Just take a look at the instructions for the plugin.


With pip
--------

On any system you can install |jedi| directly from the Python package index
using pip::

    sudo pip install jedi

If you want to install the current development version (master branch)::

    sudo pip install -e git://github.com/davidhalter/jedi.git#egg=jedi


System-wide installation via a package manager
----------------------------------------------

Arch Linux
~~~~~~~~~~

You can install |jedi| directly from official Arch Linux packages:

- `python-jedi <https://www.archlinux.org/packages/community/any/python-jedi/>`__

(There is also a packaged version of the vim plugin available: 
`vim-jedi at Arch Linux <https://www.archlinux.org/packages/community/any/vim-jedi/>`__.)

Debian
~~~~~~

Debian packages are available in the `unstable repository
<https://packages.debian.org/search?keywords=python%20jedi>`__.

Others
~~~~~~

We are in the discussion of adding |jedi| to the Fedora repositories.


Manual installation from GitHub
---------------------------------------------

If you prefer not to use an automated package installer, you can clone the source from GitHub and install it manually. To install it, run these commands::

    git clone --recurse-submodules https://github.com/davidhalter/jedi
    cd jedi
    sudo python setup.py install

Inclusion as a submodule
------------------------

If you use an editor plugin like jedi-vim_, you can simply include |jedi| as a
git submodule of the plugin directory. Vim plugin managers like Vundle_ or
Pathogen_ make it very easy to keep submodules up to date.


.. _jedi-vim: https://github.com/davidhalter/jedi-vim
.. _vundle: https://github.com/gmarik/vundle
.. _pathogen: https://github.com/tpope/vim-pathogen
