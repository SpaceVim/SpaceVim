---
title: "SpaceVim lang#dart 模块"
description: "这一模块为 SpaceVim 提供了 Dart 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#dart

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [启用模块](#启用模块)
  - [语法检查及代码格式化](#语法检查及代码格式化)
  - [安装 dart-repl](#安装-dart-repl)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)
  - [代码格式化](#代码格式化)
- [相关截图](#相关截图)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Dart 的开发支持，包括代码补全、语法检查、代码格式化等特性。

## 功能特性

- 代码补全
- 语法检查
- 代码格式化
- 交互式编程
- 异步执行

## 依赖安装及启用模块

### 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#dart"
```

### 语法检查及代码格式化

为了在 SpaceVim 中启用 Dart 语法检查以及代码格式化，需要安装 [dart sdk](https://github.com/dart-lang/sdk)。

### 安装 dart-repl

需要通过 pub 来安装 `dart_repl`，pub 是 Dart sdk 内置的包管理器：

```sh
pub global activate dart_repl
```

## 快捷键

### 交互式编程

启动 `dart.repl` 交互进程，快捷键为：`SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 Dart 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。

### 代码格式化

| 快捷键      | 功能描述       |
| ----------- | -------------- |
| `SPC b f`   | 格式化当前文件 |

## 相关截图

**代码格式化：**

![format-dart-file-in-spacevim](https://user-images.githubusercontent.com/13142418/34455939-b094db54-ed4f-11e7-9df0-80cf5de1128d.gif)

**代码补全：**

![complete-dart-in-spacevim](https://user-images.githubusercontent.com/13142418/34455816-ee77182c-ed4c-11e7-8f63-402849f60405.png)

**异步执行：**

![dart-runner-in-spacevim](https://user-images.githubusercontent.com/13142418/34455403-1f6d4c3e-ed44-11e7-893f-09a6e64e27ed.png)
