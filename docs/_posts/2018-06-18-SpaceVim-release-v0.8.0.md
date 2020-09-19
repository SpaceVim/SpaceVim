---
title: SpaceVim release v0.8.0
categories: [changelog, blog]
description: "Use toml as default configuration file for SpaceVim"
type: article
image: https://user-images.githubusercontent.com/13142418/80610442-f41e9480-8a6b-11ea-8e0e-16ef35460253.png
commentsID: "SpaceVim release v0.8.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v0.8.0


This project exists thanks to all the people who have contributed. The last release v0.7.0 is targeted
on March 18, 2018, so let's take a look at what happened in the new release v0.8.0.

![v0.8.0 welcome page](https://user-images.githubusercontent.com/13142418/80610442-f41e9480-8a6b-11ea-8e0e-16ef35460253.png)


<!-- vim-markdown-toc GFM -->

- [New features](#new-features)
- [New layers](#new-layers)
- [Enhancements](#enhancements)
- [Bug fixs](#bug-fixs)
- [Doc && Wiki](#doc--wiki)

<!-- vim-markdown-toc -->


## New features

- Add toml config support [#1636](https://github.com/SpaceVim/SpaceVim/pull/1636), [#1654](https://github.com/SpaceVim/SpaceVim/pull/1654)

In the old version of SpaceVim, we use vim file as configuration file. But this introduces a lot of problems.
please check our [faq](../faq/#why-use-toml-file-as-default-configuration-file) for why use toml file as default configuration file.

- Add async support for gitcommit [#1623](https://github.com/SpaceVim/SpaceVim/pull/1623)

when edit commit message, complete the PR and ISSUE list from GitHub asynchronously.

![complete in git commit](https://user-images.githubusercontent.com/13142418/41519892-6ee2d3fc-7290-11e8-8b48-20e24d3046bc.jpg)

- Split dein UI as plugin [#1682](https://github.com/SpaceVim/SpaceVim/pull/1682)

Dein is a awesome plugin manager for neovim and vim8, but it does not provide a
UI, If you need vim-plug like install UI, you can use [dein-ui.vim](https://github.com/wsdjeg/dein-ui.vim).

![UI for dein](https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif)

- Add buffer directory searching [#1632](https://github.com/SpaceVim/SpaceVim/pull/1632)
- Add asyncomplete-clang [#1671](https://github.com/SpaceVim/SpaceVim/pull/1671)
- add SPC `x a |` to align region at `|` [#1766](https://github.com/SpaceVim/SpaceVim/pull/1766)
- Add auto fix feature to typescript [#1706](https://github.com/SpaceVim/SpaceVim/pull/1706)
- Add compatible API for matchaddpos [#1681](https://github.com/SpaceVim/SpaceVim/pull/1681)
- Add autofix feature for php with phpcbf [#1652](https://github.com/SpaceVim/SpaceVim/pull/1652)
- Add more key bingindings [#1811](https://github.com/SpaceVim/SpaceVim/pull/1811)
- Glyph free theme [#1784](https://github.com/SpaceVim/SpaceVim/pull/1784)

## New layers

- Add org layer [#1718](https://github.com/SpaceVim/SpaceVim/pull/1718)
- Add lang#r layer [#1717](https://github.com/SpaceVim/SpaceVim/pull/1717)

## Enhancements

- Change filetype assert [#1655](https://github.com/SpaceVim/SpaceVim/pull/1655)
- Imporve `max_column` options [#1744](https://github.com/SpaceVim/SpaceVim/pull/1744)
- Improve system api [#1780](https://github.com/SpaceVim/SpaceVim/pull/1780)
- Improve tags layer [#1761](https://github.com/SpaceVim/SpaceVim/pull/1761)
- Update Go layer to reflect vim-go var name change [#1719](https://github.com/SpaceVim/SpaceVim/pull/1719)
- Set encoding [#1708](https://github.com/SpaceVim/SpaceVim/pull/1708)
- Enable nocompatible for vim [#1690](https://github.com/SpaceVim/SpaceVim/pull/1690)
- Improve vimcompatible mode [#1665](https://github.com/SpaceVim/SpaceVim/pull/1665)
- Prefer local phpmd.xml [#1656](https://github.com/SpaceVim/SpaceVim/pull/1656)
- Only Reload when the filetype is javascript [#1653](https://github.com/SpaceVim/SpaceVim/pull/1653)
- Remove vim-javascript due to conflicts in flow-type and in jsx [#1637](https://github.com/SpaceVim/SpaceVim/pull/1637)
- Use stdin instead when format java file. [#1634](https://github.com/SpaceVim/SpaceVim/pull/1634)
- Improve buffer switch key bindings [#1673](https://github.com/SpaceVim/SpaceVim/pull/1673)
- Use bash for 24-bit-color.sh [#1613](https://github.com/SpaceVim/SpaceVim/pull/1613)
- Change lang#c layer plugins [#1619](https://github.com/SpaceVim/SpaceVim/pull/1619)

## Bug fixs

- Fix error `unknown option guifont` in VimR [#1651](https://github.com/SpaceVim/SpaceVim/pull/1651)
- Fix vimcompatible mode [#1667](https://github.com/SpaceVim/SpaceVim/pull/1667)
- Fix SPConfig [#1666](https://github.com/SpaceVim/SpaceVim/pull/1666)
- Fix key bindings Tab [#1711](https://github.com/SpaceVim/SpaceVim/pull/1711)
- Fix language [#1710](https://github.com/SpaceVim/SpaceVim/pull/1710)
- Fix windows support [#1700](https://github.com/SpaceVim/SpaceVim/pull/1700)
- Fix lint [#1699](https://github.com/SpaceVim/SpaceVim/pull/1699)
- Fix SPC f f key bindings [#1698](https://github.com/SpaceVim/SpaceVim/pull/1698)
- Fix detach script [#1684](https://github.com/SpaceVim/SpaceVim/pull/1684)
- Fix jump mappings [#1680](https://github.com/SpaceVim/SpaceVim/pull/1680)
- Fix flygrep [#1678](https://github.com/SpaceVim/SpaceVim/pull/1678)
- Fix install script [#1677](https://github.com/SpaceVim/SpaceVim/pull/1677)
- Fix phpcd support [#1676](https://github.com/SpaceVim/SpaceVim/pull/1676)
- Fix Asyncomplete support [#1670](https://github.com/SpaceVim/SpaceVim/pull/1670)
- Fix hit-enter when using timers [#1722](https://github.com/SpaceVim/SpaceVim/pull/1722)
- Fix custom config path [#1779](https://github.com/SpaceVim/SpaceVim/pull/1779)
- Fix syntax highlight conflict under flow-typed js [#1769](https://github.com/SpaceVim/SpaceVim/pull/1769)
- Fix flygrep detect script [#1757](https://github.com/SpaceVim/SpaceVim/pull/1757)
- Fix bootstrap function [#1741](https://github.com/SpaceVim/SpaceVim/pull/1741)
- Fix tags layer [#1649](https://github.com/SpaceVim/SpaceVim/pull/1649)
- Fix gitcommit completion script [#1624](https://github.com/SpaceVim/SpaceVim/pull/1624)
- Fix deoplete config [#1612](https://github.com/SpaceVim/SpaceVim/pull/1612)
- Fix debug info [#1806](https://github.com/SpaceVim/SpaceVim/pull/1806)
- Fix denite config [#1650](https://github.com/SpaceVim/SpaceVim/pull/1650)
- Fix UltiSnips support #1078 [#1647](https://github.com/SpaceVim/SpaceVim/pull/1647)
- Fix mru and buffer list key bindings [#1620](https://github.com/SpaceVim/SpaceVim/pull/1620)
- Fix pluginmanager && autocomplete layer [#1614](https://github.com/SpaceVim/SpaceVim/pull/1614)
- Fix detach command [#1685](https://github.com/SpaceVim/SpaceVim/pull/1685)
- Fix loading custom plugin [#1743](https://github.com/SpaceVim/SpaceVim/pull/1743)
- Fix undefined variable for `g:_spacevim_config_path` [#1797](https://github.com/SpaceVim/SpaceVim/pull/1797)
- Fix rtp type [#1787](https://github.com/SpaceVim/SpaceVim/pull/1787)
- Escape file name [#1795](https://github.com/SpaceVim/SpaceVim/pull/1795)

## Doc && Wiki

- Fix grammar mistake [#1611](https://github.com/SpaceVim/SpaceVim/pull/1611)
- Update community [#1781](https://github.com/SpaceVim/SpaceVim/pull/1781)
- Update documentation [#1765](https://github.com/SpaceVim/SpaceVim/pull/1765)
- Manager post tags [#1762](https://github.com/SpaceVim/SpaceVim/pull/1762)
- Doc: improve SpaceVim doc [#1758](https://github.com/SpaceVim/SpaceVim/pull/1758)
- Specify the exact branch for git rebase [#1754](https://github.com/SpaceVim/SpaceVim/pull/1754)
- Type: JaveScript --> JavaScript [#1753](https://github.com/SpaceVim/SpaceVim/pull/1753)
- Update readme && wiki [#1740](https://github.com/SpaceVim/SpaceVim/pull/1740)
- Update lsp doc [#1735](https://github.com/SpaceVim/SpaceVim/pull/1735)
- Wiki: update cn wiki [#1752](https://github.com/SpaceVim/SpaceVim/pull/1752)
- Doc: update colorscheme layer doc [#1747](https://github.com/SpaceVim/SpaceVim/pull/1747)
- Correct `rubocop` spelling in docs [#1715](https://github.com/SpaceVim/SpaceVim/pull/1715)
- HTML Improvements [#1707](https://github.com/SpaceVim/SpaceVim/pull/1707)
- Update readme [#1668](https://github.com/SpaceVim/SpaceVim/pull/1668)
- Update quick start guide [#1659](https://github.com/SpaceVim/SpaceVim/pull/1659), [#1729](https://github.com/SpaceVim/SpaceVim/pull/1729)
- Correct title in haskell.md [#1645](https://github.com/SpaceVim/SpaceVim/pull/1645)
- Add toml config documentation [#1721](https://github.com/SpaceVim/SpaceVim/pull/1721)
- Add json example [#1625](https://github.com/SpaceVim/SpaceVim/pull/1625)
- Add doc for formatting on save [#1799](https://github.com/SpaceVim/SpaceVim/pull/1799)
- Add search box to the website [#1789](https://github.com/SpaceVim/SpaceVim/pull/1789)
- Add useage of statusline and tabline [#1783](https://github.com/SpaceVim/SpaceVim/pull/1783)
- Add useage of bootstrap function [#1775](https://github.com/SpaceVim/SpaceVim/pull/1775) [#1774](https://github.com/SpaceVim/SpaceVim/pull/1774)
- Add `Ctrl-a` to the vim compatibility list [#1755](https://github.com/SpaceVim/SpaceVim/pull/1755)
- Fix typo [#1813](https://github.com/SpaceVim/SpaceVim/pull/1813)
- Fix a typo in cn/documentation.md [#1812](https://github.com/SpaceVim/SpaceVim/pull/1812)
- Fix doc about enable/disable guicolors [#1785](https://github.com/SpaceVim/SpaceVim/pull/1785)
- Fix doc for colorscheme_bg && close #1737 [#1739](https://github.com/SpaceVim/SpaceVim/pull/1739)
- Fix keys highlights, add missed [#1713](https://github.com/SpaceVim/SpaceVim/pull/1713)
- Fix layer activation command and typo in Python layer docs [#1712](https://github.com/SpaceVim/SpaceVim/pull/1712)
- Fix typo in documentation [#1661](https://github.com/SpaceVim/SpaceVim/pull/1661)

