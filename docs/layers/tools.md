---
title: "SpaceVim tools layer"
description: "This layer provides some tools for vim"
---

# [Available Layers](../) >> tools

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Tools](#tools)

<!-- vim-markdown-toc -->

## Description

This layer provides some extra vim tools for SpaceVim.
All tools can be called via command or key binding.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "tools"
```

## Tools

- `:Scriptnames`: same as `:scriptnames`, but show results in quickfix list.
- `:SourceCounter`: source counter for vim
- `:Calendar`: open vim calendar

This layer also includes `vim-bookmarks`, the following key binding can be used:

| key binding | description               |
| ----------- | ------------------------- |
| `m m`       | toggle bookmark           |
| `m c`       | clear bookmarks           |
| `m i`       | add bookmark annote       |
| `m a`       | show all bookmarks        |
| `m n`       | jump to next bookmark     |
| `m p`       | jump to previous bookmark |
