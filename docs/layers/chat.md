---
title: "SpaceVim chat layer"
description: "SpaceVim chatting layer provide chatting with qq and weixin in vim."
---

# [Available Layers](../) >> chat


<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key Mappings](#key-mappings)

<!-- vim-markdown-toc -->

## Description

SpaceVim chatting layer provide chatting feature in vim.

## Install

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "chat"
```

## Key Mappings

`Alt + x` : open chatting buffer for qq.
`Alt + w` : open chatting buffer for weixin.

within chatting buffer:

`Alt + Left/Right` : switch between buffer.
`Alt + 1-9` : jump to specified channel.

for more mappings in chatting buffer, please read <kbd>:h vim-chat</kbd>.
