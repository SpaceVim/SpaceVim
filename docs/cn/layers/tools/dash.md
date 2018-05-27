---
title: "SpaceVim tools#dash 模块"
description: "该模块提供对 Dash 支持，可快速查找光标位置的单词"
lang: cn
---

# [可用模块](../) >> tools#dash

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

该模块为 SpaceVim 提供了 Dash 集成

## 启用模块

tools#dash 模块默认并为启用，如果需要启用该模块，需要在配置文件里面加入：

```toml
[[layers]]
  name = "tools#dash"
```

## 快捷键

| 按键      | 描述                     |
| --------- | ------------------------ |
| `SPC D d` | 查询光标下单词           |
| `SPC D D` | 在所有文档中查询光标单词 |
