---
title: "SpaceVim golang layer"
description: "This layer is for golang development. It also provides additional language-specific key mappings."
---

# [SpaceVim Layers:](https://spacevim.org/layers) golang

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for golang development. It also provides additional language-specific key mappings.

## Install

To use this configuration layer, add `SPLayer 'lang#go` to your custom configuration file.

## Key bindings

<<<<<<< HEAD
**Import key bindings:**

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| SPC l i     | go implements							               |
| SPC l f     | go info									                 |
| SPC l e     | go rename								                 |
| SPC l r     | go run									                 |
| SPC l b     | go build								                 |
| SPC l t     | go test									                 |
| SPC l d     | go doc									                 |
| SPC l v     | go doc vertical							             |
| SPC l c     | go coverage								               |

**Code formatting:**

the default key bindings for format current buffer is `SPC b f`. and this key bindings is defined in [format layer](<>). you can also use `g=` to indent current buffer.

To make neoformat support java file, you should install uncrustify. or
download [google's formater jar](https://github.com/google/google-java-format)
and add `let g:spacevim_layer_lang_java_formatter = 'path/to/google-java-format.jar'`
to SpaceVim custom configuration file.
=======
| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| `SPC d l`   | launching debugger                       |
| `SPC d c`   | Continue the execution                   |
| `SPC d b`   | Toggle a breakpoint for the current line |
| `SPC d B`   | Clear all breakpoints                    |
| `SPC d o`   | step over                                |
| `SPC d i`   | step into functions                      |
| `SPC d O`   | step out of current function             |
| `SPC d e s` | Evaluate and print the selected text     |
| `SPC d e e` | Evaluate the `<cword>` under the cursor  |
| `SPC d e S` | Execute the selected text                |
| `SPC d k`   | Terminates the debugger                  |

**Debug Transient State**

key bindings is too long? use `SPC d .` to open the debug transient state:

![Debug Transient State](https://user-images.githubusercontent.com/13142418/33996076-b03c05bc-e0a5-11e7-90fd-5f31e2703d7e.png)
>>>>>>> 36178d7c98ab1fbcaeb36e048dc5b84b8c41680c
