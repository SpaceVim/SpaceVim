let s:Writer = vital#gina#import('Vim.Buffer.Writer')

function! gina#core#writer#new(...) abort
  let options = extend({
        \ 'updatetime': g:gina#core#writer#updatetime,
        \}, a:0 ? a:1 : {},
        \)
  return s:Writer.new(options)
endfunction

function! gina#core#writer#replace(...) abort
  return call(s:Writer.replace, a:000)
endfunction


call gina#config(expand('<sfile>'), {
      \ 'updatetime': 100,
      \})
