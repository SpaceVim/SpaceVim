---
title: "SpaceVim lang#latex 模块"
description: "这一模块为 LaTex 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#latex

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 LaTex 开发支持，包括代码补全、语法检查以及代码格式化等特性。

主要包含插件：

- [vimtex](https://github.com/lervag/vimtex)

## 功能特性

- 代码补全
- 语法高亮
- 文档查询
- 拼写检查

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#latex"
```

若需要拼写检查功能，可以安装 [proselint](http://proselint.com/)，checkers 模块将后台运行该工具进行拼写检查。

## 快捷键

| 快捷键    | 功能描述                |
| --------- | ----------------------- |
| `SPC l i` | vimtex-info             |
| `SPC l I` | vimtex-info-full        |
| `SPC l t` | vimtex-toc-open         |
| `SPC l T` | vimtex-toc-toggle       |
| `SPC l y` | vimtex-labels-open      |
| `SPC l Y` | vimtex-labels-toggle    |
| `SPC l v` | vimtex-view             |
| `SPC l r` | vimtex-reverse-search   |
| `SPC l l` | vimtex-compile          |
| `SPC l L` | vimtex-compile-selected |
| `SPC l k` | vimtex-stop             |
| `SPC l K` | vimtex-stop-all         |
| `SPC l e` | vimtex-errors           |
| `SPC l o` | vimtex-compile-output   |
| `SPC l g` | vimtex-status           |
| `SPC l G` | vimtex-status-all       |
| `SPC l c` | vimtex-clean            |
| `SPC l C` | vimtex-clean-full       |
| `SPC l m` | vimtex-imaps-list       |
| `SPC l x` | vimtex-reload           |
| `SPC l X` | vimtex-reload-state     |
| `SPC l s` | vimtex-toggle-main      |
