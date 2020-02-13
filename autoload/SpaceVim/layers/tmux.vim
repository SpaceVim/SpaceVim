"=============================================================================
" tmux.vim --- SpaceVim tmux layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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

  if s:tmux_navigator_modifier ==# 'alt'
    nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
    nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
    nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
    nnoremap <silent> <M-l> :TmuxNavigateRight<CR>
  else
    nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
    nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
    nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
    nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
  endif
  let g:neomake_tmux_enabled_makers = ['tmux']
  let g:neomake_tmux_tmux_maker = {
        \ 'exe': 'tmux',
        \ 'args': ['source-file', '-q'],
        \ 'errorformat': '%f:%l:%m,%+Gunknown command: %s',
        \ }
  let g:tmuxline_separators = {
        \ 'left' : s:separators[s:tmuxline_separators][0],
        \ 'left_alt': s:i_separators[s:tmuxline_separators_alt][0],
        \ 'right' : s:separators[s:tmuxline_separators][1],
        \ 'right_alt' : s:i_separators[s:tmuxline_separators_alt][1],
        \ 'space' : ' '}
  let g:tmuxline_preset = {
        \'a'    : '#S',
        \'b'    : '#W',
        \'win'  : ['#I', '#W'],
        \'cwin' : ['#I', '#W'],
        \'x'    : '%a',
        \'y'    : '%R',
        \'z'    : '#H'}
  if !empty(g:spacevim_custom_color_palette)
    let t = g:spacevim_custom_color_palette
  else
    let name = g:spacevim_colorscheme
    try
      let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
      let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
  endif
  let g:tmuxline_theme = {
        \   'a'    : [ t[0][3], t[0][2], 'bold' ],
        \   'b'    : [ t[1][2], t[1][3] ],
        \   'c'    : [ t[2][2], t[2][3] ],
        \   'z'    : [ t[0][3], t[0][2] ],
        \   'y'    : [ t[1][2], t[1][3] ],
        \   'x'    : [ t[2][2], t[2][3] ],
        \   'win'  : [ t[1][2], t[1][3] ],
        \   'cwin' : [ t[0][3], t[0][2] ],
        \   'bg'   : [ t[3][1], t[3][1] ],
        \ }
endfunction

" init
let s:separators = {
      \ 'arrow' : ["\ue0b0", "\ue0b2"],
      \ 'curve' : ["\ue0b4", "\ue0b6"],
      \ 'slant' : ["\ue0b8", "\ue0ba"],
      \ 'brace' : ["\ue0d2", "\ue0d4"],
      \ 'fire' : ["\ue0c0", "\ue0c2"],
      \ 'nil' : ['', ''],
      \ }

let s:i_separators = {
      \ 'arrow' : ["\ue0b1", "\ue0b3"],
      \ 'curve' : ["\ue0b4", "\ue0b6"],
      \ 'slant' : ["\ue0b8", "\ue0ba"],
      \ 'brace' : ["\ue0d2", "\ue0d4"],
      \ 'fire' : ["\ue0c0", "\ue0c2"],
      \ 'bar' : ['|', '|'],
      \ 'nil' : ['', ''],
      \ }

let s:tmuxline_separators = g:spacevim_statusline_separator
let s:tmuxline_separators_alt = g:spacevim_statusline_iseparator
let s:tmux_navigator_modifier = 'ctrl'

function! SpaceVim#layers#tmux#set_variable(var) abort

  let s:tmuxline_separators = get(a:var,
        \ 'tmuxline_separators',
        \ g:spacevim_statusline_separator)

  let s:tmuxline_separators_alt = get(a:var,
        \ 'tmuxline_separators_alt',
        \ g:spacevim_statusline_iseparator)

  let s:tmux_navigator_modifier = get(a:var,
        \ 'tmux_navigator_modifier',
        \ s:tmux_navigator_modifier)

endfunction


function! SpaceVim#layers#tmux#get_options() abort

  return ['tmuxline_separators', 'tmuxline_separators_alt', 'tmux_navigator_modifier']

endfunction
