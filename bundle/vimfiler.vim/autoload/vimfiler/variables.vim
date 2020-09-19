"=============================================================================
" FILE: variables.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#variables#get_clipboard() abort
  if !exists('s:clipboard')
    let s:clipboard = {'operation' : '', 'files' : []}
  endif

  return s:clipboard
endfunction

function! vimfiler#variables#get_data_directory() abort
  let g:vimfiler_data_directory =
        \ substitute(fnamemodify(get(
        \   g:, 'vimfiler_data_directory',
        \  ($XDG_CACHE_HOME != '' ?
        \   $XDG_CACHE_HOME . '/vimfiler' : expand('~/.cache/vimfiler', 1))),
        \  ':p'), '\\', '/', 'g')
  if !isdirectory(g:vimfiler_data_directory) && !vimfiler#util#is_sudo()
    call mkdir(g:vimfiler_data_directory, 'p')
  endif

  return g:vimfiler_data_directory
endfunction

function! vimfiler#variables#default_context() abort
  if !exists('s:default_context')
    call s:initialize_default_options()
  endif

  return deepcopy(s:default_context)
endfunction

function! vimfiler#variables#options() abort
  if !exists('s:options')
    let s:options = map(filter(items(vimfiler#variables#default_context()),
          \ "v:val[0] !~ '^vimfiler__'"),
          \ "'-' . substitute(v:val[0], '_', '-', 'g') .
          \ (type(v:val[1]) == type(0) && (v:val[1] == 0 || v:val[1] == 1) ?
          \   '' : '=')")

    " Generic no options.
    let s:options += map(filter(copy(s:options),
          \ "v:val[-1:] != '='"), "'-no' . v:val")
  endif

  return deepcopy(s:options)
endfunction

function! s:initialize_default_options() abort
  let s:default_context = {
        \ 'buffer_name' : 'default',
        \ 'quit' : 1,
        \ 'force_quit' : 0,
        \ 'force_hide' : 0,
        \ 'toggle' : 0,
        \ 'create' : 0,
        \ 'simple' : 0,
        \ 'double' : 0,
        \ 'split' : 0,
        \ 'status' : 0,
        \ 'parent' : 1,
        \ 'horizontal' : 0,
        \ 'winheight' : -1,
        \ 'winwidth' : -1,
        \ 'winminwidth' : -1,
        \ 'direction' : 'topleft',
        \ 'auto_cd' : 0,
        \ 'explorer' : 0,
        \ 'reverse' : 0,
        \ 'project' : 0,
        \ 'find' : 0,
        \ 'tab' : 0,
        \ 'alternate_buffer' : bufnr('%'),
        \ 'prev_winsaveview' : winsaveview(),
        \ 'focus' : 1,
        \ 'invisible' : 0,
        \ 'columns' : 'type:size:time',
        \ 'explorer_columns' : '',
        \ 'safe' : 1,
        \ 'auto_expand' : 0,
        \ 'sort_type' : 'filename',
        \ 'edit_action' : 'open',
        \ 'split_action' : 'right',
        \ 'preview_action' : 'preview',
        \ 'fnamewidth' : -1,
        \ 'vimfiler__prev_bufnr' : bufnr('%'),
        \ 'vimfiler__prev_winnr' : winnr(),
        \ 'vimfiler__winfixwidth' : &l:winfixwidth,
        \ 'vimfiler__winfixheight' : &l:winfixheight,
        \ }

  " For compatibility(deprecated variables)
  for [context, var] in filter([
        \ ['direction', 'g:vimfiler_split_rule'],
        \ ['auto_cd', 'g:vimfiler_enable_auto_cd'],
        \ ['columns', 'g:vimfiler_default_columns'],
        \ ['explorer_columns', 'g:vimfiler_explorer_columns'],
        \ ['safe', 'g:vimfiler_safe_mode_by_default'],
        \ ['sort_type', 'g:vimfiler_sort_type'],
        \ ['split_action', 'g:vimfiler_split_action'],
        \ ['edit_action', 'g:vimfiler_edit_action'],
        \ ['preview_action', 'g:vimfiler_preview_action'],
        \ ], "exists(v:val[1])")
    let s:default_context[context] = {var}
  endfor
endfunction
