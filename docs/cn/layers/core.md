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
- `enable_smooth_scrolling`: 启用或者禁用平滑滚屏快捷键，默认已启用。
- `enable_filetree_gitstatus`: 在文件树内显示 Git 文件状态
- `enable_filetree_filetypeicon`: 在文件树内显示文件类型图标
- `enable_netrw`: 启用或者禁用 netrw
- `enable_quickfix_key_bindings`: 启用或者禁用 quickfix 窗口内常用快捷键

```toml
[[layers]]
    name = 'core'
    filetree_show_hidden = true
    enable_smooth_scrolling = true
    filetree_opened_icon = ''
    filetree_closed_icon = ''
```

如果 `enable_quickfix_key_bindings` 设置为 `true`，那么可以在 quickfix 窗口内使用如下快捷键：

| Key bindings | description                                                |
| ------------ | ---------------------------------------------------------- |
| `dd`         | remove item under cursor line in normal mode               |
| `d`          | remove selected items in visual mode                       |
| `c`          | remove items which filename match input regex              |
| `C`          | remove items which filename not match input regex          |
| `o`          | remove items which error description match input regex     |
| `O`          | remove items which error description not match input regex |
| `u`          | undo last change                                           |

也可以在启动函数里面使用如下变量修改默认的按键：

- `g:quickfix_mapping_delete`: default is `dd` 
- `g:quickfix_mapping_visual_delete`: default is `d` 
- `g:quickfix_mapping_filter_filename`: default is `c` 
- `g:quickfix_mapping_rfilter_filename`: default is `C` 
- `g:quickfix_mapping_filter_text`: default is `o` 
- `g:quickfix_mapping_rfilter_text`: default is `O` 
- `g:quickfix_mapping_undo`: default is `u`

