This page documents changes in master branch since last release v1.0.0

## PreRelease

The next release is v1.1.0

<!-- call SpaceVim#dev#followHEAD#update('en') -->
<!-- SpaceVim follow HEAD en start -->

#### New Features

- Add chinese linter to layer chinese [#2473](https://github.com/SpaceVim/SpaceVim/pull/2473)
- Add: zeal layer [#2469](https://github.com/SpaceVim/SpaceVim/pull/2469)
- Add: add a new feature 'format all tables' for markdown. [#2457](https://github.com/SpaceVim/SpaceVim/pull/2457)
- add ctrl - r [#2436](https://github.com/SpaceVim/SpaceVim/pull/2436)
- add mapping to clear quickfix [#2430](https://github.com/SpaceVim/SpaceVim/pull/2430)
- Add alt file plugin [#2416](https://github.com/SpaceVim/SpaceVim/pull/2416)
- Add: coc.nvim integration enhacements [#2415](https://github.com/SpaceVim/SpaceVim/pull/2415)
- Add plugin for git log [#1963](https://github.com/SpaceVim/SpaceVim/pull/1963)

#### Bug Fixs

- Fix typo [#2475](https://github.com/SpaceVim/SpaceVim/pull/2475)
- Fix: call fzf#wrap in fzf#run [#2472](https://github.com/SpaceVim/SpaceVim/pull/2472)
- Fix typo: statuline -> statusline [#2451](https://github.com/SpaceVim/SpaceVim/pull/2451)
- fix #2448 [#2450](https://github.com/SpaceVim/SpaceVim/pull/2450)
- Fix runner close job [#2441](https://github.com/SpaceVim/SpaceVim/pull/2441)
- Fix rust runner in windows [#2438](https://github.com/SpaceVim/SpaceVim/pull/2438)
- Fixed: fix typos. [#2437](https://github.com/SpaceVim/SpaceVim/pull/2437)
- Fix lua runner in windows [#2427](https://github.com/SpaceVim/SpaceVim/pull/2427)
- Fix go run support [#2426](https://github.com/SpaceVim/SpaceVim/pull/2426)
- Fixed: fix a typo, there should be a \| between >> and \/\/. [#2423](https://github.com/SpaceVim/SpaceVim/pull/2423)
- Fixed: Fix an alignment error and fix the regular expression. [#2420](https://github.com/SpaceVim/SpaceVim/pull/2420)
- Fix api import [#2418](https://github.com/SpaceVim/SpaceVim/pull/2418)
- fix `docs/cn/layers/lang/vue.md` [#2417](https://github.com/SpaceVim/SpaceVim/pull/2417)
- Fixed: fix typos. [#2413](https://github.com/SpaceVim/SpaceVim/pull/2413)
- Fix docker support [#2406](https://github.com/SpaceVim/SpaceVim/pull/2406)
- Fix debug command [#2226](https://github.com/SpaceVim/SpaceVim/pull/2226)
- Fix perl support [#2230](https://github.com/SpaceVim/SpaceVim/pull/2230)
- Fix preview in flygrep [#2256](https://github.com/SpaceVim/SpaceVim/pull/2256)

#### Unmarked PRs

- Typo dashboard [#2477](https://github.com/SpaceVim/SpaceVim/pull/2477)
- Doc: fix typos. [#2471](https://github.com/SpaceVim/SpaceVim/pull/2471)
- Improve lua support [#2470](https://github.com/SpaceVim/SpaceVim/pull/2470)
- Update about page [#2468](https://github.com/SpaceVim/SpaceVim/pull/2468)
- Update post for FlyGrep [#2465](https://github.com/SpaceVim/SpaceVim/pull/2465)
- implment Ctrl-r to paste from register for flygrep [#2460](https://github.com/SpaceVim/SpaceVim/pull/2460)
- update uncrustify URL link [#2456](https://github.com/SpaceVim/SpaceVim/pull/2456)
- remember cursor position when switch buffer [#2454](https://github.com/SpaceVim/SpaceVim/pull/2454)
- Improve terminal statusline [#2453](https://github.com/SpaceVim/SpaceVim/pull/2453)
- Doc: Correct documentations by ChineseLinter and fix typos. [#2452](https://github.com/SpaceVim/SpaceVim/pull/2452)
- Doc: Correct conventions.md by ChineseLinter and fix some typos. [#2449](https://github.com/SpaceVim/SpaceVim/pull/2449)
- Cosmetics, realign text, remove trailing spaces and tabulation [#2445](https://github.com/SpaceVim/SpaceVim/pull/2445)
- Doc: Fix typos and translate [#2443](https://github.com/SpaceVim/SpaceVim/pull/2443)
- Doc: fix serval typos. [#2442](https://github.com/SpaceVim/SpaceVim/pull/2442)
- Enhance c/c++ layer [#2440](https://github.com/SpaceVim/SpaceVim/pull/2440)
- Install, Fix bad version [#2439](https://github.com/SpaceVim/SpaceVim/pull/2439)
- Use a yellow ⚠ for warnings messages [#2435](https://github.com/SpaceVim/SpaceVim/pull/2435)
- Update statusline support for startify [#2434](https://github.com/SpaceVim/SpaceVim/pull/2434)
- Doc, cosmetics: remove trailing spaces [#2433](https://github.com/SpaceVim/SpaceVim/pull/2433)
- Improve statusline support for gina [#2432](https://github.com/SpaceVim/SpaceVim/pull/2432)
- Doc: fix typo for javascript [#2428](https://github.com/SpaceVim/SpaceVim/pull/2428)
- Jump to test of api [#2424](https://github.com/SpaceVim/SpaceVim/pull/2424)
- patch for #2114 [#2422](https://github.com/SpaceVim/SpaceVim/pull/2422)
- Doc: typo fixes [#2421](https://github.com/SpaceVim/SpaceVim/pull/2421)
- Doc: add description for SPC l k. [#2414](https://github.com/SpaceVim/SpaceVim/pull/2414)
- Website: add vim#command api doc [#2412](https://github.com/SpaceVim/SpaceVim/pull/2412)
- Improve shell layer key binding [#2409](https://github.com/SpaceVim/SpaceVim/pull/2409)
- Doc: add some tweaks on doc instructions [#2056](https://github.com/SpaceVim/SpaceVim/pull/2056)
- Improve startup experience [#1977](https://github.com/SpaceVim/SpaceVim/pull/1977)
- [issue#2367]: clear rootDir cache after rooter pattern changed [#2370](https://github.com/SpaceVim/SpaceVim/pull/2370)

<!-- SpaceVim follow HEAD en end -->

## Latest Release

SpaceVim releases v1.0.0 at 2018-12-26, please check the release page:

- [SpaceVim releases v0.9.0](https://spacevim.org/SpaceVim-release-v1.0.0/) for all the details
