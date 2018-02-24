---
title: "SpaceVim lang#csharp layer"
description: "This layer is for csharp development"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#csharp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Installation](#installation)
  - [Layer](#layer)
  - [OmniSharp Server](#omnisharp-server)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for csharp development.

## Installation

### Layer

To use this configuration layer, add `SPLayer 'lang#csharp'` to your custom configuration file.

### OmniSharp Server

You must build the *OmniSharp Server* before using this layer's features.

After all plugins installed, *cd* to the directory `$SPACEVIM_PLUGIN_BUNDLE_DIR/repos/github.com/OmniSharp/omnisharp-vim/server` (by default `$HOME/.cache/vimfiles/repos/github.com/OmniSharp/omnisharp-vim/server`, and then run

```
xbuild
```
for macOS and linux, or

```
msbuild
```
for Windows.

For more information, please read this [link](https://github.com/OmniSharp/omnisharp-vim#installation).


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
| `SPC l s r` | reload the solution                              |
| `SPC l s s` | start the OmniSharp server                       |
| `SPC l s S` | stop the OmniSharp server                        |

