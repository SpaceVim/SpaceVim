---
title: "APIs"
description: "A list of available APIs in SpaceVim, provide compatible functions for vim and neovim."
redirect_from: "/apis/"
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

<!-- call SpaceVim#dev#api#update() -->

<!-- SpaceVim api list start -->

## Available APIs

here is the list of all available APIs, and welcome to contribute to SpaceVim.

| Name                        | Description                                                                  |
| --------------------------- | ---------------------------------------------------------------------------- |
| [data#string](data/string/) | data#string API provides some besic functions and values for string.         |
| [file](file/)               | file API provides some besic functions and values for current os.            |
| [job](job/)                 | job API provides some besic functions for running a job                      |
| [logger](logger/)           | logger API provides some besic functions for log message when create plugins |
| [messletters](messletters/) | messletters API provides some besic functions for generating messletters     |
| [password](password/)       | password API provides some besic functions for generating password           |
| [system](system/)           | system API provides some besic functions and values for current os.          |
| [web#html](web/html/)       | web#html API provides some besic functions and values for parser html file.  |
| [web#http](web/http/)       | web#http API provides some besic functions and values for http request       |
| [web#xml](web/xml/)         | web#xml API provides some besic functions and values for parser xml file.    |

<!-- SpaceVim api list end -->
