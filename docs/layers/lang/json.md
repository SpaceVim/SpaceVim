---
title: "SpaceVim lang#json layer"
description: "json and json5 language support, include syntax highlighting."
---

# [Available Layers](../../) >> lang#json

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)

<!-- vim-markdown-toc -->

## Description

This layer is for editing json file, including syntax highlighting.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#json"
```

## Layer options

1. `conceal`: Set the valuable for `g:vim_json_syntax_conceal`
2. `concealcursor`: Set the valuable for `g:vim_json_syntax_concealcursor`

```toml
[[layers]]
    name = 'lang#json'
    conceal = false
    concealcursor = ''
```

3. `enable_json5`: Enable/Disable json5 support. Enabled by default.
