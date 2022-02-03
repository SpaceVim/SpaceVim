---
title: "SpaceVim debug layer"
description: "This layer provides debug workflow support in SpaceVim"
---

# [Available Layers](../) >> debug

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)
  - [Using vim-debug](#using-vim-debug)
  - [Using vimspector](#using-vimspector)

<!-- vim-markdown-toc -->

## Description

This layer provides debug workflow for SpaceVim. All of the functionality is based on [vim-vebugger](https://github.com/idanarye/vim-vebugger).

## Install

To use this configuration layer, add the following snippet to your custom configuration file.

```toml
[[layers]]
  name = "debug"
```

## Configuration

Vimspector can be used as the debugger by setting the configuration.

```toml
[[layers]]
  name = "debug"
  debugger_plugin = "vimspector"
```

## Key bindings

### Using vim-debug

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| `SPC d l`   | launch the debugger                      |
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

key bindings are too long? use `SPC d .` to open the debug transient state:

![Debug Transient State](https://user-images.githubusercontent.com/13142418/33996076-b03c05bc-e0a5-11e7-90fd-5f31e2703d7e.png)

### Using vimspector

| Key Binding | Description                           |
| ----------- | ------------------------------------- |
| `SPC d c`   | launch-or-continue-debugger           |
| `SPC d r`   | restart-debugger-with-the-same-config |
| `SPC d x`   | run-to-cursor                         |
| `SPC d p`   | pause-debugger                        |
| `SPC d b`   | toggle-line-breakpoint                |
| `SPC d B`   | clear-all-breakpoints                 |
| `SPC d o`   | step-over                             |
| `SPC d i`   | step-into-functions                   |
| `SPC d O`   | step-out-of-current-function          |
| `SPC d u`   | move-up-a-frame                       |
| `SPC d d`   | move-down-a-frame                     |
| `SPC d k`   | terminate-the-debugger                |
| `SPC d e`   | evaluate-cursor-symbol-or-selection   |

**Debug Transient State**

| Key Binding | Description                  |
| ----------- | ---------------------------- |
| `c`         | Continue execution           |
| `u`         | Move up a frame              |
| `d`         | Move down a frame            |
| `o`         | step over                    |
| `i`         | step into functions          |
| `O`         | step out of current function |
| `k`         | Terminates the debugger      |
