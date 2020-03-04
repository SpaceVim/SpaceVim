---
title: "Use Vim as a Rust IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/75607213-9afbb880-5b2f-11ea-8569-5f39142f134b.png
excerpt: "A general guide for using SpaceVim as Rust IDE, including layer configuration, requiems installation and usage."
type: BlogPosting
comments: true
commentsID: "Use Vim as a Rust IDE"
---

# [Blogs](../blog/) >> Use Vim as a Rust IDE

This is a general guide for using SpaceVim as a Rust IDE, including layer configuration and usage.
Each of the following sections will be covered:


<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Jump to test file](#jump-to-test-file)
- [Code formatting](#code-formatting)
- [running code](#running-code)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add rust language support in SpaceVim, you need to enable the `lang#rust` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet:

```toml
[[layers]]
  name = "lang#rust"
```

For more info, you can read the [lang#rust](../layers/lang/rust/) layer documentation.

### Code completion

`lang#rust` layer will load the rust plugin automatically, unless it's overriden in your `init.toml`.
The completion menu will be opened as you type.

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run rustc asynchronously.

### Jump to test file

SpaceVim use built-in plugin to manager the files in a project,
you can add a `.project_alt.json` to the root of your project with the following content:

```json
{
  "src/*.rs": {"alternate": "test/test_{}.rs"},
  "test/test_*.rs": {"alternate": "src/{}.rs"}
}
```

With this configuration, you can jump between the source code and test file via command `:A`

### Code formatting

The format layer is also enabled by default. With this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install rustfmt:

```sh
rustup component add rustfmt
```
### running code

To run current script, you can press `SPC l r`, and a split window
will be openen, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![rustide](https://user-images.githubusercontent.com/13142418/75607213-9afbb880-5b2f-11ea-8569-5f39142f134b.png)


### REPL support

Start a `evcxr` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![rustrepl](https://user-images.githubusercontent.com/13142418/75877531-ef19dc00-5e52-11ea-87c9-bf8b103a690d.png)
