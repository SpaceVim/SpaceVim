---
title: "SpaceVim lang#sml 模块"
description: "这一模块为 Standard ML 开发提供支持，包括交互式编程、一键运行等特性。"
lang: zh
---

# [可用模块](../../) >> lang#sml

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 Standard ML 开发提供了支持。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#sml"
```

## 模块选项

- `smlnj_path`: 设置 `smlnj` 可执行文件路径, 默认是 `sml`
- `mlton_path`: 设置 `mlton` 可执行文件路径, 默认是 `mlton`
- `repl_options`: 设置交互式命令启动选项，默认为 `''`
- `auto_create_def_use`: 设置保存文件时，是否自动生成 `def-use` 文件，默认的值为 `mlb`。
  可以使用的值包括：
  - `mlb`: 仅当有 `*.mlb` 文件时，自动生成 `def-use` 文件
  - `always`: 总是生成 `def-use` 文件
  - `never`: 从不生成 `def-use` 文件
- `enable_conceal`: `true`/`false`. 设置是否为SML 文件启用 concealing 特性，默认为禁用。
  `'a` 显示为 `α` (或者 `'α`). `fn` 显示为 `λ.`
- `enable_conceal_show_tick`: `true`/`false`，当启用 conceal 时，将 `'a` 显示为 `'α` 而非 `α`，默认为 `false`
- `sml_file_head`: 设置新建 sml 文件时的默认文件头模板

## 快捷键

### 交互式编程

启动 `sml` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 sml 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。


