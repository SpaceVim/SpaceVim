---
title: "Use Vim as a Perl IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/52611209-54550500-2ebf-11e9-9b9f-f697a0db52a3.png
description: "A general guide for using SpaceVim as Perl IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Perl IDE"
---

# [Blogs](../blog/) >> Use Vim as a Perl IDE

This is a general guide for using SpaceVim as a Perl IDE, including layer configuration and usage.
Each of the following sections will be covered:


<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add Perl language support in SpaceVim, you need to enable the `lang#perl` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet:

```toml
[[layers]]
  name = "lang#perl"
```

For more info, you can read the [lang#perl](../layers/lang/perl/) layer documentation.

### Code completion

`lang#perl` layer will load the Perl plugin automatically, unless it's overriden in your `init.toml`.
The completion menu will be opened as you type.

![perlcomplete](https://user-images.githubusercontent.com/13142418/52611209-54550500-2ebf-11e9-9b9f-f697a0db52a3.png)

### Syntax linting

The checkers layer is enabled by default. This layer provides asynchronous syntax linting via [neomake](https://github.com/neomake/neomake).
It will run Perl and perlcritic asynchronously.

Install perlcritic via cpan:

```sh
cpanm Perl::Critic
```

![perllint](https://user-images.githubusercontent.com/13142418/52614908-2cb96900-2ece-11e9-8c73-2881f8030c6e.png)

### Jump to test file

SpaceVim use built-in plugin to manager the files in a project, you can add a `.project_alt.json` to the root of your project with the following content:

```json
{
  "src/*.pl": {"alternate": "test/{}.pl"},
  "test/*.pl": {"alternate": "src/{}.pl"}
}
```

With this configuration, you can jump between the source code and test file via command `:A`

### running code

To run current script, you can press `SPC l r`, and a split window
will be openen, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![perlrunner](https://user-images.githubusercontent.com/13142418/52611211-54550500-2ebf-11e9-9baf-a6437da8fcf4.png)

### Code formatting

The format layer is also enabled by default. With this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install perltidy:

```sh
cpanm Perl::Tidy
```

### REPL support

Start a `perli` or  `perl -del` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![perlrepl](https://user-images.githubusercontent.com/13142418/52611210-54550500-2ebf-11e9-8ba2-b5cd3cc70885.gif)

