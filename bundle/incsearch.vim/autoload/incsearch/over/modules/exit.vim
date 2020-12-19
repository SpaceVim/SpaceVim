"=============================================================================
" FILE: autoload/incsearch/over/modules/exit.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" NOTE:
" <CR> in {rhs} wil be remapped even after exiting vital-over command line
" interface, so do not use <Over>(exit)
" See also s:cli.keymapping()
let s:incsearch_exit = {
\   'name' : 'IncsearchExit',
\   'exit_code' : 0
\}
function! s:incsearch_exit.on_char_pre(cmdline) abort
  if   a:cmdline.is_input("\<CR>")
  \ || a:cmdline.is_input("\<NL>")
    call a:cmdline.setchar('')
    call a:cmdline.exit(self.exit_code)
  endif
endfunction

function! incsearch#over#modules#exit#make() abort
  return deepcopy(s:incsearch_exit)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
