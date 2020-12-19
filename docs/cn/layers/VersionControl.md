---
title: "SpaceVim VersionControl 模块"
description: "这一模块为 SpaceVim 提供了通用的代码版本控制支持，该模块支持 Git、Mercurial、Bazaar、SVN 等等多种后台工具。"
lang: zh
---

# [可用模块](../) >> VersionControl

<!-- vim-markdown-toc GFM -->

- [模块介绍](#模块介绍)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块介绍

这一模块为 SpaceVim 提供了通用的代码版本控制支持，该模块支持 Git、Mercurial、Bazaar、SVN 等等多种后台工具。
为 SpaceVim 提供如下特性：

- 在左侧栏显示代码改动标记
- 在状态栏显示 vcs 版本信息

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "VersionControl"
```
## 模块选项

`enable-gtm-status`: 在状态栏展示当前分支工作的时间，这一特性需要安装 [gtm](https://github.com/git-time-metric/gtm) 命令。

## 快捷键

| 快捷键    | 功能描述                   |
| --------- | -------------------------- |
| `SPC g .` | 打开版本控制临时快捷键菜单 |

**临时快捷键菜单**

| 快捷键 | 功能描述                     |
| -----  | ---------------------------- |
| `w`    | Stage 当前文件               |
| `u`    | Unstage 当前文件             |
| `n`    | 下一个 vcs hunk              |
| `N/p`  | 上一个 vcs hunk              |
| `t`    | 启用/禁用 diff signs         |
| `l`    | 显示仓库 log                 |
| `D`    | Show diffs of unstaged hunks |
| `f`    | Fetch for repo with popup    |
| `F`    | Pull repo with popup         |
| `P`    | Push repo with popup         |
| `c`    | Commit with popup            |
| `C`    | Commit                       |

**通用快捷键**

| 快捷键 | 功能描述            |
| ------ | ------------------- |
| `[ c`  | 跳至上一个 vcs hunk |
| `] c`  | 跳至下一个 vcs hunk |
