"=============================================================================
" FILE: autoload/incsearch/over/modules/pattern_saver.vim
" AUTHOR: haya14busa
" License: MIT license
" @vimlint(EVL103, 1, a:cmdline)
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:pattern_saver =  {
\   'name' : 'PatternSaver',
\   'pattern' : '',
\   'hlsearch' : &hlsearch
\}

function! s:pattern_saver.on_enter(cmdline) abort
  if ! g:incsearch#no_inc_hlsearch
    let self.pattern = @/
    let self.hlsearch = &hlsearch
    if exists('v:hlsearch')
      let self.vhlsearch = v:hlsearch
    endif
    set hlsearch | nohlsearch
  endif
endfunction

function! s:pattern_saver.on_leave(cmdline) abort
  if ! g:incsearch#no_inc_hlsearch
    let is_cancel = a:cmdline.exit_code()
    if is_cancel
      let @/ = self.pattern
    endif
    let &hlsearch = self.hlsearch
    if exists('v:hlsearch')
      let v:hlsearch = self.vhlsearch
    endif
  endif
endfunction

function! incsearch#over#modules#pattern_saver#make() abort
  return deepcopy(s:pattern_saver)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
