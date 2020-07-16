"=============================================================================
" FILE: autoload/incsearch/over/modules/bulk_input_char.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" IncsearchBulkInputChar bulk insert characters and avoid updating for each
" character input. It's useful while execution macro or pasting text clipboard.
" CAUTION: cannot test getchar(0) with themis.vim
let s:bulk_input_char = {
\   'name': 'IncsearchBulkInputChar'
\ }

function! s:bulk_input_char.on_char_pre(cmdline) abort
  let stack = []
  let c = 1
  while c
    let c = getchar(0)
    if c != 0
      let stack += [nr2char(c)]
    elseif !empty(stack)
      call a:cmdline.set_input_key_stack(stack)
    endif
  endwhile
endfunction

function! incsearch#over#modules#bulk_input_char#make() abort
  return deepcopy(s:bulk_input_char)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
