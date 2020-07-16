![incsearch.vim](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/incsearch_logo.png)

[![Build Status](https://travis-ci.org/haya14busa/incsearch.vim.svg?branch=master)](https://travis-ci.org/haya14busa/incsearch.vim)
[![Build status](https://ci.appveyor.com/api/projects/status/ks6gtsu46c1djoo6/branch/master)](https://ci.appveyor.com/project/haya14busa/incsearch-vim/branch/master)
[![](http://img.shields.io/github/tag/haya14busa/incsearch.vim.svg)](https://github.com/haya14busa/incsearch.vim/releases)
[![](http://img.shields.io/github/issues/haya14busa/incsearch.vim.svg)](https://github.com/haya14busa/incsearch.vim/issues)
[![](http://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![](http://img.shields.io/badge/doc-%3Ah%20incsearch.txt-red.svg)](doc/incsearch.txt)

![](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/incremental_regex_building.gif)

Introduction
------------
incsearch.vim incrementally highlights __ALL__ pattern matches unlike default
'incsearch'.

Concepts
--------

### 1. Simple
incsearch.vim provides simple improved incremental searching.

### 2. Comfortable
You can use it comfortably like the default search(`/`, `?`).
It supports all modes (normal, visual, operator-pending mode), dot-repeat `.`,
`{offset}` flags, and so on.

### 3. Useful
incsearch.vim aims to be simple, but at the same time, it offers useful features.

#### Incremental regular expression editing
You can see all patterns that the given regular expression matches all at once
while incremental searching.

Usage
-----

### Installation

[Neobundle](https://github.com/Shougo/neobundle.vim) / [Vundle](https://github.com/gmarik/Vundle.vim) / [vim-plug](https://github.com/junegunn/vim-plug)

```vim
NeoBundle 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch.vim'
```

[pathogen](https://github.com/tpope/vim-pathogen)

```
git clone https://github.com/haya14busa/incsearch.vim ~/.vim/bundle/incsearch.vim
```

### Basic usage
```vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
```

`<Plug>(incsearch-stay)` doesn't move the cursor.

### Additional usages
README introduces some features, but please see [:h incsearch.vim](doc/incsearch.txt) for more information.

#### Automatic :nohlsearch

![](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/incsearch_auto_nohlsearch.gif)

Farewell, `nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>`!
This feature turns 'hlsearch' off automatically after searching-related motions.

```vim
" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
```

### Emacs-like incsearch: move the cursor while incremental searching

![](https://cloud.githubusercontent.com/assets/3797062/3866152/40e11c48-1fc4-11e4-8cfd-ace452a19f90.gif)

Move the cursor to next/previous matches while incremental searching like Emacs.

| Mapping                  | description                       |
| ------------------------ | --------------------------------- |
| `<Over>(incsearch-next)` | to next match. default: `<Tab>`   |
| `<Over>(incsearch-prev)` | to prev match. default: `<S-Tab>` |

### Scroll-like feature while incremental searching

![](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/incremental_move_and_scroll.gif)

| Mapping                      | description                                         |
| ------------------------     | ---------------------------------                   |
| `<Over>(incsearch-scroll-f)` | scroll to the next page match. default: `<C-j>`     |
| `<Over>(incsearch-scroll-b)` | scroll to the previous page match. default: `<C-k>` |

:tada: Version 2.0 :tada:
-------------------------
Now, incsearch.vim provides some (experimental) API.
You can implement or use very useful yet another search command :mag_right:

### Experimental API
- `:h incsearch#go()`
- `:h incsearch-config`

Starts incsearch.vim with your custom configuration. See help docs for more detail.

### Converter feature
- `:h incsearch-config-converters`
- The list of converter extensions: https://github.com/haya14busa/incsearch.vim/wiki/List-of-plugins-for-incsearch.vim#converter-extensions

#### Example

```vim
function! s:noregexp(pattern) abort
  return '\V' . escape(a:pattern, '\')
endfunction

function! s:config() abort
  return {'converters': [function('s:noregexp')]}
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config())
```

incsearch.vim x fuzzy https://github.com/haya14busa/incsearch-fuzzy.vim
![incsearch-fuzzy.gif](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/extensions/incsearch-fuzzy.gif)

### Module extension
- `:h incsearch-config-modules`
- The list of module extentions: https://github.com/haya14busa/incsearch.vim/wiki/List-of-plugins-for-incsearch.vim#module-extensions

incsearch.vim x fuzzy x vim-easymotion https://github.com/haya14busa/incsearch-easymotion.vim
![incsearch-fuzzy-easymotion.gif](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/extensions/incsearch-fuzzy-easymotion.gif)

Author
------
haya14busa (https://github.com/haya14busa)

Special thanks
--------------
osyo-manga(https://github.com/osyo-manga), the author of
the custom command line library, https://github.com/osyo-manga/vital-over,
which incsearch.vim heavily depends on.

Links
-----

### VimConf2014
- [/-improved](https://docs.google.com/presentation/d/1ie2VCSt9onXmoY3v_zxJdMjYJSbAelVR-QExdUQK-Tw/pub?start=false&loop=false&delayms=3000&slide=id.g4e7add63c_05) at [VimConf 2014](http://vimconf.vim-jp.org/2014/)
  - I talked in Japanese but wrote slide in English ;)

Document
--------
[:h incsearch.vim](doc/incsearch.txt)
