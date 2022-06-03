---
title: "SpaceVim ssh 模块"
description: "ssh 模块为 SpaceVim 提供了一个简易的 ssh 客户端"
lang: zh
---

# [可用模块](../) >> ssh

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

`ssh` 模块为 SpaceVim 提供了一个简易的 ssh 客户端。
默认情况下，该模块未启用。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "ssh"
```

## 模块选项

- `ssh_port`: 设置服务器的 ssh 端口
- `ssh_address`: 设置服务器的地址或者 ip
- `ssh_user`: 设置默认的用户名

示例：

```
[[layers]]
    name = 'ssh'
    ssh_command = 'D:\Programs\Git\usr\bin\ssh.exe'
    ssh_user = 'root'
    ssh_address = '192.168.1.10'
    ssh_port = '8097'
```

## 快捷键

| 快捷键    | 功能描述      |
| --------- | ------------- |
| `SPC S o` | 打开 ssh 窗口 |
