"=============================================================================
" mkdir.vim --- auto mkdir when saving file
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! SpaceVim#plugins#mkdir#CreateCurrent() abort

  call s:CreateDirectory(expand('%:p:h'))

endfunction

fun! s:Mkdirp(dir) abort
  if exists('*mkdir')
    try
      call mkdir(a:dir, 'p')
    catch      
      call SpaceVim#logger#error('failed to create dir:' . a:dir)
    endtry
  else
    " @todo mkdir only exist in *nix os
    call system('mkdir -p '.shellescape(a:dir))
  end
endf

fun! s:CreateDirectory(dir) abort
  let d = a:dir

  " @todo do not skip files that have schemes
  if d =~? '^[a-z]\+:/'
    return
  endif

  if !isdirectory(d)
    call s:Mkdirp(d)
  end
endf

let &cpo = s:save_cpo
unlet s:save_cpo
