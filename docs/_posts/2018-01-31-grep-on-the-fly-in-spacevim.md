---
title: "Vim 异步实时代码检索"
categories: [blog_cn, feature_cn]
excerpt: "异步执行 grep，根据输入内容实时展示搜索结果，支持全工程检索、检索当前文件、检索已打开的文件等"
image: https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif
commentsID: "Vim 异步实时代码检索"
comments: true
permalink: /cn/:title/
lang: cn
---

# Vim 异步实时代码检索

{{ page.date | date_to_string }}

SpaceVim 中代码检索采用的是 FlyGrep 这个插件，包括了常用的全工程代码检索，局部文件夹代码检索等特性。搜索结果实时展示。
这个插件是 SpaceVim 的内置插件，当然也已分离出一个备份仓库供给非 SpaceVim 用户使用。

<https://github.com/wsdjeg/FlyGrep.vim>

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

## 安装搜索工具

FlyGrep 异步调用搜索工具，搜索并展示结果，目前支持的搜索工具包括：`rg`, `ag`, `pt`, `grep`, `findstr`, `ack`。
以上这些工具在 Linux 系统下默认包含了 `grep`，Windows 系统下默认包含了 `findstr`。其他工具安装方式如下：

### Windows

在 Windows 下，可以直接下载解压，可执行文件所在目录加入 `PATH` 即可。

- rg: [ripgrep releases](https://github.com/BurntSushi/ripgrep/releases)
- ag: [the_silver_searcher-win32](https://github.com/k-takata/the_silver_searcher-win32/releases)

## 特性

- 实时检索全工程文件
- 实时检索全工程文件，指定初始输入伺，适合搜光标单词或选择的词语
- 实时检索已载入文件，这不同于全工程搜索，只搜索vim中已打开的文件，能更准确定位
- 同上，支持指定输入词来检索已载入文件
- 指定检索目录，适合跨工程检索或检索子目录，也可用于同时检索多个工程
- 支持正则表达式输入
- 支持中文检索
- 输入框采用的是终端那一套快捷键，bash 用户应该非常喜欢这样快捷键，可以快速编辑单行输入内容。
- 鼠标支持，用 Vim 其实也有鼠标党，在这个插件里面，可以用鼠标滚轮上下移动选择行，也可以用鼠标双击打开匹配位置，单击移动匹配位置
以上这些功能已经在 SpaceVim 中实现了，文中的连接是一波演示效果图。

**补充：**

首先是增加了 filter 模式，也就是当我们搜索一个关键词，出现了很多结果，而我们需要的结果排在很后，以至于下拉很久看不到，这时候你可以启用 filter 模式，filter 模式其实类似于 flygrep，但是，他是对前一次的结果进行筛选。默认快捷键是 flygrep 模式下按下 ctrl+f

## 计划中的特性

一个比较实用的 todo，提供一个快捷键，将搜索结果转变为 quickfix 列表，这有助于对这些搜索结果进行后期处理。
另外一个 TODO 是全工程替换，或局部替换，大致思路是由flygrep 删选结果，由 Iedit 多光标编辑，再应用至文件.

后期还有那些特性会去实现呢？首先当然是neovim的悬浮窗特性，在我前面的文章里面已经展示过悬浮窗的特性，那只是一个粗略的效果图， 具体细节当然还需要时间去实现。

关于代码检索，大家还有什么建议吗？欢迎留言.
