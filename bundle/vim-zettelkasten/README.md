# vim-zettelkasten

> _vim-zettelkasten_ is a [Zettelkasten](https://zettelkasten.de) note taking plugin, which is forked from [zettelkasten.nvim@fe174666](https://github.com/Furkanzmc/zettelkasten.nvim/tree/fe1746666e27c2fcc0e60dc2786cb9983b994759).

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

1. Using `vim-zettelkasten` in SpaceVim:

```toml
[[layers]]
  name = 'zettelkasten'
  zettel_dir = 'D:\me\zettelkasten'
  zettel_template_dir = 'D:\me\zettelkasten_template'
```

2. Using `vim-zettelkasten` without SpaceVim:

```vim
Plug 'wsdjeg/vim-zettelkasten'
let g:zettelkasten_directory = 'D:\me\zettelkasten'
let g:zettelkasten_template_directory = 'D:\me\zettelkasten_template'
```


## Feedback

The development of this plugin is in [`SpaceVim/bundle/vim-zettelkasten`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/vim-zettelkasten) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
