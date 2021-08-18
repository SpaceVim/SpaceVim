---
title: "SpaceVim lang#plantuml layer"
description: "This layer is for PlantUML development, provides syntax highlighting for PlantUML files."
---

# [Available Layers](../../) >> lang#plantuml

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Configuration](#configuration)
  - [Limitation](#limitation)

<!-- vim-markdown-toc -->

## Description

This layer is for PlantUML development.

## Features

- Syntax highlighting
- Inline previews

## Install

### Layer

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#plantuml"
```

## Configuration

When you want to see the picture which plantuml drew, you need to set
plantuml_jar_path. You also need to install [plantuml.jar](https://plantuml.com/download) on your system.
Then you give the path to `plantuml_jar_path`. see below.

This is just example.
```toml
 [[layers]]
  name = "lang#plantuml"
  plantuml_jar_path = "/usr/share/plantuml/plantuml.jar"
```

### Limitation

You can't do any opration While you preview the result of plantuml.
You write one more part of plantuml diagram, you can not see all
picures. You can see first one.
