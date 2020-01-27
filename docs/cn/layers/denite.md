---
title: "SpaceVim denite 模块"
description: "这一模块为 SpaceVim 提供了以 denite 为核心的异步模糊查找机制，支持模糊搜索文件、历史记录、函数列表等。"
lang: zh
---

# [可用模块](../) >> denite

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

提供以 denite 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。这一模块需要 Vim/Neovim 支持 `+python3`。
## 启用模块

denite 模块默认并未启用，如果需要启用该模块，需要在配置文件里面加入：

```toml
[[layers]]
  name = "denite"
```

## 快捷键

下列快捷键均以 `<Leader> f` 为前置键，`<Leader>` 在 SpaceVim 中默认没有修改，
为 `\` 键。

| 快捷键               | 功能描述                       |
| -------------------- | ------------------------------ |
| `<Leader> f <Space>` | 模糊查找快捷键，并执行该快捷键 |
| `<Leader> f p`       | 模糊查找已安装插件  |
| `<Leader> f e`       | 模糊搜索寄存器                 |
| `<Leader> f h`       | 模糊搜索 history/yank          |
| `<Leader> f j`       | 模糊搜索 jump, change          |
| `<Leader> f l`       | 模糊搜索 location list         |
| `<Leader> f m`       | 模糊搜索 output messages       |
| `<Leader> f o`       | 模糊搜索函数列表               |
| `<Leader> f q`       | 模糊搜索 quickfix list         |
| `<Leader> f r`       | 重置上次搜索窗口               |
