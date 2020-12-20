"=============================================================================
" FILE: variables.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

if !exists('s:use_current_unite')
  let s:use_current_unite = 1
endif

function! unite#variables#current_unite() abort "{{{
  if !exists('s:current_unite')
    let s:current_unite = {}
  endif

  return s:current_unite
endfunction"}}}

function! unite#variables#set_current_unite(unite) abort "{{{
  let s:current_unite = a:unite
endfunction"}}}

function! unite#variables#use_current_unite() abort "{{{
  return s:use_current_unite
endfunction"}}}

function! unite#variables#enable_current_unite() abort "{{{
  let s:use_current_unite = 1
endfunction"}}}

function! unite#variables#disable_current_unite() abort "{{{
  let s:use_current_unite = 0
endfunction"}}}

function! unite#variables#static() abort "{{{
  if !exists('s:static')
    let s:static = {}
    let s:static.sources = {}
    let s:static.kinds = {}
    let s:static.filters = {}
  endif

  return s:static
endfunction"}}}

function! unite#variables#dynamic() abort "{{{
  if !exists('s:dynamic')
    let s:dynamic = {}
    let s:dynamic.sources = {}
    let s:dynamic.kinds = {}
    let s:dynamic.filters = {}
  endif

  return s:dynamic
endfunction"}}}

function! unite#variables#loaded_defaults() abort "{{{
  if !exists('s:loaded_defaults')
    let s:loaded_defaults = {}
  endif

  return s:loaded_defaults
endfunction"}}}

function! unite#variables#options() abort "{{{
  if !exists('s:options')
    let s:options = map(filter(items(unite#variables#default_context()),
          \ "v:val[0] !~ '^unite__'"),
          \ "'-' . tr(v:val[0], '_', '-') .
          \ (type(v:val[1]) == type(0) && (v:val[1] == 0 || v:val[1] == 1) ?
          \   '' : '=')")

    " Generic no options.
    let s:options += map(filter(copy(s:options),
          \ "v:val[-1:] != '='"), "'-no' . v:val")
  endif

  return s:options
endfunction"}}}

function! unite#variables#kinds(...) abort "{{{
  if a:0 == 0
    call unite#init#_default_scripts('kinds', [])
  else
    call unite#init#_default_scripts('kinds', [a:1])
  endif

  let kinds = unite#init#_kinds()
  return (a:0 == 0) ? kinds : get(kinds, a:1, {})
endfunction"}}}

function! unite#variables#sources(...) abort "{{{
  let unite = unite#get_current_unite()
  if !has_key(unite, 'sources')
    return {}
  endif

  if a:0 == 0
    return unite.sources
  endif

  return unite#util#get_name(unite.sources, a:1, {})
endfunction"}}}

function! unite#variables#all_sources(...) abort "{{{
  if a:0 == 0
    return unite#init#_sources()
  endif

  let unite = unite#get_current_unite()

  let all_sources = unite#init#_sources([], a:1)
  let source = get(all_sources, a:1, {})

  return empty(source) ?
        \ get(filter(copy(get(unite, 'sources', [])),
        \ 'v:val.name ==# a:1'), 0, {}) : source
endfunction"}}}

function! unite#variables#filters(...) abort "{{{
  if a:0 == 0
    call unite#init#_default_scripts('filters', [])
  else
    call unite#init#_default_scripts('filters', [a:1])
  endif

  let filters = unite#init#_filters()

  if a:0 == 0
    return filters
  endif

  return get(filters, a:1, {})
endfunction"}}}

function! unite#variables#loaded_sources(...) abort "{{{
  " Initialize load.
  let unite = unite#get_current_unite()
  return a:0 == 0 ? unite.sources :
        \ get(filter(copy(unite.sources), 'v:val.name ==# a:1'), 0, {})
endfunction"}}}

function! unite#variables#default_context() abort "{{{
  if !exists('s:default_context')
    call s:initialize_default()
  endif

  return s:default_context
endfunction"}}}

function! s:initialize_default() abort "{{{
  let s:default_context = {
        \ 'input' : '',
        \ 'path' : '',
        \ 'prompt' : '',
        \ 'start_insert' : 0,
        \ 'complete' : 0,
        \ 'script' : 0,
        \ 'col' : -1,
        \ 'quit' : 1,
        \ 'file_quit' : 0,
        \ 'buffer_name' : 'default',
        \ 'profile_name' : '',
        \ 'default_action' : 'default',
        \ 'winwidth' : 90,
        \ 'winheight' : 20,
        \ 'immediately' : 0,
        \ 'force_immediately' : 0,
        \ 'empty' : 1,
        \ 'auto_preview' : 0,
        \ 'auto_highlight' : 0,
        \ 'horizontal' : 0,
        \ 'vertical' : 0,
        \ 'direction' : 'topleft',
        \ 'split' : 1,
        \ 'temporary' : 0,
        \ 'verbose' : 0,
        \ 'auto_resize' : 0,
        \ 'resize' : 1,
        \ 'toggle' : 0,
        \ 'quick_match' : 0,
        \ 'create' : 0,
        \ 'cursor_line_highlight' : 'CursorLine',
        \ 'abbr_highlight' : 'Normal',
        \ 'cursor_line' : 1,
        \ 'update_time' : 200,
        \ 'hide_source_names' : 0,
        \ 'max_multi_lines' : 5,
        \ 'here' : 0,
        \ 'silent' : 0,
        \ 'keep_focus' : 0,
        \ 'auto_quit' : 0,
        \ 'focus' : 1,
        \ 'multi_line' : 0,
        \ 'resume' : 0,
        \ 'wrap' : 0,
        \ 'select' : -1,
        \ 'log' : 0,
        \ 'truncate' : 1,
        \ 'truncate_width' : 50,
        \ 'tab' : 0,
        \ 'sync' : 0,
        \ 'unique' : 0,
        \ 'execute_command' : '',
        \ 'prompt_direction' : '',
        \ 'prompt_visible' : 0,
        \ 'prompt_focus' : 0,
        \ 'short_source_names' : 0,
        \ 'candidate_icon' : ' ',
        \ 'marked_icon' : '*',
        \ 'hide_icon' : 1,
        \ 'cursor_line_time' : '0.10',
        \ 'is_redraw' : 0,
        \ 'wipe' : 0,
        \ 'ignorecase' : &ignorecase,
        \ 'smartcase' : &smartcase,
        \ 'restore' : 1,
        \ 'vertical_preview' : 0,
        \ 'force_redraw' : 0,
        \ 'previewheight' : &previewheight,
        \ 'buffer' : 1,
        \ 'match_input' : 1,
        \ 'bufnr' : bufnr('%'),
        \ 'firstline' : -1,
        \ 'lastline' : -1,
        \ 'unite__old_buffer_info' : [],
        \ 'unite__direct_switch' : 0,
        \ 'unite__is_interactive' : 1,
        \ 'unite__is_complete' : 0,
        \ 'unite__is_vimfiler' : 0,
        \ 'unite__old_winwidth' : 0,
        \ 'unite__old_winheight' : 0,
        \ 'unite__disable_hooks' : 0,
        \ 'unite__disable_max_candidates' : 0,
        \ 'unite__not_buffer' : 0,
        \ 'unite__is_resize' : 0,
        \ 'unite__is_restart' : 0,
        \ 'unite__is_manual' : 0,
        \ }

  " For compatibility(deprecated variables)
  for [context, var] in filter([
        \ ['start_insert', 'g:unite_enable_start_insert'],
        \ ['prompt', 'g:unite_prompt'],
        \ ['winwidth', 'g:unite_winwidth'],
        \ ['winheight', 'g:unite_winheight'],
        \ ['vertical', 'g:unite_enable_split_vertically'],
        \ ['direction', 'g:unite_split_rule'],
        \ ['cursor_line_highlight',
        \    'g:unite_cursor_line_highlight'],
        \ ['abbr_highlight', 'g:unite_abbr_highlight'],
        \ ['update_time', 'g:unite_update_time'],
        \ ['short_source_names', 'g:unite_enable_short_source_names'],
        \ ['candidate_icon', 'g:unite_candidate_icon'],
        \ ['marked_icon', 'g:unite_marked_icon'],
        \ ['cursor_line_time', 'g:unite_cursor_line_time'],
        \ ['vertical_preview', 'g:unite_kind_file_vertical_preview'],
        \ ], "exists(v:val[1])")
    let s:default_context[context] = {var}
  endfor
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
