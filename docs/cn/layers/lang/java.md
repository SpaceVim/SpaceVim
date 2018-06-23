---
title: "SpaceVim lang#java 模块"
description: "这一模块为 java 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: cn
---

# [可用模块](../../) >> lang#java

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [导包相关快捷键](#导包相关快捷键)
  - [代码生成相关快捷键](#代码生成相关快捷键)
  - [Code formatting](#code-formatting)
  - [Maven](#maven)
  - [Jump](#jump)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 java 开发提供支持，包括代码补全、语法检查、代码格式化等特性。

## 功能特性

- 代码补全
- 代码格式化
- 重构
- 语法检查
- 交互式编程：需要 java8 的 jshell
- 调试

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#java"
```

## 快捷键

### 导包相关快捷键

| 模式          | 快捷键    | 按键描述           |
| ------------- | --------- | ------------------ |
| Insert/Normal | `F4`      | 导入光标下的类     |
| Normal        | `SPC l I` | 导入所有缺失的类   |
| Normal        | `SPC l R` | 删除多余的导包     |
| Normal        | `SPC l i` | 智能导入光标下的类 |
| Insert        | `<C-j>I`  | 导入所有缺失的类   |
| Insert        | `<C-j>R`  | 删除多余的导包     |
| Insert        | `<C-j>i`  | 智能导入光标下的类 |

### 代码生成相关快捷键

| Mode          | Key Binding | Description                           |
| ------------- | ----------- | ------------------------------------- |
| normal        | `SPC l g A` | generate accessors                    |
| normal/visual | `SPC l g s` | generate setter accessor              |
| normal/visual | `SPC l g g` | generate getter accessor              |
| normal/visual | `SPC l g a` | generate setter and getter accessor   |
| normal        | `SPC l g M` | generate abstract methods             |
| insert        | `<c-j>s`    | generate setter accessor              |
| insert        | `<c-j>g`    | generate getter accessor              |
| insert        | `<c-j>a`    | generate getter and setter accessor   |
| normal        | `SPC l g t` | generate toString function            |
| normal        | `SPC l g e` | generate equals and hashcode function |
| normal        | `SPC l g c` | generate constructor                  |
| normal        | `SPC l g C` | generate default constructor          |

### Code formatting

the default key bindings for format current buffer is `SPC b f`. and this key bindings is defined in [format layer](<>). you can also use `g=` to indent current buffer.

To make neoformat support java file, you should install uncrustify. or
download [google's formater jar](https://github.com/google/google-java-format)
and add `let g:spacevim_layer_lang_java_formatter = 'path/to/google-java-format.jar'`
to SpaceVim custom configuration file.

### Maven

| Key Binding | Description                    |
| ----------- | ------------------------------ |
| `SPC l m i` | Run maven clean install        |
| `SPC l m I` | Run maven install              |
| `SPC l m p` | Run one already goal from list |
| `SPC l m r` | Run maven goals                |
| `SPC l m R` | Run one maven goal             |
| `SPC l m t` | Run maven test                 |

### Jump

| Key Binding | Description            |
| ----------- | ---------------------- |
| `SPC l j a` | jump to alternate file |

### Inferior REPL process

Start a `jshell` inferior REPL process with `SPC l s i`. 

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |
