---
title:  Available layers
description: A list of available layers in SpaceVim.
keywords: layer,layers
---

## Introduction

SpaceVim is a community-driven vim distribution that seeks to provide layer feature. here is an example for loadding a layer with some specified options:

```vim
call SpaceVim#layers#load('shell',
        \ {
        \ 'default_position' : 'top',
        \ 'default_height' : 30,
        \ }
        \ )
```

## Available layers

this a list of buildin layers:

| Name          |            Description            | Documentation                                              |
| ------------- | :-------------------------------: | ---------------------------------------------------------- |
| autocomplete  |        autocomplete in vim        | [documentation](https://spacevim.org/layers/autocomplete)  |
| chat          |          chatting in vim          | [documentation](https://spacevim.org/layers/chat)          |
| checkers      |          checking in vim          | [documentation](https://spacevim.org/layers/checkers)      |
| chinese       |      layer for  chinese vimer     | [documentation](https://spacevim.org/layers/chinese)       |
| colorscheme   |    all colorscheme in spacevim    | [documentation](https://spacevim.org/layers/colorscheme)   |
| default       | better default for vim and neovim | [documentation](https://spacevim.org/layers/default)       |
| lang#java     |      java development in vim      | [documentation](https://spacevim.org/layers/lang/java)     |
| lang#lisp     |      lisp development in vim      | [documentation](https://spacevim.org/layers/lang/lisp)     |
| lang#markdown | layer for editing markdown in vim | [documentation](https://spacevim.org/layers/lang/markdown) |
| lang#php      |       php development in vim      | [documentation](https://spacevim.org/layers/lang/php)      |
| shell         |     shell support for SpaceVim    | [documentation](https://spacevim.org/layers/shell)         |
| tags          |        tags manager in vim        | [documentation](https://spacevim.org/layers/tags)          |
