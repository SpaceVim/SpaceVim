---
title: "Use Vim as a Python IDE"
categories: [tutorials, blog]
excerpt: "A general guide for using SpaceVim as Python IDE, including layer configuration, requiems installation and usage."
type: BlogPosting
comments: true
commentsID: "Use Vim as a Python IDE"
---

# [Blogs](../blog/) >> Use Vim as a Python IDE

This is a general guide for using SpaceVim as a python IDE, including layer configuration and usage. 
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

To add python language support in SpaceVim, you need to enable the `lang#python` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#python"
```

for more info, you can read the [lang#python](../layers/lang/python/) layer documentation.

### Code completion

`lang#python` layer will load the jedi plugin automatically, unless overriden in your `init.toml`.
The completion menu will be opened as you type.

![complete python code](https://user-images.githubusercontent.com/13142418/46339650-f5a49280-c665-11e8-86d4-20944ec23098.png)

### Syntax linting

1. [neomake](https://github.com/neomake/neomake) - Asynchronous linting and make framework for Neovim/Vim

### Import packages

When edit python file, you can import the package automatically, remove unused package and format package list.

```sh
pip install --user isort
```

### Jump to test file

SpaceVim use vim-project to manager the files in a project, you can add a `.projections.json` to the root of your project with following content:

```json
{
  "src/*.py": {"alternate": "test/{dirname}/{basename}Test.py"},
  "test/**/Test*.py": {"alternate": "src/{}.py"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`



### running code

To run current script, you can press `SPC l r`, and a split windows
will be openen, the output of the script will be shown in this windows.
It is running asynchronously, and will not block your vim.

![code runner](https://user-images.githubusercontent.com/13142418/46293837-1c5fbc00-c5c7-11e8-9f3c-c11504e2e04a.png)

### Code formatting

1. [neoformat](https://github.com/sbdchd/neoformat) - A (Neo)vim plugin for formatting code.

For formatting java code, you also nEed have [uncrustify](http://astyle.sourceforge.net/) or [astyle](http://astyle.sourceforge.net/) in your PATH.
BTW, the google's [java formatter](https://github.com/google/google-java-format) also works well with neoformat.


### REPL

Start a `ipython` or `python` inferior REPL process with `SPC l s i`. After the REPL process has been started. you can 
send code to inferior process, all key bindings are begin with `SPC l s` prefix, including sending line, sending selection or even
send whole buffer.

![REPl-JAVA](https://user-images.githubusercontent.com/13142418/34159605-758461ba-e48f-11e7-873c-fc358ce59a42.gif)

