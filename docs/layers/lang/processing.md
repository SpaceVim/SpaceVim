---
title: "SpaceVim lang#processing layer"
description: "This layer is for working on Processing sketches. It provides sytnax checking and an app runner"
---

# [Available Layers](../../) >> lang#processing

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Code runner](#code-runner)

<!-- vim-markdown-toc -->

## Description

This layer is for working on Processing sketches.
It builds on top of the existing vim plugin [sophacles/vim-processing](https://github.com/sophacles/vim-processing).

## Features

- Syntax highlighting and indent
- Run sketches asynchonously

## Install

You will need to install the `processing-java` tool.
This is best done via the Processing IDE which can be obtained from the [processing website](https://processing.org/download/).
Once you have the IDE, you can select Tools -> install "processing-java".

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#processing"
```

## Key bindings

| Key bindings    | Descriptions                     |
| --------------- | -------------------------------- |
| `SPC l r`       | Run your sketch                  |

### Code runner

You can build and run your sketch with `SPC l r`.
The sketch to run is decided based on the directory of you current buffer.
Note that the sketch is run asynchonously, so you are free to continue editing while it is running.
