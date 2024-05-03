---
title: "Following Head"
description: "The latest changes in master branch since last release."
---

# [Home](../) >> Following Head

This page documents changes in master branch since last release v2.3.0

<!-- vim-markdown-toc GFM -->

- [Next release](#next-release)
- [New features](#new-features)
- [Bugfixs](#bugfixs)
- [Docs](#docs)
- [Tests](#tests)
- [Others](#others)
- [Breakchanges](#breakchanges)
- [Latest Release](#latest-release)

<!-- vim-markdown-toc -->

## Next release

The next release is `v2.4.0`

<!--
call SpaceVim#dev#followHEAD#update('en')
-->
<!-- SpaceVim follow HEAD start -->
## New features

- feat(tabline): add lua tabline
- feat(format): add rustfmt
- perf(job): close job handle on_exit
- perf(format): use first executable formatter
- feat(format): add c format
- feat(ctags): remove tags before running ctags
- feat(format): support `:Format! filetype`
- perf(format): log formatter info
- feat(format): support custom format
- feat(format.lua) add format.lua
- feat(recordkey): support nvim 0.10.0
- perf(recordkey): use keytrans()
- perf(recordkey): ignore all events
- feat(recordkey): remove key via timer
- feat(recordkey): add recordkey plugin
- feat(git): complete `:Git branch`
- feat(notify): share viml notifys
- feat(bookmark): add VimLeave autocmd
- feat(bookmarks): update bookmarks lnums
- perf(bookmarks): skip empty bufname & buftype
- feat(bookmarks): edit existing annotation
- feat(bookmark): add virt_text support
- feat(bookmark): custom sign text and highlight
- feat(bookmarks): add new bookmark plugin
- perf(bookmark): add bookmark logger
- perf(telescope): remove `jk` for telescope
- feat(bookmarks): add telescope support
- feat(todo): add `todo_close_list` option
- feat(toml): add toml indent file

## Bugfixs

- fix(tabline): fix `Ctrl-Shift-Left/Right` key
- fix(history): fix history pos
- fix(job): return 0 for empty table
- fix(job): check cmd before run job
- fix(format): check formatted_context and stdin
- fix(format): fix formatter end_line
- fix(mapping): fix typo in help for leader f b
- fix(recordkey): fix win order
- fix(bookmarks): fix next/previous function
- fix(bookmarks): fix `mn` & `mp` key bindings
- fix(bookmark): remove sign before add new bookmark
- fix(bookmark): remove extra unlet
- fix(bookmarks): unlet bookmarks when clear

## Docs

- docs(format): add readme
- docs(readme): remove extra link
- docs(index): remove news image
- docs(typo): fix image url

## Tests


## Others

- refactor(format): refactor on_exit function
- refactor(format): enable format function
- chore(format): format code
- chore(bookmark): remove extra files
- chore(version): update to v2.4.0-dev

## Breakchanges
<!-- SpaceVim follow HEAD end -->

## Latest Release

SpaceVim releases v2.3.0 at 2024-03-24, please check the release page:

- [SpaceVim releases v2.3.0](https://spacevim.org/SpaceVim-release-v2.3.0/) for all the details
