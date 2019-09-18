---
title: "SpaceVim core#statusline layer"
description: "This layer provides default statusline for SpaceVim"
---

# [Available Layers](../) >> core#statusline

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)

<!-- vim-markdown-toc -->

### Description

This layer provides a heavily customized powerline with the following capabilities:

- show the window number
- show the current mode
- color code for current state
- show the index of searching result
- toggle syntax checking info
- toggle battery info
- toggle minor mode lighters
- show VCS information (branch, hunk summary) (need `git` and `VersionControl` layer)

### Install

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "core#statusline"
```

### Configuration

Here is a list of SpaceVim options for statusline, these are different from layer options:

```toml
[options]
    # options for statusline
    # Set the statusline separators of statusline, default is "arrow"
    statusline_separator = "arrow"
    # Set the statusline separators of inactive statusline
    statusline_inactive_separator = "bar"

    # Set SpaceVim buffer index type
    buffer_index_type = 4
    # 0: 1 ➛ ➊
    # 1: 1 ➛ ➀
    # 2: 1 ➛ ⓵
    # 3: 1 ➛ ¹
    # 4: 1 ➛ 1

    # Enable/Disable show mode on statusline
    enable_statusline_mode = true

    # left sections of statusline
    statusline_left_sections = [
       'winnr',
       'major mode',
       'filename',
       'fileformat',
       'minor mode lighters',
       'version control info',
       'search status'
    ]
    # right sections of statusline
    statusline_right_sections = [
       'cursorpos',
       'percentage',
       'input method',
       'date',
       'time'
    ]

    # 'winnr' window number
    # 'syntax checking'
    # 'filename' file name
    # 'fileformat' file format
    # 'major mode'
    # 'minor mode lighters'
    # 'cursorpos' cursor position
    # 'percentage' content range
    # 'date' date
    # 'time' time
    # 'whitespace' line number with trailing space at the end
    # 'battery status' battery status
    # 'input method' input method
    # 'search status' search index
```

All statusline key bindings can be find on [SpaceVim documentation](../../../documentation/#statusline)
