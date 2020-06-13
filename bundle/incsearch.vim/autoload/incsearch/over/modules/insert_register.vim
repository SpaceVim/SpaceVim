"=============================================================================
" FILE: autoload/incsearch/over/modules/insert_register.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:modules = vital#incsearch#import('Over.Commandline.Modules')

let s:InsertRegister = s:modules.get('InsertRegister').make()
let s:InsertRegister_orig_on_char_pre = s:InsertRegister.on_char_pre
let s:InsertRegister.search_register = ''

function! s:InsertRegister.on_enter(...) abort
  let self.search_register = @/
endfunction

function! s:InsertRegister.on_char_pre(cmdline) abort
  if exists('self.prefix_key') && a:cmdline.get_tap_key() == self.prefix_key
    call a:cmdline.setline(self.old_line)
    call a:cmdline.setpos(self.old_pos)
    let char = a:cmdline.input_key()
    if char ==# '/'
      let register = tr(self.search_register, "\n", "\r")
      call a:cmdline.setchar(register)
      return
    endif
  endif
  return call(s:InsertRegister_orig_on_char_pre, [a:cmdline], self)
endfunction

function! incsearch#over#modules#insert_register#make() abort
  return deepcopy(s:InsertRegister)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
