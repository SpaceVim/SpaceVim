---
title: "SpaceVim japanese 模块"
description: "这一模块为 SpaceVim 的日文用户提供了日文的 Vim 帮助文档，同时提供部分插件的日文帮助文档。"
lang: zh
---

# [可用模块](../) >> japanese

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块配置](#模块配置)

<!-- vim-markdown-toc -->

## 模块描述

该模块为日文用户提供了日文的 Vim 帮助文档，同时提供部分插件的日文帮助文档。

## 启用模块

日文用户，可以在配置文件里面启用该模块，以获取日文帮助文档：

```toml
[[layers]]
  name = "japanese"
```

## 模块配置

加载该模块后，默认的帮助文件语言并未设置为日文，可以通过 SpaceVim 选项
`vim_help_language` 来设置，可将其值设为 `"jp"`。

```toml
[options]
  vim_help_language = "jp"
```

