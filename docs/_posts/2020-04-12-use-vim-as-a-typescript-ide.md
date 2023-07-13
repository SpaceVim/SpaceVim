---
title: "Use Vim as a TypeScript IDE"
categories: [tutorials, blog]
image: https://img.spacevim.org/79134364-2bd8db80-7de0-11ea-848e-71d3f07cb79d.png
description: "A general guide for using SpaceVim as TypeScript IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a TypeScript IDE"
---

# [Blogs](../blog/) >> Use Vim as a TypeScript IDE

This is a general guide for using SpaceVim as a TypeScript IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Code linting](#code-linting)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->


This tutorial is not intended to teach you TypeScript itself.

If you have any problems, feel free to join the [SpaceVim gitter chatting room](https://gitter.im/SpaceVim/SpaceVim) for general discussion.

### Enable language layer

TypeScript language support in SpaceVim is provided by `lang#typescript` layer.
This layer is not loaded by default. To add TypeScript language support in SpaceVim,
you need to enable the `lang#typescript` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#typescript"
```

for more info, you can read the [lang#typescript](../layers/lang/typescript/) layer documentation.

### Code completion

`lang#typescript` layer will load the typescript plugins automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![ts](https://img.spacevim.org/79134364-2bd8db80-7de0-11ea-848e-71d3f07cb79d.png)

### Code linting

Code linting is provided by `checkers` layer which is loaded by default.
The default lint engine is [neomake](https://github.com/neomake/neomake).
It will run [eslint](https://eslint.org/) asynchronously.

To install eslint, just run following command in terminal.

```
npm install -g eslint
```

### Jump to test file

SpaceVim use built-in plugin to manage the files in a project,
you can add a `.project_alt.json` to the root of your project with following content:

```json
{
  "src/*.ts": {"alternate": "test/{}.ts"},
  "test/*.ts": {"alternate": "src/{}.ts"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`.

### running code

To run code in current buffer, you can press `SPC l r`, and a split window
will be opened, the output will be shown in this window.
It is running asynchronously, and will not block your vim.

![tsrunner](https://img.spacevim.org/79641052-b4cc8a00-81c7-11ea-8e95-35bc816b17d9.png)

### Code formatting

The format layer is also enabled by default, with this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install the command line tool [`tsfmt`](https://www.npmjs.com/package/typescript-formatter).

```sh
npm install -g typescript-formatter
```

### REPL support

Start a `ts-node -i` inferior REPL process with `SPC l s i`. After the REPL process has been started, you can 
send code to inferior process, all key bindings begins with `SPC l s` prefix, including sending line, sending selection or even
send whole buffer.

NOTE: repl support for typescript has not be implemented, because the `ts-node -i` do not fflush stdout, see [ts-node #1013](https://github.com/TypeStrong/ts-node/issues/1013).

