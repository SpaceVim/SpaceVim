incsearch-easymotion.vim
========================

Integration between [haya14busa/incsearch.vim](https://github.com/haya14busa/incsearch.vim) and [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)

![incsearch-easymotion.gif](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/extensions/incsearch-easymotion.gif)

### Dependencies
- https://github.com/haya14busa/incsearch.vim
- https://github.com/easymotion/vim-easymotion

### Installtaion

[Neobundle](https://github.com/Shougo/neobundle.vim) / [Vundle](https://github.com/gmarik/Vundle.vim) / [vim-plug](https://github.com/junegunn/vim-plug)

```vim
NeoBundle 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch.vim'

NeoBundle 'haya14busa/incsearch-easymotion.vim'
Plugin 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
```

[pathogen](https://github.com/tpope/vim-pathogen)

```
git clone https://github.com/haya14busa/incsearch.vim ~/.vim/bundle/incsearch.vim
git clone https://github.com/haya14busa/incsearch-easymotion.vim ~/.vim/bundle/incsearch-easymotion.vim
```

### Usage

**Give it a shot!** :gun: `:call incsearch#call(incsearch#config#easymotion#make()) `

```vim
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)
```

### Advanced usage

#### incremental fuzzymotion
![incsearch-fuzzy-easymotion.gif](https://raw.githubusercontent.com/haya14busa/i/master/incsearch.vim/extensions/incsearch-fuzzy-easymotion.gif)

```vim
" incsearch.vim x fuzzy x vim-easymotion

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
```

### API
- `incsearch#config#easymotion#module()`: return easymotion module for incsearch.vim
  - It provide `<Over>(easymotion)` key to invoke easymotion feature from incsearch.vim
- `incsearch#config#easymotion#make`: return default config
