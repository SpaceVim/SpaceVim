# [![Neomake](https://cloud.githubusercontent.com/assets/111942/22717189/9e3e1760-ed67-11e6-94c5-e8955869d6d0.png)](#neomake)

[![Build Status](https://circleci.com/gh/neomake/neomake.png?style=shield)](https://circleci.com/gh/neomake/neomake)
[![codecov](https://codecov.io/gh/neomake/neomake/branch/master/graph/badge.svg)](https://codecov.io/gh/neomake/neomake)
[![Coveralls](https://coveralls.io/repos/github/neomake/neomake/badge.svg)](https://coveralls.io/github/neomake/neomake)

Neomake is a plugin for [Vim]/[Neovim] to asynchronously run programs.

You can use it instead of the built-in `:make` command (since it can pick
up your `'makeprg'` setting), but its focus is on providing an extra layer
of makers based on the current file (type) or project.
Its origin is a proof-of-concept for [Syntastic] to be asynchronous.

## Requirements

### Neovim

With Neovim any release will do (after 0.0.0-alpha+201503292107).

### Vim

The minimal Vim version supported by Neomake is 7.4.503 (although if you don't
use `g:neomake_logfile` older versions will probably work fine as well).

You need Vim 8.0.0027 or later for asynchronous features.

## Installation

Use your preferred installation method for Vim plugins.

With [vim-plug](https://github.com/junegunn/vim-plug) that would mean to add
the following to your vimrc:

```vim
Plug 'neomake/neomake'
```

## Setup

If you want to run Neomake automatically (in file mode), you can configure it
in your `vimrc` by using `neomake#configure#automake`, e.g. by picking one of:

```vim
" When writing a buffer (no delay).
call neomake#configure#automake('w')
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing (no delay).
call neomake#configure#automake('rw', 1000)
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)
```

(Any function calls like these need to come after indicating the end of plugins
to your plugin manager, e.g. after `call plug#end()` with vim-plug.)

### Advanced setup

The author liked to use the following, which uses different modes based on if
your laptop runs on battery (for MacOS or Linux):

```vim
function! MyOnBattery()
  if has('macunix')
    return match(system('pmset -g batt'), "Now drawing from 'Battery Power'") != -1
  elseif has('unix')
    return readfile('/sys/class/power_supply/AC/online') == ['0']
  endif
  return 0
endfunction

if MyOnBattery()
  call neomake#configure#automake('w')
else
  call neomake#configure#automake('nw', 1000)
endif
```

See `:help neomake-automake` (in [doc/neomake.txt](doc/neomake.txt)) for more
information, e.g. how to configure it based on certain autocommands explicitly,
and for details about which events get used for the different string-based
modes.

## Usage

When calling `:Neomake` manually (or automatically through
`neomake#configure#automake` (see above)) it will populate the window's
location list with any issues that get reported by the maker(s).

You can then navigate them using the built-in methods like `:lwindow` /
`:lopen` (to view the list) and `:lprev` / `:lnext` to go back and forth.

You can configure Neomake to open the list automatically:

```vim
let g:neomake_open_list = 2
```

Please refer to [`:help neomake.txt`] for more details on configuration.

### Maker types

There are two types of makers: file makers (acting on the current buffer) and
project makers (acting globally).

You invoke file makers using `:Neomake`, and project makers using `:Neomake!`.

See [`:help neomake.txt`] for more details.

### Manually run a maker

You can run a specific maker on the current file by specifying the maker's
name, e.g. `:Neomake jshint` (you can use Vim's completion here to complete
maker names).

## Default makers

For a list of default makers please see the
[Makers page in the wiki](https://github.com/neomake/neomake/wiki/Makers).

# Contributing

If you find this plugin useful, please contribute your maker recipes to the
repository! Check out `autoload/neomake/makers/**/*.vim` for existing makers.

This is a community driven project, and maintainers are wanted.
Please contact [@blueyed](https://github.com/blueyed) if you are interested.
You should have a good profile of issue triaging and PRs on this repo already.

## Hacking / Testing

We are using [Vader](https://github.com/junegunn/vader.vim) for our tests.

### Logging

Set `let g:neomake_logfile = '/tmp/neomake.log'` (dynamically or in your vimrc)
to  enable debug logging to the given file.
From Neomake's source tree you can then run `make tail_log`, which will color
the output and pipe it into `less`, which folds long lines by default and will
follow the output (like `tail -f`).
You can use Ctrl-C to interrupt for scrolling etc, and then F to follow again.

### Running tests

#### Run all tests against your local Neovim and Vim

    make test

#### Run a specific test file

    make tests/integration.vader

#### Run some specific tests for Vim

    make testvim VADER_ARGS=tests/integration.vader

### Dockerized tests

The `docker_test` target runs tests for a specific Vim version.
See `Dockerfile.tests` for the Vim versions provided in the Docker image.

The image for this gets pulled from Docker Hub via
[neomake/vims-for-tests](https://hub.docker.com/r/neomake/vims-for-tests/).

NOTE: the Docker image used for tests does not include (different versions)
of Neovim at the moment.

#### Run all tests for Vim 8.0.586

    make docker_test DOCKER_VIM=vim-8.0.586

#### Run all tests against all Vims in the Docker image

    make docker_test_all

## Donate

 * Bitcoin: 1JscK5VaHyBhdE2ayVr63hDc6Mx94m9Y7R
 * Flattr: [![Flattr](http://api.flattr.com/button/flattr-badge-large.png)](
https://flattr.com/submit/auto?user_id=blueyed&url=https://github.com/neomake/neomake&title=Neomake&language=en_GB&tags=github&category=software)

[Neovim]: http://neovim.org/
[Vim]: http://vim.org/
[Syntastic]: https://github.com/scrooloose/syntastic
[cargo]: https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/cargo.vim
[mvn]: https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/mvn.vim
[`:help neomake.txt`]: doc/neomake.txt
