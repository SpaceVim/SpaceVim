---
title: "SpaceVim git layer"
---

# [SpaceVim Layers:](https://spacevim.org/layers) git

<!-- vim-markdown-toc GFM -->

- [Description](#description)
  - [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers adds extensive support for [git](http://git-scm.com/).

### Features

## Install

### Layer

To use this configuration layer, add `call SpaceVim#layers#load('git')` to your custom configuration file.

## Key bindings

| Key Binding    | Description            |
| -------------- | ---------------------- |
| `<Leader> g a` | git add current file   |
| `<Leader> g A` | git add All files      |
| `<Leader> g b` | open git blame window  |
| `<Leader> g s` | open git status window |
| `<Leader> g c` | open git commit window |
