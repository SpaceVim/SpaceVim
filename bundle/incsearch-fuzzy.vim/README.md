incsearch-fuzzy.vim
===================

incremantal fuzzy search extension for [incsearch.vim](https://github.com/haya14busa/incsearch.vim)

![incsearch-fuzzy.gif](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/extensions/incsearch-fuzzy.gif)

### Dependencies
- https://github.com/haya14busa/incsearch.vim

### Installtaion

[Neobundle](https://github.com/Shougo/neobundle.vim) / [Vundle](https://github.com/gmarik/Vundle.vim) / [vim-plug](https://github.com/junegunn/vim-plug)

```vim
NeoBundle 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch.vim'

NeoBundle 'haya14busa/incsearch-fuzzy.vim'
Plugin 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
```

[pathogen](https://github.com/tpope/vim-pathogen)

```
git clone https://github.com/haya14busa/incsearch.vim ~/.vim/bundle/incsearch.vim
git clone https://github.com/haya14busa/incsearch-fuzzy.vim ~/.vim/bundle/incsearch-fuzzy.vim
```

### Usage

#### fuzzy search

**Give it a shot!** :gun: `:call incsearch#call(incsearch#config#fuzzy#make()) `

```vim
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
```

#### fuzzyspell search

It use `spell` feature in Vim

![incsearch-fuzzyspell.gif](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/extensions/incsearch-fuzzyspell.gif)

```vim
map z/ <Plug>(incsearch-fuzzyspell-/)
map z? <Plug>(incsearch-fuzzyspell-?)
map zg/ <Plug>(incsearch-fuzzyspell-stay)
```

### API

#### fuzzy
- `incsearch#config#fuzzy#converter()`: return fuzzy converter function
- `incsearch#config#fuzzy#make()`: return default config for fuzzy command

#### fuzzyspell
- `incsearch#config#fuzzyspell#converter()`: return fuzzyspell converter function
- `incsearch#config#fuzzyspell#make`: return default config for fuzzyspell command

#### Example: Use both fuzzy & fuzzyspell feature

```vim
function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> zg? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
```
