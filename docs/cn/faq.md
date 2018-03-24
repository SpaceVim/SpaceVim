---
title: "FAQ" 
description: "SpaceVim 常见问题详解，包括安装、更新、设置等等" 
---

# SpaceVim 常见问题解答

这里罗列了一些关于 SpaceVim 的常见问题，如果你觉得需要添加某些问题，欢迎帮助改进本页面。

## 我应该把我的配置文件放到什么位置?

SpaceVim 默认从 ~/.SpaceVim.d/init.vim 中加载配置文件.

## E492: 未编辑的命令: ^M

这个问题是git在克隆过程中,自动添加了^M, 可以通过下面的方法来解决:

```sh
git config --global core.autocrlf input
```
## 为什么 SpaceVim 颜色怪异？

因为在 SpaceVim 中，默认情况下是启用了终端真色，因此你需要确保你的终端支持真色。
当然如果实在没有办法支持真色，你可以禁用 SpaceVim 的真色选项, 在 `~/.SpaceVim.d/init.vim`
文件中添加：

```vim
let g:spacevim_enable_guicolors = 0
```
