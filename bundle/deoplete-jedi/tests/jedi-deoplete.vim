" Tiny init.vim for deoplete-jedi

" NeoBundle
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete-jedi

" vim-plug
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete-jedi
set completeopt+=noinsert,noselect
set completeopt-=preview

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1
" let g:deoplete#ignore_sources = {}
" let g:deoplete#ignore_sources.python = ['omni']

filetype plugin indent on
