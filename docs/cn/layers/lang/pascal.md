---
title: "SpaceVim lang#pascal 模块"
description: "这一模块为 pascal 开发提供支持，包括一键运行等特性。"
lang: zh
---

# [可用模块](../../) >> lang#pascal

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 pascal 开发提供了支持。默认使用
[free pascal](https://www.freepascal.org/) 作为编译器，在使用
这一模块之前，需要下载并安装编译器。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#pascal"
```

## 快捷键

在编辑 pascal 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。
