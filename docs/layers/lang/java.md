---
title: "SpaceVim lang#java layer"
description: "This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer."
---

# [Available Layers](../../) >> lang#java

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Feature](#feature)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Import key bindings](#import-key-bindings)
  - [Generate key bindings](#generate-key-bindings)
  - [Code formatting](#code-formatting)
  - [Maven support](#maven-support)
  - [Gradle support](#gradle-support)
  - [Code runner](#code-runner)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Java development.

## Feature

- code completion: `autocomplete` layer
- code formatting: `format` layer
- refactoring
- syntax checking: `checkers` layer
- REPL(requires `jshell`)
- code runner
- debug: check out the `debug` layer

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#java"
```

## Layer options

- `format_on_save`: Enable/disabled code formatting when saving current file.
  The default value is `false`. To enable this feature:
  ```toml
  [[layers]]
    name = 'lang#java'
    format_on_save = true
  ```
- `java_formatter_jar`: Set the full path of [google's formater jar](https://github.com/google/google-java-format).
  ```toml
  [[layers]]
    name = 'lang#java'
    java_formatter_jar = 'path/to/google-java-format.jar'
  ```
- `java_file_head`: The default file header for new java file. by default it is:
  ```toml
  [[layers]]
    name = 'lang#java'
    java_file_head = [
      '/**',
      ' * @author : `fnamemodify(expand("~"), ":t")`',
      ' * @created : `strftime("%Y-%m-%d")`',
      '**/',
      ''
    ]
  ```

## Key bindings

### Import key bindings

| Key Bindings        | Descriptions                    |
| ------------------- | ------------------------------- |
| `SPC l I`           | Import missing classes          |
| `SPC l R`           | Remove unused classes           |
| `SPC l i`           | smart import class under cursor |
| `Ctrl-j I` (Insert) | Import missing classes          |
| `Ctrl-j R` (Insert) | Remove unused classes           |
| `Ctrl-j i` (Insert) | smart import class under cursor |

### Generate key bindings

| Mode          | Key Bindings | Descriptions                          |
| ------------- | ------------ | ------------------------------------- |
| normal        | `SPC l g A`  | generate accessors                    |
| normal/visual | `SPC l g s`  | generate setter accessor              |
| normal/visual | `SPC l g g`  | generate getter accessor              |
| normal/visual | `SPC l g a`  | generate setter and getter accessor   |
| normal        | `SPC l g M`  | generate abstract methods             |
| insert        | `Ctrl-j s`   | generate setter accessor              |
| insert        | `Ctrl-j g`   | generate getter accessor              |
| insert        | `Ctrl-j a`   | generate getter and setter accessor   |
| normal        | `SPC l g t`  | generate toString function            |
| normal        | `SPC l g e`  | generate equals and hashcode function |
| normal        | `SPC l g c`  | generate constructor                  |
| normal        | `SPC l g C`  | generate default constructor          |

### Code formatting

The default formater of java language is [google's formater jar](https://github.com/google/google-java-format).
You need to download the jar and set the `java_formatter_jar` layer option.

The default key bindings for format current buffer is `SPC b f`.
And this key binding is defined in [`format`](../layers/format/) layer.
You can also use `g=` to indent current buffer.

### Maven support

| Key Bindings | Descriptions                   |
| ------------ | ------------------------------ |
| `SPC l m i`  | Run maven clean install        |
| `SPC l m I`  | Run maven install              |
| `SPC l m p`  | Run one already goal from list |
| `SPC l m r`  | Run maven goals                |
| `SPC l m R`  | Run one maven goal             |
| `SPC l m t`  | Run maven test                 |

### Gradle support

| Key Bindings | Descriptions       |
| ------------ | ------------------ |
| `SPC l a b`  | gradle build       |
| `SPC l a B`  | gradle clean build |
| `SPC l a r`  | gradle run         |
| `SPC l a t`  | gradle test        |

### Code runner

| Key bindings | Descriptions                    |
| ------------ | ------------------------------- |
| `SPC l r m`  | run main method of current file |
| `SPC l r m`  | run current method              |
| `SPC l r t`  | run all test methods            |

### Inferior REPL process

Start a `jshell` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
