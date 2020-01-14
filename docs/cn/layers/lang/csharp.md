---
title: "SpaceVim lang#csharp 模块"
description: "这一模块为 SpaceVim 提供了 CSharp 的开发支持，包括代码高亮、对齐、补全等特性。"
lang: zh
---

# [Available Layers](../../) >> lang#csharp

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [依赖安装及模块启用](#依赖安装及模块启用)
  - [模块启用](#模块启用)
  - [安装 OmniSharp 服务](#安装-omnisharp-服务)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 CSharp 的开发支持，包括代码高亮、对齐、补全等特性。

## 依赖安装及模块启用

### 模块启用

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#csharp"
```

### 安装 OmniSharp 服务

在使用该模块之前，需要安装 OmniSharp 服务器。启用模块后，打开 Vim 所有插件会自动下载，
当所有插件安装完毕后，进入对应的插件目录，默认是：

`$HOME/.cache/vimfiles/repos/github.com/OmniSharp/omnisharp-vim/server`

在 macOS 及 Linux 下执行：

    xbuild

在 Windows 下则执行：

    msbuild

或者访问插件官网，阅读 [OmniSharp 服务安装指南](https://github.com/OmniSharp/omnisharp-vim#installation)。

## 快捷键

| 快捷键      | 功能描述                           |
| ----------- | ---------------------------------- |
| `SPC l b`   | compile the project                |
| `SPC l f`   | format current file                |
| `SPC l d`   | show doc                           |
| `SPC l e`   | rename symbol under cursor         |
| `SPC l g g` | go to definition                   |
| `SPC l g i` | find implementations               |
| `SPC l g t` | find type                          |
| `SPC l g s` | find symbols                       |
| `SPC l g u` | find usages of symbol under cursor |
| `SPC l g m` | find members in the current buffer |
| `SPC l s r` | reload the solution                |
| `SPC l s s` | start the OmniSharp server         |
| `SPC l s S` | stop the OmniSharp server          |
