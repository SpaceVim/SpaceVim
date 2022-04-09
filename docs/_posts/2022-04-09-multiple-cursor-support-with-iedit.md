---
title: "Vim 多光标支持"
categories: [blog_cn, feature_cn]
description: ""
image: https://user-images.githubusercontent.com/13142418/162548036-2598a705-4834-4332-9b55-fc49eae80f99.gif
commentsID: "Vim 多光标支持"
comments: true
permalink: /cn/:title/
lang: zh
---

# [Blogs](../blog/) >> Vim 多光标支持

{{ page.date | date_to_string }}


<!-- vim-markdown-toc GFM -->

- [起因](#起因)
- [模式介绍](#模式介绍)
- [关于文档](#关于文档)

<!-- vim-markdown-toc -->

## 起因

很多时候为了能够快速编辑多个相同的内容，因此 SpaceVim 实现了一个叫做 `iedit` 的功能，
有些类似于 emacs 的 iedit-mode 插件。 

## 模式介绍

启动 iedit 后，目前支持2种模式，叫做 iedit-normal 和 iedit-insert 模式，
这两种模式有点类似于常规的 Normal 和 Insert 模式。在 iedit-normal 模式下，
可以已启动光标删除内容，粘贴内容。而在 iedit-insert 模式下，主要是输入字符。
配合 `core#statusline` 模块，在状态栏上面可以看见 `IEDIT-NORMAL` 或者 `IEDIT-INSERT` 标识。

## 关于文档

可以在线阅读[Iedit-多光标编辑](../#iedit-多光标编辑)，或者在 SpaceVim 内阅读 `:h SpaceVim-plugins-iedit`
