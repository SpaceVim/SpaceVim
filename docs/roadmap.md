---
title: "Roadmap"
description: "The roadmap and milestones define the project direction and priorities."
---

# [Home](../) >> Roadmap

The roadmap defines the project direction and priorities.

## Next

- `v2.4.0`
  - [ ] rewrite statusline plugin with lua

- `v2.3.0`
  - [x] new `job` api based on neovim luv.
  - [x] implement flygrep with lua.
    - [x] use new `job` api
  - [ ] rewrite git.vim with lua.
    - [x] `:Git add`
    - [x] `:Git clean`
    - [x] `:Git fetch`
    - [x] `:Git remote`
    - [x] `:Git reset`
    - [x] `:Git rm`
    - [x] `:Git mv`
    - [x] `:Git blame`
    - [x] `:Git cherry-pick`
    - [x] `:Git shortlog`
    - [x] `:Git tag`
    - [x] plugin log manager derived from SPC runtime logger
  - [x] rewrite code runner with lua
  - [x] rewrite task manager with lua
  - [x] rewrite repl plugin with lua
  - [x] rewrite scrollbar with lua
  - [x] rewrite leader guide with lua
  - [x] implement pastebin plugin with lua
  - [x] make `:A` command support toml configuration file
  - [x] add git remote manager
    - [x] make `<cr>` show git log
    - [x] update remote context when switch project
    - [x] use desc for project manager callback function
    - [ ] cache remote and branch info
    - [ ] cache info based on project root
    - [x] display root path
  - [x] implement `ctags#update` in lua
  - [x] register project function with description
  - [x] update todo list when switch project
  - [x] make `one` coloscheme support treesitter
  - [x] quit git log win when it is last win

## Completed

All completed releases can be viewed in [changelog](../development/#Changelog)
