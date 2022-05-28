---
title: "SpaceVim lang#ruby layer"
description: "This layer is for Ruby development, provides autocompletion, syntax checking and code formatting for Ruby files."
---

# [Available Layers](../../) >> lang#ruby

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [Layer](#layer)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Ruby development. Including following features:

- code completion for ruby, requires `+ruby`
- syntax highlight
- syntax linter
- language server protocol

## Install

### Layer

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#ruby"
```

The default syntax linter for ruby is [rubylint](https://gitlab.com/yorickpeterse/ruby-lint).

```
gem install ruby-lint
```

The default code formatter is [rubocop](https://github.com/bbatsov/rubocop).

```
gem install rubocop
```

## Layer options

- `ruby_file_head`: Default file head when a new file is created.

  By default, when create a new ruby file, SpaceVim will insert the file head automatically.
  to change the file head, use the `ruby_file_head` option:

  ```toml
  [[layers]]
    name = "lang#ruby"
    ruby_file_head = [
        '#!/usr/bin/ruby -w',
        '# -*- coding: utf-8 -*-',
        '',
        ''
    ]
  ```

- `repl_command`: Set the REPL command for ruby.

  ```toml
  [[layers]]
    name = 'lang#ruby'
    repl_command = '~/download/bin/ruby_repl'
  ```

- `format_on_save`: Enable/disable code formatting when saving ruby file. Default is `false`.
  To enable this feature:

  ```toml
  [[layers]]
      name = 'lang#ruby'
      format_on_save = true
  ```

- `enabled_linters`: Set the default linters for ruby language, by default it is `['rubylint']`. You can change
  it to `['rubylint, 'rubocop']`.
  ```toml
  [[layers]]
    name = 'lang#ruby'
    enabled_linters = ['rubylint', 'rubocop']
  ```

## Key bindings

### Inferior REPL process

Start a `irb` inferior REPL process with `SPC l s i`.
You may change the REPL command by layer option `repl_command`.
For example, if you want to use `pry`, load this layer via:

```toml
[[layers]]
    name = "lang#ruby"
    repl_command = "pry"
```

however, if the executable is not on your $PATH, then you need to specify a complete file path.

```toml
[[layers]]
    name = "lang#ruby"
    repl_command = "/path/to/pry"
```

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To run a Ruby script, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.
