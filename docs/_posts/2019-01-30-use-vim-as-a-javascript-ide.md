---
title: "Use Vim as a JavaScript IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/51976034-add03380-24be-11e9-84b5-245432e7f933.png
description: "A general guide for using SpaceVim as JavaScript IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a JavaScript IDE"
---

# [Blogs](../blog/) >> Use Vim as a JavaScript IDE

This is a general guide for using SpaceVim as a JavaScript IDE, including layer configuration and usage. 
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

By default `lang#javascript` layer is not loaded. To add JavaScript language support in SpaceVim,
you need to enable the `lang#javascript` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#javascript"
```

for more info, you can read the [lang#javascript](../layers/lang/javascript/) layer documentation.

### Code completion

`lang#javascript` layer will load the javascript plugins automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![jside](https://user-images.githubusercontent.com/13142418/51976034-add03380-24be-11e9-84b5-245432e7f933.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run [eslint](https://eslint.org/) asynchronously.

To install eslint, just run following command in terminal.

```sh
npm install -g eslint-cli
```

![eslint](https://user-images.githubusercontent.com/13142418/51972203-dbfd4580-24b5-11e9-9bbd-2a88e6f656f6.png)

### Jump to test file

SpaceVim use built-in plugin to manage the files in a project,
you can add a `.project_alt.json` to the root of your project with following content:

```json
{
  "src/*.js": {"alternate": "test/{}.js"},
  "test/*.js": {"alternate": "src/{}.js"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`.

### running code

To run code in current buffer, you can press `SPC l r`, and a split window
will be opened, the output will be shown in this window.
It is running asynchronously, and will not block your vim.

![jsrunner](https://user-images.githubusercontent.com/13142418/51972835-4cf12d00-24b7-11e9-9693-5e1eea9853b0.png)

### Code formatting

The format layer is also enabled by default, with this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install js-beautify.

```sh
npm install -g js-beautify
```

### REPL support

Start a `node -i` inferior REPL process with `SPC l s i`. After the REPL process has been started, you can 
send code to inferior process, all key bindings begins with `SPC l s` prefix, including sending line, sending selection or even
send whole buffer.

![jsrepl](https://user-images.githubusercontent.com/13142418/51974494-00a7ec00-24bb-11e9-8e98-c449a7a067c3.png)
