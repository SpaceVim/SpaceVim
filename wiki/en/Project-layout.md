This is the project layout of SpaceVim org:

| Repo name                                                                 | Description                                              |
| ------------------------------------------------------------------------- | -------------------------------------------------------- |
| [SpaceVim/SpaceVim](https://github.com/SpaceVim/SpaceVim)                 | SpaceVim main repo                                       |
| [SpaceVim/Ctrlp-extensions](https://github.com/SpaceVim/Ctrlp-extensions) | Ctrlp extensions used in ctrlp layer                     |
| [SpaceVim/Unite-sources](https://github.com/SpaceVim/Unite-sources)       | Unite sources used in unite layer                        |
| [SpaceVim/Denite-sources](https://github.com/SpaceVim/Denite-sources)     | Denite sources used in denite layer                      |
| [SpaceVim/unite-ctags](https://github.com/SpaceVim/unite-ctags)           | A fork of voi/unite-ctags                                |
| [SpaceVim/gtags.vim](https://github.com/SpaceVim/gtags.vim)               | SpaceVim tags layer: gtags.vim                           |
| [SpaceVim/cscope.vim](https://github.com/SpaceVim/cscope.vim)             | A cscope plugin for vim/neovim                           |
| [SpaceVim/vim-swig](https://github.com/SpaceVim/vim-swig)                 | Swig vim syntax highlighting                             |
| [SpaceVim/vim-luacomplete](https://github.com/SpaceVim/vim-luacomplete)   | lua complete plugin for vim                              |
| [SpaceVim/unite-unicode](https://github.com/SpaceVim/unite-unicode)       | Unite.vim plugin to insert unicode gyphs                 |
| [SpaceVim/vim-material](https://github.com/SpaceVim/vim-material)         | Vim colorscheme inspired by equinusocio's Material Theme |
| [wsdjeg/vim-lookup](https://github.com/wsdjeg/vim-lookup)                 | A fork of mhinz/vim-lookup, base on SpaceVim API         |

In the main repo, the layout is:

```txt
├─ .ci/                           build automation
├─ .github/                       issue/PR templates
├─ .SpaceVim.d/                   project specific configuration
├─ autoload/SpaceVim.vim          SpaceVim core file
├─ autoload/SpaceVim/api/         Public APIs
├─ autoload/SpaceVim/layers/      available layers
├─ autoload/SpaceVim/plugins/     buildin plugins
├─ autoload/SpaceVim/mapping/     mapping guide
├─ doc/                           help(cn/en)
├─ docs/                          website(cn/en)
├─ wiki/                          wiki(cn/en)
├─ bin/                           executable
└─ test/                          tests
```
