---
title: "SpaceVim git 模块"
description: "这一模块为 SpaceVim 提供了 Git 支持，根据当前 Vim 版本特性，选择 gina 或者 gita 作为默认的后台 Git 插件。"
lang: zh
---

# [可用模块](../) >> git

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)
- [Commit message 补全](#commit-message-补全)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了 [Git](https://git-scm.com/) 支持，根据当前 Vim 版本特性，选择 gina 或者 gita 作为默认的后台 Git 插件。

## 启用模块

默认情况下，这一模块并未启用，如果需要启用该模块，可在配置文件内加入：

```toml
[[layers]]
  name = "git"
```

## 模块选项

- `git_plugin`: 设置后台使用的 git 插件，默认为 `git`，除此之外，还可以设置成为：`gina`, `fugitive`, `gita`, `git`。

如果需要使用 `fugitive` 作为后台插件，可以使用：

```toml
[[layers]]
  name = "git"
  git_plugin = 'fugitive'
```

## 快捷键

| 快捷键      | 功能描述             |
| ----------- | -------------------- |
| `SPC g s`   | 打开 git status 窗口 |
| `SPC g S`   | stage 当前文件       |
| `SPC g U`   | unstage 当前文件     |
| `SPC g c`   | 打开 git commit 窗口 |
| `SPC g p`   | 执行 git push        |
| `SPC g m`   | git 分支管理         |
| `SPC g r`   | git remote 管理      |
| `SPC g d`   | 打开 git diff 窗口   |
| `SPC g A`   | git add 所有文件     |
| `SPC g b`   | 打开 git blame 窗口  |
| `SPC g h a` | stage current hunk   |
| `SPC g h r` | undo cursor hunk     |
| `SPC g h v` | preview cursor hunk  |

## Commit message 补全

在编辑 git commit message 时，可以使用快捷键 `ctrl-x_ctrl-o` 进行补全，可以补全：

1. 标题前缀, 如 `fix:`、`doc:` 等；
2. GitHub issue 列表；
3. 上一次使用分支的 author 信息，便于添加 co-author
