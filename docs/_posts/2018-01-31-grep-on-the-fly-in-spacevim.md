---
title: "Vim 异步实时代码检索"
categories: [blog_cn, feature_cn]
description: "异步执行 grep，根据输入内容实时展示搜索结果，支持全工程检索、检索当前文件、检索已打开的文件等"
image: https://user-images.githubusercontent.com/13142418/80607963-b704d300-8a68-11ea-99c4-5b5bd653cb24.gif
commentsID: "Vim 异步实时代码检索"
comments: true
permalink: /cn/:title/
lang: zh
---

# [Blogs](../blog/) >> Vim 异步实时代码检索

{{ page.date | date_to_string }}

FlyGrep 指的是 **grep on the fly**，将根据用户输入实时展示搜索结果。当然，这些搜索命令都是异步执行的。
在使用这一功能之前，需要安装一个命令行搜索工具。目前 FlyGrep 支持的工具包括：`ag`、`rg`、`ack`、`pt` 和 `grep`，
选择你喜欢的工具安装即可。

这是一个 SpaceVim 内置插件，当然也自动剥离出一个独立的插件供非 SpaceVim 用户使用：[FlyGrep.vim](https://github.com/wsdjeg/FlyGrep.vim)

### 安装

在 Linux 系统下，flygrep 默认使用 grep，如果需要使用更快的工具，可以安装以下某一个工具：

- [ripgrep(rg)](https://github.com/BurntSushi/ripgrep)
- [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher)
- [the_platinum_searcher(pt)](https://github.com/monochromegane/the_platinum_searcher)

### 功能特性

- 全工程实时检索

在 SpaceVim 中，可以使用快捷键 `SPC s p` 或者 `SPC s /` 进行全工程检索。

![searching project](https://user-images.githubusercontent.com/13142418/80607963-b704d300-8a68-11ea-99c4-5b5bd653cb24.gif)

- 仅搜索当前文件

同时，可以使用快捷键 `SPC s s` 仅搜索当前文件中的内容，如果需要在当前文件中搜索光标下的词，可以使用快捷键 `SPC s S`。

![searching current file](https://user-images.githubusercontent.com/13142418/35278847-e0032796-0010-11e8-911b-2ee8fd81aed2.gif)

- 在所有已经载入的文件中搜索

如果需要在所有已经打开的文件中搜索，可以使用快捷键 `SPC s b`，如果需要在所有已打开的文件中搜索光标下的词语，
则可以使用快捷键 `SPC s B`。

![searching-loaded-buffer](https://user-images.githubusercontent.com/13142418/35278996-518b8a34-0011-11e8-9a7a-613668398ee2.gif)

- 搜索指定的文件夹

如果需要指定一个文件夹来搜索，可以使用快捷键 `SPC s f`，然后输入需要搜索的文件夹即可。同理，
如果需要在指定文件夹下搜索光标下的词语，可以使用快捷键 `SPC s F`。

- 全工程后台检索

首先，需要启用 incsearch 模块：

```toml
[[layers]]
    name = 'incsearch'
```

全工程后台检索，可以使用快捷键 `SPC s j`，搜索结束后，数量会展示在状态栏上。可以使用 `SPC s l` 打开搜索列表。

### 快捷键

SpaceVim 中的搜索命令以 `SPC s` 为前缀，前一个键是使用的工具，后一个键是范围。
例如 `SPC s a b`将使用 `ag`在当前所有已经打开的缓冲区中进行搜索。

如果最后一个键（决定范围）是大写字母，那么就会对当前光标下的单词进行搜索。
举个例子 `SPC s a B` 将会搜索当前光标下的单词。

如果工具键被省略了，那么会用默认的搜索工具进行搜索。默认的搜索工具对应在 `g:spacevim_search_tools`
列表中的第一个工具。列表中的工具默认的顺序为：`rg`, `ag`, `pt`, `ack`, `grep`。
举个例子：如果 `rg` 和 `ag` 没有在系统中找到，那么 `SPC s b` 会使用 `pt` 进行搜索。

下表是全部的工具键：

| 工具 | 键  |
| ---- | --- |
| ag   | a   |
| grep | g   |
| ack  | k   |
| rg   | r   |
| pt   | t   |

应当避免的范围和对应按键为：

| 范围           | 键  |
| -------------- | --- |
| 打开的缓冲区   | b   |
| 给定目录的文件 | f   |
| 当前工程       | p   |

在 FlyGrep 内的快捷键如下：

| 快捷键              | 功能描述           |
| ----------------    | ------------------ |
| `<Esc>`             | 关闭 FlyGrep 窗口  |
| `<Enter>`           | 打开光标下文件位置 |
| `<Tab>`             | 移动至下一行       |
| `Ctrl-j`            | 移动至下一行       |
| `<S-Tab>`           | 移动至上一行       |
| `Ctrl-k`            | 移动至上一行       |
| `<Backspace>`              | 删除光标前一个字符 |
| `Ctrl-w`            | 删除光标后的单词   |
| `Ctrl-u`            | 删除光标前所有字符 |
| `Ctrl-k`            | 删除光标后所有字符 |
| `Ctrl-a` / `<Home>` | 将光标定位到行首   |
| `Ctrl-e` / `<End>`  | 将光标定位到行尾   |
