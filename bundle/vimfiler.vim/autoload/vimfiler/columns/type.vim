"=============================================================================
" FILE: type.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#columns#type#define() abort
  return s:column
endfunction

let s:column = {
      \ 'name' : 'type',
      \ 'description' : 'get filetype',
      \ 'syntax' : 'vimfilerColumn__Type',
      \ }

function! s:column.length(files, context) abort
  return 3
endfunction

function! s:column.define_syntax(context) abort
  syntax match   vimfilerColumn__TypeText       '\[T\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeImage      '\[I\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeArchive    '\[A\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeExecute    '\[X\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeMultimedia '\[M\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeDirectory  '\[D\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeSystem     '\[S\]'
        \ contained containedin=vimfilerColumn__Type
  syntax match   vimfilerColumn__TypeLink       '\[L\]'
        \ contained containedin=vimfilerColumn__Type

  highlight def link vimfilerColumn__TypeText Constant
  highlight def link vimfilerColumn__TypeImage Type
  highlight def link vimfilerColumn__TypeArchive Special
  highlight def link vimfilerColumn__TypeExecute Statement
  highlight def link vimfilerColumn__TypeMultimedia Identifier
  highlight def link vimfilerColumn__TypeDirectory Preproc
  highlight def link vimfilerColumn__TypeSystem Comment
  highlight def link vimfilerColumn__TypeLink Comment
endfunction

function! s:column.get(file, context) abort
  let ext = tolower(a:file.vimfiler__extension)

  if (vimfiler#util#is_windows() && ext ==? 'LNK')
        \ || get(a:file, 'vimfiler__ftype', '') ==# 'link'
    " Symbolic link.
    return '[L]'
  elseif a:file.vimfiler__is_directory
    " Directory.
    return '[D]'
  elseif has_key(g:vimfiler_extensions.text, ext)
    " Text.
    return '[T]'
  elseif has_key(g:vimfiler_extensions.image, ext)
    " Image.
    return '[I]'
  elseif has_key(g:vimfiler_extensions.archive, ext)
    " Archive.
    return '[A]'
  elseif has_key(g:vimfiler_extensions.multimedia, ext)
    " Multimedia.
    return '[M]'
  elseif a:file.vimfiler__filename =~ '^\.'
        \ || has_key(g:vimfiler_extensions.system, ext)
    " System.
    return '[S]'
  elseif a:file.vimfiler__is_executable
    " Execute.
    return '[X]'
  else
    " Others filetype.
    return '   '
  endif
endfunction
