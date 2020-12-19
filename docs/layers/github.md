---
title: "SpaceVim github layer"
description: "This layer provides GitHub integration for SpaceVim"
---

# [Available Layers](../) >> github

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)
- [Extra configuration for GitHub and Gist](#extra-configuration-for-github-and-gist)

<!-- vim-markdown-toc -->

## Description

This layer provides GitHub integration for SpaceVim.

## Install

To use this configuration layer, add the following snippet to your custom configuration file.

```toml
[[layers]]
  name = "github"
```

## Key bindings

| Key Binding | Description                  |
| ----------- | ---------------------------- |
| `SPC g h i` | show issues                  |
| `SPC g h a` | show activities              |
| `SPC g h d` | show dashboard               |
| `SPC g h f` | show current file in browser |
| `SPC g h I` | show issues in browser       |
| `SPC g h p` | show PRs in browser          |
| `SPC g g l` | list all gist                |
| `SPC g g p` | post gist                    |

## Extra configuration for GitHub and Gist

To avoid needing to constantly input your username and password, you'll want to create the following [Bootstrap Function](https://spacevim.org/documentation/#bootstrap-functions) in a file such as .SpaceVim.d/autoload/myspacevim.vim.

```vim
func! myspacevim#before() abort
  "other configs
  let g:github_dashboard = { 'username': 'yourgithubuser', 'password': $GITHUB_TOKEN }
  let g:gista#client#default_username = 'monkeyxite'
endf
```
We recommend generating a [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) and storing it securely in an environment variable. [Refer to github dashboard](https://github.com/junegunn/vim-github-dashboard) for more information.
```shell
# in some secure file sourced in your .bashrc, .bash_profile, .zshrc, etc.
export GITHUB_TOKEN="<your 40 char token>"
```
