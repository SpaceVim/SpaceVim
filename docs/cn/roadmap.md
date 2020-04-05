---
title: "设计蓝图"
description: "SpaceVim 设计蓝图和里程碑，这决定了 SpaceVim 的开发方向和特性实现的优先顺序。"
lang: zh
---

# [主页](../) >> 设计蓝图

SpaceVim 的设计蓝图和[里程碑](https://github.com/SpaceVim/SpaceVim/milestones)决定了该项目的开发方向以及所有特性实现的优先顺序。

<!-- vim-markdown-toc GFM -->

- [下一个版本](#下一个版本)
  - [v1.5.0](#v150)
- [版本说明](#版本说明)
- [已完成](#已完成)
  - [v0.1.0](#v010)
  - [v0.2.0](#v020)
  - [v0.3.0](#v030)
  - [v0.3.1](#v031)
  - [v0.4.0](#v040)
  - [v0.5.0](#v050)
  - [v0.6.0](#v060)
  - [v0.7.0](#v070)
  - [v0.8.0](#v080)
  - [v0.9.0](#v090)
  - [v1.0.0](#v100)
  - [v1.1.0](#v110)
  - [v1.2.0](#v120)
  - [v1.3.0](#v130)
  - [v1.4.0](#v140)

<!-- vim-markdown-toc -->

## 下一个版本

### [v1.5.0](https://github.com/SpaceVim/SpaceVim/milestone/18)

## 版本说明

There are release milestones and meta milestones ("buckets").

- Version-number milestones (0.1, 0.2, 0.3, …) assign issues to production releases.
  - The nearest upcoming version is assigned a target date.
  - Low-risk fixes in the current branch are first committed to the stable branch, then merged to master. For example, if the current stable release is `0.1.1` and a bug-fix is assigned to the `0.2` milestone, it does not mean users need to wait until 0.2 to get the fix. The patch will be committed to the stable branch and released in `0.1.2`.
- [todo](https://github.com/SpaceVim/SpaceVim/milestone/4) is a bucket for triaged tickets which should be on the roadmap but cannot yet be assigned to a concrete milestone.
- [unplanned](https://github.com/SpaceVim/SpaceVim/milestone/5) is a bucket for low-priority items or items lacking a feasible path to completion.

<!-- call SpaceVim#dev#roadmap#updateCompletedItems('cn') -->

<!-- SpaceVim roadmap completed items start -->

## 已完成

### [v0.1.0](https://github.com/SpaceVim/SpaceVim/milestone/1)

the first public release of SpaceVim, and following feature will be implemented:

- Neovim-centric
- Modular configuration
- multiple leader mode
- Lazy-load 90% of plugins with dein.vim
- Robust, yet light weight
- Unite centric work-flow
- Awesome ui
- Language specific mode, code completion, syntax check, etc.
  - c family
  - java
  - js
  - rust
  - php
  - go
  - php
  - lua
  - perl
  - python
- Extensive Neocomplete setup
- Central location for tags
- Lightweight simple status/tabline
- Premium color-schemes

release note: [v0.1.0](http://spacevim.org/SpaceVim-release-v0.1.0/)

### [v0.2.0](https://github.com/SpaceVim/SpaceVim/milestone/2)

1. Many language support
2. Improve default layer
3. finish document

release note: [v0.2.0](http://spacevim.org/SpaceVim-release-v0.2.0/)

### [v0.3.0](https://github.com/SpaceVim/SpaceVim/milestone/3)

- SpaceVim api
- plugin manager ui ( for dein)

release note: [v0.3.0](http://spacevim.org/SpaceVim-release-v0.3.0/)

### [v0.3.1](https://github.com/SpaceVim/SpaceVim/milestone/6)

features need to be implemented just after v0.3.0 has been released.

release note: [v0.3.1](http://spacevim.org/SpaceVim-release-v0.3.1/)

### [v0.4.0](https://github.com/SpaceVim/SpaceVim/milestone/7)

release note: [v0.4.0](http://spacevim.org/SpaceVim-release-v0.4.0/)

### [v0.5.0](https://github.com/SpaceVim/SpaceVim/milestone/8)

release note: [v0.5.0](http://spacevim.org/SpaceVim-release-v0.5.0/)

### [v0.6.0](https://github.com/SpaceVim/SpaceVim/milestone/9)

release note: [v0.6.0](http://spacevim.org/SpaceVim-release-v0.6.0/)

### [v0.7.0](https://github.com/SpaceVim/SpaceVim/milestone/10)

- Improve all the lang#\* layers

release note: [v0.7.0](http://spacevim.org/SpaceVim-release-v0.7.0/)

### [v0.8.0](https://github.com/SpaceVim/SpaceVim/milestone/11)

release note: [v0.8.0](http://spacevim.org/SpaceVim-release-v0.8.0/)

### [v0.9.0](https://github.com/SpaceVim/SpaceVim/milestone/12)

release note: [v0.9.0](http://spacevim.org/SpaceVim-release-v0.9.0/)

### [v1.0.0](https://github.com/SpaceVim/SpaceVim/milestone/13)

First stable release of SpaceVim

release note: [v1.0.0](http://spacevim.org/SpaceVim-release-v1.0.0/)

### [v1.1.0](https://github.com/SpaceVim/SpaceVim/milestone/14)

release note: [v1.1.0](http://spacevim.org/SpaceVim-release-v1.1.0/)

### [v1.2.0](https://github.com/SpaceVim/SpaceVim/milestone/15)

release note: [v1.2.0](http://spacevim.org/SpaceVim-release-v1.2.0/)

### [v1.3.0](https://github.com/SpaceVim/SpaceVim/milestone/16)

release note: [v1.3.0](http://spacevim.org/SpaceVim-release-v1.3.0/)

### [v1.4.0](https://github.com/SpaceVim/SpaceVim/milestone/17)

release note: [v1.4.0](http://spacevim.org/SpaceVim-release-v1.4.0/)


<!-- SpaceVim roadmap completed items end -->
