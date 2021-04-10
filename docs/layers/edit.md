---
title: "SpaceVim edit layer"
description: "Improve code edit expr in SpaceVim, provide more text objects."
---

# [Available Layers](../) >> edit

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Options](#options)

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
