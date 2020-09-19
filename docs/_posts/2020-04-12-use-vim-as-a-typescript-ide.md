---
title: "Use Vim as a TypeScript IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/79134364-2bd8db80-7de0-11ea-848e-71d3f07cb79d.png
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
- [Syntax linting](#syntax-linting)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

By default `lang#typescript` layer is not loaded. To add TypeScript language support in SpaceVim,
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

![ts](https://user-images.githubusercontent.com/13142418/79134364-2bd8db80-7de0-11ea-848e-71d3f07cb79d.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run [tslint](https://www.npmjs.com/package/tslint) asynchronously.

To install eslint, just run following command in terminal.

```sh
npm install -g tslint
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

![tsrunner](https://user-images.githubusercontent.com/13142418/79641052-b4cc8a00-81c7-11ea-8e95-35bc816b17d9.png)

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

