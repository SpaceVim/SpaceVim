vim-asterisk: * -Improved
========================
[![](https://travis-ci.org/haya14busa/vim-asterisk.svg?branch=master)](https://travis-ci.org/haya14busa/vim-asterisk)
[![](https://ci.appveyor.com/api/projects/status/uurxg9ips6h2cyd3/branch/master?svg=true)](https://ci.appveyor.com/project/haya14busa/vim-asterisk/branch/master)
[![](https://drone.io/github.com/haya14busa/vim-asterisk/status.png)](https://drone.io/github.com/haya14busa/vim-asterisk/latest)
[![](https://img.shields.io/github/release/haya14busa/vim-asterisk.svg)](https://github.com/haya14busa/vim-asterisk/releases)
[![](http://img.shields.io/github/issues/haya14busa/vim-asterisk.svg)](https://github.com/haya14busa/vim-asterisk/issues)
[![](http://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![](http://img.shields.io/badge/doc-%3Ah%20asterisk.txt-red.svg)](doc/asterisk.txt)

Introduction
------------

asterisk.vim provides improved * motions.

### 1. stay star motions (z prefixed mappings)
z star motions doesn't move your cursor.

![](https://raw.githubusercontent.com/haya14busa/i/master/vim-asterisk/asterisk_z_star.gif)

### 2. visual star motions
Search selected text.

![](https://raw.githubusercontent.com/haya14busa/i/master/vim-asterisk/asterisk_visual_star.gif)

### 3. Use smartcase unlike default one
Default behavior, which sees ignorecase and not smartcase, is not intuitive.

### 4. Keep cursor position across matches
It is handy for refactoring to keep cursor position while iterating over matches.

Add following line in your vimrc to enable this feature. `let g:asterisk#keeppos = 1` Default: 0

![](https://raw.githubusercontent.com/haya14busa/i/master/vim-asterisk/asterisk_keeppos.gif)


Installation
------------

[Neobundle](https://github.com/Shougo/neobundle.vim) / [Vundle](https://github.com/gmarik/Vundle.vim) / [vim-plug](https://github.com/junegunn/vim-plug)

```vim
NeoBundle 'haya14busa/vim-asterisk'
Plugin 'haya14busa/vim-asterisk'
Plug 'haya14busa/vim-asterisk'
```

[pathogen](https://github.com/tpope/vim-pathogen)

```
git clone https://github.com/haya14busa/vim-asterisk ~/.vim/bundle/vim-asterisk
```

Usage
-----

```vim
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
```

If you want to set "z" (stay) behavior as default

```vim
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
```

To enable keepCursor feature:
```vim
let g:asterisk#keeppos = 1
```

Special thanks
--------------
|vim-asterisk| uses the code from vim-visualstar for visual star feature.

- Author: thinca (https://github.com/thinca)
- Plugin: https://github.com/thinca/vim-visualstar

Author
------
haya14busa (https://github.com/haya14busa)

