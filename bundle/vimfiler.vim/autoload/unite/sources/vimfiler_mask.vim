"=============================================================================
" FILE: vimfiler/mask.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#vimfiler_mask#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'vimfiler/mask',
      \ 'description' : 'change vimfiler mask',
      \ 'default_action' : 'change',
      \ 'action_table' : {},
      \ 'hooks' : {},
      \ 'is_listed' : 0,
      \ 'filters' : [ 'matcher_vimfiler/mask' ],
      \ }

function! s:source.hooks.on_init(args, context) abort
  if &filetype !=# 'vimfiler'
    return
  endif

  let a:context.source__mask = b:vimfiler.current_mask
  let a:context.source__candidates = b:vimfiler.current_files

  call unite#print_message(
        \ '[vimfiler/mask] Current mask: ' . a:context.source__mask)
endfunction

function! s:source.change_candidates(args, context) abort
  if !has_key(a:context, 'source__mask')
    return []
  endif

  return map(add(copy(a:context.source__candidates), {
        \ 'vimfiler__abbr' : 'New mask: "' . a:context.input . '"',
        \ 'vimfiler__is_directory' : 0,
        \ 'vimfiler__nest_level' : 0}), "{
        \ 'word' : v:val.vimfiler__abbr .
        \        (v:val.vimfiler__is_directory ? '/' : ''),
        \ 'abbr' : repeat(' ', v:val.vimfiler__nest_level
         \       * g:vimfiler_tree_indentation) . v:val.vimfiler__abbr .
        \        (v:val.vimfiler__is_directory ? '/' : ''),
        \ 'vimfiler__is_directory' : v:val.vimfiler__is_directory,
        \ 'vimfiler__abbr' : v:val.vimfiler__abbr,
        \ }")
endfunction

" Actions
let s:action_table = {}

let s:action_table.change = {
      \ 'description' : 'change current mask',
      \ }
function! s:action_table.change.func(candidate) abort
  let b:vimfiler.current_mask = unite#get_context().input
  call vimfiler#redraw_screen()
endfunction

let s:source.action_table['*'] = s:action_table
unlet! s:action_table
