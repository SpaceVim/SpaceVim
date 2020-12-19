---
title: "SpaceVim lang#javascript 模块"
description: "这一模块为 JavaScript 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#javascript

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [功能特性](#功能特性)
- [模块配置](#模块配置)
- [快捷键](#快捷键)
  - [导包相关快捷键](#导包相关快捷键)
  - [常规快捷键](#常规快捷键)
  - [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 JavaScript 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#javascript"
```

## 功能特性

- 代码补全
- 语法检查
- 跳转定义处
- 查询函数引用

## 模块配置

- `auto_fix`：保存文件时，自动修复代码问题，默认未启用该功能，若需要该功能，可在载入模块时设置该选项为 `true`。
- `enable_flow_syntax`: 启用/禁用 [flow](https://flow.org/) 语法高亮，默认未启用。

配置示例：

```toml
[[layers]]
  name = "lang#javascript"
  auto_fix = true
  enable_flow_syntax = true
```

## 快捷键

### 导包相关快捷键

| 模式          | 快捷键     | 按键描述           |
| ------------- | ---------- | ------------------ |
| Insert/Normal | `F4`       | 导入光标下的类     |
| Normal        | `SPC l I`  | 导入所有缺失的类   |
| Normal        | `SPC l R`  | 删除多余的导包     |
| Normal        | `SPC l i`  | 智能导入光标下的类 |
| Insert        | `Ctrl-j I` | 导入所有缺失的类   |
| Insert        | `Ctrl-j R` | 删除多余的导包     |
| Insert        | `Ctrl-j i` | 智能导入光标下的类 |

### 常规快捷键

| 模式   | 快捷键      | 按键描述   |
| ------ | ----------- | ---------- |
| Normal | `SPC l g d` | 生成 JSDoc |

### 交互式编程

启动 `node -i` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |
