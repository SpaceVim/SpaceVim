---
title: "Following Head"
description: "The latest changes in master branch since last release."
lang: zh
---

# [主页](../) >> Following Head

本页罗列出自上一版本 v2.3.0 以来，master 分支上所发生的变更记录：

<!-- vim-markdown-toc GFM -->

- [下一个版本](#下一个版本)
- [新特性](#新特性)
- [问题修复](#问题修复)
- [文档更新](#文档更新)
- [测试](#测试)
- [其他](#其他)
- [非兼容变更](#非兼容变更)
- [上一个版本](#上一个版本)

<!-- vim-markdown-toc -->

## 下一个版本

下一个版本号为 v2.4.0

<!--
call SpaceVim#dev#followHEAD#update('cn')
-->
<!-- SpaceVim follow HEAD start -->
## 新特性

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

## 问题修复

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

## 文档更新

- docs(format): add readme
- docs(readme): remove extra link
- docs(index): remove news image
- docs(typo): fix image url

## 测试


## 其他

- refactor(format): refactor on_exit function
- refactor(format): enable format function
- chore(format): format code
- chore(bookmark): remove extra files
- chore(version): update to v2.4.0-dev

## 非兼容变更
<!-- SpaceVim follow HEAD end -->

## 上一个版本

SpaceVim 于 2024-03-24 发布 v2.3.0 版本，可查阅版本发布文章：

- [SpaceVim 发布 v2.3.0 版本](https://spacevim.org/SpaceVim-release-v2.3.0/)
