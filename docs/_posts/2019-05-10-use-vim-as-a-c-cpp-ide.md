---
title: "Use Vim as a C/C++ IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/57497567-c6948480-730a-11e9-95ec-e44bf6e79984.png
excerpt: "A general guide for using SpaceVim as C/C++ IDE, including layer configuration, requiems installation and usage."
type: BlogPosting
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

![gorun](https://user-images.githubusercontent.com/13142418/50751761-22300200-1286-11e9-8b4f-76836438d913.png)


### code format

The format layer use neoformat as default tool to format code, it will format current file.
And the default key binding is `SPC b f`.

```toml
[[layers]]
  name = "format"
```

