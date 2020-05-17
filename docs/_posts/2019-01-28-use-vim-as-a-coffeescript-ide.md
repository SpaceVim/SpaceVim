---
title: "Use Vim as a CoffeeScript IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/51876268-fe526e80-23a2-11e9-8964-01fd62392a1f.png
description: "A general guide for using SpaceVim as CoffeeScript IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a CoffeeScript IDE"
---

# [Blogs](../blog/) >> Use Vim as a CoffeeScript IDE

This is a general guide for using SpaceVim as a [CoffeeScript](https://coffeescript.org/) IDE, including layer configuration and usage. 
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

By default `lang#coffeescript` layer is not loaded. To add CoffeeScript language support in SpaceVim,
you need to enable the `lang#coffeescript` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#coffeescript"
```

for more info, you can read the [lang#coffeescript](../layers/lang/coffeescript/) layer documentation.

### Code completion

`lang#coffeescript` layer will load the vim-coffeescript plugin automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![coffeeide](https://user-images.githubusercontent.com/13142418/51876268-fe526e80-23a2-11e9-8964-01fd62392a1f.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run [coffeelint](https://github.com/clutchski/coffeelint) asynchronously.

The coffeelint is command line lint for coffeescript, currently is maintained by [Shuan Wang](https://github.com/swang).
To install coffeelint, just run following command in terminal.

```sh
npm install -g coffeelint
```

Note: if no coffeelint is installed, neomake will ues default command `coffee`.

![coffeecheckers](https://user-images.githubusercontent.com/13142418/51875890-bb43cb80-23a1-11e9-93b2-037e7120f5f2.png)

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

### REPL support

Start a `coffee -i` inferior REPL process with `SPC l s i` when edit CoffeeScript file. After the REPL process has been started. you can 
send code to inferior process, all key bindings are begin with `SPC l s` prefix, including sending line, sending selection or even
send whole buffer.

![coffeerepl](https://user-images.githubusercontent.com/13142418/52127084-08f35900-266c-11e9-9efb-92fe8a014f08.png)
