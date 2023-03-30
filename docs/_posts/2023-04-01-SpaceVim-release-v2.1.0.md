---
title: SpaceVim release v2.1.0
categories: [changelog, blog]
description: "SpaceVim release v2.1.0"
type: article
image: https://user-images.githubusercontent.com/13142418/148374827-5f7aeaaa-e69b-441e-b872-408b47f4da04.png
commentsID: "SpaceVim release v2.1.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v2.1.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New layers](#new-layers)
  - [New feature](#new-feature)
  - [Enhancements](#enhancements)
- [Bug fixs](#bug-fixs)
- [Git Commits](#git-commits)

<!-- vim-markdown-toc -->

The last release is v2.0.0, After 9 months development.
The v2.1.0 has been released.
So let's take a look at what happened since last release.

![welcome page](https://user-images.githubusercontent.com/13142418/176910121-8e7ca78f-8434-4ac7-9b02-08c4d15f8ad9.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New layers

Since last release, the following layers have been added:

- `zettelkasten` layer:


### New feature


### Enhancements

1. implement `autosave` plugin in lua

## Bug fixs





## Git Commits

If you want to view all the git commits,
use following command in your terminal.

```
git -C ~/.SpaceVim log v2.0.0..v2.1.0
```


```
fix(branch): fix statusline branch info 
Create LICENSE 
chore(bundle): update bundle lspconfig 
chore(bundle): use bundle fugitive & dispatch 
chore(chat): add gitter js 
chore(cheat): use bundle vim-cheat 
chore(coc): use bundle coc.nvim 
chore(command): add `spacevim.command` module 
chore(copyright): add file head 
chore(copyright): update copyright 
chore(copyright): update copyright 
chore(deoplete): update bundle deoplete 
chore(deoplete-lsp): update bundle deoplete-lsp 
chore(fold): add code fold marker 
chore(fsharp): use bundle fsharp plugin 
chore(gitignore): update gitignore file 
chore(go): use bundle vim-go and deoplete-go 
chore(init): remove main.vim 
chore(java): use bundle javacomplete2 
chore(jedi): use bundle deoplete_jedi arty/typeshed/tests/stubtest_whitelists/py36.txt 
chore(jedi): use bundle jedi-vim 
chore(nerdtree): update bundle nerdtree 
chore(plantuml_previewer): update plantuml_previewer 
chore(typo): typo in clipboard.vim 
chore(version): update version to v2.1.0-dev 
chore(xmake): detach xmake.vim 
ci(cheat): fix typo 
ci(cheat): update detach_plugin script 
ci(detach): fix detach_plugin script 
ci(linux): upgrade to ubuntu-20.04 
ci(test): use ubuntu18.04 for old vim 
docs(aspectj): AspectJ support has been misspelled 
docs(bash): update `lang#sh` layer doc 
docs(bundle): update bundle plugin list 
docs(changelog): update `:h SpaceVim-changelog` 
docs(cheat): update the readme of vim-cheat 
docs(colorscheme): add missing list 
docs(colorscheme): update doc of colorscheme layer 
docs(commit): typo in gitcommit.vim 
docs(community): add issue links 
docs(community): add link to facebook 
docs(community): add link to reddit 
docs(community): remove link to smart-questions 
docs(community): remove links to gitter 
docs(community): update development and community page 
docs(community): update link  of the chatting rooms 
docs(contribute): update contribute page 
docs(contribute): update link to matrix 
docs(core): update core layer doc 
docs(data#dict): update doc of `data#dict` api 
docs(dev): change commit desc style guide 
docs(development): update cn chat link 
docs(development): update development page 
docs(dockerfile): fix typo 
docs(dockerfile): update dockerfile doc 
docs(file): add filetype icons 
docs(forum): add link to forum 
docs(git): add `:h git-functions` and `:h git-branch` 
docs(grammar): fix grammar in documentation 
docs(guide): update guide link 
docs(index): add vim versions 
docs(index): update index page 
docs(java): update doc for jdtls 
docs(lang): update language doc 
docs(layers): fix layers configuration snippet 
docs(layers): update layer list 
docs(lsp): fix typo in language-server-protocol.md 
docs(notify): update the doc for notify api 
docs(option): add `:h SpaceVim-options-disabled_plugins` 
docs(python): update python layer key bindings 
docs(python): update tutorial for python 
docs(readme): add link 
docs(readme): update link of chatting room 
docs(readme): update readme 
docs(readme): update readme 
docs(readme): update readme 
docs(readme): update readme 
docs(readme): update readme page 
docs(runner): add custom runner section 
docs(scrollbar): update doc of scrollbar 
docs(shields): update shields url 
docs(typo): fix spelling mistake 
docs(typo): fix typo in documentation.md 
docs(typo): fix typo in website 
docs(undotree): fix typo 
docs(website): fix spelling and grammar 
docs(website): typo in website 
docs(website): update community link 
docs(website): update faq 
docs(wiki): update follow head page 
docs(wiki): update matrix link 
docs: fix github workflow build badges 
feat(a.lua): improve a.lua plugin 
feat(api): add `vim.command` api 
feat(autosave): implement autosave plugin in lua 
feat(cheat): ignore readfile error 
feat(checkers): add `open_error_list` option 
feat(clipboard): add clipboard#set function 
feat(clipboard): add log for clipboard 
feat(ctags): add `--extra=+f` when generate tagfiles 
feat(custom): add log for write_to_config function 
feat(default): add default.lua 
feat(edit): add grammar checking plugin 
feat(edit): use lua plugin for nvim 0.7 
feat(file): add icon for toml file 
feat(flygrep): add apply_to_quickfix function 
feat(flygrep): add double_click function 
feat(flygrep): add lua flygrep 
feat(flygrep): add match highlight 
feat(flygrep): add move_cursor function 
feat(flygrep): add open_item_in_tab function 
feat(flygrep): add open_item_vertically/horizontally function 
feat(flygrep): add open_iten function 
feat(flygrep): add statusline for flygrep.lua 
feat(flygrep): add toggle_expr_mode function 
feat(flygrep): implement flygrep in lua 
feat(flygrep): support filter mode 
feat(flygrep): support preview item 
feat(git): add `:Git clean` command 
feat(git): use notify api for `Git commit` 
feat(go): update go layer doc 
feat(grammarous): add grammarous key bindings 
feat(iedit): handle <delete> key in iedit-insert mode 
feat(iedit): handle insert left/right/ctrl-b/f 
feat(iedit): handle normal D/p/S/G/g 
feat(iedit): handle normal n 
feat(iedit): rewrite iedit in lua (#4724) 
feat(iedit): use lua by default for nvim 
feat(jc2.vim): use notift and logger api 
feat(json5): add json5 support 
feat(lang#c): remove invalid entries from neomake 
feat(leader): add custom leader function 
feat(logger): change logger clock format 
feat(lsp): fix lsp layer options 
feat(lua): add lua implementation 
feat(markdown): use bundle markdown plugin 
feat(matrix): update link to matrix 
feat(maven): add maven task provider 
feat(messletters): add bubble_num function 
feat(messletters): add circled_num function 
feat(messletters): add messletters functions 
feat(neoformat): add formatters 
feat(neoformat): use spacevim log api 
feat(notify): support notify multiple lines 
feat(option): add `enable_list_mode` option 
feat(plantuml): fix `lang#plantuml` layer 
feat(plugins): implement lua functions 
feat(plugins): implement plugins logic 
feat(powershell): Adding quite options to powershell exec 
feat(projectmanager): support project_non_root option 
feat(prompt): add lua prompt api 
feat(prompt): fix handle function 
feat(python): add python_imports plugin 
feat(repl): add `i` key binding to insert text 
feat(runner): add ctrl-` to close code runner windows 
feat(screensaver): use bundle screensaver 
feat(searcher): rewrite searcher in lua 
feat(statusline): change statusline for python doc win 
feat(tasks): add telescope task 
feat(tasks): display background or not 
feat(todo): add enter key binding 
feat(todo): add max_len function 
feat(todo): rewrite todomanager using lua 
feat(todo): use lua todo manager for neovim 
feat(unstack): include vim-unstack 
feat(vcs): fix log grep option 
feat(vim.compatible): update vim.compatible api 
feat(vim8): use lua plugin for vim8 
feat(xmake): add xmake support 
feat(zettelkasten): add zettelkasten layer 
feat(zettelkasten): improve zettelkasten layer 
feat:(XDG): add XDG support 
fix(a.lua): fix alt function 
fix(a.lua): fix undifinded value fn 
fix(alternative): fix a.vim and a.lua 
fix(api): clear package.loaded after import api 
fix(argv): fix startup logic 
fix(autosave): fix save_buffer function 
fix(autosave): use pcall to avoid error 
fix(bootstrap): skip error in toml file 
fix(checkers): fix statusline for checkers layer 
fix(clipboard): remove --nodetach option 
fix(clipboard): remove -quiet flag on xclip clipboard 
fix(cmp): remove deprecated function 
fix(coc): fix coc `tab` && `S-tab` keybinding 
fix(coc): set `suggest.noselect` to true 
fix(color): fix color vader test 
fix(color): update color map 
fix(colorscheme): fix VertSplit highlight 
fix(ctags): fix project_root 
fix(default): use pcall to avoid error 
fix(deoplete): fix deoplete for git-commit 
fix(detach): fix xmake readme 
fix(diff): fix diff mode 
fix(erlang): fix erlang and lsp layers 
fix(flygrep): check if filewritable 
fix(flygrep): clear cmdline after closing flygrep 
fix(flygrep): clear mode when open flygrep 
fix(flygrep): fix grep_stdout function 
fix(flygrep): fix toggle_preview function 
fix(flygrep): include files required for the lua logger api 
fix(flygrep): silent update history 
fix(font): change download font url 
fix(git): add clean.vim 
fix(git): clear std_data when restart command 
fix(git): fix `Git push` command 
fix(gitcommit): fix gitcommit plugin 
fix(gtags): add warning info for executable checking 
fix(iedit): fix handle_register function 
fix(iedit): fix parse_symbol function 
fix(iedit): fix replace_symbol function 
fix(install): fix indentation, remove unnecessary newlines 
fix(install): fix install.sh 
fix(install): remove commands checking 
fix(java): build classpath when switch project 
fix(java): disable neomake when lsp enabled 
fix(java): enable jc2 only when no lsp 
fix(java): fix java layer 
fix(javalsp): disable omni source when lsp enabled 
fix(javalsp): fix jdtls_home 
fix(jc2): fix jc2 classpath 
fix(jedi): fix jedi error 
fix(job): fix job api 
fix(lang#c): disable clangx when lsp enabled 
fix(languagetool): switch to languagetool-5.9 
fix(leader): fix default_custom_leader option 
fix(list): fix default list mode 
fix(logger): fix logger time format 
fix(lsp): type error when loading lsp config (#4701) 
fix(lsp): update lspconfig 
fix(lua): handle missing `guioptions` 
fix(lua): use lua only for neovim 
fix(markdown): fix markdown ftplugin 
fix(mkfontdir): only check for mkfontdir when OS is not Darwin 
fix(neoformat): check tmp_file_path 
fix(neoyank): fix telescope neoyank extension 
fix(nvim-cmp) change source priority 
fix(nvim-cmp): fix broken hotkeys and add tab,s-tab 
fix(nvim-cmp): fix nvim-cmp config 
fix(nvim-cmp): stage missing files 
fix(option): check packpath option 
fix(option): fix for lua removing leading zeros 
fix(projectmanager): change rootdir when switch project 
fix(projectmanager): fix root sort function 
fix(projectmanager): fix rootdir detection for empty buffer 
fix(projectmanager): remove debug info 
fix(projectmanager): remove log info 
fix(projectmanager): skip git:// buffer 
fix(projectmanager): use absolute path 
fix(prompt): fix _build_prompt function 
fix(prompt): fix close logic 
fix(prompt): fix handle function 
fix(prompt): fix lua prompt api 
fix(prompt): fix register matcher 
fix(prompt): implement prompt api 
fix(python): fix python support for neovim 0.7 
fix(startup): fix startify 
fix(status): fix index array 
fix(statusline): fix warning in buffer terminal 
fix(statusline): init statusline separators 
fix(tabline): fix undefined s:lsep variable 
fix(tags): fix ctags/gtags exit function 
fix(todo): fix todo manager sort function 
fix(transient): fix transient_state quit key 
fix(typo): Ket -> Key 
fix(typo): buildin -> builtin 
fix(typo): fix typo in a.lua 
fix(typo): fix typo in flygrep 
fix(typo): fix typo in prompt.lua 
fix(typo): fix typo in r and swift layer 
fix(typo): ldefault -> default 
fix(typo): sinippet -> snippet 
fix(typo): update python guide 
fix(ultisnips): fix ultisnips config 
fix(vim#buffer): fix `vim#buffer` api 
fix(vim): fix vimrc mkdir function 
fix(xdg): fix xdg support 
fix(xmake): fix xmake function name 
fix(zettelkasten): check `layer_isLoaded` before load extension 
perf(a.lua): improve get alt logic 
perf(ctags): improve ctags log 
perf(git): add git command 
perf(git): use git.vim instead of terminal 
perf(git): use normal highlight for non-errors 
perf(git): use notify for `Git add` command 
perf(git): use notify instead of echo 
perf(health): improve layer health checking 
perf(iedit): use getreg instead of eval 
perf(java): change javac display language to en 
perf(lspconfig): update bundle lspconfig 
perf(neoyank): handle errors 
perf(notify): change notify step timer 
perf(projectmanager): improve projectmanager log format 
perf(scrollbar): disable scrollbar for tagbar and defx 
perf(scrollbar): disable scrollbar in git commit buffer 
perf(treesitter): update bundle nvim-treesitter 
refactor(a.lua): remove debug info in parse function 
refactor(a.lua): remove debug log 
revert(treesitter)!: revert treesitter 
style(lsp): format lsp.lua 
test(java): fix java layer test 
test(list): add test for `data.list` api 
test(mkdir): disable undofile option 
test(neovim): add test for nvim 0.7 
test(neovim): remove test for nvim 0.7.1 
typo(website): release 
```

