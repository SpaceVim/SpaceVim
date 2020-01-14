---
title: "SpaceVim lang#c 模块"
description: "这一模块为 SpaceVim 提供了 C/C++/Object-C 的开发支持，包括代码补全、语法检查等特性。"
lang: zh
---

# [可用模块](../../) >> lang#c

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [功能特性](#功能特性)
- [模块配置](#模块配置)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 C/C++/Object-C 的开发支持，包括代码补全、语法检查等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#c"
```

## 功能特性

- 代码补全
- 语法检查
- 代码格式化

## 模块配置

- `enable_clang_syntax_highlight` (布尔)

设置是否启用基于 clang 的语法高亮。默认并未开启，开启该功能需要 vim8 或者 neovim。

- `clang_executable`（字符串）

设置可执行程序 clang 的路径。

- `libclang_path`（字符串）

设置 libclang 的路径，默认情况下该选项值为空。

- `clang_std`（字典）

该字典存储编辑不同 C 家族文件类型时所使用的标准库。默认值为：

```json
{
    "c": "c11",
    "cpp": "c++1z",
    "objc": "c11",
    "objcpp": "c++1z",
}
```

- `clang_flag`

通常，在项目根目录新建一个 `.clang` 文件，可以将编译参数逐行写入。也可以使用一 List 值来初始化该选项。
例如：`clang_flag = ["-Iwhatever"]`

以下为一个完整的 `lang#c` 模块载入示例：

```toml
[[layers]]
  name = "lang#c"
  clang_executable = "/usr/bin/clang"
  [layer.clang_std]
    c = "c11"
    cpp = "c++1z"
    objc = "c11"
    objcpp = "c++1z"
```

## 快捷键

| 快捷键    | 功能描述           |
| --------- | ------------------ |
| `SPC l r` | 编译并执行当前文件 |
