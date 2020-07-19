# Change Log

## Version 4.6.4.1
* Added a fix for markdown commentstring

## Version 4.6.4
* Added support for center aligning columns

## Version 4.6.3
* Fixed tablemode#spreadsheet#LineNr()
* Fixed tablemode#spreadsheet#cell#SetCell()

## Version 4.6.2
* Added custom User autocmd event for tablemode activation (enabled /
  disabled)
* Adding better header support for pandoc, headers can now have a different
  fillchar configured with `g:table_mode_header_fillchar`

## Version 4.6.1
* Minor bug fixes

## Version 4.6.0
* Added better table header support. The first line of the table if separated
  by a table border will be considered as the header. This also means that it
  will not be considered / included when evaluating table formulas and that
  the first line after the header would be considered the first line of the
  table.

## Version 4.5.0
* Refactored toggled mappings
* Table Syntax now gets toggled with Table Mode

## Version 4.4.2
* Updated mappings to be buffer local.
* Updated mappings to toggle and function only when table mode is active.

## Version 4.4.1
* Added syntax for matching tables

## Version 4.4.0
* Minor bug fixes
* Added feature to allow using negative indices within formulas to access rows,
  columns relative to the last, -1 being the last.

## Version 4.3.0
* Refactored some more
* Fixed issue #19, hiphens in the table broke alignment
* Added feature #26, you can now define column alignments in the table header

## Version 4.2.0
* Refactored cells logic out to autoload/tablemode/spreadsheet/cell.vim
* Refactored formula logic out to autoload/tablemode/spreadsheet/formula.vim

## Version 4.1.0
* Fixed bad references within plugin
* Added fixtures

## Version 4.0.0
* Major refactoring of the codebase.
* Improved modular tests.
* Fixed long standing unicode character alignment issue.
* Moved to providing \<Plug\> mappings rather than configuration based mappings
  which can be more easily overriden by end user.

## Version 3.3.2
* Added new mapping \t? to echo a cells representation for use while defining
  formulas.

## Version 3.3.1
* Improved logic to ignore table borders (add as many as you'd like), the
  first row is not treated special, it is row # 1. Keep that in mind while
  defining Formulas
* Improved test coverage

## Version 3.3
* Dropped +- mapping to create table border instead now using ||
* You can now have a top table border (before header) as well as a bottom
  table border.

## Version 3.2
* Added tests to test various use cases using <a
  href='https://github.com/kana/vim-vspec'>Vspec</a>..
* Added travis integration for automated tests.

## Version 3.1
* Removed borders. You can now optionally create a table header by simply
  adding a header border immidiately after the header line by using the
  iabbrev trigger '+-'. Just type that on the line immidiately after the
  header and press space / \<CR\> to complete the header border.
* Some Bug Fixes

## Version 3.0
* Removed dependence on Tabular and added code borrowed from Tabular for
  aligning the table rows.
* Added feature to be able to define & evaluate formulas.

## Version 2.4.0
* Added Table Cell text object.
* Added api to delete entire table row.
* Added api to delete entire table column.

## Version 2.3.0
* Refactored realignment logic. Generating borders by hand.

## Version 2.2.2
* Added mapping for realigning table columns.
* Added table motions to move around in the table.

## Version 2.2.1
* Added feature to allow Table-Mode to work within comments. Uses
  'commentstring' option of vim to identify comments, so it should work for
  most filetypes as long as 'commentstring' option has been set. This is
  usually done appropriately in filetype plugins.

## Version 2.2
* Improved :Tableize to now accept a {pattern} just like :Tabular to match the
  delimiter.

## Version 2.1.3 :
* Bug Fix #1, added new option `g:table_mode_no_border_padding` which removes
  padding from the border.

## Version 2.1.2 :
* Bug Fixes #2, #3 & #4

## Version 2.1.1 :
* Added option `g:table_mode_align` to allow setting Tabular format option for
  more control on how Tabular aligns text.

## Version 2.1 :
* VIM loads plugins in alphabetical order and so table-mode would be loaded
  before Tabularize which it depends on. Hence Moved plugin into an after
  plugin. Checking if Tabularize is available and finish immidiately if it's
  not.

## Version 2.0 :
* Moved bulk of code to autoload for vimscript optimisation.

## Version 1.1 :
* Added Tableize command and mapping to convert existing content into a table.

## Version 1.0 :
* First stable release, create tables as you type.

<!--
  vim: ft=markdown
-->
