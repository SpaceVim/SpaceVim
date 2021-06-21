---
title: Available APIs
description: "A list of available APIs in SpaceVim, provides compatible functions for vim and neovim."
---

# [Home](../) >> APIs

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
- [Available APIs](#available-apis)

<!-- vim-markdown-toc -->

## Introduction

SpaceVim provides many public APIs that you can use in your plugins.
The following example shows how to load and use an API.

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

| Name                                  | Description                                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [cmdlinemenu](cmdlinemenu/)           | cmdlinemenu API provides an interface for making choices in a command line.                             |
| [data#base64](data/base64/)           | data#base64 API provides base64 encoding and decoding functions                                         |
| [data#dict](data/dict/)               | data#dict API provides some basic functions and values for dict.                                        |
| [data#list](data/list/)               | data#list API provides some basic functions and values for list.                                        |
| [data#number](data/number/)           | data#number API provides some basic functions for number generation.                                    |
| [data#string](data/string/)           | data#string API provides some basic functions and values for string.                                    |
| [data#toml](data/toml/)               | data#toml API provides some basic functions and values for toml.                                        |
| [file](file/)                         | file API provides some basic functions and values for interacting with the OS.                          |
| [job](job/)                           | job API provides some basic functions for running a jobs                                                |
| [logger](logger/)                     | logger API provides some basic functions for logging messages when creating plugins                     |
| [messletters](messletters/)           | messletters API provides some basic functions for generating messletters                                |
| [password](password/)                 | password API provides some basic functions for generating passwords                                     |
| [system](system/)                     | system API provides some basic functions and values for interacting with the OS.                        |
| [transient-state](transient-state/)   | transient state API provides some basic functions and values for interacting with the OS.               |
| [unicode#spinners](unicode/spinners/) | unicode#spinners API provides some basic functions for starting spinners timer                          |
| [vim#buffer](vim/buffer/)             | vim#buffer API provides some basic functions for setting and getting the configurations of vim buffers. |
| [vim#command](vim/command/)           | vim#command API provides some basic functions and values for creatting vim custom commands.             |
| [vim#highlight](vim/highlight/)       | vim#highlight API provides some basic functions and values for getting and setting highlighting info.   |
| [vim#signatures](vim/signatures/)     | vim#signatures API provides some basic functions for showing signatures info.                           |
| [vim#window](vim/window/)             | vim#window API provides some basic functions for setting and getting the configurations of vim windows. |
| [vim](vim/)                           | vim API provides general vim functions.                                                                 |
| [web#html](web/html/)                 | web#html API provides some basic functions and values for parsing HTML files.                           |
| [web#http](web/http/)                 | web#http API provides some basic functions and values for HTTP requests                                 |
| [web#xml](web/xml/)                   | web#xml API provides some basic functions and values for parsing XML files.                             |

<!-- SpaceVim api list end -->
