---
title: "SpaceVim lang#extra layer"
description: "This layer adds extra language support to SpaceVim"
---

# [Available Layers](../../) >> lang#extra

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Included languages](#included-languages)
- [Install](#install)

<!-- vim-markdown-toc -->

## Description

This layer adds many extra language support for less common languages to SpaceVim.

## Included languages

| language            | features                                                |
| ------------------- | ------------------------------------------------------- |
| i3 config           | syntax highlighting                                     |
| qml                 | syntax highlighting                                     |
| toml                | syntax highlighting                                     |
| coffee script       | syntax highlighting                                     |
| irssi config        | syntax highlighting                                     |
| vimperator config   | syntax highlighting                                     |
| Pug (formerly Jade) | syntax highlighting, indent                             |
| mustache            | syntax highlighting, matchit, section movement mappings |

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#extra"
```
