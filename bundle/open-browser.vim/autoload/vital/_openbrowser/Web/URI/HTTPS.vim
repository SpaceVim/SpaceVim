" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_openbrowser#Web#URI#HTTPS#import() abort', printf("return map({'canonicalize': '', '_vital_depends': '', 'default_port': '', '_vital_loaded': ''}, \"vital#_openbrowser#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:save_cpo = &cpo
set cpo&vim

let s:HTTP = {}
function! s:_vital_loaded(V) abort
  let s:HTTP = a:V.import('Web.URI.HTTP')
endfunction

function! s:_vital_depends() abort
  return ['Web.URI.HTTP']
endfunction


function! s:canonicalize(uriobj) abort
  return s:HTTP.canonicalize(a:uriobj)
endfunction

function! s:default_port(uriobj) abort
  return '443'
endfunction

" vim:set et ts=2 sts=2 sw=2 tw=0:fen:
