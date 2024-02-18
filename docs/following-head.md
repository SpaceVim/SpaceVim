---
title: "Following Head"
description: "The latest changes in master branch since last release."
---

# [Home](../) >> Following Head

This page documents changes in master branch since last release v2.2.0

<!-- vim-markdown-toc GFM -->

- [New features](#new-features)
- [Bugfixs](#bugfixs)
- [Docs](#docs)
- [Tests](#tests)
- [Others](#others)
- [Latest Release](#latest-release)

<!-- vim-markdown-toc -->

## New features

- feat(alternate): make `:A` command support toml
- feat(api): add lua job api
- feat(ctags): implement ctags#update in lua
- feat(flygrep): use job api instead of vim.fn.jobstart
- feat(git): add `:Git blame`
- feat(git): add `:Git cherry-pick` command
- feat(git): add `:Git clean` command
- feat(git): add `:Git fetch` command
- feat(git): add `:Git mv` command
- feat(git): add `:Git remote` for git.lua
- feat(git): add `:Git reset` command
- feat(git): add `:Git rm` command
- feat(git): implement git.lua
- feat(gtags): add the shortcut for jumping to a symbol
- feat(guide): rewrite leader guide in lua
- feat(job): improve job api
- feat(job): support detached opt
- feat(job): support env and clear_env opt
- feat(log): improve logger api
- feat(pastebin): add pastebin.lua
- feat(pastebin): use lua pastebin for nvim 0.9.0+
- feat(repl): add spinners
- feat(repl): rewrite repl plugin in lua
- feat(runner): rewrite code runner in lua
- feat(scrollbar): implement scrollbar in lua
- feat(tasks): implement tasks.lua
- feat(toml): add `data.toml` api
- feat(toml): add lua toml previewer
- feat(vim): add functions
- perf(a.lua): log alternate file name
- perf(git): display stderr on exit
- perf(git): update GitGutter status
- perf(git): use notify api && redrawstatus
- perf(job): use table for job stdout/stderr data
- perf(notify): change notify borderchars
- perf(repl): update statusline on exit
- perf(scrollbar): set scrollbar zindex to 10
- perf(spinners): handle none exist data
- perf(spinners): handle spinners function error
- perf(statusline): indent statusline mode text
- revert(rtp): remove `:GrepRtp` command
- revert(ui): revert indent-blankline config
- revert(url)!: revert url

## Bugfixs

- fix(cmdlinemenu): fix cmdlinemenu lua api
- fix(docker): update init.toml url
- fix(flygrep): fix version checking
- fix(indent-blankline): set max_indent_increase = 1
- fix(install): update repo url in install.cmd
- fix(job): close stdout/stderr on exit
- fix(job): support cwd option and check executable
- fix(job): support shell/shellcmdflag opt
- fix(opt): remove guioption  for nvim
- fix(pastebin): change url on stdout
- fix(pastebin): fix pastebin get visual selection
- fix(runner): add get function
- fix(scala): use old fork ensime-vim
- fix(tasks): use `vim.tbl_extend` instead
- fix(toml): fix E706
- fix(toml): use integer instead
- fix(typescript): fix lsp key binding for typescript

## Docs

- docs(job): update `:h spacevim-api-job`
- docs(alternate): update doc for toml configuration file
- docs(chat): remove IRC rooms from community page
- docs(chat): update chat link
- docs(community): remove twitter account
- docs(community): use mail list only
- docs(doc): remove github link
- docs(faq): update spacevim repo link
- docs(feedback): remove matrix room from development page
- docs(font): update doc for default font
- docs(img): use img.spacevim.org for img url
- docs(index): remove github action list
- docs(index): remove matrix link
- docs(index): update cn index
- docs(index): update index page
- docs(job): update `:h spacevim-api-job`
- docs(logger): update doc for `:h SpaceVim#logger#derive`
- docs(lua): add lua post
- docs(readme): add link to development page
- docs(readme): clear readme
- docs(readme): remove cn readme
- docs(readme): remove project layout
- docs(readme): update link to community page
- docs(readme): update readme
- docs(readme): update readme of gitlab
- docs(roadmap): update roadmap and todos
- docs(sponsors): update website
- docs(task): doc for lua task provider
- docs(website): clear badges

## Tests

- test(a.lua): fix test for a.lua
- test(a.vim): fix alternate test
- test(alternate): remove alternate file test for wiki
- test(flygrep): fix input_list test
- test(nvim): add test for nvim 0.7.0 - 0.9.1
- test(nvim): fix nvim test in linux
- test(nvim): use `--headless` for neovim test
- test(win): add codecov
- test(win): fix win test
- test(win): fix windows test
- ci(Makefile): remove coverage
- ci(gitlab): add gitlab-ci.yml
- ci(gitlab): update ci file
- ci(page): remove gitlab-ci
- ci(script): remove script

## Others

- Replace the original function Chinese2Digit with the equivalent function...
- Update cscope.md
- Update cscope.md
- add the shortcut for jumping to a symbol
- build(vader): use headless option
- chore(a.lua): remove alternate json conf
- chore(dev): remove github specific files
- chore(git): use gitlab instead
- chore(gitignore): add public directory to gitignore
- chore(install): switch to gitlab
- chore(issue): remove default title
- chore(issue): remove title
- chore(linguist): ignore iconv file
- chore(linguist): update gitattributes
- chore(spinners): change file format
- chore(ui): update bundle indent-blankline.nvim
- chore(url): change to dev.spacevim.org
- chore(version): update version to v2.3.0-dev
- chore(website): bundle jquery 1.7.1
- chore(website): remove github corner

## Latest Release

SpaceVim releases v2.2.0 at 2023-07-07, please check the release page:

- [SpaceVim releases v2.2.0](https://spacevim.org/SpaceVim-release-v2.2.0/) for all the details
