# vim-toml

Vim syntax for [TOML](https://github.com/toml-lang/toml).

## Installation

### Vim packages (recommended; Vim 8+ only)

Clone or submodule this repo into your Vim packages location. Example:

```
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/cespare/vim-toml.git
```

### Pathogen

Set up [Pathogen](https://github.com/tpope/vim-pathogen) then clone/submodule
this repo into `~/.vim/bundle/toml`, or wherever you've pointed your Pathogen.

### Vundle

Set up [Vundle](https://github.com/VundleVim/Vundle.vim) then add `Plugin
'cespare/vim-toml'` to your vimrc and run `:PluginInstall` from a fresh vim.

### vim-plug

Set up [vim-plug](https://github.com/junegunn/vim-plug). In your .vimrc, between
the lines for `call plug#begin()` and `call plug#end()`, add the line `Plug
'cespare/vim-toml', { 'branch': 'main' }`. Reload your .vimrc and then run `:PlugInstall`.

### Janus

Set up [Janus](https://github.com/carlhuda/janus) and then clone/submodule this
repo into `~/.janus` and restart vim.

## Contributing

Contributions are very welcome! Just open a PR.
