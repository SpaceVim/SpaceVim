---
title: "data#toml API"
description: "data#toml API provides some basic functions and values for toml."
---

# [Available APIs](../../) >> data#toml

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`data#toml` API provides some functions to manipulate a toml. Here is an example for using this api:

```vim
let s:TOML = SpaceVim#api#import('data#toml')
let json = s:TOML.parse_file('~/.SpaceVim.d/init.toml')
```

## functions

| name               | description       |
| ------------------ | ----------------- |
| `parse(str)`       | parse content     |
| `parse_file(path)` | parse a toml file |
