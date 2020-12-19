---
title: "SpaceVim 中一键异步运行"
categories: [blog_cn, feature_cn]
description: "异步执行当前文件，并将结果展示在下方窗口"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "VIM 异步代码执行"
---

# [Blogs](../blog/) >> SpaceVim 中一键异步运行


当编辑代码时，通常有这样的需求，即为快速运行当前文件。而 Vim 自带的 `:!` 命令可以用来执行外部命令。
但是该方式执行外部命令时并不是异步的，会锁定当前编辑器，进而影响其他编辑操作。

以下动态图展示了如何在 SpaceVim 内通过异步代码运行器来快速运行当前文件。

![async code runner](https://user-images.githubusercontent.com/13142418/33722240-141ed716-db2f-11e7-9a4d-c99f05cc1d05.gif)

在运行输出窗口最上方显示了编译、运行的实际命令，而最后一行则显示了运行结果。
默认的快捷键为 `SPC l r`，`SPC` 指的是键盘上的空格键。
