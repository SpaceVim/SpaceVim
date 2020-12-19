---
title: "Use Vim as a Go IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/57321608-4a484880-7134-11e9-8e43-5fa05085d7e5.png
description: "A general guide for using SpaceVim as Go IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Go IDE"
---

# [Blogs](../blog/) >> Use Vim as a Go IDE

This is a general guide for using SpaceVim as a Go IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [code completion](#code-completion)
- [alternate file jumping](#alternate-file-jumping)
- [code running](#code-running)
- [project building](#project-building)
- [run test](#run-test)
- [code coverage](#code-coverage)
- [code format](#code-format)

<!-- vim-markdown-toc -->

### Enable language layer

To add go language support in SpaceVim, you need to enable the `lang#go` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#go"
```

for more info, you can read the [lang#go](../layers/lang/go/) layer documentation.

### code completion

By default the autocomplete layer has been enabled, so after loading `lang#go` layer, the code completion
for go language should work well.


### alternate file jumping

To manage the alternate file for a project, you may need to create a `.project_alt.json` file in the root of your
project.

for example, add following content into the `.project_alt.json` file:

```json
{
  "src/*.go": {"alternate": "test/{}.go"},
  "test/*.go": {"alternate": "src/{}.go"}
}
```

with this configuration, you can jump between the source code and test file via command `:A`


### code running

The default code running key binding is `SPC l r`. It will run `go run current_file` asynchronously.
And the stdout will be shown on a runner buffer.

![gorun](https://user-images.githubusercontent.com/13142418/50751761-22300200-1286-11e9-8b4f-76836438d913.png)


### project building

Key binding for building current project is `SPC l b`, It will run `go build` asynchronously.
after building successfully you should see this message on the cmdline:

```txt
vim-go: [build] SUCCESS
```

### run test

There are two key bindings for running test, `SPC l t` run test for current file,
`SPC l T` only run test for current function. if the test is passed, you should see
following message on cmdline:

```txt
vim-go: [test] SUCCESS 
```

### code coverage

Key binding for showing the coverage of your source code is `SPC l c`, it will call `GoCoverageToggle` command from vim-go.

![cov](https://user-images.githubusercontent.com/13142418/57342383-57375d00-7171-11e9-9182-281d7a792c68.gif)

### code format

The format layer use neoformat as default tool to format code, it will run `gofmt` on current file.
And the default key binding is `SPC b f`.

```toml
[[layers]]
  name = "format"
```
