---
title: SpaceVim release v1.1.0
categories: [changelog, blog]
excerpt: "A community-driven modular vim distribution - The ultimate vim configuration"
type: NewsArticle
image: https://user-images.githubusercontent.com/13142418/55619929-44c1b080-57cc-11e9-9c6a-8637555c2d6c.png
commentsID: "SpaceVim release v1.1.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.1.0


<!-- vim-markdown-toc GFM -->

- [Release Notes](#release-notes)
    - [New Features](#new-features)
    - [Feature Changes](#feature-changes)
    - [Bug Fixs](#bug-fixs)
    - [Unmarked PRs](#unmarked-prs)

<!-- vim-markdown-toc -->


![v1.1.0 welcome page](https://user-images.githubusercontent.com/13142418/55619929-44c1b080-57cc-11e9-9c6a-8637555c2d6c.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## Release Notes

#### New Features

- Add: add a new key binding 's' for iedit-model. [#2723](https://github.com/SpaceVim/SpaceVim/pull/2723)
- Add fzf menu support [#2718](https://github.com/SpaceVim/SpaceVim/pull/2718)
- Add: option for list number of files on home [#2687](https://github.com/SpaceVim/SpaceVim/pull/2687)
- Add 3 key bindings SPC x t C, SPC x t W, SPC x t L [#2684](https://github.com/SpaceVim/SpaceVim/pull/2684)
- Add rust layer option [#2678](https://github.com/SpaceVim/SpaceVim/pull/2678)
- Add: Count words in select region. [#2675](https://github.com/SpaceVim/SpaceVim/pull/2675)
- add x-mode mapping for tabular [#2644](https://github.com/SpaceVim/SpaceVim/pull/2644)
- Add plugin for git log [#1963](https://github.com/SpaceVim/SpaceVim/pull/1963)
- Add disk explorer for windows [#2165](https://github.com/SpaceVim/SpaceVim/pull/2165)
- Add floating windows support for flygrep [#2216](https://github.com/SpaceVim/SpaceVim/pull/2216)
- Add defx support [#2282](https://github.com/SpaceVim/SpaceVim/pull/2282)

#### Feature Changes

- change nvim floating window API functions [#2710](https://github.com/SpaceVim/SpaceVim/pull/2710)
- change nvim_open_win API function [#2709](https://github.com/SpaceVim/SpaceVim/pull/2709)
- Change windows key binding and improve doc [#2674](https://github.com/SpaceVim/SpaceVim/pull/2674)
- Change plugin list key binding [#2665](https://github.com/SpaceVim/SpaceVim/pull/2665)
- Change markdown preview plugin [#2651](https://github.com/SpaceVim/SpaceVim/pull/2651)

#### Bug Fixs

- fix a typo in doc/SpaceVim.txt [#2717](https://github.com/SpaceVim/SpaceVim/pull/2717)
- fix alias in Docker Hub README.md [#2715](https://github.com/SpaceVim/SpaceVim/pull/2715)
- Fix: add the missing parameter '...' [#2695](https://github.com/SpaceVim/SpaceVim/pull/2695)
- fix defx mapping l and c [#2693](https://github.com/SpaceVim/SpaceVim/pull/2693)
- fix Vimfiler defx support [#2691](https://github.com/SpaceVim/SpaceVim/pull/2691)
- Fix rust layer [#2690](https://github.com/SpaceVim/SpaceVim/pull/2690)
- fix SPC ff via denite file_rec, fix ale, leaderf [#2683](https://github.com/SpaceVim/SpaceVim/pull/2683)
- Fix defx option [#2677](https://github.com/SpaceVim/SpaceVim/pull/2677)
- Fix guide for denite layer [#2676](https://github.com/SpaceVim/SpaceVim/pull/2676)
- fix typo [#2673](https://github.com/SpaceVim/SpaceVim/pull/2673)
- Fix typo of methon [#2668](https://github.com/SpaceVim/SpaceVim/pull/2668)
- Fix shell layer [#2663](https://github.com/SpaceVim/SpaceVim/pull/2663)
- Fix: delete current buffer without confirm [#2654](https://github.com/SpaceVim/SpaceVim/pull/2654)
- Fix guide content [#2649](https://github.com/SpaceVim/SpaceVim/pull/2649)
- Fix debug command [#2226](https://github.com/SpaceVim/SpaceVim/pull/2226)
- Fix perl support [#2230](https://github.com/SpaceVim/SpaceVim/pull/2230)
- Fix preview in flygrep [#2256](https://github.com/SpaceVim/SpaceVim/pull/2256)

#### Unmarked PRs

- Improve iedit mode [#2725](https://github.com/SpaceVim/SpaceVim/pull/2725)
- enhance defx keymap l, choosewin not plugin ChooseWin [#2720](https://github.com/SpaceVim/SpaceVim/pull/2720)
- Doc: fix a markdown sytax error. [#2714](https://github.com/SpaceVim/SpaceVim/pull/2714)
- Improve iedit mode [#2705](https://github.com/SpaceVim/SpaceVim/pull/2705)
- Update denite to use file/rec instead of file_rec [#2702](https://github.com/SpaceVim/SpaceVim/pull/2702)
- website: docs: Update language-server-protocol.md, correct spelling [#2700](https://github.com/SpaceVim/SpaceVim/pull/2700)
- Could we add a lang#processing? [#2696](https://github.com/SpaceVim/SpaceVim/pull/2696)
- Update nerdtree.vim [#2685](https://github.com/SpaceVim/SpaceVim/pull/2685)
- Fix: fix function of SPC f d to match its documentation. [#2682](https://github.com/SpaceVim/SpaceVim/pull/2682)
- Update installation step in lang#go [#2679](https://github.com/SpaceVim/SpaceVim/pull/2679)
- Enable test layer configuration [#2669](https://github.com/SpaceVim/SpaceVim/pull/2669)
- Filetree direction [#2661](https://github.com/SpaceVim/SpaceVim/pull/2661)
- Doc: fix a error in some former commit. [#2660](https://github.com/SpaceVim/SpaceVim/pull/2660)
- Auto close defx windows [#2653](https://github.com/SpaceVim/SpaceVim/pull/2653)
- Improve test layer [#2650](https://github.com/SpaceVim/SpaceVim/pull/2650)
- Enhance folding [#2645](https://github.com/SpaceVim/SpaceVim/pull/2645)
- Doc: add some tweaks on doc instructions [#2056](https://github.com/SpaceVim/SpaceVim/pull/2056)
- Improve startup experience [#1977](https://github.com/SpaceVim/SpaceVim/pull/1977)
- [issue#2367]: clear rootDir cache after rooter pattern changed [#2370](https://github.com/SpaceVim/SpaceVim/pull/2370)
