coveragepy.vim
==============
A Vim plugin to help integrate Ned Batchelder's excellent ``coverage.py`` (see:
http://nedbatchelder.com/code/coverage/) tool into the editor.

Allows you to bring up a buffer with detailed information from a coverage
report command and mark each line in your source that is not being covered.

You can also use that buffer to navigate into files that have reported missing
statements and display the missed lines.

Optionally, you can also hide or display the marks as you make progress.

Showing a Coverage Report
-------------------------

.. image:: https://github.com/alfredodeza/coveragepy.vim/raw/master/extras/session.png


Installation
------------
If you have Tim Pope's Pathogen you only need to place the plugin directory
inside your bundle dir, otherwise it is a single file that should go into::

    vim/ftplugin/python/

Usage
=====
This plugin provides a single command: ``Coveragepy`` that accepts a few
arguments. Each argument and its usage is described in detail below.

Whenever a ``report`` or a ``session`` is called the cursor will be placed on
the first uncovered line if any.

``report``
--------
The main action is performed with this command (same as with ``coverage.py``) and
when it runs it calls ``coverage.py`` and loads the information into a split
buffer.

It also collects all the information needed to be able to mark all lines from
files that have reported missing coverage statements. To run this command do::

    :Coveragepy report


``session``
-----------
This argument toggles the reporting buffer (closes it is open or opens if it is
not already there). Makes sense to map it directly as a shortcut as it is
completely toggable.

A big plus on this session buffer is that you can navigate through the list of
reported paths (it actually circles through!) with the arrow keys or j and k.

If you want to navigate to a reported path that has missing lines just hit
Enter (or Return) and the plugin will go to the previous window and open that
selected file and then display the missing lines.


``show``
--------
Shows or hides the actual Vim `sign` marks that display which lines are missing
coverage. It is implemented as a toggable argument so it will do the opposite
of what is currently shown.
It is useful to be able to hide these if you are already aware about the lines
that need to be covered and do not want to be visually disturbed by the signs.


``refresh``
--------
Reloads and parses coverage data similar to ``:Coveragepy report`` but does
not open report window and only updates line coverage marks (displayed by
``show`` command above).


``version``
-----------
Displays the current plugin version


sign configuration
------------------
By default, the character used for identifying uncovered lines is '^', but this
can be overridden with the following configuration flag::

    g:coveragepy_uncovered_sign

In a ``.vimrc`` file or locally in a buffer, changing this value to `-` would
look like::

    let g:coveragepy_uncovered_sign = '-'


Executable auto-detection
-------------------------
The plugin tries to detect the right executable name for ``coverage`` in the
following order of precedence:

* ``coverage``
* ``python-coverage``
* ``python3-coverage``
* ``python2-coverage``
* ``python2.7-coverage``

If none of the above match or if multiple exist but are not suitable for the
project (e.g. both python2 and python3 exist), it is possible to force it by
using the following configuration flag::

    let g:coveragepy_executable = "/path/to/prefered/coverage"


License
-------

MIT
Copyright (c) 2011 Alfredo Deza <alfredodeza [at] gmail [dot] com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


