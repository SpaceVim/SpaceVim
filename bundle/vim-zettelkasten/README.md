# vim-zettelkasten

> _vim-zettelkasten_ is a [Zettelkasten](https://zettelkasten.de) note taking plugin, which is forked from [zettelkasten.nvim@fe174666](https://github.com/Furkanzmc/zettelkasten.nvim/tree/fe1746666e27c2fcc0e60dc2786cb9983b994759).

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Usage](#usage)
- [Screenshots](#screenshots)
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

## Usage

**Commands:**

| Command           | description                       |
| ----------------- | --------------------------------- |
| `:ZkNew`          | create new note                   |
| `:ZkBrowse`       | list note in browser window       |
| `:ZkListTags`     | filter tags in telescope          |
| `:ZkListTemplete` | filte note templates in telescope |
| `:ZkListNotes`    | filte note title in telescope     |

**Key bindings in browser window:**

| key bindings    | description                        |
| --------------- | ---------------------------------- |
| `F2`            | open zettelkasten tags sidebar     |
| `<LeftRelease>` | filter notes based on cursor tag   |
| `gf`            | open the note                      |
| `Ctrl-l`        | clear tags filter pattarn          |
| `Ctrl-] / K`    | preview note in vim preview-window |
| `[I`            | list references in quickfix-window |

## Screenshots

![](https://wsdjeg.net/images/zkbrowser.png)
![](https://wsdjeg.net/images/zettelkasten-tags-sidebar.png)
![](https://wsdjeg.net/images/zettelkasten-tags-filter.png)
![](https://wsdjeg.net/images/zettelkasten-complete-id.png)

## Feedback

The development of this plugin is in [`SpaceVim/bundle/vim-zettelkasten`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/vim-zettelkasten) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
