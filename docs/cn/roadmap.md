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
  - [ ] 使用 lua 重写 tabline
  - [ ] 将网站内容合并至 `:h SpaceVim`
- `v2.3.0`
  - [x] 基于luv的新的异步`job`公共函数
  - [x] 使用 lua 重写 flygrep
    - [x] 使用新的 `job` 函数替换 `vim.fn.jobstart`
  - [ ] 使用 lua 重写 git.vim
    - [x] `:Git add`
    - [x] `:Git blame`
    - [x] `:Git branch`
      - [x] 使用 lua 重写分支管理侧栏
    - [x] `:Git checkout`
    - [x] `:Git cherry-pick`
    - [x] `:Git clean`
    - [x] `:Git commit`
    - [ ] `:Git config`
    - [x] `:Git diff`
    - [x] `:Git fetch`
    - [x] `:Git log`
      - [x] 最后一个窗口时，关闭 git log 页面
    - [x] `:Git merge`
    - [x] `:Git mv`
    - [x] `:Git pull`
    - [x] `:Git push`
    - [ ] `:Git rebase`
    - [ ] `:Git reflog`
    - [x] `:Git remote`
    - [x] `:Git reset`
    - [x] `:Git rm`
    - [x] `:Git shortlog` (lua)
    - [ ] `:Git shortlog` (viml)
    - [x] `:Git tag` (lua)
    - [ ] `:Git tag` (viml)
    - [ ] `:Git stash`
    - [x] `:Git status`
    - [x] 日志系统整合至 SpaceVim 运行时日志
  - [x] 使用 lua 重写 code runner
  - [x] 使用 lua 重写 task manager
  - [x] 使用 lua 重写 repl 插件
  - [x] 使用 lua 重写 scrollbar 插件
    - [x] 修复 scrollbar 为保存文件报错
  - [x] 使用 lua 重写 快捷键插件 leader guide
  - [x] 使用 lua 重写 pastebin 插件
  - [x] 使得 `:A` 命令支持 toml 配置文件
  - [x] 增加 git 远程仓库管理插件
    - [x] 使用 `<cr>` 快捷键展示 git log
    - [x] 切换项目时，更新 remote 窗口信息
    - [x] 注册项目管理函数时，使用描述信息
    - [ ] 缓存远程仓库以及分支名称等信息
    - [ ] 基于项目路径存储信息
    - [x] 显示根目录地址
  - [x] 使用 lua 实现 `ctags#update` 函数
  - [x] 项目管理插件注册函数增加描述支持
  - [x] 切换项目时，更新 todo 管理插件窗口内容
  - [x] 为主题 `one` 增加 treesitter 支持
  - [x] add `:h SpaceVim-dev-merge-request`
  - [x] add `:h spacevim-dev-license`
  - [x] 修复部分插件缓冲区状态栏高亮问题
  - [ ] 修复 `spacevim.org` 网站 404 页面

## 已完成版本

所有已完成的版本可以在[更新日志](../development/#更新日志)查看
