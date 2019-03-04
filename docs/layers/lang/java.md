---
title: "SpaceVim lang#java layer"
description: "This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer."
---

# [Available Layers](../../) >> lang#java

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Feature](#feature)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Import key bindings](#import-key-bindings)
  - [Generate key bindings](#generate-key-bindings)
  - [Code formatting](#code-formatting)
  - [Maven](#maven)
  - [Jump](#jump)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Java development.

## Feature

- code completion: `autocomplete` layer
- code formatting
- refactoring
- syntax checking: `checkers` layer
- REPL(need java8's jshell)
- debug: check out the `debug` layer

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#java"
```

## Key bindings

### Import key bindings

| Key Bindings         | Descriptions                    |
| -------------------- | ------------------------------- |
| `<F4>` (Insert/Normal) | Import class under cursor       |
| `SPC l I`            | Import missing classes          |
| `SPC l R`            | Remove unused classes           |
| `SPC l i`            | smart import class under cursor |
| `Ctrl-j I` (Insert)  | Import missing classes          |
| `Ctrl-j R` (Insert)  | Remove unused classes           |
| `Ctrl-j i` (Insert)  | smart import class under cursor |

### Generate key bindings

| Mode          | Key Bindings | Descriptions                          |
| ------------- | ------------ | ------------------------------------- |
| normal        | `SPC l g A`  | generate accessors                    |
| normal/visual | `SPC l g s`  | generate setter accessor              |
| normal/visual | `SPC l g g`  | generate getter accessor              |
| normal/visual | `SPC l g a`  | generate setter and getter accessor   |
| normal        | `SPC l g M`  | generate abstract methods             |
| insert        | `Ctrl-j s`     | generate setter accessor              |
| insert        | `Ctrl-j g`     | generate getter accessor              |
| insert        | `Ctrl-j a`     | generate getter and setter accessor   |
| normal        | `SPC l g t`  | generate toString function            |
| normal        | `SPC l g e`  | generate equals and hashcode function |
| normal        | `SPC l g c`  | generate constructor                  |
| normal        | `SPC l g C`  | generate default constructor          |

### Code formatting

The default key bindings for format current buffer is `SPC b f`. And this key binding is defined in [format layer](<>). You can also use `g=` to indent current buffer.

To make neoformat support Java file, you should install uncrustify.
Or download [google's formater jar](https://github.com/google/google-java-format)
and add `let g:spacevim_layer_lang_java_formatter = 'path/to/google-java-format.jar'`
to SpaceVim custom configuration file.

### Maven

| Key Bindings | Descriptions                   |
| ------------ | ------------------------------ |
| `SPC l m i`  | Run maven clean install        |
| `SPC l m I`  | Run maven install              |
| `SPC l m p`  | Run one already goal from list |
| `SPC l m r`  | Run maven goals                |
| `SPC l m R`  | Run one maven goal             |
| `SPC l m t`  | Run maven test                 |

### Jump

| Key Bindings | Descriptions           |
| ------------ | ---------------------- |
| `SPC l j a`  | jump to alternate file |

### Inferior REPL process

Start a `jshell` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
