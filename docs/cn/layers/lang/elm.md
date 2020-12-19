---
title: "SpaceVim lang#elm 模块"
description: "这一模块为 SpaceVim 提供了 Elm 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
image: https://user-images.githubusercontent.com/13142418/44625046-7b2f7700-a931-11e8-807e-dba3f73c9e90.png
lang: zh
---

# [可用模块](../../) >> lang#elm

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [依赖安装](#依赖安装)
  - [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [语言专属快捷键](#语言专属快捷键)
  - [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Elm 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 功能特性

- 代码补全
- 语法高亮、对齐
- 单元测试
- 语法检查
- 文档查询

同时，SpaceVim 还为 Elm 开发提供了交互式编程。

## 依赖安装及启用模块

### 依赖安装

首先，需要安装 [elm](http://elm-lang.org/) 语言，最方便的安装方式是使用官方的 npm 包。

```sh
npm install -g elm
```

为了可以在 vim 内执行单元测试，需要安装 [elm-test](https://github.com/rtfeldman/node-elm-test)。

```sh
npm install -g elm-test
```

代码补全以及文档查询依赖于 [elm-oracle](https://github.com/elmcast/elm-oracle)。

```sh
npm install -g elm-oracle
```

自动格式化代码，需要安装 [elm-format](https://github.com/avh4/elm-format)。

```sh
npm install -g elm-format
```

### 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#elm"
```

## 快捷键

### 语言专属快捷键

| 快捷键          | 功能描述               |
| --------------- | ---------------------- |
| `SPC l d` / `K` | 查询光标下符号的文档   |
| `SPC l m`       | 编译当前文档           |
| `SPC l t`       | 运行单元测试           |
| `SPC l e`       | 显示错误及警告信息     |
| `SPC l w`       | 使用浏览器打开相关文档 |

### 交互式编程

启动 `elm repl` 交互进程，快捷键为： `SPC l s i`。

![elm repl](https://user-images.githubusercontent.com/13142418/44625046-7b2f7700-a931-11e8-807e-dba3f73c9e90.png)

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |
