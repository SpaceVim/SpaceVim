---
title: "SpaceVim chinese 模块"
description: "该模块为中文用户提供了中文的 Vim 帮助文档，同时提供部分插件的中文帮助文档。"
lang: cn
---

# [可用模块](../) >> chinese

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块配置](#模块配置)

<!-- vim-markdown-toc -->

## 模块描述

该模块为中文用户提供了中文的 Vim 帮助文档，同时提供部分插件的中文帮助文档。

## 启用模块

中文用户，可以在配置文件里面启用该模块，以获取中文帮助文档：

```toml
[[layers]]
  name = "chinese"
```

## 模块配置

加在该模块后，默认的帮助文件语言并为设置为中文，可以通过 SpaceVim 选项
`vim_help_language` 来设置，可将其值设为 `"cn"`。

```toml
[options]
  vim_help_language = "cn"
```
