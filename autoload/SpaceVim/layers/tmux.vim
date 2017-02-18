""
" @section tmux, layer-tmux
" @parentsection layers
" Adds integration between tmux and vim panes. Switch between panes
" seamlessly.
" This layer is not added by default. To include it, add
" `SpaceVim#layers#load('tmux')` to your `~/.SpaceVim.d/init.vim`
"
" @subsection mappings
" >
"   Key       Mode        Function
"   ------------------------------
"   <C-h>     normal      Switch to pane in left direction
"   <C-j>     normal      Switch to pane in down direction
"   <C-k>     normal      Switch to pane in up direction
"   <C-l>     normal      Switch to pane in right direction
" <

function! SpaceVim#layers#tmux#plugins() abort
    let plugins = []
    call add(plugins,['christoomey/vim-tmux-navigator'])
    return plugins
endfunction

function! SpaceVim#layers#tmux#config() abort
    let g:tmux_navigator_no_mappings = 1
    nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
endfunction
