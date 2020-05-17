---
title: "Use Vim as a Lua IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/51436347-3502f780-1cc6-11e9-9ae1-02e1dfa1e165.png
description: "A general guide for using SpaceVim as Lua IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Lua IDE"
---

# [Blogs](../blog/) >> Use Vim as a Lua IDE

This is a general guide for using SpaceVim as a Lua IDE, including layer configuration and usage.
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

To add Lua language support in SpaceVim, you need to enable the `lang#lua` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#lua"
```

for more info, you can read the [lang#lua](../layers/lang/lua/) layer documentation.

### Code completion

`lang#lua` layer will load the vim-lua plugin automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![lua](https://user-images.githubusercontent.com/13142418/51436347-3502f780-1cc6-11e9-9ae1-02e1dfa1e165.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run luac asynchronously.

![luac](https://user-images.githubusercontent.com/13142418/51438866-b8cfda80-1cec-11e9-8645-b43fc6481e42.png)

### Jump to test file

SpaceVim use built-in plugin to manager the files in a project, you can add a `.projections.json` to the root of your project with following content:

```json
{
  "src/*.lua": {"alternate": "test/{}.lua"},
  "test/*.lua": {"alternate": "src/{}.lua"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`

### running code

To run current script, you can press `SPC l r`, and a split windows
will be openen, the output of the script will be shown in this windows.
It is running asynchronously, and will not block your vim.

![luarunner](https://user-images.githubusercontent.com/13142418/51438907-76f36400-1ced-11e9-8838-441965a22ce9.png)

### Code formatting

The format layer is also enabled by default, with this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install luaformatter.

```sh
luarocks install formatter
```

### REPL support

Start a `lua -i` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process, all key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![luarepl](https://user-images.githubusercontent.com/13142418/52158892-075f7a80-26d8-11e9-9bf2-2be8ab2363ab.gif)
