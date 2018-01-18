---
title: "SpaceVim lang#html layer"
description: "This layer is for html development"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#html

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
  - [Language server](#language-server)
- [Features](#features)

<!-- vim-markdown-toc -->

## Description

This layer is for html development.

## Layer Installation

To use this configuration layer, add `call SpaceVim#layers#load('lang#html')` to your custom configuration file.

### Language server

To install the language server, you need `npm` on your machine:

```bash
npm install --global vscode-html-languageserver-bin
```

## Features

- auto-completion
- syntax checking
- goto definition
- refernce finder
- language server protocol (need lsp layer) 
