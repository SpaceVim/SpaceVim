---
title: SpaceVim release v1.5.0
categories: [changelog, blog]
description: "SpaceVim release v1.5.0 with four new language layers and floating window support."
type: article
image: https://img.spacevim.org/89103568-5ad59480-d445-11ea-9745-bd53e668b956.png
commentsID: "SpaceVim release v1.5.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.5.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New language layers](#new-language-layers)
  - [New APIs](#new-apis)
  - [New features](#new-features)
- [Changes](#changes)
- [Bug Fixs](#bug-fixs)
- [Doc&&Wiki](#docwiki)
- [Others](#others)

<!-- vim-markdown-toc -->


The last release is v1.4.0, After four months development.
The v1.5.0 has been released. So let's take a look at what happened since last relase.

![welcome-page](https://img.spacevim.org/89103568-5ad59480-d445-11ea-9745-bd53e668b956.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New language layers

Four programming language layers have been added since the last release:

- Add `lang#factor` layer [#2906](https://github.com/SpaceVim/SpaceVim/pull/2906)
- Add `lang#forth` layer [#2927](https://github.com/SpaceVim/SpaceVim/pull/2927)
- Add `lang#supoercollider` layer [#3092](https://github.com/SpaceVim/SpaceVim/pull/3092)
- Add `lang#fortran` layer [#3654](https://github.com/SpaceVim/SpaceVim/pull/3654)

### New APIs

- Add `notification` API [#3621](https://github.com/SpaceVim/SpaceVim/pull/3621)
- Add multiple notification support [#3624](https://github.com/SpaceVim/SpaceVim/pull/3624)
- Add `clock` api [#3595](https://github.com/SpaceVim/SpaceVim/pull/3595)
- Add setbufvar api [#3083](https://github.com/SpaceVim/SpaceVim/pull/3083)
- Add floating_statusline api [#2664](https://github.com/SpaceVim/SpaceVim/pull/2664)
- Add type checking function for `vim` api [#3666](https://github.com/SpaceVim/SpaceVim/pull/3666)

### New features

- Add floating statusline for key bindng guide [#3605](https://github.com/SpaceVim/SpaceVim/pull/3605)
- Add floating windows support vim [#3612](https://github.com/SpaceVim/SpaceVim/pull/3612)
- Add Flygrep float preview for neovim [#3649](https://github.com/SpaceVim/SpaceVim/pull/3649)
- Disable scrollbar in vim [#3625](https://github.com/SpaceVim/SpaceVim/pull/3625)
- Floating statusline for vim [#3617](https://github.com/SpaceVim/SpaceVim/pull/3617)
- Add highlight option for floating API [#3619](https://github.com/SpaceVim/SpaceVim/pull/3619)
- Add spinners support in repl [#2232](https://github.com/SpaceVim/SpaceVim/pull/2232)
- Add branch manager plugin [#2396](https://github.com/SpaceVim/SpaceVim/pull/2396)
- Add profile plugin [#3290](https://github.com/SpaceVim/SpaceVim/pull/3290)
- Add command SPClean to claer unused plugins [#3589](https://github.com/SpaceVim/SpaceVim/pull/3589)
- Add option: escape_key_binding [#3599](https://github.com/SpaceVim/SpaceVim/pull/3599)
- Add jump transtate [#3590](https://github.com/SpaceVim/SpaceVim/pull/3590)
- Add nerdtree support in welcome screen [#3584](https://github.com/SpaceVim/SpaceVim/pull/3584)
- Improve plugin manager [#3591](https://github.com/SpaceVim/SpaceVim/pull/3591)
- Update php.vim [#3004](https://github.com/SpaceVim/SpaceVim/pull/3004)
- Show buffer name [#3340](https://github.com/SpaceVim/SpaceVim/pull/3340)
- Neovim lsp [#2627](https://github.com/SpaceVim/SpaceVim/pull/2627)
- Improve `lang#rust` layer [#3674](https://github.com/SpaceVim/SpaceVim/pull/3674)
- Improve location list statusline [#3653](https://github.com/SpaceVim/SpaceVim/pull/3653)

## Changes

- Improve project root detection [#3609](https://github.com/SpaceVim/SpaceVim/pull/3609)

## Bug Fixs

- Fix `vim#window` api [#3643](https://github.com/SpaceVim/SpaceVim/pull/3643)
- Fix smart quit should skip floating windows and popup [#3640](https://github.com/SpaceVim/SpaceVim/pull/3640)
- Fix lua api [#3639](https://github.com/SpaceVim/SpaceVim/pull/3639)
- Fix VCS Transient State [#3635](https://github.com/SpaceVim/SpaceVim/pull/3635)
- Fix vim#buffer api [#3630](https://github.com/SpaceVim/SpaceVim/pull/3630)
- Fix vim popup bug [#3616](https://github.com/SpaceVim/SpaceVim/pull/3616)
- Fix shell layer [#3608](https://github.com/SpaceVim/SpaceVim/pull/3608)
- Fix SPC g m key binding [#3607](https://github.com/SpaceVim/SpaceVim/pull/3607)
- Fix comment invert yank doesn't work in visual mode [#3606](https://github.com/SpaceVim/SpaceVim/pull/3606)
- Fix make error for missing lib folder [#3586](https://github.com/SpaceVim/SpaceVim/pull/3586)
- Fix java format config [#3575](https://github.com/SpaceVim/SpaceVim/pull/3575)
- Fix c cpp highlight [#3561](https://github.com/SpaceVim/SpaceVim/pull/3561)
- Fix coc.vim installation [#3560](https://github.com/SpaceVim/SpaceVim/pull/3560)
- Update coc.nvim installation [#3564](https://github.com/SpaceVim/SpaceVim/pull/3564)
- Fix flygrep statusline [#3657](https://github.com/SpaceVim/SpaceVim/pull/3657)
- Fix flygrep history completion [#3659](https://github.com/SpaceVim/SpaceVim/pull/3659)
- Fix dein support [#3647](https://github.com/SpaceVim/SpaceVim/pull/3647)
- Fix statuline in old split windows [#3644](https://github.com/SpaceVim/SpaceVim/pull/3644)
- Fix unknown function popup_list [#3673](https://github.com/SpaceVim/SpaceVim/pull/3673)
- Fix support for vim 7.4.1689 [#3663](https://github.com/SpaceVim/SpaceVim/pull/3663)
- Fix key binding guide floating statusline [#3658](https://github.com/SpaceVim/SpaceVim/pull/3658)
- Fix lsp support for lang#c layer [#3652](https://github.com/SpaceVim/SpaceVim/pull/3652)
- Fix fonts downloader [#3648](https://github.com/SpaceVim/SpaceVim/pull/3648)
- Fix key binding q in quickfix windows [#3645](https://github.com/SpaceVim/SpaceVim/pull/3645)

## Doc&&Wiki

- Add help file for tasks [#3371](https://github.com/SpaceVim/SpaceVim/pull/3371)
- Add cn blog for key binding guide [#3675](https://github.com/SpaceVim/SpaceVim/pull/3675)
- Update gnu global install guide for MacOS [#3651](https://github.com/SpaceVim/SpaceVim/pull/3651)
- Update following HEAD page [#3642](https://github.com/SpaceVim/SpaceVim/pull/3642)

## Others

- Update vimproc.vim bundle to latest version [#3587](https://github.com/SpaceVim/SpaceVim/pull/3587)

