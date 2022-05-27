---
title: "SpaceVim golang layer"
description: "This layer is for golang development. It also provides additional language-specific key mappings."
---

# [Available Layers](../../) >> lang#go

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for [golang](https://go.dev/) development. It also provides additional language-specific key mappings.

## Features

- auto-completion
- syntax checking
- goto definition
- reference finder

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#go"
```

After the installation, run `:GoInstallBinaries` inside vim.

To enable tagbar support, you need to install [gotags](https://github.com/jstemmer/gotags):

```sh
go install github.com/jstemmer/gotags@latest
```

## Layer options

- `enabled_linters`: set a list of enabled lint for golang. by default this
  option is `['golint']`. The available linters includes: `go`, `gometalinter`
- `go_file_head`: the default file head for golang source code.

  ```
  [[layers]]
      name = "lang#go"
      go_file_head = [
          '#!/usr/bin/python3',
          '# -*- coding : utf-8 -*-'
          ''
  ]
  ```

- `go_interpreter`: Set the interpreter of go.

  ```
  [[layers]]
      name = 'lang#go'
      go_interpreter = '~/download/bin/go'
  ```

- `format_on_save`: enable/disable code formation when save go file. This
  options is disabled by default, to enable it:

  ```
  [[layers]]
      name = 'lang#go'
      format_on_save = true
  ```

## Key bindings

**Import key bindings:**

| Key Bindings | Descriptions              |
| ------------ | ------------------------- |
| `SPC l a`    | go alternate              |
| `SPC l b`    | go build                  |
| `SPC l c`    | go coverage               |
| `SPC l d`    | go doc                    |
| `SPC l D`    | go doc vertical           |
| `SPC l e`    | go rename                 |
| `SPC l g`    | go definition             |
| `SPC l G`    | go generate               |
| `SPC l h`    | go info                   |
| `SPC l i`    | go implements             |
| `SPC l I`    | implement stubs           |
| `SPC l k`    | add tags                  |
| `SPC l K`    | remove tags               |
| `SPC l l`    | list declarations in file |
| `SPC l m`    | format imports            |
| `SPC l M`    | add import                |
| `SPC l r`    | go run                    |
| `SPC l s`    | fill struct               |
| `SPC l t`    | go test                   |
| `SPC l v`    | freevars                  |
| `SPC l x`    | go referrers              |

**Code formatting:**

the default key bindings for formatting current buffer is `SPC b f`, and this key bindings is defined in [format layer](../../format/). You can also use `g=` to indent current buffer.

To make neoformat support go files, you should have [go-fmt](http://golang.org/cmd/gofmt/) command available, or
install [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports). `go-fmt` is delivered by golang's default installation, so make sure you have correctly setup your go environment.
