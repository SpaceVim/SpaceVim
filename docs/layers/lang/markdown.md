---
title: "SpaceVim lang#markdown layer"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#markdown

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
- [formatting](#formatting)
  - [options](#options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for editing markdown file.

## Layer Installation

To use this configuration layer, add `call SpaceVim#layers#load('lang#markdown')` to your custom configuration file.

## formatting

SpaceVim use remark to formatting markdown file, so you need to install this program. you can install it via npm:

```sh
npm -g install remark
npm -g install remark-cli
npm -g install remark-stringify
```

### options

**listItemIndent**

How to indent the content from list items (`tab`, `mixed` or 1 , default: 1).

- `'tab'`: use tab stops (4 spaces)
- `'1'`: use one space
- `'mixed'`: use `1` for tight and `tab` for loose list items

**enableWcwidth**

Enable/Disable wcwidth for detecting the length of a table cell, default is 0.


## Key bindings

| Key        | mode   | description                |
| ---------- | ------ | -------------------------- |
| `SPC b f`  | Normal | Format current buffer      |
| `SPC l ft` | Normal | Format table under cursor  |
| `SPC l p`  | Normal | Real-time markdown preview |
