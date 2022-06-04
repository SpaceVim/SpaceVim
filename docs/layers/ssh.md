---
title: "SpaceVim ssh layer"
description: "This layer provides ssh support in SpaceVim"
---

# [Available Layers](../) >> ssh

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
- [Commands](#commands)

<!-- vim-markdown-toc -->

## Intro

This layer provides ssh connection support for SpaceVim.
By default this layer is not enabled.
To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "ssh"
```

## Layer options

- `ssh_port`: set the port of ssh server
- `ssh_address`: set the ip of ssh server
- `ssh_user`: set the user name of ssh server

Example:

```
[[layers]]
    name = 'ssh'
    ssh_command = 'D:\Programs\Git\usr\bin\ssh.exe'
    ssh_user = 'root'
    ssh_address = '192.168.1.10'
    ssh_port = '8097'
```

## Key bindings

| Key Binding | Description                 |
| ----------- | --------------------------- |
| `SPC S o`   | open ssh connection windows |

## Commands

- `:SSHCommand`: run comamnd in ssh client.

   for example:
   ```
   :SSHCommand nvim --version
   ```
