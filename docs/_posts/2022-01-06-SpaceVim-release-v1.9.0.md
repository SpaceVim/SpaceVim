---
title: SpaceVim release v1.9.0
categories: [changelog, blog]
description: "SpaceVim release v1.9.0 with new features and better experience."
type: article
image: https://img.spacevim.org/148374827-5f7aeaaa-e69b-441e-b872-408b47f4da04.png
commentsID: "SpaceVim release v1.9.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.9.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New Features](#new-features)
  - [Improvements](#improvements)
- [Feature Changes](#feature-changes)
- [Bug Fixs](#bug-fixs)
- [Doc&&Wiki](#docwiki)

<!-- vim-markdown-toc -->

The last release is v1.8.0, After three months development.
The v1.9.0 has been released. So let's take a look at what happened since last relase.

![welcome page](https://img.spacevim.org/148374827-5f7aeaaa-e69b-441e-b872-408b47f4da04.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New Features

- [`55365f64`](https://github.com/SpaceVim/SpaceVim/commit/55365f64) feat(`checkers`): support lsp diagnostic jumping
- [`e8a75bc7`](https://github.com/SpaceVim/SpaceVim/commit/e8a75bc7) feat(`lang#vim`): add `SPC l s` key binding
- [`9d374eaa`](https://github.com/SpaceVim/SpaceVim/commit/9d374eaa) feat(`lang#vim`): add `SPC l x` key binding
- [`c6156bf7`](https://github.com/SpaceVim/SpaceVim/commit/c6156bf7) feat(`lang#vim`): add workspace related key bindings
- [`6dbd9708`](https://github.com/SpaceVim/SpaceVim/commit/6dbd9708) feat(autocomplete): add nvim-cmp support
- [`7c905844`](https://github.com/SpaceVim/SpaceVim/commit/7c905844) feat(bundle#dein): update dein.vim
- [`362485ea`](https://github.com/SpaceVim/SpaceVim/commit/362485ea) feat(bundle#neoformat): Update neoformat from 1a49552c to f1b6cd50
- [`3863ea63`](https://github.com/SpaceVim/SpaceVim/commit/3863ea63) feat(chinese): add key binding to convert Chinese number to digit
- [`516e0525`](https://github.com/SpaceVim/SpaceVim/commit/516e0525) feat(core): update to v1.9.0-dev
- [`83aa15f1`](https://github.com/SpaceVim/SpaceVim/commit/83aa15f1) feat(edit): support fullwidth vertical bar
- [`04e4b3d1`](https://github.com/SpaceVim/SpaceVim/commit/04e4b3d1) feat(format): add vim-codefmt support
- [`5f4b6798`](https://github.com/SpaceVim/SpaceVim/commit/5f4b6798) feat(git): add omnifunc for git commit buffer
- [`1ff40354`](https://github.com/SpaceVim/SpaceVim/commit/1ff40354) feat(help): add help description for `SPC b d`
- [`a15ad8b9`](https://github.com/SpaceVim/SpaceVim/commit/a15ad8b9) feat(help): add key binding to display current time
- [`5c68676c`](https://github.com/SpaceVim/SpaceVim/commit/5c68676c) feat(lang#go): add lsp support for golang
- [`773aa07b`](https://github.com/SpaceVim/SpaceVim/commit/773aa07b) feat(lang#javascript): add more lsp key bindings
- [`2b40c524`](https://github.com/SpaceVim/SpaceVim/commit/2b40c524) feat(lang#julia): add lsp key bindings for julia
- [`aa3deb1f`](https://github.com/SpaceVim/SpaceVim/commit/aa3deb1f) feat(lang#python): add `g D` to jump type definition
- [`309728bc`](https://github.com/SpaceVim/SpaceVim/commit/309728bc) feat(lang#python): add more lsp key bindings
- [`da40455f`](https://github.com/SpaceVim/SpaceVim/commit/da40455f) feat(lang#rust): add more lsp key bindings for rust
- [`0e9127e4`](https://github.com/SpaceVim/SpaceVim/commit/0e9127e4) feat(lang#toml): add `SPC l j` to preview toml
- [`ce7652a7`](https://github.com/SpaceVim/SpaceVim/commit/ce7652a7) feat(lang#vala): add `lang#vala` layer
- [`17626165`](https://github.com/SpaceVim/SpaceVim/commit/17626165) feat(layer): Add vimspector to debug layer
- [`22b663b5`](https://github.com/SpaceVim/SpaceVim/commit/22b663b5) feat(layer): add `treesitter` layer
- [`aa95f233`](https://github.com/SpaceVim/SpaceVim/commit/aa95f233) feat(logger): add clock info
- [`ae098bab`](https://github.com/SpaceVim/SpaceVim/commit/ae098bab) feat(logger): add millisecond info
- [`be7d6130`](https://github.com/SpaceVim/SpaceVim/commit/be7d6130) feat(logger): add syntax highlighting for runtime log
- [`da18ba0a`](https://github.com/SpaceVim/SpaceVim/commit/da18ba0a) feat(lsp): add neovim-lsp (#4319)
- [`cc73d9dd`](https://github.com/SpaceVim/SpaceVim/commit/cc73d9dd) feat(lsp): add vim-language-server command
- [`35bdf0da`](https://github.com/SpaceVim/SpaceVim/commit/35bdf0da) feat(lsp): make SPC e c support to clear diagnostics
- [`5b76a80c`](https://github.com/SpaceVim/SpaceVim/commit/5b76a80c) feat(lsp): use `unicode#box` api to display workspace list
- [`cefb3756`](https://github.com/SpaceVim/SpaceVim/commit/cefb3756) feat(mail): add function to view mail context
- [`5ec1b3be`](https://github.com/SpaceVim/SpaceVim/commit/5ec1b3be) feat(mail): add login & password option
- [`31ab74f8`](https://github.com/SpaceVim/SpaceVim/commit/31ab74f8) feat(mail): add mail layer option
- [`6adb53df`](https://github.com/SpaceVim/SpaceVim/commit/6adb53df) feat(mail): improve vim-mail plugin
- [`fa43ef20`](https://github.com/SpaceVim/SpaceVim/commit/fa43ef20) feat(mail): use bundle vim-mail
- [`c8c232f4`](https://github.com/SpaceVim/SpaceVim/commit/c8c232f4) feat(mapping): add help description for `SPC f s`
- [`3f872452`](https://github.com/SpaceVim/SpaceVim/commit/3f872452) feat(ssh): add `ssh` layer
- [`93d8a153`](https://github.com/SpaceVim/SpaceVim/commit/93d8a153) feat(ssh): change ssh tab name to SSH(user@ip:port)
- [`6ad6022d`](https://github.com/SpaceVim/SpaceVim/commit/6ad6022d) feat(unicode#box, lsp): improve drawing_box() && workspace viewer
- [`fcb9f078`](https://github.com/SpaceVim/SpaceVim/commit/fcb9f078) feat(windisk): add `windisk_encoding` option

### Improvements

- [`afec95b0`](https://github.com/SpaceVim/SpaceVim/commit/afec95b0) pref(a.lua): add debug information
- [`d4597c97`](https://github.com/SpaceVim/SpaceVim/commit/d4597c97) pref(a.vim): change logger level
- [`7916f806`](https://github.com/SpaceVim/SpaceVim/commit/7916f806) pref(chat): improve `chat` layer
- [`c9411f07`](https://github.com/SpaceVim/SpaceVim/commit/c9411f07) pref(chat): improve chat layer
- [`0a89a58d`](https://github.com/SpaceVim/SpaceVim/commit/0a89a58d) pref(guide): format g prefix key binding guide
- [`28393997`](https://github.com/SpaceVim/SpaceVim/commit/28393997) pref(startup): improve startup speed
- [`76d9a53a`](https://github.com/SpaceVim/SpaceVim/commit/76d9a53a) refactor(bundle): update bundle indent-blankline.nvim
- [`e9099b66`](https://github.com/SpaceVim/SpaceVim/commit/e9099b66) refactor(bundle): use bundle helpful.vim
- [`d969cf80`](https://github.com/SpaceVim/SpaceVim/commit/d969cf80) refactor(chat): remove debug function
- [`2e6d1b71`](https://github.com/SpaceVim/SpaceVim/commit/2e6d1b71) refactor(chat): use bundle chatting server
- [`b64b80a2`](https://github.com/SpaceVim/SpaceVim/commit/b64b80a2) refactor(chat): use bundle vim-chat plugin
- [`290dc34d`](https://github.com/SpaceVim/SpaceVim/commit/290dc34d) refactor(custom): format custom.vim && update `:h SpaceVim-functions`
- [`229f66f5`](https://github.com/SpaceVim/SpaceVim/commit/229f66f5) refactor(guide): add `s:get_key_number` function
- [`71fd4db9`](https://github.com/SpaceVim/SpaceVim/commit/71fd4db9) refactor(lang#lua): use bundle vim-lua plugin
- [`d7bdd193`](https://github.com/SpaceVim/SpaceVim/commit/d7bdd193) refactor(logger): use `string.format` instead
- [`a84aa788`](https://github.com/SpaceVim/SpaceVim/commit/a84aa788) style(core): format vim script dictionary
- [`ea07a88b`](https://github.com/SpaceVim/SpaceVim/commit/ea07a88b) style(incsearch): unique key binding description style
- [`72005ed4`](https://github.com/SpaceVim/SpaceVim/commit/72005ed4) style(leaderf): unique key binding description
- [`d0cf0abc`](https://github.com/SpaceVim/SpaceVim/commit/d0cf0abc) style(leaderf): update description of `SPC h i`
- [`524ae813`](https://github.com/SpaceVim/SpaceVim/commit/524ae813) style(lua): add file head
- [`043091c3`](https://github.com/SpaceVim/SpaceVim/commit/043091c3) test(a.lua): add test for a.lua
- [`b12d1890`](https://github.com/SpaceVim/SpaceVim/commit/b12d1890) test(logger): fix logger test
- [`35bb6cb7`](https://github.com/SpaceVim/SpaceVim/commit/35bb6cb7) test(logger): fix logger test
- [`129d538c`](https://github.com/SpaceVim/SpaceVim/commit/129d538c) test(logger): test lua logger only for nvim-0.5.0
- [`bb209b9e`](https://github.com/SpaceVim/SpaceVim/commit/bb209b9e) test(lua): test lua only for nvim-0.5.0
- [`6ce3947d`](https://github.com/SpaceVim/SpaceVim/commit/6ce3947d) chore(copyright): update copyright
- [`a407aff0`](https://github.com/SpaceVim/SpaceVim/commit/a407aff0) chore: add file header to help.vim

## Feature Changes

- [`5d74df04`](https://github.com/SpaceVim/SpaceVim/commit/5d74df04) refactor(autocomplete)!: do not enable nvim-cmp by default
- [`fde8b71b`](https://github.com/SpaceVim/SpaceVim/commit/fde8b71b) refactor(chat)!: change chat windows key binding
- [`b2d1d746`](https://github.com/SpaceVim/SpaceVim/commit/b2d1d746) refactor(fuzzy)!: change key binding `SPC f F`
- [`1f2ce0e6`](https://github.com/SpaceVim/SpaceVim/commit/1f2ce0e6) refactor(lang#lua)!: remove vim-support and add layer options
- [`56b9d14e`](https://github.com/SpaceVim/SpaceVim/commit/56b9d14e) refactor(tools#mpv)!: change default musics_directory
- [`f6ac73b1`](https://github.com/SpaceVim/SpaceVim/commit/f6ac73b1) revert(shell)!: revert key binding `<Esc>` in terminal mode

## Bug Fixs

- [`c32aa6f2`](https://github.com/SpaceVim/SpaceVim/commit/c32aa6f2) fix(`lsp`): fix lsp support in nvim
- [`1e7fbd3f`](https://github.com/SpaceVim/SpaceVim/commit/1e7fbd3f) fix(about): fix typo in about page
- [`5f1a7433`](https://github.com/SpaceVim/SpaceVim/commit/5f1a7433) fix(autocmd): fix colorscheme autocmd
- [`1127b6aa`](https://github.com/SpaceVim/SpaceVim/commit/1127b6aa) fix(bundle): fix bundle ident-blacnkline
- [`07e6c2f9`](https://github.com/SpaceVim/SpaceVim/commit/07e6c2f9) fix(cache): use data_dir for SpaceVim cache
- [`7797732b`](https://github.com/SpaceVim/SpaceVim/commit/7797732b) fix(chat): fix chatting server port
- [`7b77ec76`](https://github.com/SpaceVim/SpaceVim/commit/7b77ec76) fix(chat): fix close windows key binding
- [`41740374`](https://github.com/SpaceVim/SpaceVim/commit/41740374) fix(chat): fix message handler
- [`18dd27e2`](https://github.com/SpaceVim/SpaceVim/commit/18dd27e2) fix(chat): fix server database path
- [`cf1b82ef`](https://github.com/SpaceVim/SpaceVim/commit/cf1b82ef) fix(chat): include test files
- [`6767f4da`](https://github.com/SpaceVim/SpaceVim/commit/6767f4da) fix(checkers): clear lsp diagnostics for normal buffer
- [`6e5bc9da`](https://github.com/SpaceVim/SpaceVim/commit/6e5bc9da) fix(chinese): add function() wrapper
- [`ab91988e`](https://github.com/SpaceVim/SpaceVim/commit/ab91988e) fix(chinese): fix SPC n c d key binding
- [`53e2a5cd`](https://github.com/SpaceVim/SpaceVim/commit/53e2a5cd) fix(colorscheme): fix VertSplit highlight of colorscheme `one`
- [`5f37a401`](https://github.com/SpaceVim/SpaceVim/commit/5f37a401) fix(core): Handle E319 when Vim was built without language support
- [`66b253e9`](https://github.com/SpaceVim/SpaceVim/commit/66b253e9) fix(core): fix neovim-qt welcome page
- [`7f0b6651`](https://github.com/SpaceVim/SpaceVim/commit/7f0b6651) fix(core): fix parser_argv function
- [`05ea303c`](https://github.com/SpaceVim/SpaceVim/commit/05ea303c) fix(debug): fix Undefined variable
- [`a7bedbc5`](https://github.com/SpaceVim/SpaceVim/commit/a7bedbc5) fix(flygrep): fix flygrep replace mode with grep command
- [`63c2bbf5`](https://github.com/SpaceVim/SpaceVim/commit/63c2bbf5) fix(flygrep): fix replace mode of flygrep
- [`cf9b7c08`](https://github.com/SpaceVim/SpaceVim/commit/cf9b7c08) fix(flygrep): save previous windows id
- [`594e0516`](https://github.com/SpaceVim/SpaceVim/commit/594e0516) fix(install): use mklink /J instead
- [`0d2f9082`](https://github.com/SpaceVim/SpaceVim/commit/0d2f9082) fix(lang#c): fix `clang_std` option
- [`7e77fd9f`](https://github.com/SpaceVim/SpaceVim/commit/7e77fd9f) fix(lang#html): fix emmet leader key setting
- [`4e0f3529`](https://github.com/SpaceVim/SpaceVim/commit/4e0f3529) fix(lang#lua): fix unknown variable
- [`3523dd10`](https://github.com/SpaceVim/SpaceVim/commit/3523dd10) fix(lang#markdown): remove g:mkdp_browserfunc
- [`072f7245`](https://github.com/SpaceVim/SpaceVim/commit/072f7245) fix(lang#python): fix g d key binding
- [`5d9a0975`](https://github.com/SpaceVim/SpaceVim/commit/5d9a0975) fix(lang#python): fix typo in coverage key bindings
- [`6ecba06f`](https://github.com/SpaceVim/SpaceVim/commit/6ecba06f) fix(lang#ruby): fix typo in layer doc
- [`43fc0e8d`](https://github.com/SpaceVim/SpaceVim/commit/43fc0e8d) fix(lang#vim): fix `lang#vim` layer key bindings
- [`5c63ce1f`](https://github.com/SpaceVim/SpaceVim/commit/5c63ce1f) fix(logger): add `SpaceVim#logger#debug` function
- [`da2f51ec`](https://github.com/SpaceVim/SpaceVim/commit/da2f51ec) fix(logger): add reltimefloat compatible api
- [`76428f5d`](https://github.com/SpaceVim/SpaceVim/commit/76428f5d) fix(logger): fix logger api
- [`5cd0cb78`](https://github.com/SpaceVim/SpaceVim/commit/5cd0cb78) fix(logger): fix logger debug function
- [`0eb3ee0f`](https://github.com/SpaceVim/SpaceVim/commit/0eb3ee0f) fix(logger): fix logger debug levels
- [`82d36bb8`](https://github.com/SpaceVim/SpaceVim/commit/82d36bb8) fix(lsp): avoid unknown function error
- [`81f8ce0d`](https://github.com/SpaceVim/SpaceVim/commit/81f8ce0d) fix(lsp): fix lsp key binding
- [`0bcec61d`](https://github.com/SpaceVim/SpaceVim/commit/0bcec61d) fix(lua): fix lua logger api
- [`17aac814`](https://github.com/SpaceVim/SpaceVim/commit/17aac814) fix(mail): fix date format
- [`1cc4282c`](https://github.com/SpaceVim/SpaceVim/commit/1cc4282c) fix(mail): fix mail logger
- [`a41fc80e`](https://github.com/SpaceVim/SpaceVim/commit/a41fc80e) fix(ssh): fix layer test
- [`8e418318`](https://github.com/SpaceVim/SpaceVim/commit/8e418318) fix(tabline): fix tabline fold
- [`8be152b4`](https://github.com/SpaceVim/SpaceVim/commit/8be152b4) fix(toml): fix toml json preview plugin
- [`57211cc4`](https://github.com/SpaceVim/SpaceVim/commit/57211cc4) fix(treesitter): fix layer test
- [`4a2e19fa`](https://github.com/SpaceVim/SpaceVim/commit/4a2e19fa) fix(windisk): fix `s:open_disk` function

## Doc&&Wiki

- [`db34307c`](https://github.com/SpaceVim/SpaceVim/commit/db34307c) doc(`lsp`): update `lsp` layer doc
- [`fde91a54`](https://github.com/SpaceVim/SpaceVim/commit/fde91a54) doc(bundle): update plugin list
- [`3895d205`](https://github.com/SpaceVim/SpaceVim/commit/3895d205) docs(api): add `:h SpaceVim-api-time`
- [`e6626bdd`](https://github.com/SpaceVim/SpaceVim/commit/e6626bdd) docs(api): update `:h SpaceVim-api-vim-message`
- [`cd033dd3`](https://github.com/SpaceVim/SpaceVim/commit/cd033dd3) docs(chat): add `:h SpaceVim-layers-chat`
- [`447728eb`](https://github.com/SpaceVim/SpaceVim/commit/447728eb) docs(community): update link of slack and telegram
- [`b74dd23e`](https://github.com/SpaceVim/SpaceVim/commit/b74dd23e) docs(ctrlp): add `:h SpaceVim-layers-ctrlp`
- [`5e86c24c`](https://github.com/SpaceVim/SpaceVim/commit/5e86c24c) docs(debug): add `:h SpaceVim-layers-debug`
- [`81cc0b67`](https://github.com/SpaceVim/SpaceVim/commit/81cc0b67) docs(dev): add commit style guide for breaking changes
- [`48009e8a`](https://github.com/SpaceVim/SpaceVim/commit/48009e8a) docs(dev): update commit style guide
- [`e5f77cc3`](https://github.com/SpaceVim/SpaceVim/commit/e5f77cc3) docs(documentation): translate cn documentation page
- [`eae76b84`](https://github.com/SpaceVim/SpaceVim/commit/eae76b84) docs(documentation): update doc for key binding `Leader y/Y`
- [`abbc14e1`](https://github.com/SpaceVim/SpaceVim/commit/abbc14e1) docs(format): update `:h SpaceVim-layers-format`
- [`d5d2f1e0`](https://github.com/SpaceVim/SpaceVim/commit/d5d2f1e0) docs(incsearch): update `:h SpaceVim-layers-incsearch`
- [`5b6e41f1`](https://github.com/SpaceVim/SpaceVim/commit/5b6e41f1) docs(lang#c): typo in clang example
- [`c5ca267e`](https://github.com/SpaceVim/SpaceVim/commit/c5ca267e) docs(lang#html): fix layer option demo
- [`26baf7c2`](https://github.com/SpaceVim/SpaceVim/commit/26baf7c2) docs(lang#markdown): update `:h SpaceVim-layers-lang-markdown`
- [`d6e74047`](https://github.com/SpaceVim/SpaceVim/commit/d6e74047) docs(lang#puppet): update puppet layer doc
- [`b07f2287`](https://github.com/SpaceVim/SpaceVim/commit/b07f2287) docs(lang#python): update lsp doc for python
- [`d85912c1`](https://github.com/SpaceVim/SpaceVim/commit/d85912c1) docs(lang#typescript): add doc for `SPC l g d`
- [`db8ea76c`](https://github.com/SpaceVim/SpaceVim/commit/db8ea76c) docs(lang#vala): correct language name in doc
- [`f8280b55`](https://github.com/SpaceVim/SpaceVim/commit/f8280b55) docs(layer): fix simple typo
- [`0cdc0d6d`](https://github.com/SpaceVim/SpaceVim/commit/0cdc0d6d) docs(layers): add doc for loading layer with layer option
- [`f022462a`](https://github.com/SpaceVim/SpaceVim/commit/f022462a) docs(layers): update `:h SpaceVim-layers`
- [`d4e4fc27`](https://github.com/SpaceVim/SpaceVim/commit/d4e4fc27) docs(lsp): update `:h SpaceVim-layers-lsp`
- [`b436b983`](https://github.com/SpaceVim/SpaceVim/commit/b436b983) docs(quick-start): update cn quick start guide
- [`eefef8f7`](https://github.com/SpaceVim/SpaceVim/commit/eefef8f7) docs(sponsors): add opencollective
- [`6132f96d`](https://github.com/SpaceVim/SpaceVim/commit/6132f96d) docs(sponsors): remove BountySource and opencollective
- [`ecfb31c0`](https://github.com/SpaceVim/SpaceVim/commit/ecfb31c0) docs(sponsors): update sponsors page
- [`950c2ad2`](https://github.com/SpaceVim/SpaceVim/commit/950c2ad2) docs(sponsors): update sponsors page
- [`15ccffea`](https://github.com/SpaceVim/SpaceVim/commit/15ccffea) docs(sponsors): update wechat image
- [`2ae9a354`](https://github.com/SpaceVim/SpaceVim/commit/2ae9a354) docs(ssh): update ssh layer page
- [`bcd4e755`](https://github.com/SpaceVim/SpaceVim/commit/bcd4e755) docs(usage): add `:h SpaceVim-usage-command-line-mode`
- [`cd2fee0a`](https://github.com/SpaceVim/SpaceVim/commit/cd2fee0a) docs(usage): add `:h SpaceVim-usage-search-and-replace`
- [`7f417074`](https://github.com/SpaceVim/SpaceVim/commit/7f417074) docs(usage): add `:h SpaceVim-usage-windows-and-tabs`
- [`b014a7e6`](https://github.com/SpaceVim/SpaceVim/commit/b014a7e6) docs(vim#window): fix type in `:h SpaceVim-api-vim-window`
- [`e8d636c7`](https://github.com/SpaceVim/SpaceVim/commit/e8d636c7) docs(website): add doc about hide file tree by default
- [`52c76a11`](https://github.com/SpaceVim/SpaceVim/commit/52c76a11) docs(website): update custom_plugins document
- [`689fafcc`](https://github.com/SpaceVim/SpaceVim/commit/689fafcc) docs(wiki): update following HEAD page
