"=============================================================================
" FILE: autoload/incsearch/config/easymotion.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! incsearch#config#easymotion#module(...) abort
  return call('incsearch#over#modules#EasyMotion#make', a:000, {})
endfunction

function! incsearch#config#easymotion#make(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
