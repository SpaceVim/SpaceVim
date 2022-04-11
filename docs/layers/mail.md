---
title: "SpaceVim mail layer"
description: "mail layer provides basic mail client for SpaceVim."
---

# [Available Layers](../) >> mail

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer options](#layer-options)
- [Key Mappings](#key-mappings)

<!-- vim-markdown-toc -->

## Description

The `mail` layer provides basic function to connected to mail server.
To use this configuration layer, add the following snippet to your custom configuration file.

```toml
[[layers]]
  name = "mail"
```

## Layer options

1. `imap_host`: set the imap server host
2. `imap_port`: set the imap server port
3. `imap_login`: set the login of imap server
4. `imap_password`: set the password of imap server

## Key Mappings

| Key Bingding | Description      |
| ------------ | ---------------- |
| `SPC a m`    | open mail client |
