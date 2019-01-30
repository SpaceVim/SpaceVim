---
title: "Use Vim as a JavaScript IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/51876268-fe526e80-23a2-11e9-8964-01fd62392a1f.png
excerpt: "A general guide for using SpaceVim as JavaScript IDE, including layer configuration, requiems installation and usage."
type: BlogPosting
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

![coffeeide](https://user-images.githubusercontent.com/13142418/51876268-fe526e80-23a2-11e9-8964-01fd62392a1f.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run [eslint](https://eslint.org/) asynchronously.

To install eslint, just run following command in terminal.

```sh
npm install -g eslint
```

![eslint](https://user-images.githubusercontent.com/13142418/51972203-dbfd4580-24b5-11e9-9bbd-2a88e6f656f6.png)

### Jump to test file

SpaceVim use built-in plugin to manager the files in a project,
you can add a `.project_alt.json` to the root of your project with following content:

```json
{
  "src/*.coffee": {"alternate": "test/{}.coffee"},
  "test/*.coffee": {"alternate": "src/{}.coffee"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`.

### running code

To run current script, you can press `SPC l r`, and a split windows
will be openen, the output of the script will be shown in this windows.
It is running asynchronously, and will not block your vim.

![coffeerunner](https://user-images.githubusercontent.com/13142418/51877740-3f00b680-23a8-11e9-91ce-18cf147dbb95.png)

### Code formatting

The format layer is also enabled by default, with this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install coffee-fmt.

```sh
npm install -g coffee-fmt
```

