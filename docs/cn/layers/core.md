---
title: "SpaceVim core 模块"
description: "这一模块为 SpaceVim 提供了启动及基本操作所必须的插件及配置。"
lang: zh
---

# [可用模块](../) >> core
 
## 模块简介

该模块主要包括 SpaceVim 启动时所必须的配置，默认已启用。

## 功能特性

### 文件树

nerdtree 或者 vimfiler，默认为 vimfiler，由 `filemanager` 选项控制。

如果需要使用 nerdtree 作为文件树插件，可以添加：

```toml
[options]
  filemanager = "nerdtree"
```

## 模块配置

- `filetree_show_hidden`: 在文件树内显示隐藏的文件，默认是 false。

```toml
[[layers]]
    name = 'core'
    filetree_show_hidden = true
```
