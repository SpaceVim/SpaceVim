---
title: "Use Vim as a Scala IDE"
categories: [tutorials, blog]
description: "A general guide for using SpaceVim as Scala IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Scala IDE"
---

# [Blogs](../blog/) >> Use Vim as a Scala IDE

This is a general guide for using SpaceVim as a Scala IDE, including layer configuration and usage.
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Setup Scala development environment](#setup-scala-development-environment)
- [Enable language layer](#enable-language-layer)
- [code completion](#code-completion)
- [alternate file jumping](#alternate-file-jumping)
- [code running](#code-running)
- [REPL support](#repl-support)
- [code format](#code-format)

<!-- vim-markdown-toc -->

### Setup Scala development environment

Make sure you have scala installed in your os.
If you are using windows, you can install scala and coursier via:

```
scoop install scala coursier
```

If you want to use `lsp` layer, you need to install the language server for scala:

```
coursier install metals
```

### Enable language layer

`lang#scala` layer provides scala language specific features for SpaceVim.
This layer is not enabled by default. To write scala language,
you need to enable the `lang#scala` layer.
Press `SPC f v d` to open SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = 'lang#scala'
```

for more info, you can read the [lang#scala](../layers/lang/scala/) layer documentation.

### code completion

By default the autocomplete layer has been enabled, so after loading `lang#scala` layer, the code completion
for scala language should work well.

### alternate file jumping

To manage the alternate file for a project, you may need to create a `.project_alt.json` file in the root of your
project.

for example, add following content into the `.project_alt.json` file:

```json
{
  "src/*.scala": { "alternate": "test/{}.scala" },
  "test/*.scala": { "alternate": "src/{}.scala" }
}
```

with this configuration, you can jump between the source code and test file via command `:A`

### code running

The key binding for running current file is `SPC l r `, it will run `sbt run` asynchronously.
And the stdout will be shown on a runner buffer.

### REPL support

Start a `scala` inferior REPL process with `SPC l s i`. After REPL process started,
you can send code to `scala` process via key bindings:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### code format


The code formation feature is provided by `format` layer, and this layer is enabled by default.
The default format engine is `neoformat`, it will run `scalafmt` or `scalariform`
asynchronously on current file.

To use `scalafmt`, you need to install it via:

```
coursier install scalafmt
```

If you want to use scalariform, you need to install [`scalariform`](https://github.com/scala-ide/scalariform).
and set `scalariform_jar` option to the path of the scalariform jar.
