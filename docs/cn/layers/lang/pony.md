---
title: "SpaceVim lang#pony 模块"
description: "这一模块为 pony 开发提供支持，包括交互式编程、一键运行等特性。"
lang: zh
---

# [可用模块](../../) >> lang#pony

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 pony 开发提供了支持。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#pony"
```

## 快捷键

### 运行当前脚本

在编辑 pony 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。


