---
title: "SpaceVim tools 模块"
description: "这一模块为 SpaceVim 提供了多种常用工具，包括日历、计算器等多种工具类插件，并针对 Vim8 以及 Neovim 提供了更好的插件选择。"
lang: zh
---

# [可用模块](../) >> tools

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [Commands](#commands)

<!-- vim-markdown-toc -->

## 模块简介

这一模块集成了多种工具类的 Vim 插件，这些插件都可用通过命令来调用，
并且这些插件的载入方式都是按需载入，只有首次执行相关命令时，
才会载入该插件。

## 启用模块

tools 模块默认并未启用，如果需要启用该模块，需要在配置文件里面加入：

```toml
[[layers]]
  name = "tools"
```

## Commands

这里列出本模块加入的命令，如果需要查阅命令的详细介绍，可以执行 `:help 命令`。

| 快捷键           | 功能描述                |
| ---------------- | ----------------------- |
| `:SourceCounter` | 项目代码统计            |
| `:MundoToggle`   | 打开/关闭文件编辑历史树 |
| `:Cheat`         | 查阅工具表              |
