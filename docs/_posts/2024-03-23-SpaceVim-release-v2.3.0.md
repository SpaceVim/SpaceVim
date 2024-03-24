---
title: SpaceVim release v2.3.0
categories: [changelog, blog]
description: "SpaceVim release v2.3.0 with more lua plugins and better experience."
type: article
image: https://img.spacevim.org/release-v2.3.0.png
commentsID: "SpaceVim release v2.3.0"
---

# [Changelogs](../development#changelog) > SpaceVim release v2.3.0

<!-- vim-markdown-toc GFM -->

- [New features](#new-features)
- [Bugfixs](#bugfixs)
- [Docs](#docs)
- [Tests](#tests)
- [Others](#others)
- [Breakchanges](#breakchanges)

<!-- vim-markdown-toc -->

The last release is v2.2.0, After 9 months development.
The v2.3.0 has been released.
So let's take a look at what happened since last release.

![welcome page](https://img.spacevim.org/release-v2.3.0.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## New features

- feat(git): add `:Git tag` for vim
- feat(git): rewrite `:Git stash` in lua
- perf(git): do not open diff win when no changes
- feat(git): rewrite `:Git rebase` in lua
- feat(chinese): add key bindings for translate types
- perf(scrollbar): use `vim#buffer` api
- perf(cmp): update default nvim-cmp config
- perf(cmp): update nvim-cmp
- perf(history): skip empty file and save pos before opening startify
- perf(neomru): enable file preview for neomru
- perf(file): change default file icon color
- perf(file): add file icon for vimrc and makefile
- perf(color): use `#ffffff` as default color
- perf(file): fix file icon for config and muttrc
- feat(telescope): make `SPC f r` use `Telescope neomru`
- feat(icon): highlight icons on startify
- feat(history): save searching history
- perf(powershell): add `enabled_formatters` layer option
- perf(powershell): fix powershell formatters
- perf(git): merge commit output date
- perf(git): improve commit logic
- feat(git): add `:Git grep` command
- feat(format): add layer option notify width and timeout
- perf(neoformat): use SpaceVim notify api instead of `echo`
- perf(neoformat): improve neoformat
- feat(sql): support sqlformat & fix encoding
- feat(sql): improve `lang#sql` layer
- perf(api): include neovim prerelease info
- perf(treesitter): add default setup function
- perf(guide): remove debug log
- perf(git): add git commit debug info
- perf(git): use `b#` to jump to previous buf
- feat(git): check buf is valid before setline
- feat(git): rewrite `:Git config` in lua
- perf(git): update branch manager after delete branch
- feat(git): rewrite `:Git reflog` in lua
- feat(git): compete merge options
- perf(git): notify commit done when use `-m`
- feat(git): add vim cmdline parser function
- perf(project): display path relative to the home directory
- feat(git): add git branch sidebar
- feat(git): rewrite `:Git branch` with lua
- feat(dev): update fellowing head vim function
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

## Bugfixs

- fix(string): fix string2chars function test for vim
- fix(chinese): fix translating function between numerals
- fix(rtp): fix default rtp when starting
- fix(scrollbar): disable Search highlight in scrollbar
- fix(notify): disable `Search` highlight in notify window
- fix(powershell): fix default powershell formatters
- fix(git): fix `:Git commit --amend`
- fix(git): fix commit buffer
- fix(flygrep): remove `t_ve` option
- fix(colorscheme): link WinSeparator to VertSplit
- fix(telescope): fix deoplete autocmd
- fix(pmd): check executable of Pmd_Cmd
- fix(neovide): fix neovide startup
- fix(git): check buf exists before show commit
- fix(api): fix argv api
- fix(git): update branch name after `:Git branch` command
- fix(git): fix close_diff_win in diff.lua
- fix(git): fix delete_branch function && check bufnr
- fix(statusline): fix statusline highlight
- fix(scrollbar): fix scrollbar for vim
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
- fix(opt): remove guioption for nvim
- fix(indent-blankline): set max_indent_increase = 1

## Docs

- docs(index): update test version
- docs(bundle): update bundle-plugins page
- docs(dev): update following head script and page
- docs(typo): rename `enabled_formater` to `enabled_formatters`
- docs(neoformat): update `:h neoformat`
- docs(guide): add guide for scala nim and swift
- docs(elixir): add elixir guide
- docs(chinese): update doc of chinese layer
- docs(todo): remove targed todos
- docs(source): add source code page
- docs(roadmap): update roadmap page
- docs(key): format key binding list
- docs(sponsor): update sponsors page
- docs(kotlin): fix 404 link
- docs(neovim): update neovim.zip link
- docs(roadmap): update roadmap and following head
- docs(community): add discord and slack link
- docs(screenshot): update workflow screenshot
- docs(license): add `:h spacevim-dev-license`
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

## Tests

- test(task): add extra test
- test(task): add `vader-nvim-038` task
- test(task): add task todo
- test(task): add `vader-nvim-061` task
- test(task): update task todos
- test(vim): fix test for old vim
- test(task): add `vader-nvim-080` task
- test(wsl): add `vader-nvim-wsl` task
- test(nvim): fix `make test` for nvim 0.9.5
- test(task): add `vim 7.4.1185` task
- test(tasks): add `vader-nvim-072` task
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

## Others

- build(docker): remove docker build
- chore(file): remove debug message
- chore(dev): remove bundle.lua
- chore(treesitter): update nvim-treesitter to 0.9.1 for Nvim-0.8.x
- chore(website): clear website
- chore(bundle): update ChineseLinter
- chore(ChineseLinter): update ChineseLinter
- chore(startup): add startup log
- chore(chinese): use bundle ChineseLinter
- chore(bundle): update vim-startify
- chore(todo): remove todo tag
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
- chore(url): change to dev.spacevim.org
- chore(a.lua): remove alternate json conf
- chore(linguist): update gitattributes
- chore(linguist): ignore iconv file
- chore(issue): remove title
- chore(issue): remove default title
- revert(ui): revert indent-blankline config
- chore(ui): update bundle indent-blankline.nvim
- chore(version): update version to v2.3.0-dev

## Breakchanges

- revert(mapping)!: remove `SPC b h`, duplicate with `SPC a s`
- feat(history)!: use history plugin instead of shada
- perf(go)!: change default lint to golangci_lint
- revert(url)!: revert url
