---
title: "Use Vim as a Kotlin IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/53355518-20202080-3964-11e9-92f3-476060f2761e.png
description: "A general guide for using SpaceVim as Kotlin IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Kotlin IDE"
---

# [Blogs](../blog/) >> Use Vim as a Kotlin IDE

This is a general guide for using SpaceVim as a Kotlin IDE, including layer configuration and usage.
Each of the following sections will be covered:


<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add Kotlin language support in SpaceVim, you need to enable the `lang#kotlin` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet:

```toml
[[layers]]
  name = "lang#kotlin"
```

For more info, you can read the [lang#kotlin](../layers/lang/kotlin/) layer documentation.

### Code completion

`lang#kotlin` layer will load the Kotlin plugin automatically, unless it's overriden in your `init.toml`.
The completion menu will be opened as you type.

![rubycomplete](https://user-images.githubusercontent.com/13142418/53355518-20202080-3964-11e9-92f3-476060f2761e.png)

### Syntax linting

The [checkers](../checkers/) layer is enabled by default.
This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run `kotlinc` asynchronously.

### Jump to test file

To manager the alternate files in a project, you need to current a `.project_alt.json` in the root of your project.
Within the `.project_alt.json` file, the definitions of alternate files should be included.

For example:

```json
{
  "src/*.kt": {"alternate": "test/{}.kt"},
  "test/*.kt": {"alternate": "src/{}.kt"}
}
```

With this configuration, you can jump between the source code and test file via command `:A`

### running code

To run current script, you can press `SPC l r`, and a split window
will be openen, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![rubyrunner](https://user-images.githubusercontent.com/13142418/53300165-6b600380-387e-11e9-852f-f8766300ece1.gif)

### Code formatting

The [format](../format/) layer is also enabled by default.
With this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install [prettier](https://prettier.io/):

```
npm install --save-dev --save-exact prettier
```

### REPL support

Start a `kotlinc-jvm` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![rubyrepl](https://user-images.githubusercontent.com/13142418/53347455-1098db80-3954-11e9-87c3-13a027ec88f6.gif)


