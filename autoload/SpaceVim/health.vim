"=============================================================================
" health.vim --- SpaceVim health checker
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#health#report() abort
  let items = map(SpaceVim#util#globpath(&rtp,'autoload/SpaceVim/health/*'), "fnamemodify(v:val,':t:r')")
  let report = []
  for item in items
    try
      let result = SpaceVim#health#{item}#check()
      call extend(report,result)
    catch /^Vim\%((\a\+)\)\=:E117/
      call extend(report,[
            \ '',
            \ 'SpaceVim Health Error:',
            \ '    There is no function: SpaceVim#health#' . item . '#check()',
            \ '',
            \ ])
    endtry
  endfor
  return join(report, "\n")
endfunction

" vim:set et sw=2:
