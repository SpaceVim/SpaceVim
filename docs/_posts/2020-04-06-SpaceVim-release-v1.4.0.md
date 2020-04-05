---
title: SpaceVim release v1.4.0
categories: [changelog, blog]
excerpt: "SpaceVim release v1.4.0"
type: NewsArticle
image: https://user-images.githubusercontent.com/13142418/78467954-f4fe2800-7744-11ea-8b47-0614ddc5d51b.png
commentsID: "SpaceVim release v1.4.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.4.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New language layers](#new-language-layers)
  - [New features](#new-features)
- [Feature Changes](#feature-changes)
- [Bug Fixs](#bug-fixs)
- [Website && Doc](#website--doc)

<!-- vim-markdown-toc -->


The last release is v1.3.0, After four months development.
The v1.4.0 has been released. So let's take a look at what happened since last relase.

![v1.4.0](https://user-images.githubusercontent.com/13142418/78467954-f4fe2800-7744-11ea-8b47-0614ddc5d51b.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New


### New language layers

- Add lang#vbnet layer [#3359](https://github.com/SpaceVim/SpaceVim/pull/3359)
- Add lang#zig layer [#3355](https://github.com/SpaceVim/SpaceVim/pull/3355)

### New features

The major feature in this release is asynchronously task system, which has been added in following PR:

- Add tasks support [#3346](https://github.com/SpaceVim/SpaceVim/pull/3346)
- Add backgroud task support [#3351](https://github.com/SpaceVim/SpaceVim/pull/3351)
- Add tasks detection [#3374](https://github.com/SpaceVim/SpaceVim/pull/3374)
- Add tasks options cwd support [#3385](https://github.com/SpaceVim/SpaceVim/pull/3385)
- Fix relativeFileDirname in tasks [#3366](https://github.com/SpaceVim/SpaceVim/pull/3366)
- Tasks provider [#3375](https://github.com/SpaceVim/SpaceVim/pull/3375)
- Improve tasks support [#3370](https://github.com/SpaceVim/SpaceVim/pull/3370)

for more information about the tasks system, please checkout the [task documentation](../documentation/#tasks)

Floating terminal windows support also has been added in this release, to use this feature,
adding following snippet into your SpaceVim configuration file:

```toml
[[layers]]
    name = 'shell'
    default_position = 'float'
    default_height = 35
```

- Add float terminal windows support [#3377](https://github.com/SpaceVim/SpaceVim/pull/3377)

Other new key bindings or features will be list following.

- Respect `$XDG_CACHE_HOME` for the cache dir [#3411](https://github.com/SpaceVim/SpaceVim/pull/3411)
- Add shortcut to use NERDCommenterAltDelims [#3417](https://github.com/SpaceVim/SpaceVim/pull/3417)
- add K key binding to documentation [#3415](https://github.com/SpaceVim/SpaceVim/pull/3415)
- Added elixir icons [#3402](https://github.com/SpaceVim/SpaceVim/pull/3402)
- add K binding to Defx [#3401](https://github.com/SpaceVim/SpaceVim/pull/3401)
- Add push script [#3391](https://github.com/SpaceVim/SpaceVim/pull/3391)
- Add `GoFmt` shortcut [#3381](https://github.com/SpaceVim/SpaceVim/pull/3381)
- Add alt file config for plugin a.vim [#3365](https://github.com/SpaceVim/SpaceVim/pull/3365)
- Add option for setting todo labels [#3362](https://github.com/SpaceVim/SpaceVim/pull/3362)
- Add tags support for zig lang [#3357](https://github.com/SpaceVim/SpaceVim/pull/3357)
- Improve rust support [#3430](https://github.com/SpaceVim/SpaceVim/pull/3430)
- Extend permalink clipboard copy support [#3422](https://github.com/SpaceVim/SpaceVim/pull/3422)
- use gopls in rename command for go [#3412](https://github.com/SpaceVim/SpaceVim/pull/3412)
- Improve rust repl support [#3395](https://github.com/SpaceVim/SpaceVim/pull/3395)
- Update Sponsors [#3372](https://github.com/SpaceVim/SpaceVim/pull/3372)

## Feature Changes

- Change max-width [#3361](https://github.com/SpaceVim/SpaceVim/pull/3361)
- Remove plugins [#3352](https://github.com/SpaceVim/SpaceVim/pull/3352)

## Bug Fixs

- Fix git log commands based on git plugin [#3400](https://github.com/SpaceVim/SpaceVim/pull/3400)
- Fix dein support [#3393](https://github.com/SpaceVim/SpaceVim/pull/3393)
- fix some issues on windows [#3387](https://github.com/SpaceVim/SpaceVim/pull/3387)
- Fix layer/lang/go jump to definition issue [#3378](https://github.com/SpaceVim/SpaceVim/pull/3378)
- Fix lint [#3363](https://github.com/SpaceVim/SpaceVim/pull/3363)
- Fix version [#3354](https://github.com/SpaceVim/SpaceVim/pull/3354)


## Website && Doc

- Add blog about code runner and REPL [#2390](https://github.com/SpaceVim/SpaceVim/pull/2390)
- Type in 2018-09-28-use-vim-as-ide.md [#3399](https://github.com/SpaceVim/SpaceVim/pull/3399)
- Typo in documentation [#3396](https://github.com/SpaceVim/SpaceVim/pull/3396)
- Update doc and wiki [#3353](https://github.com/SpaceVim/SpaceVim/pull/3353)
- typo fix [#3373](https://github.com/SpaceVim/SpaceVim/pull/3373)

