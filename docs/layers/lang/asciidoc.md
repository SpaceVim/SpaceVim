---
title: "SpaceVim lang#asciidoc layer"
description: "Edit AsciiDoc within vim, autopreview AsciiDoc in the default browser, with this layer you can also format AsciiDoc files."
---

# [Available Layers](../../) >> lang#asciidoc

![asciidoc](https://img.spacevim.org/92319337-7554ec00-f049-11ea-90fb-ad663dceea12.png)

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for editing AsciiDoc files. Including syntax highlighting, indent and syntax lint.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#asciidoc"
```

`ctags` is required, if users want to view the syntax outline.

## Key bindings

| Key bindings | Description                           |
| ------------ | ------------------------------------- |
| `F2`         | Open outline of current asciidoc file |
