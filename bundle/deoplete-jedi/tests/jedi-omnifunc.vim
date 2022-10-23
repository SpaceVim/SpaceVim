" Tiny init.vim for jedi-vim omnifunc

" NeoBundle
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/jedi-vim

" vim-plug
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/jedi-vim

set completeopt+=noinsert,noselect
set completeopt-=preview

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1
set omnifunc=jedi#completions
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#force_py_version = 3
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0
let g:jedi#max_doc_height = 100

filetype plugin indent on
