---
title: "SpaceVim checkers 模块"
description: "这一模块为 SpaceVim 提供了代码语法检查的特性，同时提供代码实时检查，并列出语法错误的位置。"
lang: zh
---

# [可用模块](../) >> checkers

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块配置](#模块配置)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了自动语法检查的特性，并且可设置为输入时实时检查。默认情况
下已经支持多种语言工具。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "checkers"
```

## 模块配置

默认会在光标的下一行显示当前行错误的详细信息，如果需要禁用这一特性，可以在载入模块
时指定 `show_cursor_error` 的值为 false。

```toml
[[layers]]
  name = "checkers"
  show_cursor_error = false
```

SpaceVim 选项：

| 选项名称          | 默认值 | 描述                                |
| ----------------- | ------ | ----------------------------------- |
| `enable_neomake`  | true   | 使用 Neomake 作为默认的语法检查插件 |
| `enable_ale`      | false  | 使用 Ale 作为默认语法检查插件       |
| `lint_on_the_fly` | false  | 启用实时语法检查                    |

**NOTE:** 如果你需要使用 Ale 作为默认检查工具，SpaceVim 选项需要加入：

```toml
[options]
  enable_neomake = false
  enable_ale = true
```

如果需要使用 syntastic，将两者都设置为 false。

## 快捷键

| 快捷键    | 功能描述                        |
| --------- | ------------------------------- |
| `SPC e .` | 打开错误临时快捷键菜单          |
| `SPC e c` | 清除错误列表                    |
| `SPC e h` | 描述当前检查工具                |
| `SPC e n` | 跳至下一个语法错误位置          |
| `SPC e N` | 跳至上一个语法错误位置          |
| `SPC e p` | 跳至上一个语法错误位置          |
| `SPC e l` | 列出错误列表窗口                |
| `SPC e L` | 列出错误列表窗口并跳至该窗口    |
| `SPC e e` | 解释光标处的语法错误            |
| `SPC e s` | 设置语法检查工具 (TODO)         |
| `SPC e S` | 设置语法检查工具执行命令 (TODO) |
| `SPC e v` | 确认语法检查工具启动状态        |
| `SPC t s` | 临时启用/禁用语法检查           |
