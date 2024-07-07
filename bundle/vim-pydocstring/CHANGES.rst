Version 2.5.0
-------------

Released on Aug 22th 2020

- Add ignore_init option

  see https://github.com/heavenshell/py-doq/releases/tag/0.8.0

Version 2.4.0
-------------

Released on Dec 6th 2020

- Remove blank line at Neovim

  Neovim add blank line to the end of file when PydocstringFormat executed.
  This behavior is not expected and fix as Vim's behavior.

Version 2.3.7
-------------

Released on Dec 6th 2020

- Fix PydocstringFormat also fixed

  see https://github.com/heavenshell/vim-pydocstring/issues/123

  Thx @tsuyoshicho

Version 2.3.6
-------------

Released on Dec 6th 2020

- Remove unnecessary complete

  see https://github.com/heavenshell/vim-pydocstring/issues/119

  Thx @tsuyoshicho

Version 2.3.5
-------------

Released on Dec 6th 2020

- Fix buffer local mapping

  see https://github.com/heavenshell/vim-pydocstring/pull/118

  Thx @tsuyoshicho

Version 2.3.4
-------------

Released on Nov 12th 2020

- Add option f and n for ln command

  see https://github.com/heavenshell/vim-pydocstring/pull/112

  Thx @roachsinai

Version 2.3.3
-------------

Released on Nov 11th 2020

- Add support for smarttab / shiftwidth

  see https://github.com/heavenshell/vim-pydocstring/pull/110

  Thx @brentyi

Version 2.3.2
-------------

Released on Jul 12th 2020

- Bug fix

  - PydocstringFormat deletes file contents if docstrings already present

  see https://github.com/heavenshell/vim-pydocstring/pull/105

  Thx @jrwrigh @edkirk30

Version 2.3.1
-------------

Released on Apr 30th 2020

- Document fix

  - Add README note regarding vim-plug and venv

  see https://github.com/heavenshell/vim-pydocstring/pull/95

  Thx @acamso

Version 2.3.0
-------------

Released on Apr 28th 2020

- Minor changes

  - Add support for Neovim

  see https://github.com/heavenshell/vim-pydocstring/pull/89

  Thx @brentyi, @nkakouros

Version 2.2.0
-------------

Released on Mar 31th 2020

- Bug fix

  - Fix can use relative path

  see https://github.com/heavenshell/vim-pydocstring/issues/82

  Thx @Trashcleaner

- Add exception feature

  see https://github.com/heavenshell/vim-pydocstring/pull/79

  Thx @JPFrancoia


Version 2.1.0
-------------
Released on Mar 3rd 2020

- Bug fix

  - Emits error only if in vim

  see https://github.com/heavenshell/vim-pydocstring/pull/72

  Thx @nkakouros

Version 2.0.0
-------------
Released on Feb 22th 2020

Version 2.0.0

Version 1.0.0
-------------
Released on Feb 9th 2020

Last version of pure Vim script

Version 0.7.0
-------------
Released on Jan 18th 2020

- Bug fix

  - default value as dict create wrong docstring

  see https://github.com/heavenshell/vim-pydocstring/issues/61

  Thx @LucaZampieri

Version 0.6.0
-------------
Released on Jun 30th 2018

- Bug fix

  - indent doesn't work with `{{_return_type_}}` or `{{_nested_indent_}}`

  see https://github.com/heavenshell/vim-pydocstring/issues/51

  Thx @JPFrancoia

Version 0.5.0
-------------
Released on Jun 30th 2018

- Bug fix

  - Generate missing param

  see https://github.com/heavenshell/vim-pydocstring/issues/44

Version 0.4.0
-------------
Released on May 6th 2018

- Bug fix

  - Default parameter problem

  see https://github.com/heavenshell/vim-pydocstring/issues/46

Version 0.3.0
-------------
Released on Dec 10th 2017

- Bug fix

  - Nested typed args(e.g `List[int, int, int]`) are broken
  - Cosmetic changes

  see https://github.com/heavenshell/vim-pydocstring/issues/40


Version 0.2.0
-------------
Released on Nov 19th 2017

- Minor changes

  - Notice template `{{_return_type_}}` does not add extra blank
  - Now template shows as is

Version 0.1.6
-------------
Released on Nov 18th 2017

- Minor changes

  - Change function name camelCase to snake_case
  - Change variable name camelCase to snake_case

  see https://github.com/heavenshell/vim-pydocstring/issues/34

Version 0.1.5
-------------
Released on Nov 18th 2017

- Fix bug

  - Invalid space after {{_header_}}
  - Document's custom template section was wrong

  see https://github.com/heavenshell/vim-pydocstring/issues/34

  Thx @themightyoarfish

Version 0.1.4
-------------
Released on Sep 10th 2017

- Fix bug

  Template does not exist exception at set wildignore=*.txt

  see https://github.com/heavenshell/vim-pydocstring/pull/32

  Thx @demonye

Version 0.1.3
-------------
Released on Jul 18th 2017

- Fix bug

  Do not ignore `.`.

  see https://github.com/heavenshell/vim-pydocstring/issues/28

Released on July 2nd 2017

- Fix bug

  Variable type mismatch for: argTemplate

  see https://github.com/heavenshell/vim-pydocstring/issues/25

  Thx @oxo42

Version 0.1.2
-------------
Released on Mar 25th 2017

- Fix bug

  Ignored indent when docstring start with `'''`.

  Delete blank line if `{{_returnType_}}` not exists.

  see https://github.com/heavenshell/vim-pydocstring/issues/19

  Thx @brainscience

Version 0.1.1
-------------
Released on Feb 12th 2017

- Fix bug

  If none typed arg, lack of last `:`.

  see https://github.com/heavenshell/vim-pydocstring/issues/17

Version 0.1.0
-------------
Released on Dec 25th 2016

- Add type-hint

  see https://github.com/heavenshell/vim-pydocstring/pull/15

  Thx @letientai299

Version 0.0.9
-------------
Released on Nov 20th 2016

- Add Vader integration tests

  see https://github.com/heavenshell/vim-pydocstring/pull/14

  Thx @letientai299

Version 0.0.8
-------------
Released on Sep 1th 2016

- Fix add expand to allow relative path

  see https://github.com/heavenshell/vim-pydocstring/pull/12

  thx @ning-yang

Version 0.0.7
-------------
Released on June 1th 2016

- add ``_nested_indent_`` template variable.

  see https://github.com/heavenshell/vim-pydocstring/issues/3#issuecomment-222584162

  Thx @pirDOL

Version 0.0.6
-------------
Released on January 17th 2016

- add ``pydocstring_enable_mapping`` option.

  Thx @nfischer

Version 0.0.5
-------------
Released on September 28th 2015

- Tiny refactoring.

Version 0.0.4
-------------
Released on September 14th 2015

- Enable to use ``async`` keyword


Version 0.0.3
-------------

Released on December 14th 2013

- Fix issue#5

Version 0.0.2
-------------

Released on December 06th 2013

- Add template variables for Numpy style docstring
