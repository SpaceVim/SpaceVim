---
title: "SpaceVim lang#asciidoc layer"
description: "这一模块为 SpaceVim 提供了 AsciiDoc 的编辑支持，包括格式化、自动生成文章目录、代码块等特性。"
lang: zh
---

# [Available Layers](../../) >> lang#asciidoc

![asciidoc](https://user-images.githubusercontent.com/13142418/92319337-7554ec00-f049-11ea-90fb-ad663dceea12.png)

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 AsciiDoc 的编辑支持，包括格式化、自动生成文章目录、代码块等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#asciidoc"
```

若需要查看 asciidoc 侧栏标题目录，则需要安装 `ctags`。

## 快捷键

| 快捷键 | 功能描述       |
| ------ | -------------- |
| `F2`   | 打开侧边语法树 |
