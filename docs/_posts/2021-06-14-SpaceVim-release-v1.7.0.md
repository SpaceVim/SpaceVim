---
title: SpaceVim release v1.7.0
categories: [changelog, blog]
description: "SpaceVim release v1.7.0 with four with a number of language layers and new features."
type: article
image: https://img.spacevim.org/121829909-64cb5380-ccf6-11eb-9d5a-f576fa63e69c.png
commentsID: "SpaceVim release v1.7.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.7.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New language layers](#new-language-layers)
  - [New Features](#new-features)
  - [Improvements](#improvements)
- [Feature Changes](#feature-changes)
- [Bug Fixs](#bug-fixs)
- [Doc&&Wiki](#docwiki)

<!-- vim-markdown-toc -->


The last release is v1.6.0, After six months development.
The v1.7.0 has been released. So let's take a look at what happened since last relase.

![welcome page](https://img.spacevim.org/121829909-64cb5380-ccf6-11eb-9d5a-f576fa63e69c.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New language layers

- Add `lang#e` layer [#4210](https://github.com/SpaceVim/SpaceVim/pull/4210)
- Add `lang#fennel` layer [#4260](https://github.com/SpaceVim/SpaceVim/pull/4260)
- Add `lang#autoit` layer [#4181](https://github.com/SpaceVim/SpaceVim/pull/4181)

### New Features

- Add `python3` and `ipython3` support [#4173](https://github.com/SpaceVim/SpaceVim/pull/4173)
- Add key binding `SPC w f` for toggle follow mode [#4201](https://github.com/SpaceVim/SpaceVim/pull/4201)
- Add key binding `m c` [#4199](https://github.com/SpaceVim/SpaceVim/pull/4199)
- Add key binding group `SPC x l` [#4182](https://github.com/SpaceVim/SpaceVim/pull/4182)
- Add `format_on_save` option for `lang#c` layer [#4195](https://github.com/SpaceVim/SpaceVim/pull/4195)
- Add `format_on_save` option for `lang#javascript` [#4183](https://github.com/SpaceVim/SpaceVim/pull/4183)
- Add split flygrep horizontally across vertical split [#4284](https://github.com/SpaceVim/SpaceVim/pull/4284)
- Add file search option [#4245](https://github.com/SpaceVim/SpaceVim/pull/4245)

### Improvements

- Improve `format` layer [#4265](https://github.com/SpaceVim/SpaceVim/pull/4265)
- Improve `lang#dart` layer [#4228](https://github.com/SpaceVim/SpaceVim/pull/4228)
- Improve `lang#php` layer [#4226](https://github.com/SpaceVim/SpaceVim/pull/4226)
- Improve `lang#hy` layer [#4232](https://github.com/SpaceVim/SpaceVim/pull/4232)
- Improve `lang#coffeescript` layer [#4229](https://github.com/SpaceVim/SpaceVim/pull/4229)
- Improve `gtags` layer [#4172](https://github.com/SpaceVim/SpaceVim/pull/4172)
- Improve `cscope` layer [#4171](https://github.com/SpaceVim/SpaceVim/pull/4171)
- Improve tabline and statusline [#4169](https://github.com/SpaceVim/SpaceVim/pull/4169)
- Improve alternate file config [#3493](https://github.com/SpaceVim/SpaceVim/pull/3493)

## Feature Changes

- Change Lint options [#3943](https://github.com/SpaceVim/SpaceVim/pull/3943)
- Remove travis files [#4233](https://github.com/SpaceVim/SpaceVim/pull/4233)
- Disable github issue [#4280](https://github.com/SpaceVim/SpaceVim/pull/4280)
- Check `+python3` first [#4208](https://github.com/SpaceVim/SpaceVim/pull/4208)

## Bug Fixs

- Fix python lint option [#4273](https://github.com/SpaceVim/SpaceVim/pull/4273)
- Fix directory [#4227](https://github.com/SpaceVim/SpaceVim/pull/4227)
- Fix SPC t s/S key binding [#4225](https://github.com/SpaceVim/SpaceVim/pull/4225)
- Fix Objective C language support [#4215](https://github.com/SpaceVim/SpaceVim/pull/4215)
- Fix a typo [#4214](https://github.com/SpaceVim/SpaceVim/pull/4214)
- fix gtags completion and list project files [#4209](https://github.com/SpaceVim/SpaceVim/pull/4209)
- Fix P key binding in defx [#4207](https://github.com/SpaceVim/SpaceVim/pull/4207)
- Fix random theme functionality of the [colorscheme] layer [#4204](https://github.com/SpaceVim/SpaceVim/pull/4204)
- Fix lang#html layer [#4202](https://github.com/SpaceVim/SpaceVim/pull/4202)
- Fix configuration file path [#4200](https://github.com/SpaceVim/SpaceVim/pull/4200)
- Fix ale event [#4230](https://github.com/SpaceVim/SpaceVim/pull/4230)
- Fix SPC T F key binding [#4198](https://github.com/SpaceVim/SpaceVim/pull/4198)
- Fix SPC b d key binding [#4197](https://github.com/SpaceVim/SpaceVim/pull/4197)
- Fix and add the key bindings toggle case [#4190](https://github.com/SpaceVim/SpaceVim/pull/4190)
- Fix uniquify lines in normal mode when ignorecase. [#4189](https://github.com/SpaceVim/SpaceVim/pull/4189)
- Fix SPC x l d in first line [#4185](https://github.com/SpaceVim/SpaceVim/pull/4185)
- Fix choosewin [#4174](https://github.com/SpaceVim/SpaceVim/pull/4174)
- Fix nvim-yarp [#4264](https://github.com/SpaceVim/SpaceVim/pull/4264)

## Doc&&Wiki

- Update doc of `git` layer [#4192](https://github.com/SpaceVim/SpaceVim/pull/4192)
- Update doc of key binding `SPC t h i` [#4184](https://github.com/SpaceVim/SpaceVim/pull/4184)
- Update doc of key binding `m c` [#4178](https://github.com/SpaceVim/SpaceVim/pull/4178)
- Update doc of key binding `.` [#4240](https://github.com/SpaceVim/SpaceVim/pull/4240)
- Update readme [#4282](https://github.com/SpaceVim/SpaceVim/pull/4282)
- Replace the URL of smart questions [#4179](https://github.com/SpaceVim/SpaceVim/pull/4179)
- Update Following head page [#4170](https://github.com/SpaceVim/SpaceVim/pull/4170)
- Update language list [#4203](https://github.com/SpaceVim/SpaceVim/pull/4203)
- Update doc [#4223](https://github.com/SpaceVim/SpaceVim/pull/4223)
- Update doc for SPReinstall [#4212](https://github.com/SpaceVim/SpaceVim/pull/4212)
- Type in doc [#4271](https://github.com/SpaceVim/SpaceVim/pull/4271)
- Update cndoc [#4266](https://github.com/SpaceVim/SpaceVim/pull/4266)
- Update doc [#4246](https://github.com/SpaceVim/SpaceVim/pull/4246)
- Add link to DT [#4281](https://github.com/SpaceVim/SpaceVim/pull/4281)
- Add links to the available git_plugins [#4238](https://github.com/SpaceVim/SpaceVim/pull/4238)
- Add links to the fuzzy finders [#4239](https://github.com/SpaceVim/SpaceVim/pull/4239)
- Add bootstrap function link to quick guide [#4213](https://github.com/SpaceVim/SpaceVim/pull/4213)
- Fix broken link in doc [#4256](https://github.com/SpaceVim/SpaceVim/pull/4256)
- Fix type in docs [#4235](https://github.com/SpaceVim/SpaceVim/pull/4235)
