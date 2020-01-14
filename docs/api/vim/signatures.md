---
title: "vim#signatures api"
description: "vim#signatures API provides some basic functions for showing signatures info."
---

# [Available APIs](../../) >> vim#signatures

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions ane varilues](#functions-ane-varilues)

<!-- vim-markdown-toc -->

## Intro

vim#signatures API provides some basic functions for showing signatures info.

## Functions ane varilues

| function name           | description                                           |
| ----------------------- | ----------------------------------------------------- |
| `info(line, col, msg)`  | show info signature message on specific line and col  |
| `warn(line, col, msg)`  | show warn signature message on specific line and col  |
| `error(line, col, msg)` | show error signature message on specific line and col |
| `clear()`               | clear signatures info                                 |
| `hi_info_group`         | info message highlight group name                     |
| `hi_warn_group`         | warn message highlight group name                     |
| `hi_error_group`        | error message highlight group name                    |
