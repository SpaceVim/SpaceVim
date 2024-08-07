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

<!--
call SpaceVim#dev#api#update()
-->

<!-- SpaceVim api list start -->

## Available APIs

Here is the list of all available APIs, and welcome to contribute to SpaceVim.

| Name                                  | Description                                                                                        |
| ------------------------------------- | -------------------------------------------------------------------------------------------------- |
| [cmdlinemenu](cmdlinemenu/)           | cmdlinemenu API provides interface for making choices in a command line.                           |
| [data#base64](data/base64/)           | data#base64 API provides base64 encode and decode functions                                        |
| [data#dict](data/dict/)               | data#dict API provides some basic functions and values for dict.                                   |
| [data#list](data/list/)               | data#list API provides some basic functions and values for list.                                   |
| [data#number](data/number/)           | data#number API provides some basic functions to generate number.                                  |
| [data#string](data/string/)           | data#string API provides some basic functions and values for string.                               |
| [data#toml](data/toml/)               | data#toml API provides some basic functions and values for toml.                                   |
| [file](file/)                         | file API provides some basic functions and values for current os.                                  |
| [job](job/)                           | job API provides some basic functions for running a job                                            |
| [logger](logger/)                     | logger API provides some basic functions for log message when create plugins                       |
| [messletters](messletters/)           | messletters API provides some basic functions for generating messletters                           |
| [notify](notify/)                     | notify API provides some basic functions for generating notifications                              |
| [password](password/)                 | password API provides some basic functions for generating password                                 |
| [prompt](prompt/)                     | create cmdline prompt and handle input                                                             |
| [system](system/)                     | system API provides some basic functions and values for current os.                                |
| [transient-state](transient-state/)   | transient state API provides some basic functions and values for current os.                       |
| [unicode#box](unicode/box/)           | unicode#box API provides some basic functions for drawing box.                                     |
| [unicode#spinners](unicode/spinners/) | unicode#spinners API provides some basic functions for starting spinners timer                     |
| [vim#buffer](vim/buffer/)             | vim#buffer API provides some basic functions for setting and getting config of vim buffer.         |
| [vim#command](vim/command/)           | vim#command API provides some basic functions and values for creatting vim custom command.         |
| [vim#highlight](vim/highlight/)       | vim#highlight API provides some basic functions and values for getting and setting highlight info. |
| [vim#message](vim/message/)           | vim#message API provides some basic functions to generate colored messages.                        |
| [vim#signatures](vim/signatures/)     | vim#signatures API provides some basic functions for showing signatures info.                      |
| [vim#window](vim/window/)             | vim#window API provides some basic functions for setting and getting config of vim window.         |
| [vim](vim/)                           | vim API provides general vim functions.                                                            |
| [web#html](web/html/)                 | web#html API provides some basic functions and values for parser html file.                        |
| [web#http](web/http/)                 | web#http API provides some basic functions and values for http request                             |
| [web#xml](web/xml/)                   | web#xml API provides some basic functions and values for parser xml file.                          |

<!-- SpaceVim api list end -->
