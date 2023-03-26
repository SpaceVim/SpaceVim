"=============================================================================
" health.vim --- SpaceVim health checker
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')


function! SpaceVim#health#report() abort
  let items = map(s:CMP.globpath(&rtp,'autoload/SpaceVim/health/*'), "fnamemodify(v:val,':t:r')")
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
  return join(report + s:check_layers(), "\n")
endfunction


function! s:check_layers() abort
  let report = ['Checking SpaceVim layer health:']
  for layer in SpaceVim#layers#get()
    try
      let result = SpaceVim#layers#{layer}#health() ? 'ok' : 'failed'
      call extend(report, ['  - `'   . layer . '`:' . result])
    catch /^Vim\%((\a\+)\)\=:E117/
      call extend(report, ['  - `'   . layer . '`: can not find function: SpaceVim#layers#' . layer . '#health()'])
    endtry
  endfor
  return report
endfunction

" vim:set et sw=2:
