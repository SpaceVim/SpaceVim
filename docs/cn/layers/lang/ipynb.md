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

这一模块包括了插件 vimpyter，这一插件需要安装一个 python 依赖包 notedown：

```sh
pip install --user notedown
```

注意：如果在使用 windows 系统，可能在运行以上命令后，任然无法使用 notedown 命令，
需要手动将如下路径加入 PATH 环境变量：

`%HOME%\AppData\Roaming\Python\Python37\Scripts`

`lang#ipynb` 模块默认并未启用，如果需要启用该模块，需要在配置文件里面加入：

```toml
[[layers]]
  name = "lang#ipynb"
```

## 快捷键

| 快捷键    | 功能描述           |
| --------- | ------------------ |
| `SPC l p` | 插入 python 代码块 |
| `SPC l u` | 更新 note book     |
| `SPC l j` | 启动 jupyter       |
| `SPC l n` | 启动 nteract       |
