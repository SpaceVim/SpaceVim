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
- [code completion](#code-completion)
- [alternate file jumping](#alternate-file-jumping)
- [code running](#code-running)
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

### code completion

By default the autocomplete layer has been enabled, so after loading `lang#c` layer, the code completion
for C/C++ language should works well.


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


### code format

The format layer use neoformat as default tool to format code, it will format current file.
And the default key binding is `SPC b f`.

```toml
[[layers]]
  name = "format"
```

### REPL support

Start a `igcc` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process, all key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![c_repl](https://user-images.githubusercontent.com/13142418/58744043-28aa5a80-846f-11e9-94c1-e6927696e662.png)
