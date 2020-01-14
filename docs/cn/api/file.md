---
title: "文件函数"
description: "文件函数提供了基础的文件读写相关函数，兼容不同系统平台。"
lang: zh
---

# [公共 API](../) >> file


<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [values](#values)
- [functions](#functions)

<!-- vim-markdown-toc -->

## 简介

文件函数提供了基础的文件读写相关函数，兼容不同系统平台。

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

