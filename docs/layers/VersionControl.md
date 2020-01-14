---
title: "SpaceVim VersionControl layer"
description: "This layers provides general version control feature for vim. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc…"
---

# [Available Layers](../) >> VersionControl

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

  This layer provides general function for version control. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc…

## Features

- Show a diff using Vim its sign column
- Show vcs info on statusline

## Install


To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "VersionControl"
```

## Layer options

`enable-gtm-status`: Enable diplaying time spent within SpaceVim's statusline. This feature need [gtm](https://github.com/git-time-metric/gtm) command to be installed.


## Key bindings

| Key Binding | Description                     |
| ----------- | ------------------------------- |
| `SPC g .`   | version control transient-state |

**Version Control Transient-state**

| Key Binding | Description                  |
| ----------- | ---------------------------- |
| `w`         | Stage file                   |
| `u`         | Unstage file                 |
| `n`         | next hunk                    |
| `N/p`       | previous hunk                |
| `t`         | toggle diff signs            |
| `l`         | Show repo log                |
| `D`         | Show diffs of unstaged hunks |
| `f`         | Fetch for repo with popup    |
| `F`         | Pull repo with popup         |
| `P`         | Push repo with popup         |
| `c`         | Commit with popup            |
| `C`         | Commit                       |

**Unimpaired bindings**

| Key Binding | Description                 |
| ----------- | --------------------------- |
| `[ c`       | Go to the previous vcs hunk |
| `] c`       | Go to the next vcs hunk     |
