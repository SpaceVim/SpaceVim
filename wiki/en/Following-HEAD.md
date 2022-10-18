This page documents changes in master branch since last release v2.0.0

## New features

#### New features


```
- Create LICENSE 
- chore(bundle): update bundle lspconfig 
- chore(bundle): use bundle fugitive & dispatch 
- chore(chat): add gitter js 
- chore(command): add `spacevim.command` module 
- chore(copyright): add file head 
- chore(fold): add code fold marker 
- chore(fsharp): use bundle fsharp plugin 
- chore(go): use bundle vim-go and deoplete-go 
- chore(nerdtree): update bundle nerdtree 
- chore(typo): typo in clipboard.vim 
- chore(version): update version to v2.1.0-dev 
- ci(linux): upgrade to ubuntu-20.04 
- ci(test): use ubuntu18.04 for old vim 
- docs(aspectj): AspectJ support has been misspelled 
- docs(commit): typo in gitcommit.vim 
- docs(community): add issue links 
- docs(community): add link to facebook 
- docs(community): add link to reddit 
- docs(community): update link  of the chatting rooms 
- docs(data#dict): update doc of `data#dict` api 
- docs(development): update cn chat link 
- docs(development): update development page 
- docs(forum): add link to forum 
- docs(index): add vim versions 
- docs(index): update index page 
- docs(lsp): fix typo in language-server-protocol.md 
- docs(option): add `:h SpaceVim-options-disabled_plugins` 
- docs(readme): add link 
- docs(readme): update link of chatting room 
- docs(readme): update readme 
- docs(readme): update readme 
- docs(typo): fix typo in website 
- docs(undotree): fix typo 
- docs(website): fix spelling and grammar 
- docs(website): typo in website 
- docs(website): update community link 
- docs(website): update faq 
- feat(api): add `vim.command` api 
- feat(autosave): implement autosave plugin in lua 
- feat(clipboard): add clipboard#set function 
- feat(clipboard): add log for clipboard 
- feat(custom): add log for write_to_config function 
- feat(default): add default.lua 
- feat(edit): use lua plugin for nvim 0.7 
- feat(flygrep): add apply_to_quickfix function 
- feat(flygrep): add double_click function 
- feat(flygrep): add lua flygrep 
- feat(flygrep): add match highlight 
- feat(flygrep): add move_cursor function 
- feat(flygrep): add open_item_in_tab function 
- feat(flygrep): add open_item_vertically/horizontally function 
- feat(flygrep): add open_iten function 
- feat(flygrep): add statusline for flygrep.lua 
- feat(flygrep): add toggle_expr_mode function 
- feat(flygrep): implement flygrep in lua 
- feat(flygrep): support filter mode 
- feat(flygrep): support preview item 
- feat(iedit): handle <delete> key in iedit-insert mode 
- feat(iedit): handle insert left/right/ctrl-b/f 
- feat(iedit): handle normal D/p/S/G/g 
- feat(iedit): handle normal n 
- feat(iedit): rewrite iedit in lua (#4724) 
- feat(lua): add lua implementation 
- feat(matrix): update link to matrix 
- feat(messletters): add bubble_num function 
- feat(messletters): add circled_num function 
- feat(messletters): add messletters functions 
- feat(plugins): implement lua functions 
- feat(plugins): implement plugins logic 
- feat(prompt): add lua prompt api 
- feat(prompt): fix handle function 
- feat(screensaver): use bundle screensaver 
- feat(searcher): rewrite searcher in lua 
- feat(vim.compatible): update vim.compatible api 
- feat(vim8): use lua plugin for vim8 
- fix(a.lua): fix undifinded value fn 
- fix(alternative): fix a.vim and a.lua 
- fix(api): clear package.loaded after import api 
- fix(argv): fix startup logic 
- fix(autosave): fix save_buffer function 
- fix(autosave): use pcall to avoid error 
- fix(branch): fix statusline branch info 
- fix(default): use pcall to avoid error 
- fix(flygrep): check if filewritable 
- fix(flygrep): clear cmdline after closing flygrep 
- fix(flygrep): clear mode when open flygrep 
- fix(flygrep): fix grep_stdout function 
- fix(flygrep): fix toggle_preview function 
- fix(flygrep): include files required for the lua logger api 
- fix(flygrep): silent update history 
- fix(iedit): fix parse_symbol function 
- fix(iedit): fix replace_symbol function 
- fix(java): fix java layer 
- fix(lsp): type error when loading lsp config (#4701) 
- fix(lua): use lua only for neovim 
- fix(nvim-cmp) change source priority 
- fix(nvim-cmp): fix broken hotkeys and add tab,s-tab 
- fix(option): fix for lua removing leading zeros 
- fix(prompt): fix _build_prompt function 
- fix(prompt): fix close logic 
- fix(prompt): fix handle function 
- fix(prompt): fix lua prompt api 
- fix(prompt): fix register matcher 
- fix(prompt): implement prompt api 
- fix(python): fix python support for neovim 0.7 
- fix(statusline): fix warning in buffer terminal 
- fix(statusline): init statusline separators 
- fix(tabline): fix undefined s:lsep variable 
- fix(typo): fix typo in flygrep 
- fix(typo): fix typo in prompt.lua 
- fix(ultisnips): fix ultisnips config 
- fix(vim#buffer): fix `vim#buffer` api 
- perf(iedit): use getreg instead of eval 
- perf(lspconfig): update bundle lspconfig 
- refactor(a.lua): remove debug info in parse function 
- test(java): fix java layer test 
- test(mkdir): disable undofile option 
- test(neovim): add test for nvim 0.7 
- test(neovim): remove test for nvim 0.7.1 
- typo(website): release 
```

## Latest Release

SpaceVim releases v2.0.0 at 2022-07-02, please check the release page:

- [SpaceVim releases v2.0.0](https://spacevim.org/SpaceVim-release-v2.0.0/) for all the details
