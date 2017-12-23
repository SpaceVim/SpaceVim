---
title: "SpaceVim lang#php layer"
description: "This layer adds PHP language support to SpaceVim"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#php

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Layer Installation](#layer-installation)
  - [Requirement](#requirement)

<!-- vim-markdown-toc -->

## Description

This layer adds PHP language support to SpaceVim.

## Features

- auto-completion
- syntax checking
- goto definition
- refernce finder
- lsp support (require [lsp](https://spacevim.org/layers/language-server-protocol/) layer)

## Layer Installation

To use this configuration layer, add `call SpaceVim#layers#load('lang#php')` to your custom configuration file.

### Requirement

1.  [PHP 5.3+](http://php.net/)
2.  [PCNTL](http://php.net/manual/en/book.pcntl.php) Extension
3.  [Msgpack 0.5.7+(for NeoVim)](https://github.com/msgpack/msgpack-php) Extension or [JSON(for Vim 7.4+)](http://php.net/manual/en/intro.json.php) Extension
4.  [Composer](https://getcomposer.org/) Project

