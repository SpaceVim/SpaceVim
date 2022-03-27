"=============================================================================
" cscope.vim --- cscope layer plugin
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if !exists('g:cscope_silent')
  let g:cscope_silent = 1
endif

if !exists('g:cscope_cmd')
  let g:cscope_cmd = 'cscope'
endif


if !exists('g:cscope_auto_update')
  let g:cscope_auto_update = 1
endif

if !exists('g:cscope_open_location')
  let g:cscope_open_location = 1
endif

if exists('g:cscope_preload_path')
  let g:cscope_preload_path = ''
endif

if !exists('g:cscope_split_threshold')
  let g:cscope_split_threshold = 10000
endif

set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-
""
" Clear cscope databases.
com! -nargs=? -complete=customlist,cscope#listDirs CscopeClear call cscope#clearDBs(<f-args>)
""
" List all the cscope databases.
com! -nargs=0 CscopeList call cscope#list_databases()

if exists('g:cscope_preload_path') && !empty(g:cscope_preload_path)
  call cscope#preloadDB()
endif

if g:cscope_auto_update == 1
  augroup cscope_core
    autocmd!
    au BufWritePost * call cscope#onChange()
  augroup END
endif


call cscope#loadIndex()
