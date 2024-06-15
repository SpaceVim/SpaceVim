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

- perf(statusline): support quickfix & loclist
- perf(install): clone repo with --depth 1
- perf(stl): add input_method function
- perf(helpful.vim): add helpful tag
- perf(doc): update quick start guide
- feat(statusline): add lua statusline
- feat(kotlin): update kotlin lsp support
- perf(bundle): use bundle echodoc.vim
- perf(bundle): use nvim-surround for nvim 0.8.0+
- perf(autocmd): move autocmds.vim to lua
- perf(bundle): use telescope 0.1.8 for nvim 0.10.0
- perf(guide): use timer to display win
- perf(dev): use task to open nvim and vim
- perf(guide): improve key binding guide
- perf(autocmd): close vim on last quickfix win
- perf(autocmd): move syntax autocmd to lua
- perf(autocmds): use lua autocmds instead of viml
- perf(statusline): improve syntax info color
- perf(statusline): show errors counts on statusline
- perf(gruvbox): update gruvbox
- perf(colorscheme): update `NormalFloat` for one
- perf(lspconfig): update nvim-lspconfig to 9bda20f
- perf(cursor): hide cursor
- perf(history): update register `@/`
- perf(scrollbar): change min_size to 5
- perf(tabline): use lua tablineat function
- perf(tabline): add sep after hide left section
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

- fix(file): fix file api
- fix(python): add debug info for Shebang_to_cmd
- fix(compatible): fix nvim-0.5.0 support
- fix(lua): fix lua warnings
- fix(statusline): fix code runner and repl stl
- fix(statusline): fix syntax_checking function
- fix(default): fix default color template
- fix(scrollbar): check excluded_filetypes
- fix(format): format.nvim requires nvim 0.9.0+
- fix(statusline): fix display current tag
- fix(guide): use hide option only for nvim 0.10.0+
- fix(nerdtree): fix `Enter` key binding of nerdtree
- fix(vim): fix vim start with `vim --servername VIM`
- fix(mkdir): fix mkdir lua plugin
- fix(guide): move getName function to lua
- fix(task): check isBackground by boolean
- fix(defx): use defx for nvim 0.4.0+
- fix(compatible): fix bufname() and bufnr()
- fix(scrollbar): use zindex only for nvim 0.5.0+
- fix(cmp): use nvim-cmp for nvim v0.7.x or higher
- fix(argvs): fix parser_argv function
- fix(quickfix): fix quickfix autocmd
- fix(statusline): check vim.diagnostic.count
- fix(autosave): fix lua autosave plugin
- fix(tabline): fix default colorscheme tabline
- fix(gruvbox): fix NormalFloat highlight
- fix(lsp): set server_ready to false on LspDetach
- fix(lsp): fix `SPC e l` key binding
- fix(notify): fix notify cursor position
- fix(t_ve): remove `t_ve` from iedit.lua
- fix(rtp): fix default rpt
- fix(install): ln error if ~/.config doesn't exist
- fix(statusline): fix statusline highlight
- fix(statusline): fix statusline fireformat sep
- fix(ctrlg): fix filename format & clear highlight
- fix(statusline): fix inactive separators
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

- docs(scrollbar): add doc
- docs(tabline): add doc for ctrl-shift-letf/right
- docs(nerdtree): update doc for `ctrl-h`
- docs(html): update css file
- docs(html): add codeCopy button
- docs(repository): add repository url
- docs(index): update test version
- docs(index): update tested versions
- docs(about): update about page
- docs(go): update `:h SpaceVim-layers-lang-go`
- docs(go): lsp for golang
- docs(vimdoc): add extra space
- docs(website): update doc
- docs(website): change default img to workflow
- docs(website): update roadmap and following head
- docs(format): add readme
- docs(readme): remove extra link
- docs(index): remove news image
- docs(typo): fix image url

## 测试


## 其他

- chore(bundle): update helpful.vim
- revert(html): remove copy button
- refactor(format): refactor on_exit function
- refactor(format): enable format function
- chore(format): format code
- chore(bookmark): remove extra files
- chore(version): update to v2.4.0-dev

## 非兼容变更
- revert(history)!: do not change register `@/`
<!-- SpaceVim follow HEAD end -->

## 上一个版本

SpaceVim 于 2024-03-24 发布 v2.3.0 版本，可查阅版本发布文章：

- [SpaceVim 发布 v2.3.0 版本](https://spacevim.org/SpaceVim-release-v2.3.0/)
