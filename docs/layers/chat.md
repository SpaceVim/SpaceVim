---
title: "SpaceVim chat layer"
description: "SpaceVim chatting layer provides chatting with weixin in vim."
---

# [Available Layers](../) >> chat


<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key Mappings](#key-mappings)

<!-- vim-markdown-toc -->

## Description

SpaceVim chatting layer provides chatting feature in vim.

![vim-chat](https://user-images.githubusercontent.com/13142418/166000148-4cdbe294-7d61-40e1-b503-63c70ddaf592.png)

## Install

To use this configuration layer, add the following snippet to your custom configuration file.

```toml
[[layers]]
  name = "chat"
```

## Layer options

1. `gitter_token`: set the token to your gitter account.

## Key Mappings

The default key binding to open chat windows is `SPC a h`.

Whith the chat windows. The following key binding can be use:

- `Alt + Left/H`: switch to previous channel
- `Alt + Right/L`: switch to next channel
- `Ctrl-w`: delete characters until next space before cursor

for more mappings in chatting buffer, please read <kbd>:h vim-chat</kbd>.
