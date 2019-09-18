"=============================================================================
" leaderf.vim --- leaderf layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#leaderf#plugins() abort
  let plugins = []
  call add(plugins, 
        \ ['Yggdroot/LeaderF',
        \ {
        \ 'loadconf' : 1,
        \ 'merged' : 0,
        \ }])
  return plugins
endfunction


let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#leaderf#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'LeaderfBuffer', 'buffer list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'r'], 'LeaderfMru', 'open-recent-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Denite outline', 'jump to a definition in buffer', 1)
  nnoremap <silent> <C-p> :LeaderfFile<cr>
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'LeaderfColorscheme', 'fuzzy find colorschemes', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'],
        \ "exe 'LeaderfFile ' . fnamemodify(bufname('%'), ':h')",
        \ ['Find files in the directory of the current buffer',
        \ [
        \ '[SPC f f] is to find files in the directory of the current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fo  :<C-u>LeaderfFunction<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['LeaderfFunction',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction
