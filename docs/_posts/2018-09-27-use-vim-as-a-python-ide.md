---
title: "Use Vim as a Python IDE"
categories: [tutorials, blog]
description: "A general guide for using SpaceVim as Python IDE, including layer configuration, requiems installation and usage."
type: article
image: https://img.spacevim.org/197381840-821cc059-0aad-42fd-bc39-d5fa16a824f7.png
comments: true
commentsID: "Use Vim as a Python IDE"
---

# [Blogs](../blog/) >> Use Vim as a Python IDE

This tutorial introduces you to SpaceVim as a Python environment,
by using the `lang#python` layer, you make SpaceVim into a great lightweight Python IDE.

![python-ide](https://img.spacevim.org/197381840-821cc059-0aad-42fd-bc39-d5fa16a824f7.png)

Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Select a Python interpreter](#select-a-python-interpreter)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Code formatting](#code-formatting)
- [Import packages](#import-packages)
- [Jump between alternate files](#jump-between-alternate-files)
- [Code running](#code-running)
- [REPL](#repl)

<!-- vim-markdown-toc -->

This tutorial is not intended to teach you Python itself.

If you have any problems, feel free to join the [chatting room](https://app.element.io/#/room/#spacevim:matrix.org) for general discussion.


### Enable language layer

The python language support in SpaceVim is provided by `lang#python` layer, and it is not enabled by default.
You need to enable it in SpaceVim configuration file. Press `SPC f v d` to open the SpaceVim configuration file,
and add following snippet to your configuration file.

```toml
[[layers]]
  name = "lang#python"
```

For more info, you can read the [lang#python](../layers/lang/python/) layer documentation.

### Select a Python interpreter

Python is an interpreted language, and in order to run Python code and get semantic information,
you need to tell SpaceVim which interpreter to use. This can be set with `python_interpreter` layer
option. For example:

```toml
[[layers]]
  name = 'lang#python'
  python_interpreter = 'D:\scoop\shims\python.exe'
```

This option will be applied to neomake's python maker and python code runner.

### Code completion

Code autocompletion is provided by `autocomplete` layer, which is loaded by default.
The language completion source is included in `lang#python` layer.
This layer includes `deoplete-jedi` for neovim.

![complete python code](https://img.spacevim.org/46339650-f5a49280-c665-11e8-86d4-20944ec23098.png)

### Syntax linting

Code Linting is provided by [`checkers`](../layers/checkers/) layer, which is also enabled by default.
There are two syntax linters enabled by default,
python and [pylint](https://pylint.org/), both of them run asynchronously.

To install pylint, just run following command in terminal.

```sh
pip install --user pylint
```

### Code formatting

Code formatting is provided by [`format`](../layers/format/) layer, this layer is also enabled by default.
And the key binding to format current buffer is `SPC b f`. The default formatter for python code is [yapf](https://github.com/google/yapf).

So, before using this feature, please install yapf.

```sh
pip install --user yapf
```
### Import packages

When edit Python file, you can import the package automatically, remove unused package and format package list.

```sh
pip install --user isort
```

### Jump between alternate files

The alternate files manager provides a command `:A`, with this command,
you can jump between alternate files within a project.

The alternate file structure can be definded in a `.project_alt.json`
file in the root of your project.

For example:

```json
{
  "src/*.py": {"alternate": "test/{}.py"},
  "test/*.py": {"alternate": "src/{}.py"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`.

### Code running

Code running is provided by builtin code runner. To run current script,
you can press `SPC l r`, and a split window will open,
the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![code runner](https://img.spacevim.org/46293837-1c5fbc00-c5c7-11e8-9f3c-c11504e2e04a.png)


### REPL

Start a `ipython` or `python` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![pythonrepl](https://img.spacevim.org/52177776-0fffa000-2801-11e9-9698-8e32f2865f5a.gif)
