---
title: "SpaceVim lang#typescript layer"
description: "This layer is for TypeScript development"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#typescript

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
- [Features](#features)
- [Layer configuration](#layer-configuration)

<!-- vim-markdown-toc -->

## Description

This layer is for TypeScript development.

## Layer Installation

To use this configuration layer, add `call SpaceVim#layers#load('lang#typescript')` to your custom configuration file. BTW, you need to install TypeScript via:

```sh
npm install -g typescript
```

## Features

- auto-completion
- syntax checking
- viewing documentation
- type-signature
- goto definition
- refernce finder

## Layer configuration

`typescript_server_path`: set the path of the tsserver.
