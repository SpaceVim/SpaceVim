"=============================================================================
" FILE: custom.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#custom#get() abort
  if !exists('s:custom')
    let s:custom = {}
    let s:custom.profiles = {}
  endif

  return s:custom
endfunction

function! vimfiler#custom#profile(profile_name, option_name, value) abort
  for key in split(a:profile_name, '\s*,\s*')
    let profile = vimfiler#custom#get_profile(key, a:option_name)
    call extend(profile, a:value)
  endfor
endfunction
function! vimfiler#custom#get_profile(profile_name, option_name) abort
  let custom = vimfiler#custom#get()
  let profile_name =
        \ has_key(custom.profiles, a:profile_name) ?
        \ a:profile_name : 'default'

  if !has_key(custom.profiles, profile_name)
    let custom.profiles[profile_name] = s:init_profile()
  endif

  return custom.profiles[profile_name][a:option_name]
endfunction

function! s:init_profile() abort
  return {
        \ 'context' : {},
        \ }
endfunction
