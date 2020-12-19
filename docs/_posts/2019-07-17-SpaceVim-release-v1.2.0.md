---
title: SpaceVim release v1.2.0
categories: [changelog, blog]
description: "SpaceVim release v1.2.0 with 12 new programming language layers and ton of bug fixs and new features."
type: article
image: https://user-images.githubusercontent.com/13142418/61462920-0bd9d000-a9a6-11e9-8e1f-c70d6ec6ca1e.png
commentsID: "SpaceVim release v1.2.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.2.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [async todo manager](#async-todo-manager)
- [Release Notes](#release-notes)
    - [New Features](#new-features)
    - [Feature Changes](#feature-changes)
    - [Bug Fixs](#bug-fixs)
    - [Unmarked PRs](#unmarked-prs)
- [call for collaborators](#call-for-collaborators)

<!-- vim-markdown-toc -->


The last release is v1.1.0, After three months development.
The v1.2.0 has been released. So let's take a look at what happened since last relase.

![v1.2.0](https://user-images.githubusercontent.com/13142418/61462920-0bd9d000-a9a6-11e9-8e1f-c70d6ec6ca1e.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

Since last release, we have added 13 programming language layer:

- [lang#d](../layers/lang/d/)
- [lang#groovy](../layers/lang/groovy/)
- [lang#hack](../layers/lang/hack/)
- [lang#hy](../layers/lang/hy/)
- [lang#livescript](../layers/lang/livescript/)
- [lang#matlab](../layers/lang/matlab/)
- [lang#pact](../layers/lang/pact/)
- [lang#pascal](../layers/lang/pascal/)
- [lang#prolog](../layers/lang/prolog/)
- [lang#powershell](../layers/lang/powershell/)
- [lang#sql](../layers/lang/sql/)
- [lang#tcl](../layers/lang/tcl/)
- [lang#v](../layers/lang/v/)


In addition to the new layers mentioned above, some new features have been added to the latest release:

### async todo manager

In old version of SpaceVim, the todo manager can be used only when develop SpaceVim, now it has been merged into SpaceVim core repo,
the default key binding is `SPC a o`, and the default tags is: `'fixme', 'question', 'todo', 'idea'`

- improve the code runner, show terminal colors


## Release Notes

here is the list of all the pull requests since last release:

#### New Features

- Add lang#hack layer [#2941](https://github.com/SpaceVim/SpaceVim/pull/2941)
- Add select lines feature [#2937](https://github.com/SpaceVim/SpaceVim/pull/2937)
- Add vcs conflict marker unimpaired binding [#2932](https://github.com/SpaceVim/SpaceVim/pull/2932)
- Add lang#d layer [#2923](https://github.com/SpaceVim/SpaceVim/pull/2923)
- Add doc for lang#powershell layer [#2920](https://github.com/SpaceVim/SpaceVim/pull/2920)
- Add lang#livescript layer [#2913](https://github.com/SpaceVim/SpaceVim/pull/2913)
- Add lang#hy layer [#2909](https://github.com/SpaceVim/SpaceVim/pull/2909)
- Add lang#pact layer [#2907](https://github.com/SpaceVim/SpaceVim/pull/2907)
- Add lang#prolog layer [#2905](https://github.com/SpaceVim/SpaceVim/pull/2905)
- Add lang#matlab layer [#2903](https://github.com/SpaceVim/SpaceVim/pull/2903)
- Add lang#tcl layer [#2902](https://github.com/SpaceVim/SpaceVim/pull/2902)
- Add lang#groovy layer [#2901](https://github.com/SpaceVim/SpaceVim/pull/2901)
- Add lang#v layer [#2899](https://github.com/SpaceVim/SpaceVim/pull/2899)
- Add lang#pascal layer [#2893](https://github.com/SpaceVim/SpaceVim/pull/2893)
- add color support in runner [#2890](https://github.com/SpaceVim/SpaceVim/pull/2890)
- Add coverage commands for python [#2866](https://github.com/SpaceVim/SpaceVim/pull/2866)
- Add vedio [#2862](https://github.com/SpaceVim/SpaceVim/pull/2862)
- Add sidebar [#2016](https://github.com/SpaceVim/SpaceVim/pull/2016)
- Add lang#sql layer [#2092](https://github.com/SpaceVim/SpaceVim/pull/2092)
- Add support for ydcv [#2150](https://github.com/SpaceVim/SpaceVim/pull/2150)
- Add the video tutorial [#2164](https://github.com/SpaceVim/SpaceVim/pull/2164)
- Add plugin to generate Chinese and English help [#2337](https://github.com/SpaceVim/SpaceVim/pull/2337)
- Add neovim#gui api [#2368](https://github.com/SpaceVim/SpaceVim/pull/2368)
- Add go post [#2429](https://github.com/SpaceVim/SpaceVim/pull/2429)
- Add srcery colorscheme [#2526](https://github.com/SpaceVim/SpaceVim/pull/2526)
- Add layer option for git layer [#2583](https://github.com/SpaceVim/SpaceVim/pull/2583)

#### Feature Changes

- Change layer list [#2331](https://github.com/SpaceVim/SpaceVim/pull/2331)

#### Bug Fixs

- Fix SPC j S for cpp [#2929](https://github.com/SpaceVim/SpaceVim/pull/2929)
- Fix todo manager [#2904](https://github.com/SpaceVim/SpaceVim/pull/2904)
- Fix: Replace 'conceal' with 'conceallevel' to make it more readable. [#2889](https://github.com/SpaceVim/SpaceVim/pull/2889)
- Fix SPC f y key binding [#2883](https://github.com/SpaceVim/SpaceVim/pull/2883)
- Fix ctrlp config [#2879](https://github.com/SpaceVim/SpaceVim/pull/2879)
- Fix multiple cursor [#1993](https://github.com/SpaceVim/SpaceVim/pull/1993)
- Fix json API [#2131](https://github.com/SpaceVim/SpaceVim/pull/2131)
- Fixed: ChineseLinter.vim should not be loaded for all file types. [#2534](https://github.com/SpaceVim/SpaceVim/pull/2534)
- Fix highlight mode [#2652](https://github.com/SpaceVim/SpaceVim/pull/2652)

#### Unmarked PRs

- Doc help [#2945](https://github.com/SpaceVim/SpaceVim/pull/2945)
- Detech todo [#2943](https://github.com/SpaceVim/SpaceVim/pull/2943)
- Improve todo manager [#2942](https://github.com/SpaceVim/SpaceVim/pull/2942)
- Improve lang#pony layer [#2931](https://github.com/SpaceVim/SpaceVim/pull/2931)
- Update todo manager [#2930](https://github.com/SpaceVim/SpaceVim/pull/2930)
- Vlang repl [#2928](https://github.com/SpaceVim/SpaceVim/pull/2928)
- Add repl support for d lang [#2924](https://github.com/SpaceVim/SpaceVim/pull/2924)
- Improve lang#powershell layer [#2918](https://github.com/SpaceVim/SpaceVim/pull/2918)
- Improve vader test [#2916](https://github.com/SpaceVim/SpaceVim/pull/2916)
- Livescript2 [#2915](https://github.com/SpaceVim/SpaceVim/pull/2915)
- Improve searching histroy completion in flygrep [#2888](https://github.com/SpaceVim/SpaceVim/pull/2888)
- Racket needs `rainbow_parentheses` too [#2885](https://github.com/SpaceVim/SpaceVim/pull/2885)
- Update Copyright [#2878](https://github.com/SpaceVim/SpaceVim/pull/2878)
- feat(dash.vim): add devdocs support with (devdocs.vim) [#2875](https://github.com/SpaceVim/SpaceVim/pull/2875)
- Remove some code && fix windows support [#2874](https://github.com/SpaceVim/SpaceVim/pull/2874)
- Improve plugin manager [#2873](https://github.com/SpaceVim/SpaceVim/pull/2873)
- Remove zvim [#2867](https://github.com/SpaceVim/SpaceVim/pull/2867)
- Better deafult [#2865](https://github.com/SpaceVim/SpaceVim/pull/2865)
- Improve siganture api [#2255](https://github.com/SpaceVim/SpaceVim/pull/2255)

## call for collaborators

At present, SpaceVim contains more than 70 programming language layers.
We hope that each programming language layer can be maintained by someone who is familiar with the language.
If you are interested in SpaceVim and want to improve the performance of a language layer,
you can join us in maintaining this project.
