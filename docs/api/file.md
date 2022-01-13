---
title: "file API"
description: "file API provides some basic functions and values for current os."
---

# [Available APIs](../) >> file


<!-- vim-markdown-toc GFM -->

- [values](#values)
- [functions](#functions)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## values

| name          | description                                    |
| ------------- | ---------------------------------------------- |
| separator     | The system-dependent name-separator character. |
| pathSeparator | The system-dependent path-separator character. |

## functions

| name                      | description                                     |
| ------------------------- | ----------------------------------------------- |
| `fticon(file)`            | return the icon of specific file name or path   |
| `write(message, file)`    | append message to file                          |
| `override(message, file)` | override message to file                        |
| `read(file)`              | read message from file                          |
| `ls(dir, if_file_only)`   | list files and directorys in specific directory |
| `updateFiles(files)`      | update the contents of all files                |

## Usage

This api can be used in both vim script and lua script.

**vim script:**

```vim
let s:FILE = SpaceVim#api#import('file')
echom S:FILE.separator
```

**lua script:**

```lua
local file_api = require('spacevim.api').import('file')
print(file_api.separator)
```
