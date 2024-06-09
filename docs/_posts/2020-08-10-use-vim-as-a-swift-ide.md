---
title: "Use Vim as a Swift IDE"
categories: [tutorials, blog]
image: https://img.spacevim.org/89797871-0d9ca580-db5e-11ea-8d43-c02cd9e49915.png
description: "A general guide for using SpaceVim as Swift IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Swift IDE"
language: Swift
---

# [Blogs](../blog/) >> Use Vim as a Swift IDE

This is a general guide for using SpaceVim as a Swift IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [code running](#code-running)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add swift language support in SpaceVim, you need to enable the `lang#swift` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#swift"
```

for more info, you can read the [lang#swift](../layers/lang/swift/) layer documentation.

### code running

The default code running key binding is `SPC l r`. It will run `swift current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![swift_runner](https://img.spacevim.org/89795928-96fea880-db5b-11ea-81c4-7f3384f419e7.png)

### REPL support

Start a `swift` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![swift_repl](https://img.spacevim.org/89796468-48054300-db5c-11ea-9ebe-4bb56e31722e.png)

