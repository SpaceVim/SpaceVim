---
title: SpaceVim release v1.6.0
categories: [changelog, blog]
description: "SpaceVim release v1.6.0 with four new language layers and floating window support."
type: article
image: https://img.spacevim.org/103414298-5e1da980-4bb8-11eb-96bc-b2e118f672b5.png
commentsID: "SpaceVim release v1.6.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.6.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New language layers](#new-language-layers)
  - [New Features](#new-features)
  - [Improvements](#improvements)
- [Feature Changes](#feature-changes)
- [Bug Fixs](#bug-fixs)
- [Doc&&Wiki](#docwiki)

<!-- vim-markdown-toc -->


The last release is v1.5.0, After four months development.
The v1.6.0 has been released. So let's take a look at what happened since last relase.

![welcome page](https://img.spacevim.org/103414298-5e1da980-4bb8-11eb-96bc-b2e118f672b5.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New language layers

- Add `lang#sml` layer [#3972](https://github.com/SpaceVim/SpaceVim/pull/3972)

### New Features

- Add vimdoc support in lang#vim layer [#4010](https://github.com/SpaceVim/SpaceVim/pull/4010)
- Add statusline theme for colorscheme one [#3999](https://github.com/SpaceVim/SpaceVim/pull/3999), [#3997](https://github.com/SpaceVim/SpaceVim/pull/3997)
- Add test command for `lang#zig` layer [#3970](https://github.com/SpaceVim/SpaceVim/pull/3970)
- Add splitjoin key bindings [#3956](https://github.com/SpaceVim/SpaceVim/pull/3956)
- Add LSP CodeActions for php and javascript [#3937](https://github.com/SpaceVim/SpaceVim/pull/3937)
- Add random-candidates for colorscheme layer [#3671](https://github.com/SpaceVim/SpaceVim/pull/3671)
- Add language SPC key binding function [#3260](https://github.com/SpaceVim/SpaceVim/pull/3260)
- Add custom register language specific mapping function [#2868](https://github.com/SpaceVim/SpaceVim/pull/2868)
- Add cache major mode [#3076](https://github.com/SpaceVim/SpaceVim/pull/3076)

### Improvements

- Improve terminal support [#3318](https://github.com/SpaceVim/SpaceVim/pull/3318)
- Improve projectmanager [#3489](https://github.com/SpaceVim/SpaceVim/pull/3489)
- Improve `lang#lisp` layer [#3107](https://github.com/SpaceVim/SpaceVim/pull/3107)
- Improve `lang#java` layer [#3954](https://github.com/SpaceVim/SpaceVim/pull/3954)
- Improve `lang#typescript` layer [#3948](https://github.com/SpaceVim/SpaceVim/pull/3948)
- Improve `lang#python` layer [#3947](https://github.com/SpaceVim/SpaceVim/pull/3947)
- Improve `lang#asciidoc` layer [#3556](https://github.com/SpaceVim/SpaceVim/pull/3556)
- Improve tag database manager [#3981](https://github.com/SpaceVim/SpaceVim/pull/3981)
- Improve key binding guide for `g` [#3496](https://github.com/SpaceVim/SpaceVim/pull/3496)
- Ignore `.git` directory for `rg` command [#3996](https://github.com/SpaceVim/SpaceVim/pull/3996)
- Improve tsx support [#3993](https://github.com/SpaceVim/SpaceVim/pull/3993)

## Feature Changes

- Change fortran indent file format [#3975](https://github.com/SpaceVim/SpaceVim/pull/3975)
- Remove useless php plugin [#3979](https://github.com/SpaceVim/SpaceVim/pull/3979)

## Bug Fixs

- Fix `auto_completion_complete_with_key_sequence` option [#3939](https://github.com/SpaceVim/SpaceVim/pull/3939)
- Fix `iskeyword` option for vim script [#3990](https://github.com/SpaceVim/SpaceVim/pull/3990)
- Fix grep command option in ctrlp [#3955](https://github.com/SpaceVim/SpaceVim/pull/3955)
- Fix printf() arguments [#4014](https://github.com/SpaceVim/SpaceVim/pull/4014)
- Fix code runner [#4011](https://github.com/SpaceVim/SpaceVim/pull/4011)
- Fix unknown function gtags#update [#4009](https://github.com/SpaceVim/SpaceVim/pull/4009)
- Fix wrong valuable name [#4008](https://github.com/SpaceVim/SpaceVim/pull/4008)
- Fix compare error [#4001](https://github.com/SpaceVim/SpaceVim/pull/4001)
- Fix file format [#3998](https://github.com/SpaceVim/SpaceVim/pull/3998)
- Fix default root patterns for ctrlp [#3978](https://github.com/SpaceVim/SpaceVim/pull/3978)
- Fix gitstatus not shown in defx [#3973](https://github.com/SpaceVim/SpaceVim/pull/3973)
- Rename OmniSharpFindType to OmniSharpTypeLookup [#3628](https://github.com/SpaceVim/SpaceVim/pull/3628)
- Fix dein-ui detach script [#4018](https://github.com/SpaceVim/SpaceVim/pull/4018)
- Fix g:indentLine_fileTypeExclude option [#3961](https://github.com/SpaceVim/SpaceVim/pull/3961)

## Doc&&Wiki

- Update doc for LangSPC function [#4012](https://github.com/SpaceVim/SpaceVim/pull/4012)
- Update doc for `SPC f /` [#3935](https://github.com/SpaceVim/SpaceVim/pull/3935)
- Update doc for `SPC f Y` [#3983](https://github.com/SpaceVim/SpaceVim/pull/3983)
- Update doc for statusline [#3665](https://github.com/SpaceVim/SpaceVim/pull/3665)
- Update faq page [#3984](https://github.com/SpaceVim/SpaceVim/pull/3984)
- Update file head [#3379](https://github.com/SpaceVim/SpaceVim/pull/3379)
- Update sponsors page [#3942](https://github.com/SpaceVim/SpaceVim/pull/3942)
- Update language guide [#3986](https://github.com/SpaceVim/SpaceVim/pull/3986)
- Update doc for reinstalling plugins [#3992](https://github.com/SpaceVim/SpaceVim/pull/3992)
- Update doc for `lang#sml` layer [#3977](https://github.com/SpaceVim/SpaceVim/pull/3977)
- Update doc for expand-region key bindings [#3952](https://github.com/SpaceVim/SpaceVim/pull/3952)
- Types [#4000](https://github.com/SpaceVim/SpaceVim/pull/4000), [#3488](https://github.com/SpaceVim/SpaceVim/pull/3488)

