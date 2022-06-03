---
title: "Use Vim as a C/C++ IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/58743787-db2bee80-846a-11e9-9b19-17202ac542c9.png
description: "A general guide for using SpaceVim as C/C++ IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a C/C++ IDE"
---

# [Blogs](../blog/) >> Use Vim as a C/C++ IDE

This is a general guide for using SpaceVim as a C/C++ IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Syntax highlighting](#syntax-highlighting)
- [code completion](#code-completion)
- [alternate file jumping](#alternate-file-jumping)
- [code running](#code-running)
- [Syntax lint](#syntax-lint)
- [code format](#code-format)
- [REPL support](#repl-support)

<!-- vim-markdown-toc -->

### Enable language layer

To add C/C++ language support in SpaceVim, you need to enable the `lang#c` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#c"
```

for more info, you can read the [lang#c](../layers/lang/c/) layer documentation.

### Syntax highlighting

The basic syntax highlighting is based on regular expression, If you want `clang` based
syntax highlighting. Enable `enable_clang_syntax_highlight` layer option:

```toml
[[layers]]
    name = 'lang#c'
    enable_clang_syntax_highlight = true
```

This option requires `+python` or `+python3` enabled and `libclang` has been installed.

### code completion

By default the autocomplete layer has been enabled, so after loading `lang#c` layer, the code completion
for C/C++ language should works well.

If the `autocomplete_method` is `deoplete`, then `Shougo/deoplete-clangx` will be loaded in `lang#c` layer.

If the `autocomplete_method` is `asyncomplete`, then `wsdjeg/asyncomplete-clang.vim` will be loaded.

If the `autocomplete_method` is `neocomplete`, Then `Rip-Rip/clang_complete` will be loaded.

You can check the value of `autocomplete_method` via `:SPSet autocomplete_method`.

### alternate file jumping

To manage the alternate file for a project, you may need to create a `.project_alt.json` file in the root of your
project.

for exmaple, add following content into the `.project_alt.json` file:

```json
{
  "*.c": {"alternate": "{}.h"},
  "*.h": {"alternate": "{}.c"}
}
```

with this configuration, you can jump between the alternate file via command `:A`


### code running

The default code running key binding is `SPC l r`. It will compile and run current file asynchronously.
And the stdout will be shown on a runner buffer.

![c-cpp-runner](https://user-images.githubusercontent.com/13142418/58743787-db2bee80-846a-11e9-9b19-17202ac542c9.png)

The default runner compile option is defineded in `clang_std` and `clang_flag` option.
If you want to use `c11`, you can change `clang_std` option to:

```toml
[[layers]]
  name = "lang#c"
  [layer.clang_std]
    cpp = "c11"
```

You can also create a `.clang` file in the root directory of you project. Within this
file, all compile option should be defineded in it. for example:

```
-I/home/test
-I/user/std/include
```

### Syntax lint

The [checker](../layers/checkers/) layer provides syntax checking for many programming languages.
Including C/C++, and the default plugin is [neomake](https://github.com/neomake/neomake). The default
lint for C/C++ is `gcc`/`g++`. These commands also read configuration in `.clang` file.

### code format

In order to be able to format C/C++ files, you need to install `uncrustify`, `clangformat` or `astyle`.
The key binding `SPC b f` is defineded in [format](../layers/format/) layer which is loaded by default.
In this layer, the default format engine is `neoformat`.

### REPL support

Start a `igcc` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process, all key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![c_repl](https://user-images.githubusercontent.com/13142418/58744043-28aa5a80-846f-11e9-94c1-e6927696e662.png)
