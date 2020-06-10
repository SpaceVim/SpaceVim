" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/lervag/vimtex
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space

function! s:SetDefault(var, val)
  if !exists(a:var)
    execute 'let ' . a:var . '=' . string(a:val)
  endif
endfunction

" Left and right delimiters (added only when status string is not empty)
call s:SetDefault( 'g:airline#extensions#vimtex#left',       "{")
call s:SetDefault( 'g:airline#extensions#vimtex#right',      "}")

" The current tex file is the main project file
call s:SetDefault( 'g:airline#extensions#vimtex#main',       "" )
"
" The current tex file is a subfile of the project
" and the compilation is set for the main file
call s:SetDefault( 'g:airline#extensions#vimtex#sub_main',   "m")
"
" The current tex file is a subfile of the project
" and the compilation is set for this subfile
call s:SetDefault( 'g:airline#extensions#vimtex#sub_local',  "l")
"
" Compilation is running and continuous compilation is off
call s:SetDefault( 'g:airline#extensions#vimtex#compiled',   "c₁")

" Compilation is running and continuous compilation is on
call s:SetDefault( 'g:airline#extensions#vimtex#continuous', "c")

" Viewer is opened
call s:SetDefault( 'g:airline#extensions#vimtex#viewer',     "v")

function! airline#extensions#vimtex#init(ext)
  call airline#parts#define_raw('vimtex', '%{airline#extensions#vimtex#get_scope()}')
  call a:ext.add_statusline_func('airline#extensions#vimtex#apply')
endfunction

function! airline#extensions#vimtex#apply(...)
  if exists("b:vimtex")
    let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x)
    let w:airline_section_x.=s:spc.g:airline_left_alt_sep.s:spc.'%{airline#extensions#vimtex#get_scope()}'
  endif
endfunction

function! airline#extensions#vimtex#get_scope()
  let l:status = ''

  let vt_local = get(b:, 'vimtex_local', {})
  if empty(vt_local)
    let l:status .= g:airline#extensions#vimtex#main
  else
    if get(vt_local, 'active')
      let l:status .= g:airline#extensions#vimtex#sub_local
    else
      let l:status .= g:airline#extensions#vimtex#sub_main
    endif
  endif

  if get(get(get(b:, 'vimtex', {}), 'viewer', {}), 'xwin_id')
    let l:status .= g:airline#extensions#vimtex#viewer
  endif

  let l:compiler = get(get(b:, 'vimtex', {}), 'compiler', {})
  if !empty(l:compiler)
    if has_key(l:compiler, 'is_running') && b:vimtex.compiler.is_running()
      if get(l:compiler, 'continuous')
        let l:status .= g:airline#extensions#vimtex#continuous
      else
        let l:status .= g:airline#extensions#vimtex#compiled
      endif
    endif
  endif

  if !empty(l:status)
    let l:status = g:airline#extensions#vimtex#left . l:status . g:airline#extensions#vimtex#right
  endif
  return l:status
endfunction
