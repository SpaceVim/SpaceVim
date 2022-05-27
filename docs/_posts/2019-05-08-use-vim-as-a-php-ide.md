---
title: "Use Vim as a PHP IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/57497567-c6948480-730a-11e9-95ec-e44bf6e79984.png
description: "A general guide for using SpaceVim as PHP IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a PHP IDE"
---

# [Blogs](../blog/) >> Use Vim as a PHP IDE

This is a general guide for using SpaceVim as a PHP IDE, including layer configuration and usage.
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Enable LSP support](#enable-lsp-support)
- [Ctags integration](#ctags-integration)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add PHP language support in SpaceVim, you need to enable the `lang#php` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet:

```toml
[[layers]]
  name = "lang#php"
```

For more info, you can read the [lang#php](../layers/lang/php/) layer documentation.

### Code completion

`lang#php` layer will load the PHP plugin automatically, unless it's overriden in your `init.toml`.
The completion menu will be opened as you type.

![phpide](https://user-images.githubusercontent.com/13142418/57497567-c6948480-730a-11e9-95ec-e44bf6e79984.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run [psalm](https://github.com/vimeo/psalm) asynchronously.

To install psalm, you may need to run:

```sh
composer require --dev vimeo/psalm
```

### Enable LSP support

To enable language server protocol(LSP) support for php,
you need to enable [lsp](../layers/language-server-protocol/) layer for php.

```toml
[[layers]]
  name = "lsp"
  filetypes = ["php"]
```

The default language server command of php is:

```
['php', g:spacevim_plugin_bundle_dir . 'repos/github.com/phpactor/phpactor/bin/phpactor', 'language-server']
```

If you want to use `intelephense`, install intelephense from command line:

```
npm install -g intelephense
```

To override the server command, you may need to use `override_cmd` option:

```toml
[[layers]]
  name = "lsp"
  filetypes = [ "php" ]
  [layers.override_cmd]
    php = ["intelephense", "--stdio"]
```

If you are using `nvim(>=0.5.0)`, you do not need to use `filetypes` and `override_cmd` option. 
You just need to use `enabled_clients` to specific the language servers.
for example:

```toml
[[layers]]
    name = 'lsp'
    enabled_clients = ['intelephense']
```

### Ctags integration

The `gtags` layer provides `ctags` integration for your project. It will create the index file for
each of your project. To enable `gtags` layer:

```toml
[[layers]]
    name = 'gtags'
```

With this layer, you can jump to method and class definitions easily (using `ctrl + ]` by default).
Read [gtags](../layers/gtags/) layer for more info.

### Jump to test file

To manage the alternate file for a project, you may need to create a `.project_alt.json` file in the root of your
project.

for exmaple, add following content into the `.project_alt.json` file:

```json
{
  "src/*.php": { "alternate": "test/{}.php" },
  "test/*.php": { "alternate": "src/{}.php" }
}
```

with this configuration, you can jump between the source code and test file via command `:A`

### running code

To run current script, you can press `SPC l r`, and a split window
will be openen, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![phpcoderunner](https://user-images.githubusercontent.com/13142418/57496602-79aeaf00-7306-11e9-8c18-32f00bd28307.gif)

### Code formatting

The [format](../layers/format/) layer is also enabled by default.
With this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install [php_beautifier](http://phpbeautifier.com/):

```sh
pear install PHP_Beautifier
```

### REPL support

Start a `php -a` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![phprepl](https://user-images.githubusercontent.com/13142418/57497156-0ce8e400-7309-11e9-8628-da42d6f8432e.gif)
