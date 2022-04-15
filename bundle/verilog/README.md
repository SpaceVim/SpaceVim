# Vim Syntax Plugin for Verilog and SystemVerilog

[![Build Status](https://travis-ci.org/vhda/verilog_systemverilog.vim.svg?branch=master)](https://travis-ci.org/vhda/verilog_systemverilog.vim)

## About

Based on script originally found at:

http://www.vim.org/scripts/script.php?script_id=1586

[comment]: <http://> "_ stop highlighting the underscore from the link above"

## IMPORTANT NOTICE

Version 3.0 reviews the configuration variables used in this plugin. As
such, take into account that the following variables were deprecated and
are no longer supported:

* `b:verilog_indent_modules`
* `b:verilog_indent_preproc`
* `g:verilog_dont_deindent_eos`

The following variables were renamed:

* `g:verilog_disable_indent` -> `g:verilog_disable_indent_lst`
* `g:verilog_syntax_fold` -> `g:verilog_syntax_fold_lst`

Most configuration variables now also support buffer local variables,
allowing exceptions to the default configuration through the use of
`autocmd`.

## Features

Besides some bug corrections, the following features were added to this set of scripts:

* Omni completion.
* Configurable syntax folding.
* Matchit settings to support Verilog 2001 and SystemVerilog.
* Error format definitions for common Verilog tools.
* Commands for code navigation.

### Omni Completion

This plugin implements an omni completion function that will offer completion
suggestions depending on the current context. This will only work if a `.`
character is found in the keyword behind the cursor. At the moment the following
contexts are supported:

1. Module instantiation port names.
2. Function/task arguments.
3. Object methods and attributes.

In order to use omni completion a tags file must be generated using the
following arguments:

* `--extra=+q` - Enable hierarchy qualified tags extraction.
* `--fields=+i` - Enable class inheritance extraction.
* `-n` - (Optional) Use line number instead of Ex: patterns to identify
  declaration.

No tool alternative to [universal-ctags][e] was tested, but any tool should work
seemingly as long as it is able to generate a standard class qualified tags file.
For more information on using omni completion please check the vim man page for
[`i_CTRL-X_CTRL-O`][vim-omni] (the required option [`omnifunc`][vim-omnifunc] is
automatically defined for the supported file extensions).

[comment]: <http://> "TODO Explain how gd works"

__Note__: Proper SystemVerilog tag generation requires development version of
[universal-ctags][c].

### Syntax folding

To enable syntax folding set the following option:

```VimL
set foldmethod=syntax
```

### Verilog Compilation and Error format

This plugin includes the [errorformat][vim-errorformat] configurations for
the following Verilog tools:

* Synopsys VCS (`vcs`)
* Mentor Modelsim (`msim`)
* Icarus Verilog (`iverilog`)
* GPL Cver (`cver`)
* Synopsys Leda (`leda`)
* Verilator (`verilator`)
* Cadence NCVerilog (`ncverilog`)

The command `VerilogErrorFormat` allows the interactive selection of these
configurations. In some cases it is also possible to ignore _lint_ and/or
_warning_ level messages.

A specific tool can be directly selected calling this command with some
arguments. Below is an example for `VCS`:

```VimL
:VerilogErrorFormat vcs 2
```

In this example the second argument disables the detection of _lint_ messages.
This argument can take the following values:

1. All messages are detected.
2. Ignore _lint_ messages.
3. Ignore _lint_ and _warning_ messages.

After the [errorformat][vim-errorformat] has been so defined, it is only a
matter of setting [makeprg][vim-makeprg] and run `:make` to call the tool of
choice and vim will automatically detect errors, open the required file and
place the cursor on the error position. To navigate the error list use the
commands `:cnext` and `:cprevious`.

For more information check the help page for the [quickfix][vim-quickfix]
vim feature.

### Following an Instance

A framework is provided to follow a module instance to its module
declaration as long as its respective entry exists in the tags file. To
do so simply execute `:VerilogFollowInstance` within the instance to
follow it to its declaration.

Alternatively, if the cursor is placed over a port of the instance the
command `:VerilogFollowPort` can be used to navigate to the module
declaration and immediately searching for that port.

These commands can be mapped as following:

```VimL
nnoremap <leader>i :VerilogFollowInstance<CR>
nnoremap <leader>I :VerilogFollowPort<CR>
```

### Jump to start of current instance

The command `:VerilogGotoInstanceStart` is provided to move the cursor
to the start of the first module instantiation that precedes the current
cursor location.

This command can be mapped as following:

```VimL
nnoremap <leader>u :VerilogGotoInstanceStart<CR>
```

## Installation

### Using [vim-plug][P]

1. Add the following to your `vimrc`:

   ```VimL
   Plug 'vhda/verilog_systemverilog.vim'
   ```

2. Run:

   ```Shell
   $ vim +PlugInstall +qall
   ```

### Using [Vundle][v]

1. Add the following to your `vimrc`:

   ```VimL
   Plugin 'vhda/verilog_systemverilog.vim'
   ```

2. Run:

   ```Shell
   $ vim +PluginInstall +qall
   ```

### Using [Pathogen][p]

```Shell
$ cd ~/.vim/bundle
$ git clone https://github.com/vhda/verilog_systemverilog.vim
```

## Other Vim addons helpful for Verilog/SystemVerilog

### Matchit

This addon allows using <kbd>%</kbd> to jump between matching keywords as Vim already
does for matching parentheses/brackets. Many syntax files include the definition
of the matching keyword pairs for their supported languages.

Since it is already included in all Vim installations and the addon can be
easily loaded by adding the following line to `.vimrc`:

```VimL
runtime macros/matchit.vim
```

### Highlight Matchit

The [hl_matchit.vim][hl_matchit] addon complements Matchit by automatically
underlining matching words, similarly as Vim already does for
parentheses/brackets.

### Supertab

[Supertab][supertab] configures the <kbd>tab</kbd> key to perform insert
completion. To take full advantage of the omni completion functionality the
following configuration should be used:

```VimL
let g:SuperTabDefaultCompletionType = 'context'
```

When this is done [Supertab][supertab] will choose the most appropriate type of
completion to use depending on the current context.

### Tagbar

[Tagbar][t] allows browsing all variable, functions, tasks, etc within a file in
a nice hierarchical view. SystemVerilog language and Verilog/SystemVerilog
hierarchical browsing are only supported when used together with the development
version of [universal-ctags][c].

The required filetype related configuration for [Tagbar][t] is included
within this addon.

### FastFold

Vim can become very slow in Insert mode when using [Syntax
Folding][vim-synfold] and the folds extend across the complete file. The
[FastFold][f] addon overcomes this limitation by automatically creating
manual folds from the syntax generated ones. More information about this
problem and on how to configure the addon can be found on its GitHub
page.

[c]: https://github.com/universal-ctags/ctags
[f]: https://github.com/Konfekt/FastFold
[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
[P]: https://github.com/junegunn/vim-plug
[e]: https://ctags.io
[t]: http://majutsushi.github.io/tagbar/
[hl_matchit]:   https://github.com/vimtaku/hl_matchit.vim
[supertab]:     https://github.com/ervandew/supertab
[vim-omni]:     http://vimdoc.sourceforge.net/htmldoc/insert.html#i_CTRL-X_CTRL-O
[vim-omnifunc]: http://vimdoc.sourceforge.net/htmldoc/options.html#'omnifunc'
[vim-echom]:    http://vimdoc.sourceforge.net/htmldoc/eval.html#:echom
[vim-errorformat]: http://vimdoc.sourceforge.net/htmldoc/options.html#'errorformat'
[vim-makeprg]:  http://vimdoc.sourceforge.net/htmldoc/options.html#'makeprg'
[vim-quickfix]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html
[vim-synfold]:  http://vimdoc.sourceforge.net/htmldoc/syntax.html#syntax


<!-- Other links:
https://github.com/nachumk/systemverilog.vim
-->
