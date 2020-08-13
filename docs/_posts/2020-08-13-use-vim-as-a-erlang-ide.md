---
title: "Use Vim as a erlang IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/89797871-0d9ca580-db5e-11ea-8d43-c02cd9e49915.png
description: "A general guide for using SpaceVim as erlang IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a erlang IDE"
---

# [Blogs](../blog/) >> Use Vim as a erlang IDE

This is a general guide for using SpaceVim as a erlang IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code formatting](#code-formatting)
- [code running](#code-running)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add erlang language support in SpaceVim, you need to enable the `lang#erlang` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#erlang"
```

for more info, you can read the [lang#erlang](../layers/lang/erlang/) layer documentation.

### Code formatting

Code formatting is provided by [format](../layers/format/) layer. The default key binding is `SPC b f`.
To enable code formatting feature for erlang, you need to load the format layer.

```toml
[[layers]]
  name = "format"
```

### code running

The default code running key binding is `SPC l r`. It will run `erlang current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![swift_runner](https://user-images.githubusercontent.com/13142418/89795928-96fea880-db5b-11ea-81c4-7f3384f419e7.png)

### REPL support

Start a `erlang` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![swift_repl](https://user-images.githubusercontent.com/13142418/89796468-48054300-db5c-11ea-9ebe-4bb56e31722e.png)



