---
title: "设计蓝图"
description: "SpaceVim 设计蓝图和里程碑，这决定了 SpaceVim 的开发方向和特性实现的优先顺序。"
lang: zh
---

# [主页](../) >> 设计蓝图

设计蓝图决定了该项目的开发方向以及所有特性实现的优先顺序。

## 后续版本

- `v2.4.0`
  - [ ] 使用 lua 重写状态栏插件

- `v2.3.0`
  - [x] 基于luv的新的异步`job`公共函数
  - [x] 使用 lua 重写 flygrep
    - [x] 使用新的 `job` 函数替换 `vim.fn.jobstart`
  - [ ] 使用 lua 重写 git.vim
    - [x] `:Git add`
    - [x] `:Git clean`
    - [x] `:Git fetch`
    - [x] `:Git remote`
    - [x] `:Git reset`
    - [x] `:Git rm`
    - [x] `:Git mv`
    - [x] `:Git blame`
    - [x] `:Git cherry-pick`
    - [x] `:Git shortlog`
    - [x] 日志系统整合至 SpaceVim 运行时日志
  - [x] 使用 lua 重写 code runner
  - [x] 使用 lua 重写 task manager
  - [x] 使用 lua 重写 repl 插件
  - [x] 使用 lua 重写 scrollbar 插件
  - [x] 使用 lua 重写 快捷键插件 leader guide
  - [x] 使用 lua 重写 pastebin 插件
  - [x] 使得 `:A` 命令支持 toml 配置文件
  - [x] 增加 git 远程仓库管理插件
  - [x] implement `ctags#update` in lua

## 已完成版本

- `v2.2.0`
  - [x] rewrite scrollbar with lua
  
  release notes: [v2.2.0](../SpaceVim-release-v2.2.0/)
