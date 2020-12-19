" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/mbbill/undotree
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':UndotreeToggle')
  finish
endif

function! airline#extensions#undotree#apply(...)
  if exists('t:undotree')
    if &ft == 'undotree'
      if exists('*t:undotree.GetStatusLine')
        call airline#extensions#apply_left_override('undo', '%{exists("t:undotree") ? t:undotree.GetStatusLine() : ""}')
      else
        call airline#extensions#apply_left_override('undotree', '%f')
      endif
    endif

    if &ft == 'diff' && exists('*t:diffpanel.GetStatusLine')
      call airline#extensions#apply_left_override('diff', '%{exists("t:diffpanel") ? t:diffpanel.GetStatusLine() : ""}')
    endif
  endif
endfunction

function! airline#extensions#undotree#init(ext)
  call a:ext.add_statusline_func('airline#extensions#undotree#apply')
endfunction
