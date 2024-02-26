---
title: "Following Head"
description: "The latest changes in master branch since last release."
lang: zh
---

# [主页](../) >> Following Head

本页罗列出自上一版本 v2.2.0 以来，master 分支上所发生的变更记录：

<!-- vim-markdown-toc GFM -->

- [下一个版本](#下一个版本)
- [新特性](#新特性)
- [问题修复](#问题修复)
- [文档更新](#文档更新)
- [测试](#测试)
- [其他](#其他)
- [上一个版本](#上一个版本)

<!-- vim-markdown-toc -->

## 下一个版本

下一个版本号为 v2.3.0

<!-- SpaceVim follow HEAD start -->
## 新特性

- feat(git): add `:Git tag` command
- perf(neoyank): use notify api
- feat(git): quit git log win when it is last win
- feat(git): display root path of repo
- feat(todo): update todo list when switch project
- feat(projectmanager): make reg_callback support description
- feat(git): update remote manager context when switch project
- feat(colorscheme): support treesitter highlight group
- perf(telescope): use telescope 0.1.2 for nvim 0.7.0
- perf(git): open remote branch log in new tab
- feat(git): make `<Cr>` show git log in remote manager
- feat(git): add git remote manager
- feat(git.vim): complete shortlog command
- feat(git.vim): add `:Git shortlog` command
- feat(gtags): add the shortcut for jumping to a symbol
- feat(scrollbar): implement scrollbar in lua
- feat(log): improve logger api
- feat(git): add `:Git blame`
- perf(repl): update statusline on exit
- perf(spinners): handle none exist data
- perf(spinners): handle spinners function error
- feat(repl): add spinners
- feat(repl): rewrite repl plugin in lua
- feat(guide): rewrite leader guide in lua
- feat(git): add `:Git rm` command
- feat(git): add `:Git reset` command
- feat(git): add `:Git cherry-pick` command
- feat(git): add `:Git fetch` command
- feat(tasks): implement tasks.lua
- feat(toml): add lua toml previewer
- feat(alternate): make `:A` command support toml
- feat(toml): add `data.toml` api
- perf(git): update GitGutter status
- perf(git): display stderr on exit
- feat(git): add `:Git mv` command
- feat(git): add `:Git clean` command
- perf(notify): change notify borderchars
- feat(git): add `:Git remote` for git.lua
- feat(git): implement git.lua
- perf(a.lua): log alternate file name
- feat(pastebin): use lua pastebin for nvim 0.9.0+
- feat(pastebin): add pastebin.lua
- feat(job): improve job api
- perf(statusline): indent statusline mode text
- feat(runner): rewrite code runner in lua
- perf(scrollbar): set scrollbar zindex to 10
- perf(git): use notify api && redrawstatus
- feat(vim): add functions
- feat(job): support env and clear_env opt
- feat(job): support detached opt
- feat(ctags): implement ctags#update in lua
- feat(flygrep): use job api instead of vim.fn.jobstart
- perf(job): use table for job stdout/stderr data
- feat(api): add lua job api

## 问题修复

- fix(scrollbar): fix unsaved error
- fix(git): ignore remote manager when close win
- fix(telescope): fix telescope loadconf
- fix(git): skip unsupported subcommand
- fix(git): make error message clear
- fix(git): fix git log command
- fix(git): fix wrong branch name
- fix(git): fix wrong remote line number
- fix(git): rename cherry_pick to cherry-pick
- fix(git.vim): fix plog_jobid
- fix(shortlog): fix `:Git shortlog` command
- fix(docker): update init.toml url
- fix(install): update repo url in install.cmd
- fix(tasks): use `vim.tbl_extend` instead
- fix(scala): use old fork ensime-vim
- fix(cmdlinemenu): fix cmdlinemenu lua api
- fix(toml): use integer instead
- fix(toml): fix E706
- fix(typescript): fix lsp key binding for typescript
- fix(job): close stdout/stderr on exit
- fix(runner): add get function
- fix(pastebin): fix pastebin get visual selection
- fix(pastebin): change url on stdout
- fix(job): support cwd option and check executable
- fix(flygrep): fix version checking
- fix(job): support shell/shellcmdflag opt
- fix(opt): remove guioption  for nvim
- fix(indent-blankline): set max_indent_increase = 1

## 文档更新

- docs(index): update index page
- docs(help): add `:h SpaceVim-dev-merge-request`
- docs(faq): change repo url
- docs(roadmap): update roadmap page
- docs(community): update community page
- docs(index): update index page
- docs(index): remote shields link
- docs(roadmap): update completed item
- docs(roadmap): update roadmap page
- docs(community): update community en page
- docs(community): add link to x account
- docs(website): update index page
- docs(roadmap): update roadmap page
- docs(fhead): update following-head page
- docs(git.vim): remove duplicate tag
- docs(dev): update development page
- docs(website): update following head page
- docs(development): update merge request steps
- docs(dev): update upstream url
- docs(remote): use custom remote url
- docs(website): move language link to menu
- docs(website): fix language link
- docs(website): add language link
- docs(development): update development page
- docs(index): update description
- docs(following-head): update following-head page
- docs(sponsors): update website
- docs(community): remove twitter account
- docs(index): remove github action list
- docs(doc): remove github link
- docs(font): update doc for default font
- docs(faq): update spacevim repo link
- docs(readme): update link to community page
- docs(readme): update readme of gitlab
- docs(website): clear badges
- docs(index): update cn index
- docs(index): update index page
- docs(readme): update readme
- docs(job): update `:h spacevim-api-job`
- docs(logger): update doc for `:h SpaceVim#logger#derive`
- docs(lua): add lua post
- docs(feedback): remove matrix room from development page
- docs(readme): clear readme
- docs(index): remove matrix link
- docs(community): use mail list only
- docs(chat): remove IRC rooms from community page
- docs(alternate): update doc for toml configuration file
- docs(roadmap): update roadmap and todos
- docs(task): doc for lua task provider
- docs(img): use img.spacevim.org for img url
- docs(readme): add link to development page
- docs(readme): remove cn readme
- docs(readme): remove project layout
- docs(chat): update chat link

## 测试

- test(nvim): fix nvim test in linux
- test(flygrep): fix input_list test
- test(nvim): use `--headless` for neovim test
- test(win): fix win test
- test(win): add codecov
- test(win): fix windows test
- test(nvim): add test for nvim 0.7.0 - 0.9.1
- test(a.lua): fix test for a.lua
- test(a.vim): fix alternate test
- test(alternate): remove alternate file test for wiki

## 其他

- chore(conduct): remove CODE_OF_CONDUCT.md
- chore(todo): add todo item for git log
- chore(telescope): update telescope to 0.1.5
- ci(script): remove script
- ci(Makefile): remove coverage
- Merge branch 'xinfengwu-master-patch-82221' into 'master'
- Merge branch 'xinfengwu-master-patch-44776' into 'master'
- Merge branch 'nouzername-master-patch-09495' into 'master'
- Replace the original function Chinese2Digit with the equivalent function...
- add the shortcut for jumping to a symbol
- Update cscope.md
- Update cscope.md
- build(vader): use headless option
- chore(website): bundle jquery 1.7.1
- ci(page): remove gitlab-ci
- chore(website): remove github corner
- chore(install): switch to gitlab
- chore(git): use gitlab instead
- ci(gitlab): update ci file
- chore(gitignore): add public directory to gitignore
- ci(gitlab): add gitlab-ci.yml
- chore(dev): remove github specific files
- revert(rtp): remove `:GrepRtp` command
- chore(spinners): change file format
- revert(url)!: revert url
- chore(url): change to dev.spacevim.org
- chore(a.lua): remove alternate json conf
- chore(linguist): update gitattributes
- chore(linguist): ignore iconv file
- chore(issue): remove title
- chore(issue): remove default title
- revert(ui): revert indent-blankline config
- chore(ui): update bundle indent-blankline.nvim
- chore(version): update version to v2.3.0-dev
<!-- SpaceVim follow HEAD end -->

## 上一个版本

SpaceVim 于 2023-07-05 发布 v2.2.0 版本，可查阅版本发布文章：

- [SpaceVim 发布 v2.2.0 版本](https://spacevim.org/SpaceVim-release-v2.2.0/)
