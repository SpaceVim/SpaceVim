---
title: "Use Vim as a CoffeeScript IDE"
categories: [tutorials, blog]
images: https://user-images.githubusercontent.com/13142418/51436347-3502f780-1cc6-11e9-9ae1-02e1dfa1e165.png
excerpt: "A general guide for using SpaceVim as CoffeeScript IDE, including layer configuration, requiems installation and usage."
type: BlogPosting
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

`lang#lua` layer will load the vim-lua plugin automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![lua](https://user-images.githubusercontent.com/13142418/51436347-3502f780-1cc6-11e9-9ae1-02e1dfa1e165.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run [coffeelint](https://github.com/clutchski/coffeelint) asynchronously.

The coffeelint is command line lint for coffeescript, currently is maintained by [Shuan Wang](https://github.com/swang).
To install coffeelint, just run following command in terminal.

```sh
npm install -g coffeelint
```

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

