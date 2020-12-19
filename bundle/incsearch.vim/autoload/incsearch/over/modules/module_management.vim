"=============================================================================
" FILE: autoload/incsearch/over/modules/module_management.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module_management =  {
\   'name' : 'IncsearchModuleManagement',
\   'modules' : [ ]
\}

function! s:module_management.on_enter(cmdline) abort
  if !exists('s:default_backward_word')
    let s:default_backward_word = a:cmdline.backward_word
  endif
  for module in self.modules
    if has_key(module, '_condition') && ! module._condition()
      call a:cmdline.disconnect(module.name)
      if module.name ==# 'IgnoreRegexpBackwardWord'
        function! a:cmdline.backward_word(...) abort
          return call(s:default_backward_word, a:000, self)
        endfunction
      endif
    elseif empty(a:cmdline.get_module(module.name))
      call a:cmdline.connect(module)
      if has_key(module, 'on_enter')
        call module.on_enter(a:cmdline)
      endif
    endif
  endfor
endfunction

function! s:module_management.priority(event) abort
  " NOTE: to overwrite backward_word() with default function
  return a:event ==# 'on_enter' ? 5 : 0
endfunction

function! incsearch#over#modules#module_management#make(modules) abort
  let m = deepcopy(s:module_management)
  let m.modules = a:modules
  return m
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
