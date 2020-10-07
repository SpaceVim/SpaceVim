---
title: "Use Vim as a Clojure IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/57321608-4a484880-7134-11e9-8e43-5fa05085d7e5.png
description: "A general guide for using SpaceVim as Clojure IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Clojure IDE"
---

# [Blogs](../blog/) >> Use Vim as a Clojure IDE

This is a general guide for using SpaceVim as a Clojure IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [code completion](#code-completion)
- [alternate file jumping](#alternate-file-jumping)
- [code running](#code-running)
- [code format](#code-format)
- [Tasks manage](#tasks-manage)

<!-- vim-markdown-toc -->

### Enable language layer

To add clojure language support in SpaceVim, you need to enable the `lang#clojure` layer.
Press `SPC f v d` to open SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = 'lang#clojure'
```

for more info, you can read the [lang#clojure](../layers/lang/clojure/) layer documentation.

### code completion

By default the autocomplete layer has been enabled, so after loading `lang#clojure` layer, the code completion
for clojure language should work well.


### alternate file jumping

To manage the alternate file for a project, you may need to create a `.project_alt.json` file in the root of your
project.

for example, add following content into the `.project_alt.json` file:

```json
{
  "src/*.clj": {"alternate": "test/{}.clj"},
  "test/*.clj": {"alternate": "src/{}.clj"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`


### code running

The default code running key binding is `SPC l r`. It will run `clojure -M current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![clojure-runner](https://user-images.githubusercontent.com/13142418/95334765-1a7d1180-08e1-11eb-8c78-9a87d61d3d63.png)

### code format

The format layer use neoformat as default tool to format code, it will run `cljfmt` on current file.
And the default key binding is `SPC b f`.

```toml
[[layers]]
  name = "format"
```

### Tasks manage

SpaceVim will detect `lein` project tasks automatically. If there is `project.clj` file in the root directory
of your project. following tasks will be detected:

```
lein:run
lein:test
```

To select a tast to run, use key binding `SPC p t r`, you can also use `SPC p t l` to list all the tasks
in the tasks manager window.
