---
title: "Grep on the fly in SpaceVim"
categories: [feature, blog]
description: "Run grep asynchronously, show search results in real-time based on user input, support searching the entire project, searching loaded files or only searching current file"
image: https://user-images.githubusercontent.com/13142418/80607963-b704d300-8a68-11ea-99c4-5b5bd653cb24.gif
commentsID: "Grep on the fly"
comments: true
---

# [Blogs](../blog/) >> Asynchronous grep on the fly

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

![searching project](https://user-images.githubusercontent.com/13142418/80607963-b704d300-8a68-11ea-99c4-5b5bd653cb24.gif)

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

| Key Bindings      | Descriptions                      |
| ----------------- | --------------------------------- |
| `<Esc>`           | close FlyGrep buffer              |
| `<Enter>`         | open file at the cursor line      |
| `<Tab>`           | move cursor line down             |
| `Ctrl-j`          | move cursor line down             |
| `Shift-<Tab>`     | move cursor line up               |
| `Ctrl-k`          | move cursor line up               |
| `<Backspace>`     | remove last character             |
| `Ctrl-w`          | remove the word before the cursor |
| `Ctrl-u`          | remove the line before the cursor |
| `Ctrl-k`          | remove the line after the cursor  |
| `Ctrl-a`/`<Home>` | Go to the beginning of the line   |
| `Ctrl-e`/`<End>`  | Go to the end of the line         |
