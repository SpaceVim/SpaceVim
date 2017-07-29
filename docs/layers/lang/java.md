---
title: "SpaceVim lang#java layer"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#java

<!-- vim-markdown-toc GFM -->
* [Description](#description)
* [Layer Installation](#layer-installation)
* [Key bindings](#key-bindings)
    * [Java language specified key bindings](#java-language-specified-key-bindings)
        * [Maven](#maven)
        * [Jump](#jump)
    * [Problems buffer](#problems-buffer)
    * [Project buffer](#project-buffer)

<!-- vim-markdown-toc -->

## Description

This layer is for Java development.

## Layer Installation

To use this configuration layer, add `SPLayer 'lang#java'` to your custom configuration file.

## Key bindings

### Java language specified key bindings

**Import key bindings:**

| Key Binding          | Description                     |
| -------------------- | ------------------------------- |
| `F4` (Insert/Normal) | Import class under cursor       |
| `SPC l I`            | Import missing classes          |
| `SPC l R`            | Remove unused classes           |
| `SPC l i`            | smart import class under cursor |
| `<C-j>I` (Insert)    | Import missing classes          |
| `<C-j>R` (Insert)    | Remove unused classes           |
| `<C-j>i` (Insert)    | smart import class under cursor |

**Generate key bindings:**

| Mode          | Key Binding | Description                           |
| ------------- | ----------- | ------------------------------------- |
| normal        | `SPC l A`   | generate accessors                    |
| normal/visual | `SPC l s`   | generate setter accessor              |
| normal/visual | `SPC l g`   | generate getter accessor              |
| normal/visual | `SPC l a`   | generate setter and getter accessor   |
| normal        | `SPC l M`   | generate abstract methods             |
| insert        | `<c-j>s`    | generate setter accessor              |
| insert        | `<c-j>g`    | generate getter accessor              |
| insert        | `<c-j>a`    | generate getter and setter accessor   |
| normal        | `SPC l ts`  | generate toString function            |
| normal        | `SPC l eq`  | generate equals and hashcode function |
| normal        | `SPC l c`   | generate constructor                  |
| normal        | `SPC l C`   | generate default constructor          |

**Code formatting:**

the default key bindings for format current buffer is `SPC b f`. and this key bindings is defined in [format layer](<>). you can also use `g=` to indent current buffer.

To make neoformat support java file, you should install uncrustify. or
download [google's formater jar](https://github.com/google/google-java-format)
and add `let g:spacevim_layer_lang_java_formatter = 'path/to/google-java-format.jar'`
to SpaceVim custom configuration file.

#### Maven

| Key Binding | Description                    |
| ----------- | ------------------------------ |
| `SPC l m i` | Run maven clean install        |
| `SPC l m I` | Run maven install              |
| `SPC l m p` | Run one already goal from list |
| `SPC l m r` | Run maven goals                |
| `SPC l m R` | Run one maven goal             |
| `SPC l m t` | Run maven test                 |

#### Jump

| Key Binding | Description            |
| ----------- | ---------------------- |
| `SPC l j a` | jump to alternate file |

### Problems buffer

### Project buffer
