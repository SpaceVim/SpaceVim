---
title: "系统函数"
description: "system 函数提供了系统相关函数，包括判断当前系统平台，文件格式等函数。"
lang: zh
---

# [公共 API](../) >> system

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [values](#values)
- [functions](#functions)

<!-- vim-markdown-toc -->

## 简介

system 函数提供了系统相关函数，包括判断当前系统平台，文件格式等函数。

## values

| names     | values | descriptions               |
| --------- | ------ | -------------------------- |
| isWindows | 0 or 1 | check if the os is windows |
| isLinux   | 0 or 1 | check if the os is linux   |
| isOSX     | 0 or 1 | check if the os is OSX     |
| isDarwin  | 0 or 1 | check if the os is Darwin  |

## functions

| names      | descriptions                           |
| ---------- | -------------------------------------- |
| fileformat | return the icon of current file format |
