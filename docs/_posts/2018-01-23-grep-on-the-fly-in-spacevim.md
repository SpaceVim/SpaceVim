---
title: "FlyGrep in SpaceVim"
categories: feature
excerpt: "Run grep Asynchronously and on the fly as you type in SpaceVim, quick searching whole project or opened files."
image: https://user-images.githubusercontent.com/13142418/34907415-c2cf7e88-f843-11e7-92d3-ef0f9b1b72ae.gif
---

# Asynchronous grep on the fly in SpaceVim

FlyGrep means **grep on the fly**, it will update the result as you type. of caulse, it is running
asynchronously. before using this feature, you need to install a searching tool. FlyGrep can be
interfaced with different searching tools like: `ag`, `rg`, `ack`, `pt` and `grep`, select any one
you like.

![grep in current project](https://user-images.githubusercontent.com/13142418/35276219-4aa9f9c0-0008-11e8-8d3c-7bf57f60a88e.gif)

This ia a build-in plugin in SpaceVim, and we also split a plugin : [FlyGrep.vim](https://github.com/wsdjeg/FlyGrep.vim)

## Features

- Searching in current file

You can use `SPC s s` to searching in current file. To searching word under the cursor, you may need to press `SPC s S`.

- Searching in all loaded buffers

To searching in all loaded buffers, you need to press `SPC s b`, and you can also use `SPC s B` to search word under the point.

- Searching in an arbitrary directory

If you want to searching in a different directory instead of current directory, you can use `SPC s f`.

- Searching in a project

In SpaceVim, you can use `SPC s p` or `SPC s /` to searching in current project.

- Background searching in a project

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

| key bindings | description |
| ------------ | ----------- |
| `<TAb>`      | next result |
