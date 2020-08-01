---
title: "Mnemonic key bindings navigation"
categories: [feature, blog]
description: "Key bindings are organized using mnemonic prefixes like b for buffer, p for project, s for search, h for help, etc…"
image: https://user-images.githubusercontent.com/13142418/89091735-5de96a00-d3de-11ea-85e1-b0fc64537836.gif
commentsID: "Mnemonic key bindings navigation"
comments: true
---

# [Blogs](../blog/) >> Mnemonic key bindings navigation

You don't need to remember any key bindings, as a guide buffer is displayed each time the prefix key is pressed
in normal/visual mode. It lists the available key bindings and their short description.

The prefix can be `[SPC]`, `[Window]`, `<leader>`, when the guide is opened, you can
see the prefix on the statusline.

This will be shown in floating windows if your vim/neovim support this feature.

- vim: `8.1.1364`
- neovim: `v0.4.2`

![float_guide](https://user-images.githubusercontent.com/13142418/89091735-5de96a00-d3de-11ea-85e1-b0fc64537836.gif)

Otherwise, it will be displayed in split Window.

![mapping guide](https://user-images.githubusercontent.com/13142418/35568184-9a318082-058d-11e8-9d88-e0eafd1d498d.gif)

## default key binding prefixes

| Prefix name | custom option and default value                         | description                        |
| ----------- | ------------------------------------------------------- | ---------------------------------- |
| `[SPC]`     | NONE / `<Space>`                                        | default mapping prefix of SpaceVim |
| `[Window]`  | `g:spacevim_windows_leader` / `s`                       | window mapping prefix of SpaceVim  |
| `<leader>`  | `mapleader` / `\` | default leader prefix of vim/neovim |

By default the guide buffer will be displayed 1000ms after the key has been pressed. You can change the delay by setting `'timeoutlen'` option to your liking (the value is in milliseconds).

for example, after pressing `<Space>` in normal mode, you will see :

![mapping-guide](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

this guide show you all the available key bindings begin with `[SPC]`, you can type `b` for all the buffer mappings, `p` for project mappings, etc.

## Get paging and help info

after pressing `Ctrl-h` in guide buffer, you will get paging and help info in the statusline.

| keys | descriptions                  |
| ---- | ----------------------------- |
| `u`  | undo pressing                 |
| `n`  | next page of guide buffer     |
| `p`  | previous page of guide buffer |
