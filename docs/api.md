---
title: Available APIs
description: "A list of available APIs in SpaceVim, provide compatible functions for vim and neovim."
---

# [Home](../) >> APIs

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
- [Available APIs](#available-apis)

<!-- vim-markdown-toc -->

## Introduction

SpaceVim provides many public APIs, you can use these APIs in your plugins.
The following example shows how to load APIs, and how to use the public functions within the APIs.

```vim
" use SpaceVim#api#import() to load the API
let s:file = SpaceVim#api#import('file')
let s:system = SpaceVim#api#import('system')

" check the if current os is Windows.
if s:system.isWindows
    echom "OS is Windows"
endif
echom s:file.separator
echom s:file.pathSeparator
```

<!-- call SpaceVim#dev#api#update() -->

<!-- SpaceVim api list start -->

## Available APIs

Here is the list of all available APIs, and welcome to contribute to SpaceVim.

| Name                                  | Description                                                                                        |
| ------------------------------------- | -------------------------------------------------------------------------------------------------- |
| [data#base64](data/base64/)           | data#base64 API provides base64 encode and decode functions                                        |
| [data#dict](data/dict/)               | data#dict API provides some basic functions and values for dict.                                   |
| [data#list](data/list/)               | data#list API provides some basic functions and values for list.                                   |
| [data#string](data/string/)           | data#string API provides some basic functions and values for string.                               |
| [data#toml](data/toml/)               | data#toml API provides some basic functions and values for toml.                                   |
| [file](file/)                         | file API provides some basic functions and values for current os.                                  |
| [job](job/)                           | job API provides some basic functions for running a job                                            |
| [logger](logger/)                     | logger API provides some basic functions for log message when create plugins                       |
| [messletters](messletters/)           | messletters API provides some basic functions for generating messletters                           |
| [password](password/)                 | password API provides some basic functions for generating password                                 |
| [system](system/)                     | system API provides some basic functions and values for current os.                                |
| [transient-state](transient-state/)   | transient state API provides some basic functions and values for current os.                       |
| [unicode#spinners](unicode/spinners/) | unicode#spinners API provides some basic functions for starting spinners timer                     |
| [vim#command](vim/command/)           | vim#command API provides some basic functions and values for creatting vim custom command.         |
| [vim#highlight](vim/highlight/)       | vim#highlight API provides some basic functions and values for getting and setting highlight info. |
| [web#html](web/html/)                 | web#html API provides some basic functions and values for parser html file.                        |
| [web#http](web/http/)                 | web#http API provides some basic functions and values for http request                             |
| [web#xml](web/xml/)                   | web#xml API provides some basic functions and values for parser xml file.                          |

<!-- SpaceVim api list end -->
