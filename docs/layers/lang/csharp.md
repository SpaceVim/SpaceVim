---
title: "SpaceVim lang#csharp layer"
description: "This layer is for csharp development"
---

# [Available Layers](../../) >> lang#csharp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [Layer](#layer)
  - [OmniSharp Server](#omnisharp-server)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for csharp development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#csharp"
  highlight_types = 0
```

When opening a cs file at first time, it will popup a window and ask whether install the OmniSharp
server or not, enter 'Y' to confirm.

If you choose "coc" as your auto completion engine, you must run ":CocInstall coc-omnisharp"
to install the extension.

## Key bindings

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l b`   | compile the project                              |
| `SPC l f`   | format current file                              |
| `SPC l d`   | show doc                                         |
| `SPC l e`   | rename symbol under cursor                       |
| `SPC l g g` | go to definition                                 |
| `SPC l g i` | find implementations                             |
| `SPC l g t` | find type                                        |
| `SPC l g s` | find symbols                                     |
| `SPC l g u` | find usages of symbol under cursor               |
| `SPC l g m` | find members in the current buffer               |
| `SPC l c f` | fix using                                        |
| `SPC l c a` | contextual code actions                          |
| `SPC l c c` | find all code errors/warnings for the current solution|
| `SPC l s r` | reload the solution                              |
| `SPC l s s` | start the OmniSharp server                       |
| `SPC l s S` | stop the OmniSharp server                        |

