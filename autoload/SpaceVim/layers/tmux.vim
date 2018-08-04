"=============================================================================
" tmux.vim --- SpaceVim tmux layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section tmux, layer-tmux
" @parentsection layers
" Adds integration between tmux and vim panes. Switch between panes
" seamlessly.syntax highlighting, commenting, man page navigation
" and ability to execute lines as tmux commands.
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
  call add(plugins, ['tmux-plugins/vim-tmux', {'on_ft' : 'tmux'}])
  call add(plugins, ['edkolev/tmuxline.vim', {'merged' : 0}])
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
  let g:neomake_tmux_enabled_makers = ['tmux']
  let g:neomake_tmux_tmux_maker = {
        \ 'exe': 'tmux',
        \ 'args': ['source-file', '-q'],
        \ 'errorformat': '%f:%l:%m,%+Gunknown command: %s',
        \ }
  let g:tmuxline_separators = {
        \ 'left' : "\ue0b0",
        \ 'left_alt': '>',
        \ 'right' : '',
        \ 'right_alt' : '<',
        \ 'space' : ' '}
endfunction

