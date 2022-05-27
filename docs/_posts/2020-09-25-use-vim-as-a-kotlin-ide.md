---
title: "Use Vim as a Kotlin IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/94328509-cbcc9f00-ffe5-11ea-8f0d-9ea7b5b81352.png
description: "A general guide for using SpaceVim as Kotlin IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Kotlin IDE"
---

# [Blogs](../blog/) >> Use Vim as a Kotlin IDE

This is a general guide for using SpaceVim as a Kotlin IDE, including layer configuration and usage.
Each of the following sections will be covered:


<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL support](#repl-support)
- [Tasks manager](#tasks-manager)

<!-- vim-markdown-toc -->

### Enable language layer

To add Kotlin language support in SpaceVim, you need to enable the `lang#kotlin` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet:

```toml
[[layers]]
  name = "lang#kotlin"
```

For more info, you can read the [lang#kotlin](../layers/lang/kotlin/) layer documentation.

### Code completion

`lang#kotlin` layer will load the Kotlin plugin automatically, unless it's overriden in your `init.toml`.
The completion menu will be opened as you type.

### Syntax linting

The [checkers](../checkers/) layer is enabled by default.
This layer provides asynchronous syntax linting for kotlin.
The default plugin is [neomake](https://github.com/neomake/neomake),
and the default lint command is [ktlint](https://github.com/pinterest/ktlint).

In the Windows system, `ktlint` can be installed using [scoop](https://github.com/lukesampson/scoop):

```
scoop bucket add extras
scoop install ktlint
```

![kotlin-lint](https://user-images.githubusercontent.com/13142418/94366839-3e846a00-010d-11eb-9e6c-200931646479.png)

### Jump to test file

To manager the alternate files in a project, you need to current a `.project_alt.json` in the root of your project.
Within the `.project_alt.json` file, the definitions of alternate files should be included.

For example:

```json
{
  "src/*.kt": {"alternate": "test/{}.kt"},
  "test/*.kt": {"alternate": "src/{}.kt"}
}
```

With this configuration, you can jump between the source code and test file via command `:A`

### running code

To run current kotlin script, you can press `SPC l r`, and a split window
will be openen, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![kotlin-runner](https://user-images.githubusercontent.com/13142418/94288524-14566f00-ff8a-11ea-8440-ee9ca8ba8843.png)

### Code formatting

The [format](../format/) layer is also enabled by default.
With this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install [prettier](https://prettier.io/):

```
npm install --save-dev --save-exact prettier
```

### REPL support

Start a `kotlinc-jvm` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![kotlin-repl](https://user-images.githubusercontent.com/13142418/94289606-84192980-ff8b-11ea-84c8-1547741f377c.png)

### Tasks manager

Create `.SpaceVim.d/task.toml` file in the root of your project. and add all the task command into it.

```toml
[gradle-build]
    command = 'gradlew'
    args = ['build']
```

For more info about task configuration, please checkout the [task documentation](../documentation/#task)


This article is not finished yet and new content will be updated in the future.
If you want to help improve this article, please join the SpaceVim [gitter room](https://gitter.im/SpaceVim/SpaceVim).
