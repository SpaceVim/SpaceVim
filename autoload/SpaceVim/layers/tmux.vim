""
" @section tmux, layer-tmux
" @parentsection layers
" Adds integration between tmux and vim panes. Switch between panes
" seamlessly.
" This layer is not added by default. To include it, add
" `SpaceVim#layers#load('tmux')` to your `~/.SpaceVim.d/init.vim`.
" If you are having issues with <C-h> in a neovim buffer, see
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
  let plugins = [
        \ ['christoomey/vim-tmux-navigator', { 'on_cmd': [
        \ 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp',
        \ 'TmuxNavigateRight'] }],
        \ ]

  return plugins
endfunction

function! SpaceVim#layers#tmux#config() abort
  let g:tmux_navigator_no_mappings = 1

  augroup SpaceVim_layer_tmux
    autocmd!
    autocmd FocusGained * set cursorline
    autocmd FocusLost * set nocursorline | redraw!
  augroup END

  nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
  nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
  nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
  nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
endfunction

