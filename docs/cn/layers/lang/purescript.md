---
title: "SpaceVim lang#purescript 模块"
description: "这一模块为 SpaceVim 提供了 PureScript 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#purescript

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [语言专属快捷键](#语言专属快捷键)
  - [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 PureScript 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 功能特性

- 代码补全
- 文档查询
- 跳转定义处

同时，SpaceVim 还为 PureScript 开发提供了交互式编程、一键运行和语言服务器等功能。若要启用语言服务器，需要载入 `lsp` 模块。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#purescript"
```

## 快捷键

### 语言专属快捷键

| 快捷键    | 功能描述                          |
| --------- | --------------------------------- |
| `g d`     | 跳至定义处                        |
| `SPC l L` | 列出所有已载入的模块              |
| `SPC l l` | 重置并载入模块                    |
| `SPC l r` | 运行当前项目                      |
| `SPC l R` | 重新编译当前文件                  |
| `SPC l f` | 生成函数模板                      |
| `SPC l t` | 添加类型注解                      |
| `SPC l a` | 在当前未至应用修改建议            |
| `SPC l A` | 应用所有修改建议                  |
| `SPC l C` | 添加 case expression              |
| `SPC l i` | 导入光标下的模块                  |
| `SPC l p` | 搜索 pursuit for cursor ident     |
| `SPC l T` | 查询光标符号类型                  |

### 交互式编程

启动 `pulp repl` 交互进程，快捷键为：`SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |
