---
title: "Use Vim as a Python IDE"
categories: [tutorials, blog]
description: "A general guide for using SpaceVim as Python IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Python IDE"
---

# [Blogs](../blog/) >> Use Vim as a Python IDE

This is a general guide for using SpaceVim as a Python IDE, including layer configuration and usage.
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Import packages](#import-packages)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL](#repl)

<!-- vim-markdown-toc -->

### Enable language layer

To add Python language support in SpaceVim, you need to enable the `lang#python` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet to your configuration:

```toml
[[layers]]
  name = "lang#python"
```

For more info, you can read the [lang#python](../layers/lang/python/) layer documentation.

### Code completion

`lang#python` layer will load the jedi plugin automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![complete python code](https://user-images.githubusercontent.com/13142418/46339650-f5a49280-c665-11e8-86d4-20944ec23098.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run flake asynchronously.

To install flake8, just run following command in terminal.

```sh
pip install --user flake8
```

### Import packages

When edit Python file, you can import the package automatically, remove unused package and format package list.

```sh
pip install --user isort
```

### Jump to test file

SpaceVim use built-in plugin to manager the files in a project,
you can add a `.project_alt.json` to the root of your project with following content:

```json
{
  "src/*.py": {"alternate": "test/{}.py"},
  "test/*.py": {"alternate": "src/{}.py"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`.

### running code

To run current script, you can press `SPC l r`, and a split window
will open, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![code runner](https://user-images.githubusercontent.com/13142418/46293837-1c5fbc00-c5c7-11e8-9f3c-c11504e2e04a.png)

### Code formatting

The format layer is also enabled by default, with this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install yapf.

```sh
pip install --user yapf
```

### REPL

Start a `ipython` or `python` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![pythonrepl](https://user-images.githubusercontent.com/13142418/52177776-0fffa000-2801-11e9-9698-8e32f2865f5a.gif)
