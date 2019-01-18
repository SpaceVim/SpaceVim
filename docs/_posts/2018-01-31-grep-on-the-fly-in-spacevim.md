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

# [Blogs](../blog/) >> Vim 异步实时代码检索

{{ page.date | date_to_string }}

FlyGrep means **grep on the fly**, it will update the result as you type. Of course, it is running
asynchronously. Before using this feature, you need to install a searching tool. FlyGrep works
through search tools: `ag`, `rg`, `ack`, `pt` and `grep`, Choose one you like.

This ia a built-in plugin in SpaceVim, and we also separated a plugin : [FlyGrep.vim](https://github.com/wsdjeg/FlyGrep.vim)

## Install

In linux os, flygrep use grep by default, if you want a more fast tool, you can choose one of following:

- [ripgrep(rg)](https://github.com/BurntSushi/ripgrep)
- [the_silver_searcher(ag)](https://github.com/ggreer/the_silver_searcher)
- [the_platinum_searcher(pt)](https://github.com/monochromegane/the_platinum_searcher)

## Features

- **Search in a project**

In SpaceVim, you can use `SPC s p` or `SPC s /` to search in the current project.

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

- **Search in current file**

You can use `SPC s s` to search in the current file. To search word under the cursor, you can press `SPC s S`.

![searching current file](https://user-images.githubusercontent.com/13142418/35278847-e0032796-0010-11e8-911b-2ee8fd81aed2.gif)

- **Search in all loaded buffers**

To searching in all loaded buffers, you need to press `SPC s b`, and you can also use `SPC s B` to search word under the point.

![searching-loaded-buffer](https://user-images.githubusercontent.com/13142418/35278996-518b8a34-0011-11e8-9a7a-613668398ee2.gif)

- **Search in an arbitrary directory**

If you want to searching in a different directory instead of current directory, you can
use `SPC s f`. Then insert the path of the arbitrary directory.

- **Search in a project in the background**

If you need background searching, you can press `SPC s j`, after searching is done, the index will be displayed on statusline. you can use `SPC s l` to list all the search results.

## Key bindings

The search commands in SpaceVim are organized under the `SPC s` prefix with the next key is the tool to use and the last key is the scope. For instance `SPC s a b` will search in all opened buffers using `ag`.

If the last key (determining the scope) is uppercase then the current word under the cursor is used as default input for the search. For instance `SPC s a B` will search with word under cursor.

If the tool key is omitted then a default tool will be automatically selected for the search. This tool corresponds to the first tool found on the system of the list `g:spacevim_search_tools`, the default calling sequence is `rg`, `ag`, `pt`, `ack` then `grep`. For instance `SPC s b` will search in the opened buffers using `pt` if `rg` and `ag` have not been found on the system.

The tool keys are:

| Tool | Key |
| ---- | --- |
| ag   | a   |
| grep | g   |
| ack  | k   |
| rg   | r   |
| pt   | t   |

The available scopes and corresponding keys are:

| Scope                      | Key |
| -------------------------- | --- |
| opened buffers             | b   |
| files in a given directory | f   |
| current project            | p   |

**Within FlyGrep buffer:**

| Key Binding      | Description                       |
| ---------------- | --------------------------------- |
| `<Esc>`          | close FlyGrep buffer              |
| `<Enter>`        | open file at the cursor line      |
| `<Tab>`          | move cursor line down             |
| `<C-j>`          | move cursor line down             |
| `<S-Tab>`        | move cursor line up               |
| `<C-k>`          | move cursor line up               |
| `<Bs>`           | remove last character             |
| `<C-w>`          | remove the word before the cursor |
| `<C-u>`          | remove the line before the cursor |
| `<C-k>`          | remove the line after the cursor  |
| `<C-a>`/`<Home>` | Go to the beginning of the line   |
| `<C-e>`/`<End>`  | Go to the end of the line         |
