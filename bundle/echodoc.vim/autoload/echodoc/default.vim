"=============================================================================
" FILE: autoload/echodoc/default.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
"          Tommy Allen <tommy@esdf.io>
" License: MIT license
"=============================================================================

let s:complete_cache = {}
let s:default = {
      \ 'name' : 'default',
      \ 'rank' : 10,
      \ }

function! s:default.search(cur_text, filetype) abort
  if a:filetype ==# ''
    return []
  endif

  let cache = echodoc#default#get_cache(a:filetype)
  let comp = {}

  for comp in reverse(echodoc#util#parse_funcs(a:cur_text, a:filetype))
    if comp.end == -1
      break
    endif
  endfor

  if empty(comp) || !has_key(cache, comp.name)
    return []
  endif

  let ret = s:format(comp.pos, cache[comp.name])
  return ret
endfunction

function! s:format(pos, v_comp) abort
  let ret = [
        \ {
        \  'text': a:v_comp.name,
        \  'highlight': g:echodoc#highlight_identifier
        \ },
        \ {'text': '('}]
  let l = max([a:pos, len(a:v_comp.args)])

  for i in range(l)
    let item = {'text': '#'.i}

    if i < len(a:v_comp.args)
      let arg = a:v_comp.args[i]
      let item.text = matchstr(arg, '^\_s*\zs.\{-}\ze\_s*$')
    endif

    if i == a:pos - 1 || (i == 0 && a:pos == 0)
      let item.highlight = g:echodoc#highlight_arguments
      let item.i = i
    endif

    call add(ret, item)

    if i != l - 1
      call add(ret, {'text': ', '})
    endif
  endfor

  call add(ret, {'text': ')'})

  if has_key(a:v_comp, 'trailing') && !empty(a:v_comp.trailing)
    call add(ret, {
          \ 'text': ' ' . a:v_comp.trailing,
          \ 'highlight': g:echodoc#highlight_trailing
          \ })
  endif
  return ret
endfunction

function! echodoc#default#get() abort
  return s:default
endfunction

function! echodoc#default#get_cache(filetype) abort
  if !has_key(s:complete_cache, a:filetype)
    let s:complete_cache[a:filetype] = {}
  endif

  return s:complete_cache[a:filetype]
endfunction

function! echodoc#default#make_cache(filetype, completed_item) abort
  let cache = echodoc#default#get_cache(a:filetype)

  let candidates = [a:completed_item]
  if exists('g:deoplete#_prev_completion')
    let candidates += g:deoplete#_prev_completion.candidates
  endif
  for candidate in candidates
    let v_comp = echodoc#util#completion_signature(
          \ candidate, &columns * &cmdheight - 1, a:filetype)
    if empty(v_comp)
      continue
    endif

    if a:filetype ==# 'vim'
      let args = []
      for i in range(len(v_comp.args))
        for a in split(substitute(v_comp.args[i], '\[, ', ',[', 'g'), ',')
          call add(args, matchstr(a, '\s*\zs.\{-}\ze\s*$'))
        endfor
      endfor

      let v_comp.args = args
    endif

    let cache[v_comp.name] = v_comp
  endfor
endfunction

" vim: foldmethod=marker
