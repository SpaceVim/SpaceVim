"=============================================================================
" mapping.vim --- SpaceVim mapping API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:VIM = SpaceVim#api#import('vim#compatible')

function! SpaceVim#api#vim#mapping#get() abort
  return map({
        \ 'map' : '',
        \ },
        \ "function('s:' . v:key)"
        \ )
endfunction

function! s:map(...) abort
  if a:0 == 1
    return s:parser(s:VIM.execute(':map ' . a:1))
  endif
  return []
endfunction

function! s:parser(rst) abort
  let mappings = split(a:rst, "\n")
  let mappings = map(mappings, 'split(v:val)')
  let rst = []
  for mapping in mappings
    if len(mapping) >= 3
      let mode = mapping[0]
      let key = mapping[1]
      let m = maparg(key, mode, 0, 1)
      if !empty(m)
        call add(rst, m)
      endif
    endif
  endfor
  return rst
endfunction

" vim:set et sw=2 cc=80:
