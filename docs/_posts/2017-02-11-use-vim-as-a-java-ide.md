---
title: "Use Vim as a Java IDE"
categories: [tutorials, blog]
excerpt: "A general guide for using SpaceVim as Java IDE, including layer configuration and requiems installation."
redirect_from: "/2017/02/11/use-vim-as-a-java-ide.html"
type: BlogPosting
comments: true
commentsID: "Use Vim as a Java IDE"
---

# [Blogs](../blog/) >> Use Vim as a Java IDE

This is a general guide for using SpaceVim as a Java IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Code completion](#code-completion)
- [Syntax lint](#syntax-lint)
- [Import packages](#import-packages)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL](#repl)

<!-- vim-markdown-toc -->

## Installation

SpaceVim is a Vim and neovim configuration, so you need to install vim or neovim,
here are two guides for installing neovim and vim8 with `+python3` feature.
following the [quick start guide](../quick-start-guide/) to install SpaceVim.

SpaceVim do not enable language layer by default, so you need to enable `lang#java` layer.
Press `SPC f v d` to open SpaceVim configuration file, and add following section:


```toml
[[layers]]
  name = "lang#java"
```

## Code completion

javacomplete2 which has been included in `lang#java` layer provides omnifunc for java file and deoplete source.
with this plugin and `autocomplete` layer, the completion popup menu will be opened automatically。

![code complete](https://user-images.githubusercontent.com/13142418/46297202-ba0ab980-c5ce-11e8-81a0-4a4a85bc98a5.png)

## Syntax lint

`checkers` layer provides asynchronous linting feature, this layer use [neomake](https://github.com/neomake/neomake) by default.
neomake support maven, gradle and eclipse project. it will generate classpath automatically for these project.

![lint-java](https://user-images.githubusercontent.com/13142418/46323584-99b81a80-c621-11e8-8ca5-d8eb7fbd93cf.png)

within above picture, we can see the checkers layer provides following feature:

- list errors and warnings in quickfix windows
- sign error and warning position on the left side
- show numbers of errors and warnings on statusline
- show cursor error and warning information below current line

## Import packages

There are two kind features for importing packages, import packages automatically and manually. SpaceVim will import the packages after selecting the class name on popmenu.
Also, you can use key binding `<F4>` to import the class at the cursor point. If there are more than one class, a menu will be shown below current windows.

![import class](https://user-images.githubusercontent.com/13142418/46298485-c04e6500-c5d1-11e8-96f3-01d84f9fe237.png)

## Jump to test file

SpaceVim use vim-project to manager the files in a project, you can add a `.projections.json` to the root of your project with following content:

```json
{
  "src/main/java/*.java": {"alternate": "src/test/java/{dirname}/Test{basename}.java"},
  "src/test/java/**/Test*.java": {"alternate": "src/main/java/{}.java"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`

![jump-test](https://user-images.githubusercontent.com/13142418/46322905-12b57300-c61e-11e8-81a2-53c69d10140f.gif)


## running code

Base on JavaUnite, you can use `SPC l r c` to run current function or use `SPC l r m` to run the main function of current Class.

![run-main](https://user-images.githubusercontent.com/13142418/46323137-61174180-c61f-11e8-94df-61b6998b8907.gif)


## Code formatting

For formatting java code, you also nEed have [uncrustify](http://astyle.sourceforge.net/) or [astyle](http://astyle.sourceforge.net/) in your PATH.
BTW, the google's [java formatter](https://github.com/google/google-java-format) also works well with neoformat.

![format-java](https://user-images.githubusercontent.com/13142418/46323426-ccadde80-c620-11e8-9726-d99025f3bf76.gif)

## REPL

you need to install jdk9 which provide a build-in tools `jshell`, and SpaceVim use the `jshell` as default inferior REPL process:

![REPl-JAVA](https://user-images.githubusercontent.com/13142418/34159605-758461ba-e48f-11e7-873c-fc358ce59a42.gif)
