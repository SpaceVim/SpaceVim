---
title: "Use Vim as a Nim IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/95338841-f07a1e00-08e5-11eb-9e1b-6dbc5c4ad7de.png
description: "A general guide for using SpaceVim as Nim IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Nim IDE"
---

# [Blogs](../blog/) >> Use Vim as a Nim IDE

This is a general guide for using SpaceVim as a Nim IDE, including layer configuration and usage. 
Each of the following sections will be covered:

![nim-ide](https://user-images.githubusercontent.com/13142418/95338841-f07a1e00-08e5-11eb-9e1b-6dbc5c4ad7de.png)

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [code completion](#code-completion)
- [alternate file jumping](#alternate-file-jumping)
- [code running](#code-running)
- [REPL support](#repl-support)
- [code format](#code-format)
- [Tasks manage](#tasks-manage)

<!-- vim-markdown-toc -->

### Enable language layer

`lang#nim` layer provides nim language specific features for SpaceVim.
This layer is not enabled by default. To write nim language,
you need to enable the `lang#nim` layer.
Press `SPC f v d` to open SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = 'lang#nim'
```

for more info, you can read the [lang#nim](../layers/lang/nim/) layer documentation.

### code completion

By default the autocomplete layer has been enabled, so after loading `lang#nim` layer, the code completion
for nim language should work well.


### alternate file jumping

To manage the alternate file for a project, you may need to create a `.project_alt.json` file in the root of your
project.

for example, add following content into the `.project_alt.json` file:

```json
{
  "src/*.nim": {"alternate": "test/{}.nim"},
  "test/*.nim": {"alternate": "src/{}.nim"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`


### code running

The key binding for running current file is `SPC l r `, it will run `nim c -r current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![nim-runner](https://user-images.githubusercontent.com/13142418/95334765-1a7d1180-08e1-11eb-8c78-9a87d61d3d63.png)

### REPL support

![nim-repl](https://user-images.githubusercontent.com/13142418/95341519-f1f91580-08e8-11eb-9280-04f89875dc78.png)

`lang#nim` layer provides key bindings for REPL support of nim language.
You can Start a `nim` inferior REPL process with `SPC l s i`. After REPL process started,
you can send code to `nim` process via key bindings:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


### code format

The `format` layer use neoformat as default tool to format code, it will run `cljfmt` on current file.
And the default key binding is `SPC b f`.

```toml
[[layers]]
  name = "format"
```

### Tasks manage

SpaceVim will detect [`lein`](https://leiningen.org/) project tasks automatically. If there is `project.clj` file in the root directory
of your project. following tasks will be detected:

![taskmanager](https://user-images.githubusercontent.com/13142418/95338987-1a334500-08e6-11eb-80c4-ad811095d8c8.png)

To select a tast to run, use key binding `SPC p t r`, you can also use `SPC p t l` to list all the tasks
in the tasks manager window.

