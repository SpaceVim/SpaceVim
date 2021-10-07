---
title: "SpaceVim lang#vue layer"
description: "This layer adds Vue language support to SpaceVim"
---

# [Available Layers](../../) >> lang#vue

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Installation](#installation)
  - [Enable language layer](#enable-language-layer)
  - [Language tools](#language-tools)

<!-- vim-markdown-toc -->

## Description

This layer adds Vue language support to SpaceVim. This layer includes plugin [vim-vue](https://github.com/posva/vim-vue).

## Installation

### Enable language layer

The `lang#vue` layer is not loaded by default, to use this layer,
you need to add following snippet into your spacevim configuration file.

```toml
[[layers]]
  name = "lang#vue"
```

### Language tools

- **syntax checking:**

  `checker` layer provides syntax checking feature, and for vue it uses the `eslint` and `eslint-plugin-vue` package:

  ```sh
  npm install -g eslint eslint-plugin-vue
  ```
