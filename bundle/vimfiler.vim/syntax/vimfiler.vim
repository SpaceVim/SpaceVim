"=============================================================================
" FILE: syntax/vimfiler.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

call vimfiler#init#_initialize()

" Initialize icon patterns."{{{
let s:leaf_icon = vimfiler#util#escape_pattern(
      \ g:vimfiler_tree_leaf_icon)
let s:file_icon = vimfiler#util#escape_pattern(
      \ g:vimfiler_file_icon)
let s:marked_file_icon = vimfiler#util#escape_pattern(
      \ g:vimfiler_marked_file_icon)
let s:opened_icon = vimfiler#util#escape_pattern(
      \ g:vimfiler_tree_opened_icon)
let s:closed_icon = vimfiler#util#escape_pattern(
      \ g:vimfiler_tree_closed_icon)
let s:ro_file_icon = vimfiler#util#escape_pattern(
      \ g:vimfiler_readonly_file_icon)

execute 'syntax match   vimfilerLeaf'
      \ '''^\s*'  . s:leaf_icon . ''' contained'

execute 'syntax match   vimfilerNonMark'
      \ '''^\s*\%('.s:leaf_icon.'\)\?\%('.s:opened_icon.'\|'
      \ .s:closed_icon.'\|'.s:ro_file_icon.'\|'.s:file_icon.'\) ''
      \ contained contains=vimfilerLeaf'

execute 'syntax match   vimfilerMark'
      \ '''^\s*\%('.s:leaf_icon.'\)\?\%('.s:marked_file_icon.'\) ''
      \ contained'

unlet s:opened_icon
unlet s:closed_icon
unlet s:ro_file_icon
unlet s:file_icon
unlet s:marked_file_icon
"}}}

syntax match   vimfilerStatus            '^\%1l\[in\]: \%(\[unsafe\]\)\?'
      \ nextgroup=vimfilerCurrentDirectory
syntax match   vimfilerCurrentDirectory  '.*$'
      \ contained contains=vimfilerMask
syntax match   vimfilerMask  '\[.*\]$' contained

syntax match   vimfilerDirectory         '^..$'

highlight def link vimfilerStatus Special
highlight def link vimfilerCurrentDirectory Identifier
highlight def link vimfilerMask Statement

highlight def link vimfilerNonMark Special
highlight def link vimfilerMark Type
highlight def link vimfilerLeaf Special

highlight def link vimfilerNormalFile Normal
highlight def link vimfilerMarkedFile Type
highlight def link vimfilerDirectory Preproc
highlight def link vimfilerOpenedFile Preproc
highlight def link vimfilerClosedFile Preproc
highlight def link vimfilerROFile Comment

let b:current_syntax = 'vimfiler'

if exists('b:vimfiler') && !empty(b:vimfiler.syntaxes)
  call vimfiler#view#_define_syntax()
  call vimfiler#view#_redraw_screen()
endif

" vim: foldmethod=marker
