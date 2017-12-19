---
title: "SpaceVim golang layer"
description: "This layer is for golang development. It also provides additional language-specific key mappings."
---

# [SpaceVim Layers:](https://spacevim.org/layers) go

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for golang development. It also provides additional language-specific key mappings.

## Install

To use this configuration layer, add `SPLayer 'lang#go` to your custom configuration file.

## Key bindings

**Import key bindings:**

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| SPC l i     | go implements							               |
| SPC l f     | go info									                 |
| SPC l e     | go rename								                 |
| SPC l r     | go run									                 |
| SPC l b     | go build								                 |
| SPC l t     | go test									                 |
| SPC l d     | go doc									                 |
| SPC l v     | go doc vertical							             |
| SPC l c     | go coverage								               |

**Code formatting:**

the default key bindings for format current buffer is `SPC b f`, and this key bindings is defined in [format layer](<>). you can also use `g=` to indent current buffer.

To make neoformat support go files, you should have [go-fmt](http://golang.org/cmd/gofmt/) command available, or
install [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports). `go-fmt` is delivered by golang's default installation, so make sure you have correctly setup your go environment.
