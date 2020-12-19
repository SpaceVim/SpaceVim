---
title: "SpaceVim edit layer"
description: "Improve code edit expr in SpaceVim, provide more text opjects."
---

# [Available Layers](../) >> edit

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Options](#options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides many edit key bindings for SpaceVim, and also provides more text objects.

## Features

- change surround symbol via vim-surround
- repeat latest action via vim-repeat
- multiple cursor
- align
- set justification for paragraph
- highlight whitespaces at the end of a line
- load editorconfig config, need `+python` or `+python3`

## Options

- `textobj`: specified a list of text objects to be enabled, the avaliable list is :`indent`, `line`, `entire`

## Key bindings

| Key bindings          | Descraptions                     |
| --------------------- | -------------------------------- |
| `SPC x a {delimiter}` | align content based on delimiter |

**default delimiters**

- `=`: align `===`, `==`, `!=`, `>=` etc.
- `&`: align `&`
- `¦`: align `¦`
- `|`: align `|`
- `;`: align `;`
- `:`: align `:`
- `,`: align `,`
- `.`: align `.`
- `[`: align `[`
- `(`: align `(`
- `{`: align `{`
- `]`: align `]`
- `}`: align `}`
- `)`: align `)`
- `[SPC]`: align `[SPC]`
- `o`: align `+ - * / % ^` etc.
- `r`: align user specified regular expression.

| Key bindings | Descraptions                         |
| ------------ | ------------------------------------ |
| `SPC x j c`  | set the justification to center      |
| `SPC x j f`  | set the justification to full (TODO) |
| `SPC x j l`  | set the justification to left        |
| `SPC x j n`  | set the justification to none (TODO) |
| `SPC x j r`  | set the justification to right       |
| `SPC x u`    | set the selected text to lower case  |
| `SPC x U`    | set the selected text to upper case  |
| `SPC x w c`  | count the words in the select region |
