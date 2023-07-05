---
title: SpaceVim release v1.8.0
categories: [changelog, blog]
description: "SpaceVim release v1.8.0 with lua plugins enabled and better experience."
type: article
image: https://img.spacevim.org/135842225-addb0f53-7520-4a8b-bdd2-c4f7e98b3253.png
commentsID: "SpaceVim release v1.8.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v1.8.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New Features](#new-features)
  - [Improvements](#improvements)
- [Feature Changes](#feature-changes)
- [Bug Fixs](#bug-fixs)
- [Doc&&Wiki](#docwiki)

<!-- vim-markdown-toc -->


The last release is v1.7.0, After three months development.
The v1.8.0 has been released. So let's take a look at what happened since last relase.

![welcome page](https://img.spacevim.org/135842225-addb0f53-7520-4a8b-bdd2-c4f7e98b3253.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New Features

- [`81e58fdd`](https://github.com/SpaceVim/SpaceVim/commit/81e58fdd) Rewrite plugin `a.vim` in lua (#4390)
- [`b518b77e`](https://github.com/SpaceVim/SpaceVim/commit/b518b77e) Add lua projectmanager (#4401)
- [`7b4ae22d`](https://github.com/SpaceVim/SpaceVim/commit/7b4ae22d) Add lua evn (#4400)
- [`b80606ae`](https://github.com/SpaceVim/SpaceVim/commit/b80606ae) Add `SPC j c` key binding (#4443)
- [`ca70bd8e`](https://github.com/SpaceVim/SpaceVim/commit/ca70bd8e) Add key binding `SPC p F` (#4309)
- [`38496452`](https://github.com/SpaceVim/SpaceVim/commit/38496452) Add lua logger api (#4395)
- [`5fe3d09b`](https://github.com/SpaceVim/SpaceVim/commit/5fe3d09b) Add lua file api (#4391)
- [`66f3306a`](https://github.com/SpaceVim/SpaceVim/commit/66f3306a) Add lua `system` api & test (#4392)
- [`c7eb99d6`](https://github.com/SpaceVim/SpaceVim/commit/c7eb99d6) Add wrap_line option (#4291)
- [`487f4fa5`](https://github.com/SpaceVim/SpaceVim/commit/487f4fa5) Add Git mv command (#4350)
- [`697fec62`](https://github.com/SpaceVim/SpaceVim/commit/697fec62) Add `Git rm` command (#4347)
- [`c151563b`](https://github.com/SpaceVim/SpaceVim/commit/c151563b) Add Git remote command (#4371)
- [`8f742f30`](https://github.com/SpaceVim/SpaceVim/commit/8f742f30) Add spacevim lua logger (#4398)
- [`3b455c1b`](https://github.com/SpaceVim/SpaceVim/commit/3b455c1b) Add option for disable smooth scrolling & fix css (#4387)
- [`061de45b`](https://github.com/SpaceVim/SpaceVim/commit/061de45b) Add smooth scrolling key bindings (#4386)
- [`bb7a5480`](https://github.com/SpaceVim/SpaceVim/commit/bb7a5480) Use indent-blankline for neovim (#4325)
- [`8dc62173`](https://github.com/SpaceVim/SpaceVim/commit/8dc62173) Add option to hilight cursorword (#4385)

### Improvements

- [`2d6bfd39`](https://github.com/SpaceVim/SpaceVim/commit/2d6bfd39) Improve notify api (#4355)
- [`5c8e9ac7`](https://github.com/SpaceVim/SpaceVim/commit/5c8e9ac7) Improve cscope layer (#4418)
- [`bcb92d75`](https://github.com/SpaceVim/SpaceVim/commit/bcb92d75) Use cc instead of cnext (#4416)
- [`5ed892fe`](https://github.com/SpaceVim/SpaceVim/commit/5ed892fe) Add --no-fonts option (#4415)
- [`a45a8242`](https://github.com/SpaceVim/SpaceVim/commit/a45a8242) feat(layer): add julia code formattor
- [`553749f5`](https://github.com/SpaceVim/SpaceVim/commit/553749f5) feat(layer): use notify api in `lang#vim` layer
- [`e098ae34`](https://github.com/SpaceVim/SpaceVim/commit/e098ae34) feat(core): add `code_runner_focus` option
- [`71d78fae`](https://github.com/SpaceVim/SpaceVim/commit/71d78fae) feat(layer): add `enable_tmux_clipboard` option
- [`a3197351`](https://github.com/SpaceVim/SpaceVim/commit/a3197351) add(core): add key binding to toggle auto parens mode
- [`65816f22`](https://github.com/SpaceVim/SpaceVim/commit/65816f22) feat(unite): improve `unite` layer
- [`03b62e1a`](https://github.com/SpaceVim/SpaceVim/commit/03b62e1a) feat(layer): add `open_quickfix` layer option
- [`6a1437f4`](https://github.com/SpaceVim/SpaceVim/commit/6a1437f4) feat(layer): add layer option for filetree columns
- [`5866f07b`](https://github.com/SpaceVim/SpaceVim/commit/5866f07b) feat: use relative path for `SPC f s`
- [`68e12344`](https://github.com/SpaceVim/SpaceVim/commit/68e12344) Update `core` layer (#4467)
- [`654cfc88`](https://github.com/SpaceVim/SpaceVim/commit/654cfc88) feat(core): add `SPC h g/G` to run helpgrep asynchronously
- [`bdc0101b`](https://github.com/SpaceVim/SpaceVim/commit/bdc0101b) feat(core): Add `SPC f a` key binding to save as new file
- [`1bbc24ea`](https://github.com/SpaceVim/SpaceVim/commit/1bbc24ea) feat(plugins): Do not open quickfix list when only one entry
- [`dd6c9db1`](https://github.com/SpaceVim/SpaceVim/commit/dd6c9db1) Add -f flag (#4459)
- [`05e45fc0`](https://github.com/SpaceVim/SpaceVim/commit/05e45fc0) Improve `ui` layer (#4455)
- [`943d34a1`](https://github.com/SpaceVim/SpaceVim/commit/943d34a1) Add option for emmet (#4451)
- [`cd295362`](https://github.com/SpaceVim/SpaceVim/commit/cd295362) Fork neoformat (#4290)
- [`f4dd68db`](https://github.com/SpaceVim/SpaceVim/commit/f4dd68db) Update lang#html layer to install emmet for ERB (#4287)
- [`46869748`](https://github.com/SpaceVim/SpaceVim/commit/46869748) Use splitjoin to open line (#4442)
- [`12e19d8d`](https://github.com/SpaceVim/SpaceVim/commit/12e19d8d) Tabmanager name (#4427)
- [`15f1765a`](https://github.com/SpaceVim/SpaceVim/commit/15f1765a) feat(dev): add tesk to generate vim doc

## Feature Changes

- [`39bf31c4`](https://github.com/SpaceVim/SpaceVim/commit/39bf31c4) Change default filetree to nerdtree (#4464)
- [`caa54d32`](https://github.com/SpaceVim/SpaceVim/commit/caa54d32) Change filetree gitstatus option name (#4465)
- [`483e3c0e`](https://github.com/SpaceVim/SpaceVim/commit/483e3c0e) change(core): deprecate `statusline_unicode_symbols` option
- [`72349e4d`](https://github.com/SpaceVim/SpaceVim/commit/72349e4d) change(core): deprecate `project_rooter_automatically` option

## Bug Fixs

- [`48e701e0`](https://github.com/SpaceVim/SpaceVim/commit/48e701e0) fix todo manager with rg 13.0 (#4383)
- [`fd4b7a6e`](https://github.com/SpaceVim/SpaceVim/commit/fd4b7a6e) Add test for windows (#4412)
- [`8f76047c`](https://github.com/SpaceVim/SpaceVim/commit/8f76047c) Fix cache directory (#4414)
- [`33fd230c`](https://github.com/SpaceVim/SpaceVim/commit/33fd230c) fix(docker): disables package verification (#4411)
- [`d9524d5d`](https://github.com/SpaceVim/SpaceVim/commit/d9524d5d) fix(flygrep): use current directory when none specified for ripgrep. (#4410)
- [`1e4cb1f2`](https://github.com/SpaceVim/SpaceVim/commit/1e4cb1f2) Fix data dir (#4409)
- [`420f861d`](https://github.com/SpaceVim/SpaceVim/commit/420f861d) Hot Fix (#4430)
- [`f286e5a8`](https://github.com/SpaceVim/SpaceVim/commit/f286e5a8) Fix typescript eslint maker (#4441)
- [`ee07874b`](https://github.com/SpaceVim/SpaceVim/commit/ee07874b) fix notify api (#4438)
- [`84c2d69e`](https://github.com/SpaceVim/SpaceVim/commit/84c2d69e) Fix cached project (#4403)
- [`2bad1033`](https://github.com/SpaceVim/SpaceVim/commit/2bad1033) Fix job api (#4463)
- [`e33aeb1b`](https://github.com/SpaceVim/SpaceVim/commit/e33aeb1b) fix(layer): add `:h SpaceVim-layers-lang-vue`
- [`892b18fe`](https://github.com/SpaceVim/SpaceVim/commit/892b18fe) fix(plugin): Allow `:A` to switch between `*.h` and `{}.c`
- [`458b9729`](https://github.com/SpaceVim/SpaceVim/commit/458b9729) Fix g d in lang#typescript layer (#4454)
- [`2253f54b`](https://github.com/SpaceVim/SpaceVim/commit/2253f54b) fix(layer): fix `rustfmt_cmd` option in `lang#rust` layer
- [`14d75c04`](https://github.com/SpaceVim/SpaceVim/commit/14d75c04) fix(lsp): replace javascript lsp command
- [`36896f7d`](https://github.com/SpaceVim/SpaceVim/commit/36896f7d) Fix buffer_id in flygrep (#4288)
- [`38955b7d`](https://github.com/SpaceVim/SpaceVim/commit/38955b7d) Fix flygrep (#4361)
- [`b834a494`](https://github.com/SpaceVim/SpaceVim/commit/b834a494) Fix vim support (#4359)
- [`eb1d0780`](https://github.com/SpaceVim/SpaceVim/commit/eb1d0780) Fix notify scratch buffer (#4358)
- [`fd96c4ea`](https://github.com/SpaceVim/SpaceVim/commit/fd96c4ea) fix(nerdtree): fix key binding `h` in filetree
- [`ba588581`](https://github.com/SpaceVim/SpaceVim/commit/ba588581) fix(nerdtree): fix key binding `Home` and `End`
- [`3aecd6c3`](https://github.com/SpaceVim/SpaceVim/commit/3aecd6c3) fix(nerdtree): key binding `d` does not work
- [`3354f6e6`](https://github.com/SpaceVim/SpaceVim/commit/3354f6e6) fix(nerdtree): Fix `.` key binding in nerdtree
- [`534c2bf8`](https://github.com/SpaceVim/SpaceVim/commit/534c2bf8) fix(nerdtree): Fix `N` key binding in nerdtree
- [`513a6829`](https://github.com/SpaceVim/SpaceVim/commit/513a6829) Fix type in elixir article
- [`7093d3aa`](https://github.com/SpaceVim/SpaceVim/commit/7093d3aa) fix link (#4471)
- [`8c3dae57`](https://github.com/SpaceVim/SpaceVim/commit/8c3dae57) fix(nerdtree): arrow key does not work
- [`218f16e4`](https://github.com/SpaceVim/SpaceVim/commit/218f16e4) fix(lsp): specify cmd for typescriptreact
- [`25bf4a1b`](https://github.com/SpaceVim/SpaceVim/commit/25bf4a1b) fix(core): fix `Enter` key in filetree(nerdtree)
- [`492209fe`](https://github.com/SpaceVim/SpaceVim/commit/492209fe) fix(core): filetree key binding `ctrl-home` does not work
- [`db1ed720`](https://github.com/SpaceVim/SpaceVim/commit/db1ed720) Fix statusline (#4370)
- [`d23c6e18`](https://github.com/SpaceVim/SpaceVim/commit/d23c6e18) Fix `SPC x d SPC` key binding (#4369)
- [`8cf5519c`](https://github.com/SpaceVim/SpaceVim/commit/8cf5519c) Fix docker image building (#4367)
- [`dcb669ee`](https://github.com/SpaceVim/SpaceVim/commit/dcb669ee) Fix broken link (#4363)
- [`b8eae5e4`](https://github.com/SpaceVim/SpaceVim/commit/b8eae5e4) fix(plugin): Fix key binding error E225
- [`41c981e9`](https://github.com/SpaceVim/SpaceVim/commit/41c981e9) Fix Git mv options (#4353)
- [`e6cb9e90`](https://github.com/SpaceVim/SpaceVim/commit/e6cb9e90) Fix coffeescript api sys dependency (#4343)
- [`3f3a4912`](https://github.com/SpaceVim/SpaceVim/commit/3f3a4912) Fix statusline can't response to custom config (#4328)
- [`d5020d81`](https://github.com/SpaceVim/SpaceVim/commit/d5020d81) Fix layer lang::markdown install (#4327)
- [`a00ca02d`](https://github.com/SpaceVim/SpaceVim/commit/a00ca02d) Fix list style (#4324)

## Doc&&Wiki

- [`2f4a8054`](https://github.com/SpaceVim/SpaceVim/commit/2f4a8054) doc(layer): add `:h SpaceVim-layers-tools-mpv`
- [`a2734a9e`](https://github.com/SpaceVim/SpaceVim/commit/a2734a9e) doc(layer): add `:h SpaceVim-layers-lang-smalltalk`
- [`247b1550`](https://github.com/SpaceVim/SpaceVim/commit/247b1550) doc(layer): update `:h SpaceVim-layers-lang-typescript`
- [`87937800`](https://github.com/SpaceVim/SpaceVim/commit/87937800) doc(layer): add `:h SpaceVim-layers-lang-zig`
- [`3b6ad7f7`](https://github.com/SpaceVim/SpaceVim/commit/3b6ad7f7) doc(layer): add `:h SpaceVim-layers-lang-fennel`
- [`3a68e6ad`](https://github.com/SpaceVim/SpaceVim/commit/3a68e6ad) doc(core): add `:h SpaceVim-options-bootstrap_after/before`
- [`859753d4`](https://github.com/SpaceVim/SpaceVim/commit/859753d4) doc(wiki): update following HEAD page
- [`bc0bc6e3`](https://github.com/SpaceVim/SpaceVim/commit/bc0bc6e3) doc(core): update doc of `<Enter>` key in filetree
- [`7de44bde`](https://github.com/SpaceVim/SpaceVim/commit/7de44bde) doc(layer): add `:h SpaceVim-layers-lang-autoit`
- [`f544542a`](https://github.com/SpaceVim/SpaceVim/commit/f544542a) doc(layer): update `:h SpaceVim-layers-lang-agda`
- [`a08746ff`](https://github.com/SpaceVim/SpaceVim/commit/a08746ff) doc(layer): update `:h SpaceVim-layers-lang-java`
- [`0147cd8f`](https://github.com/SpaceVim/SpaceVim/commit/0147cd8f) doc(wiki): update labels info
- [`5cfd0e6a`](https://github.com/SpaceVim/SpaceVim/commit/5cfd0e6a) chore(core): remove `.vim-bookmarks`
- [`4ea483fd`](https://github.com/SpaceVim/SpaceVim/commit/4ea483fd) doc(layer): use `go install` replace `go get`
- [`f48b6a9a`](https://github.com/SpaceVim/SpaceVim/commit/f48b6a9a) doc(core): add `:h SpaceVim-dev`
- [`d604674a`](https://github.com/SpaceVim/SpaceVim/commit/d604674a) doc(layer): update `:h SpaceVim-layers-git`
- [`77d57270`](https://github.com/SpaceVim/SpaceVim/commit/77d57270) doc(layer): update `:h SpaceVim-layers-leaderf`
- [`e1dfadee`](https://github.com/SpaceVim/SpaceVim/commit/e1dfadee) doc(core): add commit type `change`
- [`c85c47fa`](https://github.com/SpaceVim/SpaceVim/commit/c85c47fa) doc(core): update development page
- [`4b4e80e7`](https://github.com/SpaceVim/SpaceVim/commit/4b4e80e7) ci(test): disable test for nvim nightly
- [`c9e22897`](https://github.com/SpaceVim/SpaceVim/commit/c9e22897) doc(layer): update doc about fuzzy finder layer
- [`8a8f5f41`](https://github.com/SpaceVim/SpaceVim/commit/8a8f5f41) doc(bundle): update plugins bundle readme
- [`eca21273`](https://github.com/SpaceVim/SpaceVim/commit/eca21273) doc(layer): add `:h SpaceVim-layers-cscope`
- [`6d44ea47`](https://github.com/SpaceVim/SpaceVim/commit/6d44ea47) doc(layer): fix layer tags prefix
- [`5f434d28`](https://github.com/SpaceVim/SpaceVim/commit/5f434d28) doc: update doc of `checkers` layer
- [`3fc49916`](https://github.com/SpaceVim/SpaceVim/commit/3fc49916) chore: update copyright
- [`7280ce8b`](https://github.com/SpaceVim/SpaceVim/commit/7280ce8b) chore: delete appveyor.yml
- [`c143ae07`](https://github.com/SpaceVim/SpaceVim/commit/c143ae07) doc: fix layer link
- [`7e613e11`](https://github.com/SpaceVim/SpaceVim/commit/7e613e11) docs: update `:h SpaceVim-changelog`
- [`7e33b5e3`](https://github.com/SpaceVim/SpaceVim/commit/7e33b5e3) Add doc for custom spc func (#4472)
- [`4bad7427`](https://github.com/SpaceVim/SpaceVim/commit/4bad7427) Fetch all history (#4460)
- [`2a3981ac`](https://github.com/SpaceVim/SpaceVim/commit/2a3981ac) Update documentation.md (#4456)
- [`8146051d`](https://github.com/SpaceVim/SpaceVim/commit/8146051d) Fixed typo in layers/lang/go.md (#4452)
- [`aa026288`](https://github.com/SpaceVim/SpaceVim/commit/aa026288) Update README.md (#4449)
- [`dc93c46f`](https://github.com/SpaceVim/SpaceVim/commit/dc93c46f) Update issue template (#4446)
- [`0c290681`](https://github.com/SpaceVim/SpaceVim/commit/0c290681) Use mirror (#4444)
- [`4006e9b9`](https://github.com/SpaceVim/SpaceVim/commit/4006e9b9) add language mapping test (#4431)
- [`d807b9bf`](https://github.com/SpaceVim/SpaceVim/commit/d807b9bf) Update doc (#4425)
- [`a3551972`](https://github.com/SpaceVim/SpaceVim/commit/a3551972) Use bot token (#4429)
- [`9646f700`](https://github.com/SpaceVim/SpaceVim/commit/9646f700) Update followHEAD (#4428)
- [`d7ccf937`](https://github.com/SpaceVim/SpaceVim/commit/d7ccf937) Escape space in rtp (#4423)
- [`6b633d9d`](https://github.com/SpaceVim/SpaceVim/commit/6b633d9d) Change title margin (#4422)
- [`8f349d0a`](https://github.com/SpaceVim/SpaceVim/commit/8f349d0a) Update website (#4421)
- [`938ad166`](https://github.com/SpaceVim/SpaceVim/commit/938ad166) Fix list-style (#4417)
- [`fbe1c12a`](https://github.com/SpaceVim/SpaceVim/commit/fbe1c12a) Update cn pages (#4384)
- [`be155d6f`](https://github.com/SpaceVim/SpaceVim/commit/be155d6f) Enable neovim test (#4382)
- [`c2dc72b5`](https://github.com/SpaceVim/SpaceVim/commit/c2dc72b5) Change li icon (#4379)
- [`e047354a`](https://github.com/SpaceVim/SpaceVim/commit/e047354a) Change comment border color (#4378)
- [`ec1ff581`](https://github.com/SpaceVim/SpaceVim/commit/ec1ff581) doc: Update development page (#4376)
- [`a7e9465a`](https://github.com/SpaceVim/SpaceVim/commit/a7e9465a) Update community & development page (#4373)
- [`9be4885a`](https://github.com/SpaceVim/SpaceVim/commit/9be4885a) Update docker readme (#4368)
- [`6387f595`](https://github.com/SpaceVim/SpaceVim/commit/6387f595) Update (#4365)
- [`225e417f`](https://github.com/SpaceVim/SpaceVim/commit/225e417f) Update layer page list (#4364)
- [`3e9b52af`](https://github.com/SpaceVim/SpaceVim/commit/3e9b52af) Add codecov.yml (#4381)
- [`6377357a`](https://github.com/SpaceVim/SpaceVim/commit/6377357a) Add codecov (#4380)
- [`4740d021`](https://github.com/SpaceVim/SpaceVim/commit/4740d021) Add issue template (#4360)
- [`dd46a88b`](https://github.com/SpaceVim/SpaceVim/commit/dd46a88b) Add doc for notify api (#4357)
- [`95e235ab`](https://github.com/SpaceVim/SpaceVim/commit/95e235ab) add bookmarks (#4346)
- [`7a6b6ff6`](https://github.com/SpaceVim/SpaceVim/commit/7a6b6ff6) Update irc channel (#4356)
- [`46346dd7`](https://github.com/SpaceVim/SpaceVim/commit/46346dd7) update default go-lsp to gopls (#4338)
- [`21398fcf`](https://github.com/SpaceVim/SpaceVim/commit/21398fcf) refactor layer: Update deprecated fugitive calls in git layer (#4340)
- [`af8e26af`](https://github.com/SpaceVim/SpaceVim/commit/af8e26af) update make_tasks example to support Makefiles with multiple .PHONY options (#4337)
- [`ceff70e6`](https://github.com/SpaceVim/SpaceVim/commit/ceff70e6) Update website (#4305)
- [`5b7535bf`](https://github.com/SpaceVim/SpaceVim/commit/5b7535bf) Fixed typescript installation issue (#4314)
- [`cad43708`](https://github.com/SpaceVim/SpaceVim/commit/cad43708) Update doc for todo manager (#4304)
- [`7fc00c9c`](https://github.com/SpaceVim/SpaceVim/commit/7fc00c9c) Update documentation (#4253)
- [`8558514f`](https://github.com/SpaceVim/SpaceVim/commit/8558514f) Update version to v1.8.0-dev (#4286)
- [`4a584be2`](https://github.com/SpaceVim/SpaceVim/commit/4a584be2) Hotfix: version
