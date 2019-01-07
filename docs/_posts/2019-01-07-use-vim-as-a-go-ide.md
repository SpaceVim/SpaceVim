---
title: "Use Vim as a Go IDE"
categories: [tutorials, blog]
excerpt: "A general guide for using SpaceVim as Go IDE, including layer configuration, requiems installation and usage."
type: BlogPosting
comments: true
commentsID: "Use Vim as a Go IDE"
---

# [Blogs](../blog/) >> Use Vim as a Go IDE

This is a general guide for using SpaceVim as a Go IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [code running](#code-running)
- [code format](#code-format)

<!-- vim-markdown-toc -->

### Enable language layer

To add go language support in SpaceVim, you need to enable the `lang#go` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#go"
```

for more info, you can read the [lang#go](../layers/lang/go/) layer documentation.

### code running

The default code running key binding is `SPC l r`. It will run `go run current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![gorun](https://user-images.githubusercontent.com/13142418/50751761-22300200-1286-11e9-8b4f-76836438d913.png)


### code format

The format layer use neoformat as default tool to format code, it will run `gofmt` on current file.
And the default key binding is `SPC b f`.
