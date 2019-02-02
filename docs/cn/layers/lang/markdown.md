---
title: "SpaceVim lang#markdown 模块"
description: "这一模块为 Markdown 编辑提供支持，包括格式化、自动生成文章目录、代码块等特性。"
lang: cn
---

# [可用模块](../../) >> lang#markdown

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [代码格式化](#代码格式化)
- [模块设置](#模块设置)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供 Markdown 编辑支持，包括格式化、实时预览、自动生成 TOC 等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#markdown"
```

## 代码格式化

SpaceVim 默认使用 remark 来格式化 Markdown 文件，因此需要安装该命令，可通过如下命令来安装：

```sh
npm -g install remark
npm -g install remark-cli
npm -g install remark-stringify
```

## 模块设置

**listItemIndent**

设置有序列表对齐方式 (`tab`, `mixed` 或者 `1` , 默认: `1`)。

- `'tab'`: 使用 tab stops 对齐
- `'1'`: 使用空格对齐
- `'mixed'`: use `1` for tight and `tab` for loose list items

**enableWcwidth**

启用/禁用表格字符宽度检测，默认未启用该功能。若需要启用该功能，需要额外安装 [wcwidth](https://www.npmjs.com/package/wcwidth)。

**listItemChar**

设置无序列表前缀 (`'-'`, `'*'`, or `'+'`, 默认: `'-'`)。

## 快捷键

| 快捷键     | 模式   | 按键描述                   |
| ---------- | ------ | -------------------------- |
| `SPC b f`  | Normal | 格式化当前文件             |
| `SPC l ft` | Normal | 格式化光标处的表格         |
| `SPC l k`  | Normal | 增加链接 URL               |
| `SPC l p`  | Normal | 通过浏览器实时预览当前文件 |
