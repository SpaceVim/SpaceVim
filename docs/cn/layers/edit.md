---
title: "SpaceVim edit 模块"
description: "这一模块为 SpaceVim 提供了更好的文本编辑体验，提供更多种文本对象。"
lang: zh
---

# [可用模块](../) >> edit

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [模块选项](#模块选项)

<!-- vim-markdown-toc -->

## 模块简介

该模块提升了 SpaceVim 的文本编辑体验，提供更多种文本对象。

## 功能特性

- 修改围绕当前光标的符号
- 重复编辑
- 多光标支持
- 对齐文档内容
- 设置文档段落对齐方式
- 高亮行为符号
- 自动载入 editorconfig 配置，需要 `+python` 或者 `+python3` 支持
- 默认已启用

## 模块选项

- `textobj`: 设定启用的文本对象列表，可用列表包括：`indent`, `line`, `entire`
- `autosave_timeout`: 设置自动保存的时间间隔，默认是0，表示未开启定时自动保存。这个选项设定的值需要是毫秒数，并且需要小于100\*60\*1000 (100 分钟) 且 大于1000（1秒）。比如设定成每隔5分钟自动保存一次：
  ```
  [[layers]]
    name = 'edit'
    autosave_timeout = 300000
  ```
- `autosave_events`: 设定自动保存依赖的Vim事件，默认是空表。比如需要在离开插入模式时或者内容改变时自动保存：
  ```
  [[layers]]
    name = 'edit'
    autosave_events = ['InsertLeave', 'TextChanged']
  ```
- `autosave_all_buffers`: 设定是否需要保存所有文件，默认是只保存当前编辑的文件，如果该选项设定成`true`则保存所有文件。
  ```
  [[layers]]
    name = 'edit'
    autosave_all_buffers = true
  ```
- `autosave_location`: 设定保存文件的位置，默认为空，表示保存为原始路径。也可以设定成一个备份文件夹，自动保存的文件保存到指定的备份文件夹里面，而不修改原始文件。
  ```
  [[layers]]
    name = 'edit'
    autosave_location = '~/.cache/backup/'
  ```
