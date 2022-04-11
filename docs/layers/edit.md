---
title: "SpaceVim edit layer"
description: "Improve code edit experience in SpaceVim, provides more text objects."
---

# [Available Layers](../) >> edit

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Options](#options)

<!-- vim-markdown-toc -->

## Description

This layer provides many edit key bindings for SpaceVim, and also provides more text objects.

## Features

- change surround symbol via vim-surround
- repeat last action via vim-repeat
- multiple cursors
- align
- set justification for paragraph
- highlight whitespace at the end of a line
- load editorconfig config, need `+python` or `+python3`

## Options

- `textobj`: specified a list of text objects to be enabled, the avaliable list is :`indent`, `line`, `entire`
- `autosave_timeout`: set the timeoutlen of autosave plugin. By default it
  is 0. And autosave is disabled. timeoutlen must be given in millisecods and
  can't be > 100\*60\*1000 (100 minutes) or < 1000 (1 second). For example,
  setup timer with 5 minutes:
  ```
  [[layers]]
    name = 'edit'
    autosave_timeout = 300000
  ```
- `autosave_events`: set the events on which autosave will perform a save.
  This option is an empty list by default. you can trigger saving based
  on vim's events, for example:
  ```
  [[layers]]
    name = 'edit'
    autosave_events = ['InsertLeave', 'TextChanged']
  ```
- `autosave_all_buffers`: By default autosave plugin only save current buffer.
  If you want to save all buffers automatically. Set this option to `true`.
  ```
  [[layers]]
    name = 'edit'
    autosave_all_buffers = true
  ```
