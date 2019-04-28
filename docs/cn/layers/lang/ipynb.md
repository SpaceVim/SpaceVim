---
title: "SpaceVim lang#ipynb 模块"
description: "该模块为SpaceVim添加了 Jupyter Notebook 支持，包括语法高亮、代码折叠等特点。"
---

# [可用模块](../../) >> lang#ipynb

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [模块启用及依赖安装](#模块启用及依赖安装)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 添加了 Jupyter Notebook 的支持，包括语法高亮，代码块折叠等特性。

## 功能特性

- 语法高亮

## 模块启用及依赖安装

this layer includes vimpyter, to use this plugin, you may need to install notedown.

```sh
pip install --user notedown
```

NOTE: if you are using windows, you need to add this dir to your \$PATH.

`%HOME%\AppData\Roaming\Python\Python37\Scripts`

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#ipynb"
```

## 快捷键

| 快捷键    | 功能描述            |
| --------- | ------------------- |
| `SPC l p` | insert python block |
| `SPC l u` | update note book    |
| `SPC l j` | start jupyter       |
| `SPC l n` | start nteract       |
