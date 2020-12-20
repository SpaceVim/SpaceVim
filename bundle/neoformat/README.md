# Neoformat [![Build Status](https://travis-ci.org/sbdchd/neoformat.svg?branch=master)](https://travis-ci.org/sbdchd/neoformat)

A (Neo)vim plugin for formatting code.

Neoformat uses a variety of formatters for many filetypes. Currently, Neoformat
will run a formatter using the current buffer data, and on success it will
update the current buffer with the formatted text. On a formatter failure,
Neoformat will try the next formatter defined for the filetype.

By using `getbufline()` to read from the current buffer instead of file,
Neoformat is able to format your buffer without you having to `:w` your file first.
Also, by using `setline()`, marks, jumps, etc. are all maintained after formatting.

Neoformat supports both sending buffer data to formatters via stdin, and also
writing buffer data to `/tmp/` for formatters to read that do not support input
via stdin.

## Basic Usage

Format the entire buffer, or visual selection of the buffer

```viml
:Neoformat
```

Or specify a certain formatter (must be defined for the current filetype)

```viml
:Neoformat jsbeautify
```

Or format a visual selection of code in a different filetype

**Note:** you must use a ! and pass the filetype of the selection

```viml
:Neoformat! python
```

You can also pass a formatter to use

```viml
:Neoformat! python yapf
```

Or perhaps run a formatter on save

```viml
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
```

The `undojoin` command will put changes made by Neoformat into the same
`undo-block` with the latest preceding change. See
[Managing Undo History](#managing-undo-history).

## Install

[vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'sbdchd/neoformat'
```

## Current Limitation(s)

If a formatter is either not configured to use `stdin`, or is not able to read
from `stdin`, then buffer data will be written to a file in `/tmp/neoformat/`,
where the formatter will then read from

## Config [Optional]

Define custom formatters.

Options:

| name               | description                                                                                                       | default | optional / required |
| ------------------ | ----------------------------------------------------------------------------------------------------------------- | ------- | ------------------- |
| `exe`              | the name the formatter executable in the path                                                                     | n/a     | **required**        |
| `args`             | list of arguments                                                                                                 | \[]     | optional            |
| `replace`          | overwrite the file, instead of updating the buffer                                                                | 0       | optional            |
| `stdin`            | send data to the stdin of the formatter                                                                           | 0       | optional            |
| `stderr`           | capture stderr output from formatter                                                                              | 0       | optional            |
| `no_append`        | do not append the `path` of the file to the formatter command, used when the `path` is in the middle of a command | 0       | optional            |
| `env`              | list of environment variable definitions to be prepended to the formatter command                                 | \[]     | optional            |
| `valid_exit_codes` | list of valid exit codes for formatters who do not respect common unix practices                                  | \[0]    | optional            |

Example:

```viml
let g:neoformat_python_autopep8 = {
            \ 'exe': 'autopep8',
            \ 'args': ['-s 4', '-E'],
            \ 'replace': 1 " replace the file, instead of updating buffer (default: 0),
            \ 'stdin': 1, " send data to stdin of formatter (default: 0)
            \ 'env': ["DEBUG=1"], " prepend environment variables to formatter command
            \ 'valid_exit_codes': [0, 23],
            \ 'no_append': 1,
            \ }

let g:neoformat_enabled_python = ['autopep8']
```

Configure enabled formatters.

```viml

let g:neoformat_enabled_python = ['autopep8', 'yapf', 'docformatter', 'autoflake']

```

Have Neoformat use &formatprg as a formatter

```viml
let g:neoformat_try_formatprg = 1
```

Enable basic formatting when a filetype is not found. Disabled by default.

```viml
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
```

Run all enabled formatters (by default Neoformat stops after the first formatter
succeeds)

```viml
let g:neoformat_run_all_formatters = 1
```

Above options can be activated or deactivated per buffer. For example:

```viml
    " runs all formatters for current buffer without tab to spaces conversion
    let b:neoformat_run_all_formatters = 1
    let b:neoformat_basic_format_retab = 0
```

Have Neoformat only msg when there is an error

```viml
let g:neoformat_only_msg_on_error = 1
```

When debugging, you can enable either of following variables for extra logging.

```viml
let g:neoformat_verbose = 1 " only affects the verbosity of Neoformat
" Or
let &verbose            = 1 " also increases verbosity of the editor as a whole
```

## Adding a New Formatter

Note: you should replace everything `{{ }}` accordingly

1. Create a file in `autoload/neoformat/formatters/{{ filetype }}.vim` if it does not
   already exist for your filetype.

2. Follow the following format

See Config above for options

```viml
function! neoformat#formatters#{{ filetype }}#enabled() abort
    return ['{{ formatter name }}', '{{ other formatter name for filetype }}']
endfunction

function! neoformat#formatters#{{ filetype }}#{{ formatter name }}() abort
    return {
        \ 'exe': '{{ formatter name }}',
        \ 'args': ['-s 4', '-q'],
        \ 'stdin': 1
        \ }
endfunction

function! neoformat#formatters#{{ filetype }}#{{ other formatter name }}() abort
  return {'exe': {{ other formatter name }}
endfunction
```

## Managing Undo History

If you use an `autocmd` to run Neoformat on save, and you have your editor
configured to save automatically on `CursorHold` then you might run into
problems reverting changes. Pressing `u` will undo the last change made by
Neoformat instead of the change that you made yourself - and then Neoformat
will run again redoing the change that you just reverted. To avoid this
problem you can run Neoformat with the Vim `undojoin` command to put changes
made by Neoformat into the same `undo-block` with the preceding change. For
example:

```viml
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
```

When `undojoin` is used this way pressing `u` will "skip over" the Neoformat
changes - it will revert both the changes made by Neoformat and the change
that caused Neoformat to be invoked.

## Supported Filetypes

- Arduino
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html),
    [`astyle`](http://astyle.sourceforge.net)
- Assembly
  - [`asmfmt`](https://github.com/klauspost/asmfmt)
- Bazel
  - [`buildifier`](https://github.com/bazelbuild/buildtools/blob/master/buildifier/README.md)
- C
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html),
    [`astyle`](http://astyle.sourceforge.net)
- C#
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`astyle`](http://astyle.sourceforge.net)
- C++
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html),
    [`astyle`](http://astyle.sourceforge.net)
- CMake
  - [`cmake_format`](https://github.com/cheshirekow/cmake_format)
- Crystal
  - `crystal tool format` (ships with [`crystal`](http://crystal-lang.org))
- CSS
  - `css-beautify` (ships with [`js-beautify`](https://github.com/beautify-web/js-beautify)),
    [`prettydiff`](https://github.com/prettydiff/prettydiff),
    [`stylefmt`](https://github.com/morishitter/stylefmt),
    [`stylelint`](https://stylelint.io/),
    [`csscomb`](http://csscomb.com),
    [`prettier`](https://github.com/prettier/prettier)
- CSV
  - [`prettydiff`](https://github.com/prettydiff/prettydiff)
- D
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`dfmt`](https://github.com/Hackerpilot/dfmt)
- Dart
  - [`dartfmt`](https://www.dartlang.org/tools/)
- Dhall
  - [`dhall format`](https://dhall-lang.org)
- dune
  - [`dune format`](https://github.com/ocaml/dune)
- Elixir
  - [`mix format`](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html)
- Elm
  - [`elm-format`](https://github.com/avh4/elm-format)
- Fish
  - [`fish_indent`](http://fishshell.com)
- Go
  - [`gofmt`](https://golang.org/cmd/gofmt/),
    [`goimports`](https://godoc.org/golang.org/x/tools/cmd/goimports)
- GLSL
  - [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html)
- GraphQL
  - [`prettier`](https://github.com/prettier/prettier)
- Haskell
  - [`stylish-haskell`](https://github.com/jaspervdj/stylish-haskell),
    [`hindent`](https://github.com/chrisdone/hindent),
    [`hfmt`](https://github.com/danstiner/hfmt),
    [`brittany`](https://github.com/lspitzner/brittany),
    [`sort-imports`](https://github.com/evanrelf/sort-imports),
    [`floskell`](https://github.com/ennocramer/floskell)
    [`ormolu`](https://github.com/tweag/ormolu)
    ```vim
    let g:ormolu_ghc_opt=["TypeApplications", "RankNTypes"]
    ```
- PureScript
  - [`purty`](https://gitlab.com/joneshf/purty)
- HTML
  - `html-beautify` (ships with [`js-beautify`](https://github.com/beautify-web/js-beautify)),
    [`prettier`](https://github.com/prettier/prettier),
    [`prettydiff`](https://github.com/prettydiff/prettydiff)
- Jade
  - [`pug-beautifier`](https://github.com/vingorius/pug-beautifier)
- Java
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`astyle`](http://astyle.sourceforge.net),
    [`prettier`](https://github.com/prettier/prettier)
- JavaScript
  - [`js-beautify`](https://github.com/beautify-web/js-beautify),
    [`prettier`](https://github.com/prettier/prettier),
    [`prettydiff`](https://github.com/prettydiff/prettydiff),
    [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html),
    [`esformatter`](https://github.com/millermedeiros/esformatter/),
    [`prettier-eslint`](https://github.com/kentcdodds/prettier-eslint-cli),
    [`eslint_d`](https://github.com/mantoni/eslint_d.js)
    [`standard`](https://standardjs.com/)
- JSON
  - [`js-beautify`](https://github.com/beautify-web/js-beautify),
    [`prettydiff`](https://github.com/prettydiff/prettydiff),
    [`prettier`](https://github.com/prettier/prettier),
    [`jq`](https://stedolan.github.io/jq/),
    [`fixjson`](https://github.com/rhysd/fixjson)
- Kotlin
  - [`ktlint`](https://github.com/shyiko/ktlint),
    [`prettier`](https://github.com/prettier/prettier)
- LaTeX
  - [`latexindent`](https://github.com/cmhughes/latexindent.pl)
- Less
  - [`csscomb`](http://csscomb.com),
    [`prettydiff`](https://github.com/prettydiff/prettydiff),
    [`prettier`](https://github.com/prettier/prettier),
    [`stylelint`](https://stylelint.io/)
- Lua
  - [`luaformatter`](https://github.com/LuaDevelopmentTools/luaformatter)
  - [`lua-fmt`](https://github.com/trixnz/lua-fmt)
- Markdown
  - [`remark`](https://github.com/wooorm/remark)
    [`prettier`](https://github.com/prettier/prettier)
- Matlab
  - [`matlab-formatter-vscode`](https://github.com/affenwiesel/matlab-formatter-vscode)
- Nim
  - `nimpretty` (ships with [`nim`](https://nim-lang.org/))
- Nix
  - [`nixfmt`](https://github.com/serokell/nixfmt)
- Objective-C
  - [`uncrustify`](http://uncrustify.sourceforge.net),
    [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html),
    [`astyle`](http://astyle.sourceforge.net)
- OCaml
  - [`ocp-indent`](http://www.typerex.org/ocp-indent.html),
    [`ocamlformat`](https://github.com/ocaml-ppx/ocamlformat)
- Pandoc Markdown
  - [`pandoc`](https://pandoc.org/MANUAL.html)
- Pawn
  - [`uncrustify`](http://uncrustify.sourceforge.net)
- Perl
  - [`perltidy`](http://perltidy.sourceforge.net)
- PHP
  - [`php_beautifier`](http://pear.php.net/package/PHP_Beautifier),
    [`php-cs-fixer`](http://cs.sensiolabs.org/),
    [`phpcbf`](https://github.com/squizlabs/PHP_CodeSniffer)
- Proto
  - [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html)
- Pug (formally Jade)
  - [`pug-beautifier`](https://github.com/vingorius/pug-beautifier)
- Python
  - [`yapf`](https://github.com/google/yapf),
    [`autopep8`](https://github.com/hhatto/autopep8),
    [`black`](https://github.com/ambv/black)
    [`pydevf`](https://github.com/fabioz/PyDev.Formatter)
  - [`isort`](https://github.com/timothycrosley/isort)
  - [`docformatter`](https://github.com/myint/docformatter)
  - [`pyment`](https://github.com/dadadel/pyment)
  - [`autoflake`](https://github.com/myint/autoflake)
- R
  - [`styler`](https://github.com/r-lib/styler),
    [`formatR`](https://github.com/yihui/formatR)
- Reason
  - [`refmt`](https://github.com/facebook/reason)
- Ruby
  - [`rufo`](https://github.com/ruby-formatter/rufo),
    [`ruby-beautify`](https://github.com/erniebrodeur/ruby-beautify),
    [`rubocop`](https://github.com/bbatsov/rubocop)
- Rust
  - [`rustfmt`](https://github.com/rust-lang-nursery/rustfmt)
- Sass
  - [`sass-convert`](http://sass-lang.com/documentation/#executables),
    [`stylelint`](https://stylelint.io/),
    [`csscomb`](http://csscomb.com)
- Sbt
  - [`scalafmt`](http://scalameta.org/scalafmt/)
- Scala
  - [`scalariform`](https://github.com/scala-ide/scalariform),
    [`scalafmt`](http://scalameta.org/scalafmt/)
- SCSS
  - [`sass-convert`](http://sass-lang.com/documentation/#executables),
    [`stylelint`](https://stylelint.io/),
    [`stylefmt`](https://github.com/morishitter/stylefmt),
    [`prettydiff`](https://github.com/prettydiff/prettydiff),
    [`csscomb`](http://csscomb.com),
    [`prettier`](https://github.com/prettier/prettier)
- Shell
  - [`shfmt`](https://github.com/mvdan/sh)
    ```vim
    let g:shfmt_opt="-ci"
    ```
- SQL
  - [`sqlfmt`](https://github.com/jackc/sqlfmt),
    `sqlformat` (ships with [sqlparse](https://github.com/andialbrecht/sqlparse)),
    `pg_format` (ships with [pgFormatter](https://github.com/darold/pgFormatter))
- Starlark
  - [`buildifier`](https://github.com/bazelbuild/buildtools/blob/master/buildifier/README.md)
- Svelte
  - [`prettier-plugin-svelte`](https://github.com/UnwrittenFun/prettier-plugin-svelte)
- Swift
  - [`Swiftformat`](https://github.com/nicklockwood/SwiftFormat)
- Terraform
  - [`terraform`](https://www.terraform.io/docs/commands/fmt.html),
- TypeScript
  - [`tsfmt`](https://github.com/vvakame/typescript-formatter),
    [`prettier`](https://github.com/prettier/prettier),
    [`tslint`](https://palantir.github.io/tslint)
    [`eslint_d`](https://github.com/mantoni/eslint_d.js)
    [`clang-format`](http://clang.llvm.org/docs/ClangFormat.html),
- VALA
  - [`uncrustify`](http://uncrustify.sourceforge.net)
- Vue
  - [`prettier`](https://github.com/prettier/prettier)
- XHTML
  - [`tidy`](http://www.html-tidy.org),
    [`prettydiff`](https://github.com/prettydiff/prettydiff)
- XML
  - [`tidy`](http://www.html-tidy.org),
    [`prettydiff`](https://github.com/prettydiff/prettydiff),
    [`prettier`](https://github.com/prettier/prettier)
- YAML
  - [`pyaml`](https://pypi.python.org/pypi/pyaml),
    [`prettier`](https://github.com/prettier/prettier)
