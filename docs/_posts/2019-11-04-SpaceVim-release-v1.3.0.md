---
title: SpaceVim release v1.3.0
categories: [changelog, blog]
description: "SpaceVim release v1.3.0"
type: article
image: https://user-images.githubusercontent.com/13142418/68079142-904e4280-fe1f-11e9-993e-b834ea3d39ea.png
commentsID: "SpaceVim release v1.3.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.3.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New layers](#new-layers)
  - [New features](#new-features)
  - [Improvements](#improvements)
- [Pull requests](#pull-requests)
  - [New Features](#new-features-1)
  - [Feature Changes](#feature-changes)
  - [Bug Fixs](#bug-fixs)
  - [Unmarked PRs](#unmarked-prs)

<!-- vim-markdown-toc -->


The last release is v1.2.0, After three months development.
The v1.3.0 has been released. So let's take a look at what happened since last relase.

![v1.3.0](https://user-images.githubusercontent.com/13142418/61462920-0bd9d000-a9a6-11e9-8e1f-c70d6ec6ca1e.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New layers

Since last release, we have added 10 programming language layer:

- [lang#gosu](../layers/lang/gosu/)
- [lang#wolfram](../layers/lang/wolfram/)
- [lang#chapel](../layers/lang/chapel/)
- [lang#foxpro](../layers/lang/foxpro/)
- [lang#idris](../layers/lang/idris/)
- [lang#batch](../layers/lang/batch/)
- [lang#io](../layers/lang/io/)
- [lang#j](../layers/lang/j/)
- [lang#goby](../layers/lang/goby/)
- [lang#assembly](../layers/lang/assembly/)

we also add some function layers:

- [CtrlSpace](../layers/ctrlspace/)


### New features

The following layers have been improved:

- [leaderf](../layers/leaderf/)

### Improvements

- improve the `enable` option when load layer.

```toml
[[layers]]
    name = "denite"
    enable = "has('python3')"
```

- autoscroll the buffer in REPL window.

the REPL buffer will be scrolled automatically.

## Pull requests

here is the list of all the pull requests since last release:

### New Features

- Add key binding to close denite in filter buffer [#3206](https://github.com/SpaceVim/SpaceVim/pull/3206)
- Add CtrlSpace to layers.md [#3182](https://github.com/SpaceVim/SpaceVim/pull/3182)
- Add support for fuzzy find unicode [#3168](https://github.com/SpaceVim/SpaceVim/pull/3168)
- Add key binding to close flygrep [#3166](https://github.com/SpaceVim/SpaceVim/pull/3166)
- Add npm support for building 2 plugins [#3154](https://github.com/SpaceVim/SpaceVim/pull/3154)
- Add test for api [#3135](https://github.com/SpaceVim/SpaceVim/pull/3135)
- Add vim#window api [#3133](https://github.com/SpaceVim/SpaceVim/pull/3133)
- Add lua_foldmethod as lang#lua layer option [#3123](https://github.com/SpaceVim/SpaceVim/pull/3123)
- Add lang#wolfram layer [#3122](https://github.com/SpaceVim/SpaceVim/pull/3122)
- Add lang#chapel layer [#3118](https://github.com/SpaceVim/SpaceVim/pull/3118)
- add: add two new align symbols: # % [#3112](https://github.com/SpaceVim/SpaceVim/pull/3112)
- Add lsp support for crystal [#3108](https://github.com/SpaceVim/SpaceVim/pull/3108)
- Add lang#gosu layer [#3106](https://github.com/SpaceVim/SpaceVim/pull/3106)
- Add option to show hidden files in filetree [#3103](https://github.com/SpaceVim/SpaceVim/pull/3103)
- Add lang#foxpro layer [#3093](https://github.com/SpaceVim/SpaceVim/pull/3093)
- Add command to create pull request [#3091](https://github.com/SpaceVim/SpaceVim/pull/3091)
- Add keybinding for resize defx [#3084](https://github.com/SpaceVim/SpaceVim/pull/3084)
- Add lang#idris layer [#3081](https://github.com/SpaceVim/SpaceVim/pull/3081)
- Add lang#batch layer [#3079](https://github.com/SpaceVim/SpaceVim/pull/3079)
- Add lang#io layer [#3078](https://github.com/SpaceVim/SpaceVim/pull/3078)
- Add a new layer: CtrlSpace (plugin) [#3075](https://github.com/SpaceVim/SpaceVim/pull/3075)
- Add lang#goby layer  [#3055](https://github.com/SpaceVim/SpaceVim/pull/3055)
- Add ~ keybinding for iedit [#3046](https://github.com/SpaceVim/SpaceVim/pull/3046)
- add fname_to_path function [#3043](https://github.com/SpaceVim/SpaceVim/pull/3043)
- add fish script support [#3033](https://github.com/SpaceVim/SpaceVim/pull/3033)
- Add: add new layer lang#j [#3032](https://github.com/SpaceVim/SpaceVim/pull/3032)
- Add vertical split support [#2999](https://github.com/SpaceVim/SpaceVim/pull/2999)
- Add lang#assembly layer [#2979](https://github.com/SpaceVim/SpaceVim/pull/2979)
- Add debug support for powershell [#2961](https://github.com/SpaceVim/SpaceVim/pull/2961)
- Add additional bindings from coc.nvim for c layer [#2967](https://github.com/SpaceVim/SpaceVim/pull/2967)
- Add Leader f f to fzf layer [#2971](https://github.com/SpaceVim/SpaceVim/pull/2971)


### Feature Changes

- change lang#plantuml add a plugin to preivew uml in brower and save pics in disk [#3180](https://github.com/SpaceVim/SpaceVim/pull/3180)
- Change rust.vim [#3173](https://github.com/SpaceVim/SpaceVim/pull/3173)
- change lang#java mapping-gd [#3167](https://github.com/SpaceVim/SpaceVim/pull/3167)
- change lang#java mapping-gd, add a new mapping [#3164](https://github.com/SpaceVim/SpaceVim/pull/3164)
- Change: rename tags layer to gtags layer [#3030](https://github.com/SpaceVim/SpaceVim/pull/3030)
- Change: fix csharp layer and update doc (#2935). [#3007](https://github.com/SpaceVim/SpaceVim/pull/3007)
- Change plugin list plugin [#2446](https://github.com/SpaceVim/SpaceVim/pull/2446)


### Bug Fixs

- Fix split string function [#3201](https://github.com/SpaceVim/SpaceVim/pull/3201)
- fix [SPC]xa[SPC] aligns the entire paragraph instead of selection [#3191](https://github.com/SpaceVim/SpaceVim/pull/3191)
- Fix invalid fileformat of some files (Windows instead Unix).  [#3190](https://github.com/SpaceVim/SpaceVim/pull/3190)
- Fix code runner encoding [#3184](https://github.com/SpaceVim/SpaceVim/pull/3184)
- Fix leaderf mru support [#3171](https://github.com/SpaceVim/SpaceVim/pull/3171)
- Fix job api [#3165](https://github.com/SpaceVim/SpaceVim/pull/3165)
- Fixed typo [#3162](https://github.com/SpaceVim/SpaceVim/pull/3162)
- fix [SPC]bt for defx [#3160](https://github.com/SpaceVim/SpaceVim/pull/3160)
- Fix typo and change wording [#3158](https://github.com/SpaceVim/SpaceVim/pull/3158)
- Fix typo [#3155](https://github.com/SpaceVim/SpaceVim/pull/3155)
- fixed a typo [#3151](https://github.com/SpaceVim/SpaceVim/pull/3151)
- fix completion for :OpenProject, close #3145 [#3146](https://github.com/SpaceVim/SpaceVim/pull/3146)
- Fix lint build vim [#3144](https://github.com/SpaceVim/SpaceVim/pull/3144)
- Fix typo in documentation [#3142](https://github.com/SpaceVim/SpaceVim/pull/3142)
- Fix repl cursor position [#3139](https://github.com/SpaceVim/SpaceVim/pull/3139)
- Fix lint [#3124](https://github.com/SpaceVim/SpaceVim/pull/3124)
- Fix floating windows api [#3119](https://github.com/SpaceVim/SpaceVim/pull/3119)
- Fix title of quickfix statusline [#3113](https://github.com/SpaceVim/SpaceVim/pull/3113)
- Fix NeoSolarized [#3109](https://github.com/SpaceVim/SpaceVim/pull/3109)
- Fix bs in insert mode [#3089](https://github.com/SpaceVim/SpaceVim/pull/3089)
- Fix: add ':nohlsearch' feature to match the documentation. [#3085](https://github.com/SpaceVim/SpaceVim/pull/3085)
- Fix typo in PHP layer documentation [#3080](https://github.com/SpaceVim/SpaceVim/pull/3080)
- Fix search background plugin [#3070](https://github.com/SpaceVim/SpaceVim/pull/3070)
- Fixed typo 'yarked' to 'yanked' [#3059](https://github.com/SpaceVim/SpaceVim/pull/3059)
- Fix keybindings for GitGutter Hunks [#3049](https://github.com/SpaceVim/SpaceVim/pull/3049)
- Fix install script [#3048](https://github.com/SpaceVim/SpaceVim/pull/3048)
- Fixed output error where open file by flyGrep [#3041](https://github.com/SpaceVim/SpaceVim/pull/3041)
- Fix #2897 [#3021](https://github.com/SpaceVim/SpaceVim/pull/3021)
- Fix: fugitive blame [#3006](https://github.com/SpaceVim/SpaceVim/pull/3006)
- fix shortcuts/docs about marking spelling [#3003](https://github.com/SpaceVim/SpaceVim/pull/3003)
- fix typos [#3000](https://github.com/SpaceVim/SpaceVim/pull/3000)
- Fix typo [#2989](https://github.com/SpaceVim/SpaceVim/pull/2989)
- Fix flygrep and vim-todo error [#2983](https://github.com/SpaceVim/SpaceVim/pull/2983)
- Fix matchaddpos api func [#2982](https://github.com/SpaceVim/SpaceVim/pull/2982)
- fix api func matchaddpos [#2977](https://github.com/SpaceVim/SpaceVim/pull/2977)
- fix a map bug cscope [#2952](https://github.com/SpaceVim/SpaceVim/pull/2952)
- Fix: Issue #2948 function call update from deoplete#mappings#smart_close_p… [#2954](https://github.com/SpaceVim/SpaceVim/pull/2954)
- Fix errors in Go layer shortcuts in the documentation [#2955](https://github.com/SpaceVim/SpaceVim/pull/2955)
- fix a map bug cscope [#2953](https://github.com/SpaceVim/SpaceVim/pull/2953)
- Fix typo [#2965](https://github.com/SpaceVim/SpaceVim/pull/2965)
- Fix typo in edit.md [#2970](https://github.com/SpaceVim/SpaceVim/pull/2970)


### Unmarked PRs

- 'enable' of layer configuration supports expression [#3211](https://github.com/SpaceVim/SpaceVim/pull/3211)
- Update language server docs for elm [#3209](https://github.com/SpaceVim/SpaceVim/pull/3209)
- Update elixir layer [#3205](https://github.com/SpaceVim/SpaceVim/pull/3205)
- Support search key with prefix [#3193](https://github.com/SpaceVim/SpaceVim/pull/3193)
- Improve window swapping [#3192](https://github.com/SpaceVim/SpaceVim/pull/3192)
- Improve todo manager [#3185](https://github.com/SpaceVim/SpaceVim/pull/3185)
- Improve windisk info [#3183](https://github.com/SpaceVim/SpaceVim/pull/3183)
- Update chinese community [#3176](https://github.com/SpaceVim/SpaceVim/pull/3176)
- Use deoplete-plugins/deoplete-dictionary instead [#3172](https://github.com/SpaceVim/SpaceVim/pull/3172)
- move [SPC]iu from edit layer to unite layer, and add the same mapping… [#3169](https://github.com/SpaceVim/SpaceVim/pull/3169)
- Update links [#3152](https://github.com/SpaceVim/SpaceVim/pull/3152)
- split feed xml [#3149](https://github.com/SpaceVim/SpaceVim/pull/3149)
- Improve lang#scala layer [#3148](https://github.com/SpaceVim/SpaceVim/pull/3148)
- Buffer api [#3136](https://github.com/SpaceVim/SpaceVim/pull/3136)
- Improve autoscroll feature [#3134](https://github.com/SpaceVim/SpaceVim/pull/3134)
- Scheme guile support [#3127](https://github.com/SpaceVim/SpaceVim/pull/3127)
- Improve the vim api [#3126](https://github.com/SpaceVim/SpaceVim/pull/3126)
- Autoscroll runner and repl windows [#3125](https://github.com/SpaceVim/SpaceVim/pull/3125)
- Update website [#3121](https://github.com/SpaceVim/SpaceVim/pull/3121)
- Improve spacevim.org [#3117](https://github.com/SpaceVim/SpaceVim/pull/3117)
- Doc: fix some typos. [#3116](https://github.com/SpaceVim/SpaceVim/pull/3116)
- Improve doc [#3115](https://github.com/SpaceVim/SpaceVim/pull/3115)
- Improve leaderf layer [#3114](https://github.com/SpaceVim/SpaceVim/pull/3114)
- Preserve Git Hunks while using Github Layer [#3105](https://github.com/SpaceVim/SpaceVim/pull/3105)
- Improve autocomplete layer [#3099](https://github.com/SpaceVim/SpaceVim/pull/3099)
- Improve the statusline for quickfix buffer [#3098](https://github.com/SpaceVim/SpaceVim/pull/3098)
- flygrep replace mode [#3090](https://github.com/SpaceVim/SpaceVim/pull/3090)
- Pythonenable typeinfo [#3088](https://github.com/SpaceVim/SpaceVim/pull/3088)
- Maven [#3087](https://github.com/SpaceVim/SpaceVim/pull/3087)
- Disable issue of github and gitee [#3086](https://github.com/SpaceVim/SpaceVim/pull/3086)
- Colorscheme spacevim [#3074](https://github.com/SpaceVim/SpaceVim/pull/3074)
- Remove listchars setting in guide [#3071](https://github.com/SpaceVim/SpaceVim/pull/3071)
- Set search tools for Grepper [#3069](https://github.com/SpaceVim/SpaceVim/pull/3069)
- Update crystal layer [#3067](https://github.com/SpaceVim/SpaceVim/pull/3067)
- Denite fix [#3066](https://github.com/SpaceVim/SpaceVim/pull/3066)
- Refactor lua initialization [#3065](https://github.com/SpaceVim/SpaceVim/pull/3065)
- deoplete and denite backward compatibility [#3058](https://github.com/SpaceVim/SpaceVim/pull/3058)
- Update hint desc [#3050](https://github.com/SpaceVim/SpaceVim/pull/3050)
- detach iedit plugin [#3047](https://github.com/SpaceVim/SpaceVim/pull/3047)
- urlescape spaces in font names [#3042](https://github.com/SpaceVim/SpaceVim/pull/3042)
- Googlegroups [#3040](https://github.com/SpaceVim/SpaceVim/pull/3040)
- Naming rules [#3037](https://github.com/SpaceVim/SpaceVim/pull/3037)
- Python file head [#3036](https://github.com/SpaceVim/SpaceVim/pull/3036)
- Improve file head support [#3034](https://github.com/SpaceVim/SpaceVim/pull/3034)
- Update cscope layer [#3023](https://github.com/SpaceVim/SpaceVim/pull/3023)
- Ctrlp message [#3022](https://github.com/SpaceVim/SpaceVim/pull/3022)
- Improve: make ctrlp layer works better [#3015](https://github.com/SpaceVim/SpaceVim/pull/3015)
- plugin install failed to call _append_buf_line in WIN10 [#3011](https://github.com/SpaceVim/SpaceVim/pull/3011)
- Update manager.vim [#3010](https://github.com/SpaceVim/SpaceVim/pull/3010)
- Website: Add git-plugin documentation to git layer [#3005](https://github.com/SpaceVim/SpaceVim/pull/3005)
- Comment code block in markdown [#2988](https://github.com/SpaceVim/SpaceVim/pull/2988)
- Make ruby runner support stdin [#2986](https://github.com/SpaceVim/SpaceVim/pull/2986)
- close #2367 [#2978](https://github.com/SpaceVim/SpaceVim/pull/2978)
- Type: change works to work [#2975](https://github.com/SpaceVim/SpaceVim/pull/2975)
- Update erlang layer code owner [#2218](https://github.com/SpaceVim/SpaceVim/pull/2218)
- Introduce lang#nix layer [#2541](https://github.com/SpaceVim/SpaceVim/pull/2541)
- Version [#2956](https://github.com/SpaceVim/SpaceVim/pull/2956)
- Update version to v1.2.0-dev [#2732](https://github.com/SpaceVim/SpaceVim/pull/2732)
- On Windows, send CTRL+r if '+' register is not given [#2950](https://github.com/SpaceVim/SpaceVim/pull/2950)

