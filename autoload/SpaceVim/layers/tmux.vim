""
" @section tmux, layer-tmux
" @parentsection layers
" Adds integration between tmux and vim panes. Switch between panes
" seamlessly.
" This layer is not added by default. To include it, add
" `SpaceVim#layers#load('tmux')` to your `~/.SpaceVim.d/init.vim`.
" This layer currently overwrites some SpaceVim keybinds including multiple
" cursors. If you are having issues with <C-h> in a neovim buffer, see
" `https://github.com/neovim/neovim/issues/2048#issuecomment-78045837`
"
" @subsection mappings
" >
"   Key       Mode        Function
"   ------------------------------
"   <C-h>     normal      Switch to vim/tmux pane in left direction
"   <C-j>     normal      Switch to vim/tmux pane in down direction
"   <C-k>     normal      Switch to vim/tmux pane in up direction
"   <C-l>     normal      Switch to vim/tmux pane in right direction
" <

function! SpaceVim#layers#tmux#plugins() abort
    let plugins = []
    call add(plugins,['christoomey/vim-tmux-navigator', {'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#tmux#config() abort
    let g:tmux_navigator_no_mappings = 1
    augroup spacevim_layer_tmux
        au!
        au VimEnter * call s:tmuxMappings()
    augroup END
    func s:tmuxMappings()
        nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
        nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
        nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
        nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
    endf
endfunction
