---
title: "Use Vim as a Elixir IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/90253911-80669300-de74-11ea-9786-4b97a4091bc6.png
description: "A general guide for using SpaceVim as Elixir IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Elixir IDE"
---

# [Blogs](../blog/) >> Use Vim as a Elixir IDE

This is a general guide for using SpaceVim as a Elixir IDE, including layer configuration and usage. 
Each of the following sections will be covered:

![elixir-ide](https://user-images.githubusercontent.com/13142418/90253911-80669300-de74-11ea-9786-4b97a4091bc6.png)

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Code formatting](#code-formatting)
- [Syntax lint](#syntax-lint)
- [code running](#code-running)
- [REPL support](#repl-support)
- [Jump to test file](#jump-to-test-file)
- [Task manager](#task-manager)

<!-- vim-markdown-toc -->


### Enable language layer

To add elixir language support in SpaceVim, you need to enable the `lang#elixir` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#elixir"
```

for more info, you can read the [lang#elixir](../layers/lang/elixir/) layer documentation.

### Code completion

The [autocomplete](../layers/autocomplete/) layer is enabled by default.

### Code formatting

Code formatting is provided by [format](../layers/format/) layer. The default key binding is `SPC b f`.
It will run `mix format current_file`. To enable code formatting feature for elixir, you need to load the format layer.

```toml
[[layers]]
  name = "format"
```

### Syntax lint

Syntax lint is provided by [checkers](../layers/checkers/) layer. Error will be displayed in quickfix window
after saving current file. This layer is enabled by default.

### code running

The default code running key binding is `SPC l r`. It will run `elixir current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![elixir-code-runner](https://user-images.githubusercontent.com/13142418/90252211-accce000-de71-11ea-8a93-3f07e9cc2b69.png)

### REPL support

Start a `elixir` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.


![elixir-repl](https://user-images.githubusercontent.com/13142418/90252532-409eac00-de72-11ea-992e-8f0b678bdc51.png)


### Jump to test file

SpaceVim use vim-project to manager the files in a project,
you can add a `.projections.json` to the root of your project with following content:

```json
{
  "lib/*.ex": {"alternate": "test/{}.exs"},
  "test/*.exs": {"alternate": "lib/{}.ex"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`

### Task manager

To manage the task of elixir project, you need to create a task configuration file: `.SpaceVim.d/task.toml`.

For example:

```toml
[mix-test]
    command = 'mix'
    args = ['test']
[mix-coveralls]
    command = 'mix'
    args = ['coveralls']
```

For more information about the task manager plugin, checkout the [task documentation](../documentation/#tasks).
