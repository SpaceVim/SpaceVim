---
title: SpaceVim release v1.0.0
categories: [changelog, blog]
excerpt: "A community-driven modular vim distribution - The ultimate vim configuration"
type: NewsArticle
image: https://user-images.githubusercontent.com/13142418/46079239-277eaa80-c1c9-11e8-845c-8220f6d60af8.png
commentsID: "SpaceVim release v1.0.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.0.0


<!-- vim-markdown-toc GFM -->

- [New features](#new-features)
- [Pull requests list](#pull-requests-list)
  - [Added](#added)
  - [Improvement](#improvement)
  - [Changed](#changed)
  - [Fixed](#fixed)
  - [Removed](#removed)
  - [Doc, Wiki && Website](#doc-wiki--website)

<!-- vim-markdown-toc -->

The first commit of the project is on 2016-12-26, after two years development, the first stable version
of SpaceVim v1.0.0 has been released. so let's take a look at some of the new features in SpaceVim.

![v0.9.0 welcome page](https://user-images.githubusercontent.com/13142418/46079239-277eaa80-c1c9-11e8-845c-8220f6d60af8.png)


## New features

Since last release, SpaceVim has 

## Pull requests list

### Added

- Add unicode#spinners api ([#1926](https://github.com/SpaceVim/SpaceVim/pull/1926))
- Add layer option for autocomplete layer ([#2236](https://github.com/SpaceVim/SpaceVim/pull/2236))
- Add function for customizing searching tools ([#2235](https://github.com/SpaceVim/SpaceVim/pull/2235))
- Add `lang#scheme` layer ([#2248](https://github.com/SpaceVim/SpaceVim/pull/2248))
- Add log for bootstrap function ([#2232](https://github.com/SpaceVim/SpaceVim/pull/2323))
- Add findstr support in flygrep ([#2344](https://github.com/SpaceVim/SpaceVim/pull/2344))
- Add API: `get_sid_from_path` ([#2350](https://github.com/SpaceVim/SpaceVim/pull/2350))

### Improvement

- Update runtime log for startup ([#2219](https://github.com/SpaceVim/SpaceVim/pull/2219))
- Add doc for how run run spacevim in docker ([#2238](https://github.com/SpaceVim/SpaceVim/pull/2238))
- Improve error key bindings ([#2336](https://github.com/SpaceVim/SpaceVim/pull/2336))
- Improve spacevim debug info ([#2349](https://github.com/SpaceVim/SpaceVim/pull/2349))
- Improve cursor eval in `lang#vim` layer ([#2358](https://github.com/SpaceVim/SpaceVim/pull/2358))
- Add more key bindings for typescript ([#2356](https://github.com/SpaceVim/SpaceVim/pull/2356))
- Improve align feature ([#2213](https://github.com/SpaceVim/SpaceVim/pull/2213))

### Changed

- Do not load language layer ([#2220](https://github.com/SpaceVim/SpaceVim/pull/2220))
- Changed the behavior of 2-LeftMouse in vimfiler ([#2221](https://github.com/SpaceVim/SpaceVim/pull/2221))
- Use forked neoformat repo ([#2360](https://github.com/SpaceVim/SpaceVim/pull/2360), [#2355](https://github.com/SpaceVim/SpaceVim/pull/2355))
- Change default font to SauceCodePro ([#2373](https://github.com/SpaceVim/SpaceVim/pull/2373))

### Fixed

- Do not load matchup in old version ([#2324](https://github.com/SpaceVim/SpaceVim/pull/2324))
- Ctrlp support in windows ([#2325](https://github.com/SpaceVim/SpaceVim/pull/2325))
- Fix layers list in windows ([#2327](https://github.com/SpaceVim/SpaceVim/pull/2327))
- Fix statusline icon ([#2328](https://github.com/SpaceVim/SpaceVim/pull/2328))
- Fix vimdoc command in windows ([#2338](https://github.com/SpaceVim/SpaceVim/pull/2338), [#2372](https://github.com/SpaceVim/SpaceVim/pull/2372))
- Fix comment paragraphs key bindings ([#2340](https://github.com/SpaceVim/SpaceVim/pull/2340))
- Fix dein-ui error, add syntax ([#2352](https://github.com/SpaceVim/SpaceVim/pull/2352), [`c9e1d4c`](https://github.com/SpaceVim/SpaceVim/commit/c9e1d4c9635c483bb3334c00ed36026d18950070))
- Fix fullscreen key binding ([#2351](https://github.com/SpaceVim/SpaceVim/pull/2351))
- Added missed syntax for detached FlyGrep ([#2353](https://github.com/SpaceVim/SpaceVim/pull/2353), [`08d0713`](https://github.com/SpaceVim/SpaceVim/commit/08d0713c4494ca401942a6ca10a48a1ac8484ce1))
- Add log for generate configuration file ([#2369](https://github.com/SpaceVim/SpaceVim/pull/2369))
- Fix FlyGrep syntax to support different outputs ([#2363](https://github.com/SpaceVim/SpaceVim/pull/2363), [`0b26f40`](https://github.com/SpaceVim/SpaceVim/commit/0b26f407d879427505418f5c3b4c1d753f3f4317))
- Fix `project_rooter_automatically = 0` option to not change directory to project root ([#2363](https://github.com/SpaceVim/SpaceVim/pull/2365))
- Add log for generate configuration file ([#2369](https://github.com/SpaceVim/SpaceVim/pull/2369))
- Fix flygrep and neovim support in windows os ([#2371](https://github.com/SpaceVim/SpaceVim/pull/2371))

### Removed

### Doc, Wiki && Website

- Online tutorial ([#2004](https://github.com/SpaceVim/SpaceVim/pull/2004))
