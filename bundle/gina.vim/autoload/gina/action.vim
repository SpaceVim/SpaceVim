scriptencoding utf-8
let s:Action = vital#gina#import('Action')
let s:Action.name = 'gina'
let s:Highlight = vital#gina#import('Vim.Highlight')



function! gina#action#get(...) abort
  return call(s:Action.get, a:000, s:Action)
endfunction

function! gina#action#attach(...) abort
  return call(s:Action.attach, a:000, s:Action)
endfunction

function! gina#action#include(scheme) abort
  let binder = s:Action.get()
  if binder is# v:null
    " TODO: raise an exception
    return
  endif
  let scheme = substitute(a:scheme, '-', '_', 'g')
  try
    return call(
          \ printf('gina#action#%s#define', scheme),
          \ [binder]
          \)
  catch /^Vim\%((\a\+)\)\=:E117: [^:]\+: gina#action#[^#]\+#define/
    call gina#core#console#debug(v:exception)
    call gina#core#console#debug(v:throwpoint)
  endtry
  throw gina#core#revelator#error(printf(
        \ 'No action script "gina/action/%s.vim" is found',
        \ a:scheme,
        \))
endfunction

function! gina#action#alias(...) abort
  let binder = s:Action.get()
  if binder is# v:null
    " TODO: raise an exception
    return
  endif
  return gina#core#revelator#call(binder.alias, a:000, binder)
endfunction

function! gina#action#shorten(action_scheme, ...) abort
  let excludes = get(a:000, 0, [])
  let binder = s:Action.get()
  if binder is# v:null
    " TODO: raise an exception
    return
  endif
  let action_scheme = substitute(a:action_scheme, '-', '_', 'g')
  let names = filter(
        \ keys(binder.actions),
        \ 'v:val =~# ''^'' . action_scheme . '':'''
        \)
  for name in filter(names, 'index(excludes, v:val) == -1')
    call binder.alias(matchstr(name, '^' . action_scheme . ':\zs.*'), name)
  endfor
endfunction

function! gina#action#call(...) abort
  let binder = s:Action.get()
  if binder is# v:null
    " TODO: raise an exception
    return
  endif
  return gina#core#revelator#call(binder.call, a:000, binder)
endfunction

function! gina#action#candidates(...) abort
  let binder = s:Action.get()
  if binder is# v:null
    " TODO: raise an exception
    return
  endif
  return gina#core#revelator#call(binder._get_candidates, a:000, binder)
endfunction


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'mark_sign_text': '|',
      \})


" Highlight ------------------------------------------------------------------
function! s:define_highlihghts() abort
  silent let bg = s:Highlight.get('SignColumn')
  silent let fg = s:Highlight.get('Title')
  call s:Highlight.set({
        \ 'name': 'GinaActionMarkSelected',
        \ 'attrs': {
        \   'cterm': 'bold',
        \   'ctermfg': get(fg.attrs, 'ctermfg', '1'),
        \   'ctermbg': get(bg.attrs, 'ctermbg', 'NONE'),
        \   'gui': 'bold',
        \   'guifg': get(fg.attrs, 'guifg', '#ff0000'),
        \   'guibg': get(bg.attrs, 'guibg', 'NONE'),
        \ }
        \}, {
        \ 'default': 1,
        \})
  highlight link VitalActionMarkSelectedLine Search
  highlight link VitalActionMarkSelected GinaActionMarkSelected
  let s:Action.mark_sign_text = g:gina#action#mark_sign_text
endfunction

augroup gina_action_internal
  autocmd! *
  autocmd ColorScheme * call s:define_highlihghts()
augroup END

call s:define_highlihghts()
