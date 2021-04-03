---
title: "SpaceVim lang#ruby layer"
description: "This layer is for Ruby development, provide autocompletion, syntax checking, code format for Ruby file."
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

This layer is for Ruby development.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#ruby"
```

The default syntax linter for ruby is [rubylint](https://gitlab.com/yorickpeterse/ruby-lint).

```
gem install ruby-lint
```

The default code formatter is [rubocop](https://github.com/bbatsov/rubocop).

```sh
gem install rubocop
```

## Layer options

- `ruby_file_head`: Default file head when create new ruby file.

  By default, when create a new ruby file, SpaceVim will insert file head automatically.
  to change the file head, use `ruby_file_head` option:

  ```toml
  [[layers]]
    name = "lang#python"
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

To running a Ruby script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
