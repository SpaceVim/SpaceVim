---
title: "Use Vim as a Rust IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/75607213-9afbb880-5b2f-11ea-8569-5f39142f134b.png
description: "A general guide for using SpaceVim as Rust IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Rust IDE"
---

# [Blogs](../blog/) >> Use Vim as a Rust IDE

This is a general guide for using SpaceVim as a Rust IDE, including layer configuration and usage.
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)
- [Code completion](#code-completion)
- [Syntax linting](#syntax-linting)
- [Jump to test file](#jump-to-test-file)
- [Code formatting](#code-formatting)
- [running code](#running-code)
- [REPL support](#repl-support)
- [Tasks manager](#tasks-manager)

<!-- vim-markdown-toc -->

### Enable language layer

To add rust language support in SpaceVim, you need to enable the `lang#rust` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add the following snippet:

```toml
[[layers]]
  name = "lang#rust"
```

For more info, you can read the [lang#rust](../layers/lang/rust/) layer documentation.

### Code completion

Code completion is provided by `autocomplete` layer, the rust language completion is provided by `lang#rust` layer.
We also recommended to use `lsp` layer for rust.

```toml
[[layers]]
  name = "lsp"
```

The lsp layer uses [rls](https://github.com/rust-lang/rls) as the language server for rust, to install rls:

```sh
rustup component add rls rust-analysis rust-src
```

Add following snippet to SpaceVim config file:

```toml
[[layers]]
  name = "lsp"
  filetypes = [
    "rust"
  ]
  [layers.override_cmd]
    rust = ["rls"]
```

### Syntax linting

The `checkers` layer is enabled by default. This layer provides asynchronous syntax linting via
[neomake](https://github.com/neomake/neomake). The default lint is cargo. To use rustc as default
lint, add following config to bootstrap function:

```viml
let g:neomake_rust_enabled_makers = ['rustc']
```

### Jump to test file

SpaceVim use built-in plugin to manager the files in a project,
you can add a `.project_alt.json` to the root of your project with the following content:

```json
{
  "src/*.rs": { "alternate": "test/test_{}.rs" },
  "test/test_*.rs": { "alternate": "src/{}.rs" }
}
```

With this configuration, you can jump between the source code and test file via command `:A`

### Code formatting

The format layer is also enabled by default. With this layer you can use key binding `SPC b f` to format current buffer.
Before using this feature, please install rustfmt:

```sh
rustup component add rustfmt
```

### running code

To run current script, you can press `SPC l r`, and a split window
will be openen, the output of the script will be shown in this window.
It is running asynchronously, and will not block your Vim.

![rustide](https://user-images.githubusercontent.com/13142418/75607213-9afbb880-5b2f-11ea-8569-5f39142f134b.png)

### REPL support

Start a `evcxr` inferior REPL process with `SPC l s i`. After the REPL process being started, you can
send code to inferior process. All key bindings prefix with `SPC l s`, including sending line, sending selection or even
send whole buffer.

![rustrepl](https://user-images.githubusercontent.com/13142418/75877531-ef19dc00-5e52-11ea-87c9-bf8b103a690d.png)

### Tasks manager

The tasks manager provides a function to register task provider. Adding following vim script
into bootstrap function, then SpaceVim can detect the cargo tasks.

```viml
function! s:cargo_task() abort
    if filereadable('Cargo.toml')
        let commands = ['build', 'run', 'test']
        let conf = {}
        for cmd in commands
            call extend(conf, {
                        \ cmd : {
                        \ 'command': 'cargo',
                        \ 'args' : [cmd],
                        \ 'isDetected' : 1,
                        \ 'detectedName' : 'cargo:'
                        \ }
                        \ })
        endfor
        return conf
    else
        return {}
    endif
endfunction
call SpaceVim#plugins#tasks#reg_provider(funcref('s:cargo_task'))
```

Open SpaceVim with a rust file, after pressing `SPC p t r`, you will see the following tasks menu.

![image](https://user-images.githubusercontent.com/13142418/76683906-957b9380-6642-11ea-906e-42b6e6a17841.png)

The task will run asynchronously, and the results will be shown in the runner buffer.

![image](https://user-images.githubusercontent.com/13142418/76683919-b04e0800-6642-11ea-8dd8-f7fc0ae7e0cd.png)
