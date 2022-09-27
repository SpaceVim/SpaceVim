" Tiny init.vim for deoplete-go

let $XDG_CACHE_HOME = $HOME . '/.cache'
let $XDG_CONFIG_HOME = $HOME . '/.config'

if isdirectory($XDG_CACHE_HOME . '/nvim/dein')
  " dein
  set runtimepath+=$HOME/src/github.com/Shougo/deoplete.nvim
  set runtimepath+=$HOME/src/github.com/zchee/deoplete-go
elseif isdirectory($XDG_CONFIG_HOME . '/nvim/bundle')
  " NeoBundle
  set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete.nvim
  set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete-go
elseif isdirectory($XDG_CONFIG_HOME . '/nvim/plugged')
  " vim-plug
  set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete.nvim
  set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete-go
endif

set completeopt+=noinsert,noselect
set completeopt-=preview
set termguicolors

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

call deoplete#custom#set('_', 'converters', [
      \   'converter_auto_paren',
      \   'converter_remove_overlap',
      \ ])

filetype plugin indent on
