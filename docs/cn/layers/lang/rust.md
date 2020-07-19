---
title: "SpaceVim lang#rust 模块"
description: "这一模块为 Rust 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#rust

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
  - [语言工具](#语言工具)
- [模块选项](#模块选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Rust 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 功能特性

- 代码补全
- 文档查询
- 跳转定义处

同时，SpaceVim 还为 Rust 开发提供了交互式编程、一键运行和语言服务器等功能。若要启用语言服务器，需要载入 `lsp` 模块。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#rust"
```

### 语言工具

- [evcxr](https://github.com/google/evcxr): Rust 交互式编程命令行工具。

## 模块选项

- `recommended-style`: 1/0 (启用/禁用) rust 推荐的代码规范，该选项默认已禁用。
- `format-autosave`: 1/0 (启动/禁用) 保存文件修改后自动格式化，该选项默认已禁用。
- `racer-cmd`: 可执行文件 `racer` 的路径，该选项默认为 `$HOME/.cargo/bin/racer`。
- `rustfmt-cmd`: 可执行文件 `rustfmt` 的路径，该选项默认为 `$HOME/.cargo/bin/rustfmt`。

## 快捷键

| 快捷键          | 功能描述                                       |
| --------------- | ---------------------------------------------- |
| `g d`           | 跳至函数或变量定义处                           |
| `SPC l d` / `K` | 展示光标函数或变量相关文档                     |
| `SPC l s`       | 跳至函数或变量定义处 (split)                   |
| `SPC l x`       | 跳至函数或变量定义处 (vertical)                |
| `SPC l f`       | 格式化当前文件代码                             |
| `SPC l e`       | 重命名光标函数或变量（需要 `lsp` 模块）        |
| `SPC l u`       | 显示光标函数或变量的所有引用 (需要 `lsp` 模块) |
| `SPC l c b`     | 运行 `cargo build`                             |
| `SPC l c c`     | 运行 `cargo clean`                             |
| `SPC l c f`     | 运行 `cargo fmt`                               |
| `SPC l c t`     | 运行 `cargo test`                              |
| `SPC l c u`     | 运行 `cargo update`                            |
| `SPC l c B`     | 运行 `cargo bench`                             |
| `SPC l c D`     | 运行 `cargo doc`                               |
| `SPC l c r`     | 运行 `cargo run`                               |

