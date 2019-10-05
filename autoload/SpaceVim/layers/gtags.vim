"=============================================================================
" tags.vim --- SpaceVim gtags layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#gtags#plugins() abort
  return [
        \ ['SpaceVim/gtags.vim', {'merged' : 0}],
        \ ]
endfunction

function! SpaceVim#layers#gtags#config() abort
  let g:_spacevim_mappings_space.m.g = {'name' : '+gtags'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'c'], 'GtagsGenerate!', 'create-a-gtags-database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'u'], 'GtagsGenerate', 'update-tag-database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'p'], 'Gtags -p', 'list-all-file-in-GTAGS', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'exe "Gtags -d " . expand("<cword>")', 'find-definitions', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'exe "Gtags -r " . expand("<cword>")', 'find-references', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 's'], 'exe "Gtags -s " . expand("<cword>")', 'find-cursor-symbol', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'g'], 'exe "Gtags -g " . expand("<cword>")', 'find-cursor-string', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Gtags -f %', 'list of objects', 1)
  let g:gtags_gtagslabel = s:gtagslabel
  augroup spacevim_layer_tags
    autocmd!
    autocmd BufEnter *
          \   if empty(&buftype) && &filetype != 'help'
          \|      nnoremap <silent><buffer> <Leader>] :call MyTagfunc()<CR>
          \|      nnoremap <silent><buffer> <Leader>[ :call MyTagfuncBack()<CR>
          \|  endif
  augroup END
endfunction

function! MyTagfunc() abort
  mark H
  let s:MyTagfunc_flag = 1
  UniteWithCursorWord -force-immediately tag
endfunction

function! MyTagfuncBack() abort
  if exists('s:MyTagfunc_flag')&&s:MyTagfunc_flag
    exe 'normal! `H'
    let s:MyTagfunc_flag =0
  endif
endfunction


let s:gtagslabel = ''

function! SpaceVim#layers#gtags#set_variable(var) abort

  let s:gtagslabel = get(a:var,
        \ 'gtagslabel',
        \ '')
endfunction


function! SpaceVim#layers#gtags#get_options() abort

  return ['gtagslabel']

endfunction
