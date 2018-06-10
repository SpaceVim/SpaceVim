---
title: "SpaceVim golang layer"
description: "This layer is for golang development. It also provides additional language-specific key mappings."
---

# [SpaceVim Layers:](https://spacevim.org/layers) go

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for golang development. It also provides additional language-specific key mappings.

## Install

To use this configuration layer, add `call SpaceVim#layers#load('lang#go')` to your custom configuration file.

## Features

- auto-completion
- syntax checking
- goto definition
- refernce finder

## Key bindings

**Import key bindings:**

| Key Binding | Description                 |
| ----------- | --------------------------- |
| SPC l a     |    go alternate             |
| SPC l b     |    go build                 |
| SPC l c     |    go coverage              |
| SPC l d     |    go doc                   |
| SPC l D     |    go doc vertical          |
| SPC l e     |    go rename                |
| SPC l g     |    go definition            |
| SPC l G     |    go generate              |
| SPC l h     |    go info                  |
| SPC l i     |    go implements            |
| SPC l I     |    implement stubs          |
| SPC l k     |    add tags                 |
| SPC l K     |    remove tags              |
| SPC l l     |    list declarations in file|
| SPC l m     |    format improts           |
| SPC l M     |    add import               |
| SPC l r     |    go referrers             |
| SPC l s     |    fill struct              |
| SPC l t     |    go test                  |
| SPC l v     |    freevars                 |
| SPC l x     |    go run                   |

**Code formatting:**

the default key bindings for format current buffer is `SPC b f`, and this key bindings is defined in [format layer](<>). you can also use `g=` to indent current buffer.

To make neoformat support go files, you should have [go-fmt](http://golang.org/cmd/gofmt/) command available, or
install [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports). `go-fmt` is delivered by golang's default installation, so make sure you have correctly setup your go environment.
