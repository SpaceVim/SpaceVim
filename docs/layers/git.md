---
title: "SpaceVim git layer"
description: "This layer adds extensive support for git"
---

# [Available Layers](../) >> git

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
- [Omnifunc of commit message](#omnifunc-of-commit-message)

<!-- vim-markdown-toc -->

## Description

This layer adds extensive support for [git](https://git-scm.com/).

## Install

To use this configuration layer, add the following snippet to your custom configuration file (`SPC f v d`).

```toml
[[layers]]
  name = "git"
```

## Layer options

- `git_plugin`: default value is `git`, available values include: [`gina`](https://github.com/lambdalisue/gina.vim), [`fugitive`](https://github.com/tpope/vim-fugitive), [`gita`](https://github.com/lambdalisue/vim-gita) (obsolete), `git`.

if you want to use `fugitive` instead:

```toml
[[layers]]
  name = "git"
  git_plugin = 'fugitive'
```

## Key bindings

| Key Binding | Description            |
| ----------- | ---------------------- |
| `SPC g s`   | view git status        |
| `SPC g S`   | stage current file     |
| `SPC g U`   | unstage current file   |
| `SPC g c`   | edit git commit        |
| `SPC g p`   | git push               |
| `SPC g m`   | git branch manager     |
| `SPC g r`   | git remote manager     |
| `SPC g d`   | view git diff          |
| `SPC g A`   | stage all files        |
| `SPC g b`   | open git blame windows |
| `SPC g h a` | stage current hunk     |
| `SPC g h r` | undo cursor hunk       |
| `SPC g h v` | preview cursor hunk    |

**Key bindings in Git branch manager:**

| Key Binding | Description        |
| ----------- | ------------------ |
| `v`         | view log of branch |
| `Enter`     | checkout branch    |
| `dd`        | delete branch      |

## Omnifunc of commit message

This layer also provides omnifunc of commit message. The key binding is `ctrl-x_ctrl-o` in insert mode.

1. complete commit title prefix, `fix:`, `doc:` etc.
2. complete github issue list
3. complete co-author info
