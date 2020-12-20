---
title: "SpaceVim lang#typescript 模块"
description: "这一模块为 SpaceVim 提供了 TypeScript 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#typescript

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [功能特性](#功能特性)
- [模块配置](#模块配置)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 TypeScript 的开发支持，包括代码补全、语法检查代码格式化等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#typescript"
```

同时，需要通过以下命令安装 TypeScript：

```sh
npm install -g typescript
```

## 功能特性

- 代码补全
- 语法检查
- 查阅文档
- 类型图标标记
- 跳至定义处
- 查询函数引用
- LSP 支持

## 模块配置

`typescript_server_path`: 该模块选项可以设置 tsserver 的路径。

## 快捷键

| 快捷键      | 功能描述           |
| ----------- | ------------------ |
| `SPC l d`   | show documentation |
| `SPC l e`   | rename symbol      |
| `SPC l f`   | code fix           |
| `SPC l g`   | definition         |
| `SPC l i`   | import             |
| `SPC l r`   | references         |
| `SPC l t`   | type               |
| `SPC l g d` | generate doc       |
| `g d`       | defintion preview  |
| `g D`       | type definition    |
