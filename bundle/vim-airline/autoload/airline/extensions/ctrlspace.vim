" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/szw/vim-ctrlspace
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#ctrlspace#statusline(...)
  let spc = g:airline_symbols.space
  let padding = spc . spc . spc
  let cs = ctrlspace#context#Configuration().Symbols.CS

  let b = airline#builder#new({ 'active': 1 })
  call b.add_section('airline_b', cs . padding . ctrlspace#api#StatuslineModeSegment(s:padding))
  call b.split()
  call b.add_section('airline_x', spc . ctrlspace#api#StatuslineTabSegment() . spc)
  return b.build()
endfunction

function! airline#extensions#ctrlspace#init(ext)
  let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"
endfunction
