---
title: "SpaceVim floobits layer"
description: "This layer adds support for the peer programming tool floobits to SpaceVim."
---

# [Available Layers](../) >> floobits

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds support for the peer programming tool floobits to SpaceVim.

NOTE: This layer only support neovim.

## Features

- Adjust floobits configuration file in the root of a project.
- Creation of floobits workspaces and populating it with content.
- Highlight cursor position for all users in current workspace.
- Follow recent changes by other users

## Install

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
name = "floobits"
```

## Key bindings

| Key bindings | Discription                                               |
| ------------ | --------------------------------------------------------- |
| `SPC m f j`  | Join workspace                                            |
| `SPC m f t`  | Toggle follow mode                                        |
| `SPC m f s`  | Summon everyone in the workspace to your cursor position. |
