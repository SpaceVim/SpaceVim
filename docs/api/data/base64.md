---
title: "data#base64 API"
description: "data#base64 API provides base64 encode and decode functions"
---

# [Available APIs](../../) >> data#toml

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [functions](#functions)

<!-- vim-markdown-toc -->

## Intro

data#base64 API provides base64 encode and decode functions

```vim
let s:B = SpaceVim#api#import('data#base64')
let str1 = 'hello world!'
let str2 = s:B.encode(str1)
echo str1 == s:B.decode(str2)
```

## functions

| name          | description   |
| ------------- | ------------- |
| `encode(str)` | encode string |
| `decode(str)` | decode string |
