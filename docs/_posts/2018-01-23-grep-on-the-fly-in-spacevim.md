---
title: "Grep on the fly in SpaceVim"
categories: feature
excerpt: "Run grep Asynchronously and on the fly as you type in SpaceVim, quick searching whole project or opened files."
image: https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif
---

# Asynchronous grep on the fly

FlyGrep means **grep on the fly**, it will update the result as you type. Of course, it is running
asynchronously. Before using this feature, you need to install a searching tool. FlyGrep can be
interfaced with different searching tools like: `ag`, `rg`, `ack`, `pt` and `grep`, select any one
you like.

This ia a build-in plugin in SpaceVim, and we also separate a plugin : [FlyGrep.vim](https://github.com/wsdjeg/FlyGrep.vim)

## Features

- **Searching in a project**

In SpaceVim, you can use `SPC s p` or `SPC s /` to searching in current project.

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

- **Searching in current file**

You can use `SPC s s` to searching in current file. To searching word under the cursor, you may need to press `SPC s S`.

![searching current file](https://user-images.githubusercontent.com/13142418/35278847-e0032796-0010-11e8-911b-2ee8fd81aed2.gif)

- **Searching in all loaded buffers**

To searching in all loaded buffers, you need to press `SPC s b`, and you can also use `SPC s B` to search word under the point.

![searching-loaded-buffer](https://user-images.githubusercontent.com/13142418/35278996-518b8a34-0011-11e8-9a7a-613668398ee2.gif)

- **Searching in an arbitrary directory**

If you want to searching in a different directory instead of current directory, you can
use `SPC s f`. Then insert the path of the arbitrary directory.

- **Background searching in a project**

If you need background searching, you can press `SPC s j`, after searching is done, the index will be shown on statusline. you can use `SPC s l` to list all the searching result.

## Key bindings

The search commands in SpaceVim are organized under the `SPC s` prefix with the next key is the tool to use and the last key is the scope. For instance `SPC s a b` will search in all opened buffers using `ag`.

If the last key (determining the scope) is uppercase then the current word under the cursor is used as default input for the search. For instance `SPC s a B` will search with word under cursor.

If the tool key is omitted then a default tool will be automatically selected for the search. This tool corresponds to the first tool found on the system of the list `g:spacevim_search_tools`, the default order is `rg`, `ag`, `pt`, `ack` then `grep`. For instance `SPC s b` will search in the opened buffers using `pt` if `rg` and `ag` have not been found on the system.

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
| `<C-w>`          | remove the Word before the cursor |
| `<C-u>`          | remove the Line before the cursor |
| `<C-k>`          | remove the Line after the cursor  |
| `<C-a>`/`<Home>` | Go to the beginning of the line   |
| `<C-e>`/`<End>`  | Go to the end of the line         |
