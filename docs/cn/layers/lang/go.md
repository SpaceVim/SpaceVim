---
title: "SpaceVim lang#go 模块"
description: "这一模块为 SpaceVim 提供了 Go 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#go

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [功能特性](#功能特性)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供了 Golang 开发支持，包括代码补全，格式化，语法检查等特性。同时提供诸多语言专属快捷键。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#go"
```

默认情况下，tagbar 这一插件无法显示 go 语法树，需要安装一个依赖 [gotags](https://github.com/jstemmer/gotags)：

```sh
go get -u github.com/jstemmer/gotags
```

## 功能特性

- 代码补全
- 语法检查
- 跳转定义处
- 查询函数引用

## 快捷键

**语言专属快捷键：**

| 快捷键    | 功能描述                  |
| --------- | ------------------------- |
| `SPC l a` | go alternate              |
| `SPC l b` | go build                  |
| `SPC l c` | go coverage               |
| `SPC l d` | go doc                    |
| `SPC l D` | go doc vertical           |
| `SPC l e` | go rename                 |
| `SPC l g` | go definition             |
| `SPC l G` | go generate               |
| `SPC l h` | go info                   |
| `SPC l i` | go implements             |
| `SPC l I` | implement stubs           |
| `SPC l k` | add tags                  |
| `SPC l K` | remove tags               |
| `SPC l l` | list declarations in file |
| `SPC l m` | format improts            |
| `SPC l M` | add import                |
| `SPC l r` | go run              |
| `SPC l s` | fill struct               |
| `SPC l t` | go test                   |
| `SPC l v` | freevars                  |
| `SPC l x` | go referrers              |

**代码格式化：**

默认的代码格式化快捷键是 `SPC b f`，该快捷键由 `format` 模块定义，同时也可以通过 `g =` 来对齐整个文档。

为了使得 `format` 模块支持 Go 文件，需要确认有可执行命令 [go-fmt](http://golang.org/cmd/gofmt/) 或者 [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports)，
通常 `go-fmt` 命令为 Go 自带的程序，请确认 Go 开发环境是否配置正确。
