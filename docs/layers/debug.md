---
title: "SpaceVim debug layer"
description: "This layer provide debug workflow support in SpaceVim"
---

# [Available Layers](../) >> debug

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provide a debug workflow for SpaceVim. All of the function is based on [vim-vebugger](https://github.com/idanarye/vim-vebugger).

## Install


To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "debug"
```

## Key bindings

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
