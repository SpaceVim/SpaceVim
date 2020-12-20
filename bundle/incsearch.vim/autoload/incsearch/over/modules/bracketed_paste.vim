"=============================================================================
" FILE: autoload/incsearch/over/modules/bracketed_paste.vim
" AUTHOR: haya14busa
" License: MIT license
" @vimlint(EVL103, 1, a:cmdline)
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" https://github.com/haya14busa/incsearch.vim/issues/131
let s:bracketed_paste =  {
\   'name' : 'BracketedPaste',
\   't_BE' : '',
\}

function! s:bracketed_paste.on_enter(cmdline) abort
  if !exists('&t_BE')
    return
  endif
  let self.t_BE = &t_BE
  set t_BE=
endfunction

function! s:bracketed_paste.on_leave(cmdline) abort
  if !exists('&t_BE')
    return
  endif
  let &t_BE = self.t_BE
endfunction

function! incsearch#over#modules#bracketed_paste#make() abort
  return deepcopy(s:bracketed_paste)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

