---
title: SpaceVim 发布 v2.4.0
categories: [changelog_cn, blog_cn]
description: "SpaceVim 发布 v2.4.0，优化了 Neovim 支持，核心插件使用 Lua 重写"
type: article
permalink: /cn/:title/
lang: zh
image: https://img.spacevim.org/workflow.png
---

# [Changelogs](../development#changelog) > SpaceVim 发布 v2.4.0

<!-- vim-markdown-toc GFM -->

- [新特性](#新特性)
- [问题修复](#问题修复)
- [文档更新](#文档更新)
- [测试](#测试)
- [其他](#其他)
- [非兼容变更](#非兼容变更)

<!-- vim-markdown-toc -->

SpaceVim `v2.4.0` 正式发布了，优化了 Neovim 支持，核心插件使用 Lua 重写。
本页罗列了 `v2.3.0` 至 `v2.4.0` 之间的提交历史记录：

![work-flow](https://img.spacevim.org/workflow.png)

- [入门指南](../quick-start-guide/): 基本的安装以及配置示例，同时包括了针对不同语言的配置技巧。
- [使用文档](../documentation/): 完整的使用文档，详细介绍了每一个快捷键以及配置的功能。
- [可用模块](../layers/): 罗列了目前已经实现的所有模块，包括功能模块和语言模块。

## 新特性

- perf(zettelkasten): check title width
- feat(git): update git-tag completion
- feat(markdown): add `SPC l f` to format code block
- feat(tabs): add tabs key bindings
- feat(git): lua complete for git-fetch
- feat(git): lua completion for sub command
- feat(git): implement lua complete for git-tag
- feat(git): implement lua complete for git-add
- feat(markdown): add `SPC l t` to toggle todo
- feat(zettelkasten): sort tags in sidebar
- feat(git.vim): complete git push command
- feat(git): improve git branch detection
- feat(zettelkasten): use `<Enter>` to open note
- perf(zettelkasten): set winfixwidth option
- feat(zktagstree): support `<LeftRelease>` key
- feat(zettelkasten): add zk tags tree
- feat(zkbrowser): use `<LeftRelease>` to filter tag
- feat(zettelkasten): filter zk tags
- feat(zettelkasten): detach vim-zettelkasten plugin
- feat(git): complete checkout command
- feat(zettelkasten): improve zettelkasten plugin
- feat(telescope): add `hidden` & `no_ignore` opt
- feat(cpicker): change cursor highlight
- feat(flygrep): use `ctrl-h` toggle hidden files
- perf(shell): add `center-float` position
- perf(SourceCounter): import sourcecounter
- feat(cpicker.nvim): detact_bundle cpicker.nvim
- feat(cpicker): add xyz color space
- feat(cpicker): add linear and lab color space
- feat(cpicker): add hwb color-mix
- feat(cpicker): add color-mix-method
- feat(cpicker): add color-mix function
- feat(cpicker): picker color from cursor
- feat(cpicker): change color code background
- feat(cpicker): add hwb color space
- feat(cpicker): add cmyk color space
- feat(hsv): add hsv format
- feat(cpicker): use Enter to copy color
- feat(cpicker): add tools#cpicker layer
- feat(core): add logevent plugin
- feat(github): add ci files
- feat(github): enable github action
- perf(core): add opt for lazy load config
- perf(tabline): use BufAdd instead of BufNew
- perf(lazy): lazy load plugins
- perf(dein): skip type checking
- perf(layer): lazy load layer config
- perf(neo-tree): use lua notify
- perf(plugins): lazy load plugins
- perf(git): add key binding `v` to view log
- feat(qml): add `lang#qml` layer
- perf(buf): open buf in best win
- perf(nvimtree): use nvim-web-devicons
- perf(markdown): lazy load toc plugin
- perf(core): lazy load core plugins
- perf(edit): lazy load grammarous and tabular
- perf(checkers): lazy load neomake
- feat(autocmd): add SpaceVimLspSetup autocmd
- perf(start): lazy load plugins
- perf(cmp): lazy load nvim-cmp
- perf(telescope): lazy load telescope
- perf(co-author): complete co-author info
- perf(gtags): make gtags and ctags lazy loaded
- perf(default): remove unused var & functions
- perf(neovim): use nvim-cmp & skip checking python
- perf(guide): remove debug info
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

- fix(zettelkasten): use string.sub for long title
- fix(git): complete tags only after `-d` opt
- fix(tasks): update vim-zettelkasten task
- fix(zettelkasten): test zettelkasten plugin
- fix(cmp): fix return nil behavior
- fix(guide): update language specified mapping
- fix(messletters): make bubble_num avoid nil
- fix(telescope): remove on_cmd option
- fix(cmp): fix nvim-cmp mapping
- fix(guide): fix `g` guide map
- fix(javavi): include jar files
- fix(opt): check belloff opt
- fix(cpicker): fix unknow function
- fix(scrollbar): detach apis
- fix(scrollbar): detach logger
- fix(cpicker): init data_dir
- fix(cpicker): set wrap opt for win
- fix(flygrep): detach job api
- fix(detach): fix detach url
- fix(bootstrap): use timer for bootstrap_after
- fix(cpicker): disable number and wrap opt
- fix(chat): fix vim chat statusline
- fix(cpicker): remove extra space
- fix(color): add missing functions
- fix(cpicker): fix get cursor color function
- fix(color): use math.round instead of floor
- fix(mapping): fix SPC a r/o
- fix(mapping): fix SPC b d key binding
- fix(tabline): update tabline on buflisted changed
- fix(custom): fix unknown key
- fix(mirror): remove `-f` opt
- fix(tabline): handle `BufNew` event
- fix(menu): fix unite menu
- fix(tasks): fix task status
- fix(format): format code in visual mode
- fix(git): fix git lazy command
- fix(projectmanager): skip when &autochdir is true
- fix(lsp): fix lua lsp WarningMsg
- fix(guide): fix prompt of flygrep
- fix(markdown): lazy load toc plugin on_ft
- fix(layer): fix all unknown functions
- fix(notify): fix unknown functions
- fix(find): fix find statusline
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

- docs(record-key): typo in readme
- docs(record-key): update readme
- docs(zettelkasten): update readme
- docs(website): remove r/SpaceVim
- docs(website): update following-head page
- docs(docker): update docker link
- docs(zettelkasten): update vim-zettelkasten readme
- docs(git): update readme of git.vim
- docs(development): use github issue & pull request
- docs(matrix): remove all chatting rooms
- docs(scrollbar): update requirements
- docs(scrollbar): add scrollbar img
- docs(flygrep): update flygrep readme
- docs(api): add prompt doc
- docs(git): update README
- docs(development): fix dev link
- docs(cpicker): update key bindings
- docs(website): update layer list
- docs(readme): update readme
- docs(bundle-plugins): add neo-tree link
- docs(autocomplete): update doc
- docs(opt): update doc of filemanager
- docs(help): update and rollback
- docs(help): update doc for editing
- docs(about): remove support email
- docs(help): update doc for tabline
- docs(help): update doc for filetree
- docs(typo): fix typo in post
- docs(help): add windows and ui doc
- docs(error): update doc for error handling
- docs(help): update buffer/file doc
- docs(highlighter): add doc for SPC s h
- docs(help): update help SpaceVim-options
- docs(guide): update help doc for mapping guide
- docs(help): update doc
- docs(help): add `:h SpaceVim-roadmap/community`
- docs(website): update following head and roadmap
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

- test(zettelkasten): fix test script
- test(scrollbar): fix scrollbar task
- test(scrollbar): add scrollbar task
- test(vader): fix vader test

## 其他

- ci(record-key.nvim): detact record-key.nvim
- ci(format.nvim): detact format.nvim
- ci(zettelkasten): detact zettelkasten syntax file
- ci(plugin): change commit email
- ci(detach): fix detach script
- ci(version)! remove old tests
- typo(guide): Key binding not defined
- ci(detach): fix scrollbar detach script
- ci(runner): switch to ubuntu-22.04
- ci(scrollbar): detach lua scrollbar
- refactor(scrollbar): detach scrollbar
- ci(detach): detach lua git plugin
- ci(detach): update detach script
- chore(async): detach SourceCounter.vim
- ci(async): add cpicker.nvim
- chore(log): remove log.txt
- chore(cpicker): remove duplicate code
- chore(typo): typo in cpicker
- build(docker): use new docker repo
- build(makefile): update makefile
- chore(colorscheme): use bundle vim-hybrid
- chore(pydocstring): use bundle pydocstring
- chore(bundle): use bundle splitjoin
- chore(bundle): update helpful.vim
- revert(html): remove copy button
- refactor(format): refactor on_exit function
- refactor(format): enable format function
- chore(format): format code
- chore(bookmark): remove extra files
- chore(version): update to v2.4.0-dev

## 非兼容变更
- revert(history)!: do not change register `@/`