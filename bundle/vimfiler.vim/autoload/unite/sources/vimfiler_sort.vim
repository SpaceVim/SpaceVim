"=============================================================================
" FILE: vimfiler/sort.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#vimfiler_sort#define() abort
  return s:source
endfunction

let s:Cache = vimfiler#util#get_vital_cache()

let s:source = {
      \ 'name' : 'vimfiler/sort',
      \ 'description' : 'candidates from vimfiler sort method',
      \ 'default_action' : 'sort',
      \ 'action_table' : {},
      \ 'hooks' : {},
      \ 'is_listed' : 0,
      \ }

function! s:source.hooks.on_init(args, context) abort
  if &filetype !=# 'vimfiler'
    return
  endif

  let a:context.source__sort = b:vimfiler.local_sort_type
endfunction

function! s:source.gather_candidates(args, context) abort
  if !has_key(a:context, 'source__sort')
    return []
  endif

  let cache_dir = vimfiler#variables#get_data_directory() . '/' . 'sort'
  let path = b:vimfiler.source.'/'.b:vimfiler.current_dir

  call unite#print_message(
        \ '[vimfiler/sort] Current sort type: ' . a:context.source__sort
        \ . (s:Cache.filereadable(cache_dir, path) ? '(saved)' : ''))
  call unite#print_message(
        \ '[vimfiler/sort] (Upper case is descending order)')

  return map(add([ 'none', 'size', 'extension', 'filename', 'time', 'manual',
        \ 'None', 'Size', 'Extension', 'Filename', 'Time', 'Manual'],
        \  s:Cache.filereadable(cache_dir, path) ? 'nosave' : 'save'), '{
        \ "word" : v:val,
        \ "action__sort" : v:val,
        \ }')
endfunction

" Actions
let s:action_table = {}

let s:action_table.sort = {
      \ 'description' : 'sort vimfiler items',
      \ }
function! s:action_table.sort.func(candidate) abort
  if &filetype != 'vimfiler'
    call unite#print_error('Current vimfiler is not found.')
    return
  endif

  let cache_dir = vimfiler#variables#get_data_directory() . '/' . 'sort'
  let path = b:vimfiler.source.'/'.b:vimfiler.current_dir
  if a:candidate.action__sort ==# 'save' && !vimfiler#util#is_sudo()
    " Save current sort type.
    call s:Cache.writefile(cache_dir, path, [b:vimfiler.local_sort_type])
  elseif a:candidate.action__sort ==# 'nosave'
    " Nosave current sort type.
    if s:Cache.filereadable(cache_dir, path)
      call s:Cache.deletefile(cache_dir, path)
    endif
  else
    let b:vimfiler.global_sort_type = a:candidate.action__sort
    let b:vimfiler.local_sort_type = a:candidate.action__sort
    if s:Cache.filereadable(cache_dir, path) && !vimfiler#util#is_sudo()
      call s:Cache.writefile(cache_dir, path, [b:vimfiler.local_sort_type])
    endif

    call vimfiler#force_redraw_screen(1)
  endif
endfunction

let s:source.action_table['*'] = s:action_table
unlet! s:action_table
