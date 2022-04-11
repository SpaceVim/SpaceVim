---
title: "Multiple cursor support for Vim"
categories: [blog, feature]
description: ""
image: https://user-images.githubusercontent.com/13142418/162548036-2598a705-4834-4332-9b55-fc49eae80f99.gif
commentsID: "Multiple cursor support for Vim"
comments: true
---

# [Blogs](../blog/) >> Multiple cursor support for Vim

{{ page.date | date_to_string }}


<!-- vim-markdown-toc GFM -->

- [Design causes](#design-causes)
- [Mode introduction](#mode-introduction)
- [About documentation](#about-documentation)

<!-- vim-markdown-toc -->

## Design causes

Many times in order to quickly edit multiple pieces of the same content, SpaceVim implements a feature called `iedit`,
which is same as the `iedit-mode` of emacs.

## Mode introduction

With `iedit` enabled, there are two modes currently, called iedit-normal and iedit-insert.
These two modes are somewhat similar to the regular Normal and Insert modes. In iedit-normal mode,
you can move the cursor, delete content and paste content. In iedit-insert mode, you can input characters.
With the `core#statusline` layer, the `IEDIT-NORMAL` or `IEDIT-INSERT` modu text can be seen on the statusline.

## About documentation

You can read online doc: [Replace text with iedit](../documentation/#replace-text-with-iedit), or read `:h spacevim-plugins-iedit` in SpaceVim
