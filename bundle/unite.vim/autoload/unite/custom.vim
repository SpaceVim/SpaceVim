"=============================================================================
" FILE: custom.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#custom#get() abort "{{{
  if !exists('s:custom')
    let s:custom = {}
    let s:custom.sources = {}
    let s:custom.sources._ = {}
    let s:custom.actions = {}
    let s:custom.default_actions = {}
    let s:custom.aliases = {}
    let s:custom.profiles = {}
  endif

  return s:custom
endfunction"}}}

function! unite#custom#source(source_name, option_name, value) abort "{{{
  return s:custom_base('sources', a:source_name, a:option_name, a:value)
endfunction"}}}

function! unite#custom#alias(kind, name, action) abort "{{{
  call s:custom_base('aliases', a:kind, a:name, a:action)
endfunction"}}}

function! unite#custom#default_action(kind, default_action) abort "{{{
  let custom = unite#custom#get()

  let custom = unite#custom#get().default_actions
  for key in split(a:kind, '\s*,\s*')
    if !has_key(custom, key)
      let custom[key] = {}
    endif

    let custom[key] = a:default_action
  endfor
endfunction"}}}

function! unite#custom#action(kind, name, action) abort "{{{
  return s:custom_base('actions', a:kind, a:name, a:action)
endfunction"}}}

function! unite#custom#profile(profile_name, option_name, value) abort "{{{
  if a:option_name ==# 'smartcase'
        \ || a:option_name ==# 'ignorecase'
    call unite#print_error(
          \ printf('You cannot set "%s". '
          \ .'Please set "context.%s" by unite#custom#profile() instead.',
          \ a:option_name, a:option_name))
    return
  endif

  let profile_name =
        \ (a:profile_name == '' ? 'default' : a:profile_name)
  let custom = unite#custom#get()

  for key in split(profile_name, '\s*,\s*')
    if !has_key(custom.profiles, key)
      let custom.profiles[key] = {
            \ 'substitute_patterns' : {},
            \ 'matchers' : [],
            \ 'sorters' : [],
            \ 'converters' : [],
            \ 'context' : {},
            \ 'unite__save_pos' : {},
            \ 'unite__inputs' : {},
            \ }
    endif

    if a:option_name ==# 'substitute_patterns'
      let substitute_patterns = custom.profiles[key].substitute_patterns

      if has_key(substitute_patterns, a:value.pattern)
            \ && empty(a:value.subst)
        call remove(substitute_patterns, a:value.pattern)
      else
        let substitute_patterns[a:value.pattern] = {
              \ 'pattern' : a:value.pattern,
              \ 'subst' : a:value.subst, 'priority' : a:value.priority,
              \ }
      endif
    else
      let custom.profiles[key][a:option_name] = a:value
    endif
  endfor
endfunction"}}}
function! unite#custom#get_profile(profile_name, option_name) abort "{{{
  let custom = unite#custom#get()
  let profile_name =
        \ (a:profile_name == '' || !has_key(custom.profiles, a:profile_name)) ?
        \ 'default' : a:profile_name

  if !has_key(custom.profiles, profile_name)
    let custom.profiles[profile_name] = {
          \ 'substitute_patterns' : {},
          \ 'matchers' : [],
          \ 'sorters' : [],
          \ 'converters' : [],
          \ 'context' : {},
          \ 'unite__save_pos' : {},
          \ 'unite__inputs' : {},
          \ }
  endif

  return custom.profiles[profile_name][a:option_name]
endfunction"}}}
function! unite#custom#get_context(profile_name) abort "{{{
  let context = copy(unite#custom#get_profile(a:profile_name, 'context'))
  for option in map(filter(items(context),
        \ "stridx(v:val[0], 'no_') == 0 && v:val[1]"), 'v:val[0]')
    let context[option[3:]] = 0
  endfor
  return context
endfunction"}}}

function! unite#custom#substitute(profile, pattern, subst, ...) abort "{{{
  let priority = get(a:000, 0, 0)
  call unite#custom#profile(a:profile, 'substitute_patterns', {
        \ 'pattern': a:pattern,
        \ 'subst': a:subst,
        \ 'priority': priority,
        \ })
endfunction"}}}

function! s:custom_base(key, kind, name, value) abort "{{{
  let custom = unite#custom#get()[a:key]

  for key in split(a:kind, '\s*,\s*')
    if !has_key(custom, key)
      let custom[key] = {}
    endif

    let custom[key][a:name] = a:value
  endfor
endfunction"}}}

" Default customs  "{{{
call unite#custom#profile('files', 'substitute_patterns', {
      \ 'pattern' : '^\~',
      \ 'subst' : substitute(substitute($HOME, '\\', '/', 'g'),
      \ ' ', '\\\\ ', 'g'),
      \ 'priority' : -100,
      \ })
call unite#custom#profile('files', 'substitute_patterns', {
      \ 'pattern' : '\.\{2,}\ze[^/]',
      \ 'subst' : "\\=repeat('../', len(submatch(0))-1)",
      \ 'priority' : 10000,
      \ })
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
