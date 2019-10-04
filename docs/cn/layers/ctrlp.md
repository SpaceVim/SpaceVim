---
title: "SpaceVim ctrlp 模块"
description: "这一模块为 SpaceVim 提供以 ctrlp 为核心的模糊查找机制，支持模糊搜索文件、历史记录、函数列表等。"
lang: zh
---

# [可用模块](../) >> ctrlp


<!-- vim-markdown-toc GFM -->

- [模块介绍](#模块介绍)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块介绍

这一模块在 ctrlp 的基础上做了适当的包装和定制，提供了搜索文件、函数列表、
命令历史等等特性。

## 启用模块

ctrlp 模块默认并未启用，如果需要启用该模块，需要在配置文件里面加入：

```toml
[[layers]]
  name = "ctrlp"
```

## 快捷键

下列快捷键均以 `<Leader> f` 为前缀键，`<Leader>` 在 SpaceVim 中默认没有修改，
为 `\` 键。

| 快捷键               | 功能描述                       |
| -------------------- | ------------------------------ |
| `<Leader> f <Space>` | 模糊查找快捷键，并执行该快捷键 |
| `<Leader> f p`       | 模糊查找已安装插件  |
| `<Leader> f e`       | 模糊搜索寄存器                 |
| `<Leader> f h`       | 模糊搜索 history/yank          |
| `<Leader> f j`       | 模糊搜索 jump, change          |
| `<Leader> f o`       | 模糊搜索函数列表               |
| `<Leader> f q`       | 模糊搜索 quickfix list         |
