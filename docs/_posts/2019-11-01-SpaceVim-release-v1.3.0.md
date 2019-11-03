---
title: SpaceVim release v1.3.0
categories: [changelog, blog]
excerpt: "SpaceVim release v1.3.0"
type: NewsArticle
image: https://user-images.githubusercontent.com/13142418/68079142-904e4280-fe1f-11e9-993e-b834ea3d39ea.png
commentsID: "SpaceVim release v1.3.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.3.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
- [Release Notes](#release-notes)
  - [New Features](#new-features)
  - [Feature Changes](#feature-changes)
  - [Bug Fixs](#bug-fixs)
  - [Unmarked PRs](#unmarked-prs)

<!-- vim-markdown-toc -->


The last release is v1.2.0, After three months development.
The v1.2.0 has been released. So let's take a look at what happened since last relase.

![v1.3.0](https://user-images.githubusercontent.com/13142418/61462920-0bd9d000-a9a6-11e9-8e1f-c70d6ec6ca1e.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

Since last release, we have added 13 programming language layer:

## Release Notes

here is the list of all the pull requests since last release:

### New Features

- Add debug support for powershell [#2961](https://github.com/SpaceVim/SpaceVim/pull/2961)
- Add additional bindings from coc.nvim for c layer [#2967](https://github.com/SpaceVim/SpaceVim/pull/2967)
- Add Leader f f to fzf layer [#2971](https://github.com/SpaceVim/SpaceVim/pull/2971)


### Feature Changes

- Change plugin list plugin [#2446](https://github.com/SpaceVim/SpaceVim/pull/2446)


### Bug Fixs

- fix a map bug cscope [#2952](https://github.com/SpaceVim/SpaceVim/pull/2952)
- Fix: Issue #2948 function call update from deoplete#mappings#smart_close_p… [#2954](https://github.com/SpaceVim/SpaceVim/pull/2954)
- Fix errors in Go layer shortcuts in the documentation [#2955](https://github.com/SpaceVim/SpaceVim/pull/2955)
- fix a map bug cscope [#2953](https://github.com/SpaceVim/SpaceVim/pull/2953)
- Fix typo [#2965](https://github.com/SpaceVim/SpaceVim/pull/2965)
- Fix typo in edit.md [#2970](https://github.com/SpaceVim/SpaceVim/pull/2970)


### Unmarked PRs

- Update erlang layer code owner [#2218](https://github.com/SpaceVim/SpaceVim/pull/2218)
- Introduce lang#nix layer [#2541](https://github.com/SpaceVim/SpaceVim/pull/2541)
- Version [#2956](https://github.com/SpaceVim/SpaceVim/pull/2956)
- Update version to v1.2.0-dev [#2732](https://github.com/SpaceVim/SpaceVim/pull/2732)
- On Windows, send CTRL+r if '+' register is not given [#2950](https://github.com/SpaceVim/SpaceVim/pull/2950)
In old version of SpaceVim, the todo manager can be used only when develop SpaceVim, now it has been merged into SpaceVim core repo,
the default key binding is `SPC a o`, and the default tags is: `'fixme', 'question', 'todo', 'idea'`

- improve the code runner, show terminal colors


