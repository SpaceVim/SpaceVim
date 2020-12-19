---
title: "SpaceVim test layer"
description: "这一模块为 SpaceVim 提供了一个测试框架，支持快速运行多种语言的单元测试。"
lang: zh
---

# [可用模块](../) >> test

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [模块安装](#模块安装)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块用于在 SpaceVim 中直接运行单元测试。

## 模块安装

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "test"
```

## 快捷键

| 按键 | 功能描述                                                                                                                                                                                                                                                                             |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SPC k n`   | Run nearest test                                                                                                                                                                                                                                                                        |
| `SPC k f`   | Run test file                                                                                                                                                                                                                                                                           |
| `SPC k s`   | Runs the whole test suite (if the current file is a test file, runs that framework's test suite, otherwise determines the test framework from the last run test).                                                                                                                       |
| `SPC k l`   | Runs the last test                                                                                                                                                                                                                                                                      |
| `SPC k v`   | Visits the test file from which you last run your tests (useful when you're trying to make a test pass, and you dive deep into application code and close your test buffer to make more space, and once you've made it pass you want to go back to the test file to write more tests)   |


