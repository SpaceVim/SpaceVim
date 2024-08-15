---
title: "Use Vim as a Java IDE"
categories: [tutorials, blog]
description: "A general guide for using SpaceVim as Java IDE, including layer configuration and requiems installation."
redirect_from: "/2017/02/11/use-vim-as-a-java-ide.html"
type: article
comments: true
commentsID: "Use Vim as a Java IDE"
language: Java
---

# [Blogs](../blog/) >> Use Vim as a Java IDE

This article introduces you to SpaceVim as a Java environment.
Before reading this article, I recommend reading [Use vim as IDE](../use-vim-as-ide/), which is for the general usage.
With `lang#java` layer, spacevim can be built into a lightweight java integrated development environment.

![java ide](https://img.spacevim.org/228426235-cd9c6fd8-8756-4586-8bfe-d62f51a8ec50.png)

Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Language server](#language-server)
  - [neovim(`>=0.5.0`)](#neovim050)
  - [vim or neovim(`<0.5.0`)](#vim-or-neovim050)
- [Code completion](#code-completion)
- [Code outline](#code-outline)
- [Rename symbol](#rename-symbol)
- [Javadoc hovers](#javadoc-hovers)
- [Syntax lint](#syntax-lint)
- [Import packages](#import-packages)
- [Jump to test file](#jump-to-test-file)
- [Code running](#code-running)
- [Code formatting](#code-formatting)
- [REPL](#repl)

<!-- vim-markdown-toc -->

This tutorial is not intended to teach you Java itself.

### Enable language layer

By default, the `lang#java` layer is not loaded in SpaceVim. To use SpaceVim for java,
you need to enable this layer in SpaceVim configuration file.
Press `SPC f v d` to open SpaceVim configuration file, and add following section:

```toml
[[layers]]
  name = "lang#java"
```

### Language server

There are two ways to configure the java language server protocol.

#### neovim(`>=0.5.0`)

If you are using `nvim(>=0.5.0)`. You need to use `enabled_clients` to specific the language servers.
for example:

```toml
[[layers]]
    name = 'lsp'
    enabled_clients = ['jdtls', 'clangd']
```

To override the command of client, you may need to use `override_client_cmds` option:

```toml
[[layers]]
  name = "lsp"
  enabled_clients = ['jdtls', 'clangd']
  [layers.override_client_cmds]
    jdtls = ["jdtls", "-configuration", "/home/user/.cache/jdtls/config", "-data", "/home/user/.cache/jdtls/workspace"]
```

You can install `jdtls` via packages manager. For example:

```
scoop install jdtls
```

For manual installation you can download precompiled binaries from the [official downloads site](http://download.eclipse.org/jdtls/snapshots/?d) and ensure that the PATH variable contains the bin directory of the extracted archive.

#### vim or neovim(`<0.5.0`)

To enable language server protocol support, you may need to enable lsp layer.

```toml
[[layers]]
  name = "lsp"
  filetypes = [
    "java"
  ]
  [layers.override_cmd]
    java = [
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=NONE",
    "-noverify",
    "-Xmx1G",
    "-jar",
    "D:\\dev\\jdt-language-server-latest\\plugins\\org.eclipse.equinox.launcher_1.5.200.v20180922-1751.jar",
    "-configuration",
    "D:\\dev\\jdt-language-server-latest\\config_win",
    "-data",
    "C:\\Users\\Administrator\\.cache\\javalsp"
    ]
```

You need to replace `D:\dev\jdt-language-server-latest\plugins\org.eclipse.equinox.launcher_1.5.200.v20180922-1751.jar` with the actual name of the org.eclipse.equinox.launcher jar

The configuration flag can point to either:

- `config_win`, for Windows
- `config_mac`, for MacOS
- `config_linux`, for Linux

The data flag value should be the absolute path to the working directory of the server.
This should be different from the path of the user's project files (which is sent during the initialize handshake).

### Code completion

javacomplete2 which has been included in `lang#java` layer provides omnifunc for java file and deoplete source.
with this plugin and `autocomplete` layer, the completion popup menu will be opened automatically.

![code complete](https://img.spacevim.org/46297202-ba0ab980-c5ce-11e8-81a0-4a4a85bc98a5.png)

### Code outline

The default outline plugin is tagbar, and the key binding is `F2`. This key binding will open an outline sidebar on the left.

![java outline](https://img.spacevim.org/53250502-7c313d80-36f5-11e9-8fa2-8437ecf57a78.png)

To fuzzy find outline in current buffer, you need to enable a fuzzy find layer, for example denite layer,
then press `Leader f o`:

![java fuzzy outline](https://img.spacevim.org/53250728-f1047780-36f5-11e9-923d-0b34568f9566.gif)

### Rename symbol

To rename java symbol, you need to enable `lsp` layer for java. The default key binding
for rename symbol under the cursor is `SPC l e`.

![rename java symblo](https://img.spacevim.org/53250190-da115580-36f4-11e9-9590-bf945fa8dcc0.gif)

### Javadoc hovers

The default key binding to get doc of cursor symbol is `SPC l d` or `K`:

![javadoc](https://img.spacevim.org/53255520-bf44de00-3700-11e9-9f47-50bc50ed6e83.gif)

### Syntax lint

`checkers` layer provides asynchronous linting feature, this layer use [neomake](https://github.com/neomake/neomake) by default.
neomake support maven, gradle and eclipse project. it will generate classpath automatically for these project.

![lint-java](https://img.spacevim.org/46323584-99b81a80-c621-11e8-8ca5-d8eb7fbd93cf.png)

within above picture, we can see the checkers layer provides following feature:

- list errors and warnings in quickfix windows
- sign error and warning position on the left side
- show numbers of errors and warnings on statusline
- show cursor error and warning information below current line

### Import packages

There are two kind features for importing packages, import packages automatically and manually.
SpaceVim will import the packages after selecting the class name on popmenu.
Also, you can use key binding `SPC l i` to import the class at the cursor point.
If there are more than one class, a menu will be shown below current windows.

![import class](https://img.spacevim.org/46298485-c04e6500-c5d1-11e8-96f3-01d84f9fe237.png)

### Jump to test file

SpaceVim uses vim-project to manager the files in a project, you can add a `.projections.json` to the root of your project with following content:

```json
{
  "src/main/java/*.java": {
    "alternate": "src/test/java/{dirname}/Test{basename}.java"
  },
  "src/test/java/**/Test*.java": { "alternate": "src/main/java/{}.java" }
}
```

with this configuration, you can jump between the source code and test file via command `:A`

![jump-test](https://img.spacevim.org/46322905-12b57300-c61e-11e8-81a2-53c69d10140f.gif)

### Code running

Base on JavaUnite, you can use `SPC l r c` to run current function or use `SPC l r m` to run the main function of current Class.

![run-main](https://img.spacevim.org/46323137-61174180-c61f-11e8-94df-61b6998b8907.gif)

### Code formatting

Code formatting is provided by `format` layer, which is loaded by default.
The default format engine is `neoformat`, it will run google's [java formatter](https://github.com/google/google-java-format)
asynchronously. The key binding for formatting current file is `SPC b f`.
To use this feature, you need to download the google's java formatter jar, and set the
path of this jar file in layer option.

```toml
[[layers]]
  name = 'lang#java'
  java_formatter_jar = 'path/to/google-java-format.jar'
```

![format-java](https://img.spacevim.org/46323426-ccadde80-c620-11e8-9726-d99025f3bf76.gif)

### REPL

you need to install jdk9 which provide a build-in tools `jshell`, and SpaceVim use the `jshell` as default inferior REPL process:

![REPl-JAVA](https://img.spacevim.org/34159605-758461ba-e48f-11e7-873c-fc358ce59a42.gif)
