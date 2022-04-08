---
title: "Vim 多光标支持"
categories: [blog_cn, feature_cn]
description: "异步执行 grep，根据输入内容实时展示搜索结果，支持全工程检索、检索当前文件、检索已打开的文件等"
image: https://user-images.githubusercontent.com/13142418/80607963-b704d300-8a68-11ea-99c4-5b5bd653cb24.gif
commentsID: "Vim 异步实时代码检索"
comments: true
permalink: /cn/:title/
lang: zh
---

# [Blogs](../blog/) >> Vim 多光标支持

{{ page.date | date_to_string }}

FlyGrep 指的是 **grep on the fly**，将根据用户输入实时展示搜索结果。当然，这些搜索命令都是异步执行的。
在使用这一功能之前，需要安装一个命令行搜索工具。目前 FlyGrep 支持的工具包括：`ag`、`rg`、`ack`、`pt` 和 `grep`，
选择你喜欢的工具安装即可。
