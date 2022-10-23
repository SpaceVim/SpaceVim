" Tiny init.vim for deoplete-jedi

" NeoBundle
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete-jedi
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/neco-syntax
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/neoinclude.vim

" vim-plug
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete-jedi
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/neco-syntax
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/neoinclude.vim

set completeopt+=noinsert,noselect
set completeopt-=preview

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1

" let g:deoplete#ignore_sources = {}
" let g:deoplete#ignore_sources.python = ['omni']
" let g:deoplete#ignore_sources.python += ['buffer']
" let g:deoplete#ignore_sources.python += ['tag']
" let g:deoplete#ignore_sources.python += ['ns']
" let g:deoplete#ignore_sources.python += ['member']

filetype plugin indent on
