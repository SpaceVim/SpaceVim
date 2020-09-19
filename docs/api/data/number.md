---
title: "data#number API"
description: "data#number API provides some basic functions to generate number."
---

# [Available APIs](../../) >> data#number

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`data#number` API provides some functions to manipulate a number. Here is an example for using this api:

```vim
let s:NUM = SpaceVim#api#import('data#number')
let random_number = s:NUM.random(3, 10)
```

## functions

| name           | description                               |
| -------------- | ----------------------------------------- |
| `random()`     | an unbounded random integer number.       |
| `random(a)`    | an unbounded random number larger than a. |
| `random(a, b)` | a random number from [a, a + b - 1].      |
