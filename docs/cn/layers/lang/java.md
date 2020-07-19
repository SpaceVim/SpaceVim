---
title: "SpaceVim lang#java 模块"
description: "这一模块为 Java 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#java

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [导包相关快捷键](#导包相关快捷键)
  - [代码生成相关快捷键](#代码生成相关快捷键)
  - [代码格式化](#代码格式化)
  - [Maven](#maven)
  - [Jump](#jump)
  - [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 Java 开发提供支持，包括代码补全、语法检查、代码格式化等特性。

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

| 模式          | 快捷键     | 按键描述           |
| ------------- | ---------  | ------------------ |
| Insert/Normal | `<F4>`     | 导入光标下的类     |
| Normal        | `SPC l I`  | 导入所有缺失的类   |
| Normal        | `SPC l R`  | 删除多余的导包     |
| Normal        | `SPC l i`  | 智能导入光标下的类 |
| Insert        | `Ctrl-j I` | 导入所有缺失的类   |
| Insert        | `Ctrl-j R` | 删除多余的导包     |
| Insert        | `Ctrl-j i` | 智能导入光标下的类 |

### 代码生成相关快捷键

| 模式          | 快捷键      | 按键描述                              |
| ------------- | ----------- | ------------------------------------- |
| Normal        | `SPC l g A` | generate accessors                    |
| Normal/Visual | `SPC l g s` | generate setter accessor              |
| Normal/Visual | `SPC l g g` | generate getter accessor              |
| Normal/Visual | `SPC l g a` | generate setter and getter accessor   |
| Normal        | `SPC l g M` | generate abstract methods             |
| Insert        | `Ctrl-j s`  | generate setter accessor              |
| Insert        | `Ctrl-j g`  | generate getter accessor              |
| Insert        | `Ctrl-j a`  | generate getter and setter accessor   |
| Normal        | `SPC l g t` | generate toString function            |
| Normal        | `SPC l g e` | generate equals and hashcode function |
| Normal        | `SPC l g c` | generate constructor                  |
| Normal        | `SPC l g C` | generate default constructor          |

### 代码格式化

默认的代码格式化快捷键是 `SPC b f`，该快捷键由 `format` 模块定义，同时也可以通过 `g =` 来对齐整个文档。

为了使 format 模块支持 Java 文件，需要安装 uncrustify 或者下载 [google's formater jar](https://github.com/google/google-java-format)。
同时，需要设置 SpaceVim 选项`layer_lang_java_formatter`：

```toml
[options]
  layer_lang_java_formatter = "path/to/google-java-format.jar"
```

### Maven

| 快捷键      | 功能描述                       |
| ----------- | ------------------------------ |
| `SPC l m i` | Run maven clean install        |
| `SPC l m I` | Run maven install              |
| `SPC l m p` | Run one already goal from list |
| `SPC l m r` | Run maven goals                |
| `SPC l m R` | Run one maven goal             |
| `SPC l m t` | Run maven test                 |

### Jump

| 快捷键      | 描述                   |
| ----------- | ---------------------- |
| `SPC l j a` | jump to alternate file |

### 交互式编程

启动 `jshell` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                    |
| ----------- | --------------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL     |
| `SPC l s l` | 发送当前行内容至 REPL       |
| `SPC l s s` | 发送已选中的内容至 REPL     |
