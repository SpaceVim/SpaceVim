---
title: "SpaceVim chat layer"
description: "SpaceVim chatting layer provides chatting with weixin in vim."
---

# [Available Layers](../) >> chat


<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
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

## Key Mappings

`Alt + w` : open chatting buffer for weixin.
Note: The web-qq has stopped providing service.

within chatting buffer:

`Alt + Left/Right` : switch between buffers.
`Alt + 1-9` : jump to the specified channel.

for more mappings in chatting buffer, please read <kbd>:h vim-chat</kbd>.
