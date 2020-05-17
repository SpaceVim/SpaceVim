---
title: SpaceVim release v1.4.0
categories: [changelog, blog]
description: "SpaceVim release v1.4.0"
type: article
image: https://user-images.githubusercontent.com/13142418/80494420-3925c680-8999-11ea-9652-21e1e5564148.png
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

![v1.4.0](https://user-images.githubusercontent.com/13142418/80494420-3925c680-8999-11ea-9652-21e1e5564148.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New language layers

Eight programming language layers have been added since the last release:

- Add [`lang#vbnet`](../layers/lang/vbnet/) layer [#3359](https://github.com/SpaceVim/SpaceVim/pull/3359)
- Add [`lang#zig`](../layers/lang/zig/) layer [#3355](https://github.com/SpaceVim/SpaceVim/pull/3355)
- Add `lang#wdl` layer [#3307](https://github.com/SpaceVim/SpaceVim/pull/3307)
- Add [`lang#ring`](../layers/lang/ring/) layer [#3311](https://github.com/SpaceVim/SpaceVim/pull/3311)
- Add [`lang#asepctj`](../layers/lang/asepctj/) layer [#3313](https://github.com/SpaceVim/SpaceVim/pull/3313)
- Add [`lang#lasso`](../layers/lang/lasso/) layer [#3314](https://github.com/SpaceVim/SpaceVim/pull/3314)
- Add `lang#xquery` layer [#3327](https://github.com/SpaceVim/SpaceVim/pull/3327)
- Add [`lang#janet`](../layers/lang/janet/) layer [#3330](https://github.com/SpaceVim/SpaceVim/pull/3330)

### New features

**Asynchronously task:**

The major feature in this release is asynchronously task system, which is implemented in following PR:

- Add tasks support [#3346](https://github.com/SpaceVim/SpaceVim/pull/3346)
- Add backgroud task support [#3351](https://github.com/SpaceVim/SpaceVim/pull/3351)
- Add tasks detection [#3374](https://github.com/SpaceVim/SpaceVim/pull/3374)
- Add tasks options cwd support [#3385](https://github.com/SpaceVim/SpaceVim/pull/3385)
- Fix relativeFileDirname in tasks [#3366](https://github.com/SpaceVim/SpaceVim/pull/3366)
- Tasks provider [#3375](https://github.com/SpaceVim/SpaceVim/pull/3375)
- Improve tasks support [#3370](https://github.com/SpaceVim/SpaceVim/pull/3370)

for more information about the tasks system, please checkout the [task documentation](../documentation/#tasks)

**Floating terminal:**

Floating terminal windows support also has been added into [shell](../layers/shell/) layer, to use this feature,
adding following snippet into your SpaceVim configuration file:

```toml
[[layers]]
    name = 'shell'
    default_position = 'float'
    default_height = 35
```

- Add float terminal windows support [#3377](https://github.com/SpaceVim/SpaceVim/pull/3377)
- Fix shell config path [#3344](https://github.com/SpaceVim/SpaceVim/pull/3344)

**Alternate git plugin:**

Instead of using gina or fugitive, the `git.vim` will be used as default plugin in git layer:

- Add git plugin [#3244](https://github.com/SpaceVim/SpaceVim/pull/3244)
- Improve git support [#3247](https://github.com/SpaceVim/SpaceVim/pull/3247)
- Update branch info via job [#3280](https://github.com/SpaceVim/SpaceVim/pull/3280)

**Alternate file manager:**

The new release also add support for config alt file in the project:

- Add support to config alt file [#3283](https://github.com/SpaceVim/SpaceVim/pull/3283)
- Add type support for alt file [#3308](https://github.com/SpaceVim/SpaceVim/pull/3308)
- Add bang support for `:A` command [#3331](https://github.com/SpaceVim/SpaceVim/pull/3331)

Other new key bindings or features are listed below:

- Add file copy key binding `SPC f Y` [#3348](https://github.com/SpaceVim/SpaceVim/pull/3348)
- Improve `lang#r` layer [#3322](https://github.com/SpaceVim/SpaceVim/pull/3322)
- Respect `$XDG_CACHE_HOME` for the cache dir [#3411](https://github.com/SpaceVim/SpaceVim/pull/3411)
- Add shortcut to use NERDCommenterAltDelims [#3417](https://github.com/SpaceVim/SpaceVim/pull/3417)
- add K key binding to documentation [#3415](https://github.com/SpaceVim/SpaceVim/pull/3415)
- Added elixir icons [#3402](https://github.com/SpaceVim/SpaceVim/pull/3402)
- add K binding to Defx [#3401](https://github.com/SpaceVim/SpaceVim/pull/3401)
- Add push script [#3391](https://github.com/SpaceVim/SpaceVim/pull/3391)
- Add alt file config for plugin a.vim [#3365](https://github.com/SpaceVim/SpaceVim/pull/3365)
- Add option for setting todo labels [#3362](https://github.com/SpaceVim/SpaceVim/pull/3362)
- Add tags support for zig lang [#3357](https://github.com/SpaceVim/SpaceVim/pull/3357)
- Improve rust support [#3430](https://github.com/SpaceVim/SpaceVim/pull/3430)
- Extend permalink clipboard copy support [#3422](https://github.com/SpaceVim/SpaceVim/pull/3422)
- use gopls in rename command for go [#3412](https://github.com/SpaceVim/SpaceVim/pull/3412)
- Improve rust repl support [#3395](https://github.com/SpaceVim/SpaceVim/pull/3395)
- Improve rust layer [#3336](https://github.com/SpaceVim/SpaceVim/pull/3336)
- Update Sponsors [#3372](https://github.com/SpaceVim/SpaceVim/pull/3372)
- Add more key bindings for `lang#ocaml` layer [#3223](https://github.com/SpaceVim/SpaceVim/pull/3223)
- Improve find plugin [#3227](https://github.com/SpaceVim/SpaceVim/pull/3227)
- Highlight long lines [#3228](https://github.com/SpaceVim/SpaceVim/pull/3228)
- Add fzf action key bindings [#3234](https://github.com/SpaceVim/SpaceVim/pull/3234)
- Add repo mirror [#3235](https://github.com/SpaceVim/SpaceVim/pull/3235)
- Add plugin for search in visual mode [#3262](https://github.com/SpaceVim/SpaceVim/pull/3262)
- Add REPL support for typescript [#3274](https://github.com/SpaceVim/SpaceVim/pull/3274)
- Add delete action in denite [#3274](https://github.com/SpaceVim/SpaceVim/pull/3275)
- Improve todo plugin [#3276](https://github.com/SpaceVim/SpaceVim/pull/3276)
- Improve lint [#3291](https://github.com/SpaceVim/SpaceVim/pull/3291)
- Improve `lang#scheme` layer [#3299](https://github.com/SpaceVim/SpaceVim/pull/3299)
- Improve python code runner [#3304](https://github.com/SpaceVim/SpaceVim/pull/3304)
- Improve repl and runner [#3305](https://github.com/SpaceVim/SpaceVim/pull/3305)
- Improve flygrep [#3312](https://github.com/SpaceVim/SpaceVim/pull/3312)
- Improve project manager [#3316](https://github.com/SpaceVim/SpaceVim/pull/3316)
- Add icon to defx [#3320](https://github.com/SpaceVim/SpaceVim/pull/3320)
- Fix run compile command [#3329](https://github.com/SpaceVim/SpaceVim/pull/3329)

## Feature Changes

- Change max-width [#3361](https://github.com/SpaceVim/SpaceVim/pull/3361)
- Remove plugins [#3352](https://github.com/SpaceVim/SpaceVim/pull/3352)
- Use textwidth instead of 80 [#3226](https://github.com/SpaceVim/SpaceVim/pull/3226)

## Bug Fixs

- Fix lsp support [#3338](https://github.com/SpaceVim/SpaceVim/pull/3338)
- Fix git status info on statusline [#3341](https://github.com/SpaceVim/SpaceVim/pull/3341)
- Fix tmux layer [#3342](https://github.com/SpaceVim/SpaceVim/pull/3342)
- Fix git log commands based on git plugin [#3400](https://github.com/SpaceVim/SpaceVim/pull/3400)
- Fix dein support [#3393](https://github.com/SpaceVim/SpaceVim/pull/3393)
- fix some issues on windows [#3387](https://github.com/SpaceVim/SpaceVim/pull/3387)
- Fix layer/lang/go jump to definition issue [#3378](https://github.com/SpaceVim/SpaceVim/pull/3378)
- Fix lint [#3363](https://github.com/SpaceVim/SpaceVim/pull/3363)
- Fix version [#3354](https://github.com/SpaceVim/SpaceVim/pull/3354)
- Silence FlyGrep to avoid hit-enter-prompt [#3215](https://github.com/SpaceVim/SpaceVim/pull/3215)
- Fix vimproc dll pointer [#3238](https://github.com/SpaceVim/SpaceVim/pull/3238)
- Fix R REPL support [#3253](https://github.com/SpaceVim/SpaceVim/pull/3253)
- Fix cursor pos [#3279](https://github.com/SpaceVim/SpaceVim/pull/3279)
- Fix `SPC s a j` [#3281](https://github.com/SpaceVim/SpaceVim/pull/3281)
- Fix code runner [#3292](https://github.com/SpaceVim/SpaceVim/pull/3292)
- Fix shell key bindings [#3293](https://github.com/SpaceVim/SpaceVim/pull/3293)
- Fix lua runtimepath [#3317](https://github.com/SpaceVim/SpaceVim/pull/3317)
- Skip home directory [#3321](https://github.com/SpaceVim/SpaceVim/pull/3321)
- Fix ale repo path [#3345](https://github.com/SpaceVim/SpaceVim/pull/3345)


## Website && Doc

- Add blog about code runner and REPL [#2390](https://github.com/SpaceVim/SpaceVim/pull/2390)
- Add help for `lang#batch` layer [#3230](https://github.com/SpaceVim/SpaceVim/pull/3230)
- Type in 2018-09-28-use-vim-as-ide.md [#3399](https://github.com/SpaceVim/SpaceVim/pull/3399)
- Typo in documentation [#3396](https://github.com/SpaceVim/SpaceVim/pull/3396)
- Update doc and wiki [#3353](https://github.com/SpaceVim/SpaceVim/pull/3353)
- Typo: [#3373](https://github.com/SpaceVim/SpaceVim/pull/3373), [#3225](https://github.com/SpaceVim/SpaceVim/pull/3225)
- Type in go layer [#3272](https://github.com/SpaceVim/SpaceVim/pull/3272)
- Type vim-gik [#3277](https://github.com/SpaceVim/SpaceVim/pull/3277)
- Type [#3284](https://github.com/SpaceVim/SpaceVim/pull/3284)
- Update doc [#3306](https://github.com/SpaceVim/SpaceVim/pull/3306)
- Update wiki [#3310](https://github.com/SpaceVim/SpaceVim/pull/3310)
- Type [#3325](https://github.com/SpaceVim/SpaceVim/pull/3325)
- Update ring doc [#3328](https://github.com/SpaceVim/SpaceVim/pull/3328)
- Improve general doc [#3333](https://github.com/SpaceVim/SpaceVim/pull/3333)
