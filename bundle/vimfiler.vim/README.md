# vimfiler
A powerful file explorer implemented in Vim script

**Note**: Active development on vimfiler.vim has stopped. The only future
changes will be bug fixes.

Please see [Defx.nvim](https://github.com/Shougo/defx.nvim).
https://github.com/Shougo/vimfiler.vim/issues/380

## Introduction
vimfiler is a powerful file explorer ("filer") written in Vim script.

## Usage
To start vimfiler, run this command:

	:VimFiler

If you set `g:vimfiler_as_default_explorer` to 1, vimfiler will be used as the default
explorer (instead of netrw.)

	:let g:vimfiler_as_default_explorer = 1

**vimfiler depends on [unite.vim](https://github.com/Shougo/unite.vim).**

Please install unite.vim 3.0 or later before you install vimfiler.

Note: To use vimfiler with files larger than 2 GB,
      vimfiler requires Vim to have Lua support (|if_lua|).

## Screenshots

Common operations
----------------------------
![Vimfiler standard operations](https://f.cloud.github.com/assets/214488/657681/c40265e6-d56f-11e2-96fd-03d01f10cc4e.gif)

Explorer feature (similar to NERDTree)
----------------------------------------
![Vimfiler explorer](https://f.cloud.github.com/assets/214488/657685/95011fc4-d571-11e2-9934-159196cf9e59.gif)

Dark theme
----------------------------
![Vimfiler dark theme](https://cloud.githubusercontent.com/assets/147918/3933094/412cc0e0-2478-11e4-902e-63b658f04d81.png)
![another dark theme](https://user-images.githubusercontent.com/7071307/31679880-7e4d785c-b340-11e7-894e-3ea74556e491.png)

## What are some of the advantages vimfiler offers compared to other file explorers?

- Integration with [unite](https://github.com/Shougo/unite.vim)
- Integration with [vimshell](https://github.com/Shougo/vimshell.vim)
- External sources (for example, [unite-ssh](https://github.com/Shougo/unite-ssh))
- vimfiler is highly customizable.
- Many options (see |vimfiler-options|)
- Fast (if your version of Vim has |if_lua| enabled)
- Column customization
- Support for more than one screen
