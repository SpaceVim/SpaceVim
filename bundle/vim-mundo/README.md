vim-mundo
=========
A Vim plugin to visualizes the Vim [undo tree].

<img src="https://simnalamburt.github.io/vim-mundo/screenshot.png">

* [Official webpage]
* [Introductory Video]

<br>

### How is this different than other plugins?
Mundo is a fork of [Gundo], and it has bunch of improvements.

* Several new features:
  * Ability to search undo history using <kbd>/</kbd>.
  * An 'in line' diff mode.
  * Navigation keys <kbd>J</kbd> and <kbd>K</kbd> to move thru written undos.
* Merged upstream [pull requests]:
  * [Fix paths with spaces][pr-29]
  * [Display timestamps in ISO format][pr-28]
  * [Real time updates][i-40]
  * [Show changes saved to disk][i-34]
  * [Python NoneType errors][i-38]
  * [open vimdiff of current buffer][i-28]
  * [Add global_disable option][i-33]
  * [Reduce verbosity][i-31]
* [Neovim] support

#### What's your further plan?
* Make faster
* Automated test

<br>

### Requirements
* Vim ≥ *7.3* &nbsp; *or* &nbsp; [Neovim]
* `+python3` or `+python` compile option
* Python ≥ *2.4*

Recommended vim settings:
```vim
" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo
```

<br>

### Installation

It is recommended to use one of the popular plugin managers for Vim. There are
many and you probably already have a preferred one, but a few examples for your
copy-and-paste convenience:

#### Pathogen

    $ git clone https://github.com/simnalamburt/vim-mundo ~/.vim/bundle/mundo.vim

#### Vundle

```vim
Plugin 'simnalamburt/vim-mundo'
```

#### NeoBundle

```vim
NeoBundle 'simnalamburt/vim-mundo'
```

#### Vim-Plug

```vim
Plug 'simnalamburt/vim-mundo'
```

#### Manual (not recommended)

[Download](releases) the plugin and extract it in `~/.vim/` (or
`%PROGRAMFILES%/Vim/vimfiles` on Windows).

#### Unit tests
Tests unit tests can be run with [nose]:
```shell
cd autoload
nosetests
```

<br>

--------

*vim-mundo* is primarily distributed under the terms of the [GNU General Public
License, version 2] or any later version. See [COPYRIGHT] for details.

[pull requests]: https://github.com/sjl/gundo.vim/pulls
[undo tree]: https://neovim.io/doc/user/undo.html#undo-tree
[Gundo]: https://github.com/sjl/gundo.vim
[Official webpage]: https://simnalamburt.github.io/vim-mundo
[Introductory Video]: https://simnalamburt.github.io/vim-mundo/screencast.mp4
[Neovim]: https://neovim.io
[pr-29]: https://github.com/sjl/gundo.vim/pull/29
[pr-28]: https://github.com/sjl/gundo.vim/pull/28
[i-34]: https://bitbucket.org/sjl/gundo.vim/issue/34/show-changes-that-were-saved-onto-disk
[i-38]: https://bitbucket.org/sjl/gundo.vim/issue/38/python-errors-nonetype-not-iterable-with
[i-40]: https://bitbucket.org/sjl/gundo.vim/issue/40/feature-request-live-reload
[i-28]: https://bitbucket.org/sjl/gundo.vim/issue/28/feature-request-open-vimdiff-of-current#comment-3129981
[i-33]: https://bitbucket.org/sjl/gundo.vim/issue/33/let-g-gundo_disable-0-is-not-available
[i-31]: https://bitbucket.org/sjl/gundo.vim/issue/31/reduce-verbosity-of-the-list
[nose]: https://nose.readthedocs.org/en/latest/
[GNU General Public License, version 2]: LICENSE
[COPYRIGHT]: COPYRIGHT
