" Vim syntastic plugin
" Language: jsonnet
" Author: Benjamin Staffin <benley@gmail.com>
"
" For details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists("g:loaded_syntastic_jsonnet_jsonnet_checker")
  finish
endif
let g:loaded_syntastic_jsonnet_jsonnet_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_jsonnet_jsonnet_IsAvailable() dict
  return executable(self.getExec())
endfunction

function! SyntaxCheckers_jsonnet_jsonnet_GetLocList() dict

  let errorformat =
        \ 'STATIC ERROR:\ %f:%l:%c:%m,' .
        \ 'STATIC ERROR:\ %f:%l:%c-%\d%#:%m,' .
        \ '%ERUNTIME ERROR:\ %m,' .
        \ '%C\ %#%f:(%\?%l:%c)%\?%.%#'

  return SyntasticMake({
        \ 'makeprg': self.makeprgBuild({}),
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'jsonnet',
      \ 'name': 'jsonnet'})

" Register for syntastic tab completion:
if exists('g:syntastic_extra_filetypes')
  call add(g:syntastic_extra_filetypes, 'jsonnet')
else
  let g:syntastic_extra_filetypes = ['jsonnet']
endif

let &cpo = s:save_cpo
unlet s:save_cpo
