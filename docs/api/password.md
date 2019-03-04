---
title: "password api"
description: "password API provides some basic functions for generating password"
---

# [Available APIs](../) >> password

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

This api provides some basic Functions for generating password.

```vim
let s:PW = SpaceVim#api#import('password')
let password = s:PW.generate_simple(8)
echom password
" you should see a string like `GAN0q7aE`
```

## Functions

| function name            | description                  |
| ------------------------ | ---------------------------- |
| `generate_simple(len)`   | generating simple password   |
| `generate_strong(len)`   | generating strong password   |
| `generate_paranoid(len)` | generating paranoid password |
| `generate_numeric(len)`  | generating numeric password  |
| `generate_phonetic(len)` | generating phonetic password |
