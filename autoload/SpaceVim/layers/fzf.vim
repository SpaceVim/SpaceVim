"=============================================================================
" fzf.vim --- fzf layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#fzf#plugins() abort
  let plugins = []
  call add(plugins, ['junegunn/fzf',                { 'merged' : 0}])
  call add(plugins, ['Shougo/neoyank.vim', {'merged' : 0}])
  call add(plugins, ['SpaceVim/fzf-neoyank',                { 'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#fzf#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Denite outline', 'jump to a definition in buffer', 1)
  nnoremap <silent> <C-p> :FzfFiles<cr>
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'FzfColors', 'fuzzy find colorschemes', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fe
        \ :<C-u>FZFNeoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['FZFNeoyank',
        \ 'fuzzy find registers',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction

command! FzfColors call <SID>colors()
function! s:colors() abort
  call fzf#run({'source': map(split(globpath(&rtp, 'colors/*.vim')),
        \               'fnamemodify(v:val, ":t:r")'),
        \ 'sink': 'colo', 'down': '40%'})
endfunction
command! FzfFiles call <SID>files()
function! s:files() abort
  call fzf#run({'sink': 'e', 'options': '--reverse', 'down' : '40%'}})
endfunction
