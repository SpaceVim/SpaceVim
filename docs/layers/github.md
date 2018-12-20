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

To use this configuration layer, add following snippet to your custom configuration file.

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

For avoid repeating input the account name and passwrod, you need to add the belowing contennt for auto .SpaceVim.d/autoload/myspacevim.vim [Bootstrap Functions](https://spacevim.org/documentation/#bootstrap-functions). 

```vim
func! myspacevim#before() abort
  "other configs
  let g:github_dashboard = { 'username': 'yourgithubuser', 'password': $GITHUB_TOKEN }
  let g:gista#client#default_username = 'monkeyxite'
endf
```
Refer [github dashboar](https://github.com/junegunn/vim-github-dashboard), for security concerns you could create a Personal Access Token, export it as an environment variable and use it as a password.
```shell
# in some secure file sourced in your .bashrc, .bash_profile, .zshrc, etc.
export GITHUB_TOKEN="<your 40 char token>"
```
