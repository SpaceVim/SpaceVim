---
title: "SpaceVim format 模块"
description: "这一模块为 SpaceVim 提供了代码异步格式化功能，支持高度自定义配置和多种语言。"
lang: zh
---

# [可用模块](../) >> format

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [模块设置](#模块设置)
  - [模块选项](#模块选项)
  - [全局选项](#全局选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

`format` 模块为 SpaceVim 提供代码格式化的功能，使用了 Vim8/neovim 的异步特性。引入了插件 [neoformat](https://github.com/sbdchd/neoformat)。

## 启用模块

`format` 模块默认已经启用，如果需要禁用该模块，可以在配置文件中添加如下配置：

```toml
[[layers]]
  name = "format"
  enable = false
```

## 模块设置

### 模块选项

- **`format_on_save`**: 这一模块选项是用于设置是否在保存文件时自动进行格式化，默认是禁用的，
  如果需要启用该功能，可以在设置文件中加入以下内容：

  ```toml
  [[layers]]
    name = "format"
    format_on_save = true
  ```

  这一选项可以被语言模块中的 `format_on_save` 选项所覆盖。比如，为所有文件类型启用自动格式化，但是 Python
  除外：

  ```toml
  # 启用 format 模块
  [[layers]]
    name = 'format'
    format_on_save = true
  # 启用 lang#java 模块
  [[layers]]
    name = 'lang#python'
    format_on_save = false
  ```

### 全局选项

`neoformat` 是一个格式化框架插件，该插件的所有自身选项可以在启动函数中进行设置，可以预读 `:help neoformat`
获取完整帮助。

以下是一个为 Java 文件设置格式化命令的配置，以下配置已经包含在 `lang#java` 模块内了：

```viml
let g:neoformat_enabled_java = ['googlefmt']
let g:neoformat_java_googlefmt = {
    \ 'exe': 'java',
    \ 'args': ['-jar', '~/Downloads/google-java-format-1.5-all-deps.jar', '-'],
    \ 'stdin': 1,
    \ }
```

## 快捷键

| 快捷键    | 功能描述                   |
| --------- | -------------------------- |
| `SPC b f` | 格式化当前文件或者选中内容 |
