---
title: "APIs"
description: "A list of available APIs in SpaceVim, provide compatible functions for vim and neovim."
---

# SpaceVim APIs

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
- [Available APIs](#available-apis)

<!-- vim-markdown-toc -->

## Introduction

SpaceVim provides many public apis, you can use this apis in your plugins.
This is an example for how to load API, and how to use the public functions within the APIs.

```vim
" use SpaceVim#api#import() to load the API
let s:file = SpaceVim#api#import('file')
let s:system = SpaceVim#api#import('system')

" check the if current os is Windows.
if s:system.isWindows
    echom "Os is Windows"
endif
echom s:file.separator
echom s:file.pathSeparator
```

## Available APIs

here is the list of all available APIs, and welcome to contribute to SpaceVim.

<!-- SpaceVim api list start -->

| name   |             description            | documentation                             |
| ------ | :--------------------------------: | ----------------------------------------- |
| file   | basic api about file and directory | [readme](https://spacevim.org/api/file)   |
| system |       basic api about system       | [readme](https://spacevim.org/api/system) |

<!-- SpaceVim api list end -->

