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

<!-- SpaceVim api list start -->

## Available APIs

here is the list of all available APIs, and welcome to contribute to SpaceVim.

| Name              | Description                                                         |
| ----------------- | ------------------------------------------------------------------- |
| [file](file/)     | file API provides some besic functions and values for current os.   |
| [system](system/) | system API provides some besic functions and values for current os. |

<!-- SpaceVim api list end -->
