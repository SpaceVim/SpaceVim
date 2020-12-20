"=============================================================================
" FILE: tab.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tab#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'tab',
      \ 'description' : 'candidates from tab list',
      \ 'syntax' : 'uniteSource__Tab',
      \ 'hooks' : {},
      \ 'default_kind' : 'tab',
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  let list = range(1, tabpagenr('$'))
  let arg = get(a:args, 0, '')
  if arg ==# 'no-current'
    call filter(list, 'v:val != tabpagenr()')
  endif

  let candidates = []
  for i in list
    " Get current window buffer in tabs.
    let bufnr = tabpagebuflist(i)[tabpagewinnr(i) - 1]

    let bufname = unite#util#substitute_path_separator(
          \ (i == tabpagenr() ?
          \       bufname('#') : bufname(bufnr)))
    if bufname == ''
      let bufname = '[No Name]'
    endif

    if exists('*gettabvar')
      " Use gettabvar().
      let title = gettabvar(i, 'title')
      if title != ''
        let title = '[' . title . ']'
      endif

      let cwd = unite#util#substitute_path_separator(
            \ (i == tabpagenr() ? getcwd() : gettabvar(i, 'cwd')))
      if cwd !~ '/$'
        let cwd .= '/'
      endif
    else
      let title = ''
      let cwd = ''
    endif

    let abbr = i . ': ' . title
    if cwd != ''
      if stridx(bufname, cwd) == 0
        let bufname = bufname[len(cwd) :]
      endif
      let abbr .= (title != '' ? ' ' : '') . bufname

      let abbr .= ' (' . substitute(cwd, '.\zs/$', '', '') . ')'
    else
      let abbr .= bufname
    endif

    let wincnt = tabpagewinnr(i, '$')
    if i == tabpagenr()
      let wincnt -= 1
    endif
    if wincnt > 1
      let abbr .= '{' . wincnt . '}'
    endif
    let abbr .= getbufvar(bufnr('%'), '&modified') ? '[+]' : ''

    if len(tabpagebuflist(i)) > 1
      " Get tab windows list.
      for [winnr, bufnr] in map(tabpagebuflist(i), "[v:key, v:val]")
        let abbr .= "\n" . printf('%s %d: %s', repeat(' ', 1), (winnr+1),
              \ (bufname(bufnr) == '' ? '[No Name]' : bufname(bufnr)))
      endfor
    endif

    call add(candidates, {
          \ 'word' : abbr,
          \ 'is_multiline' : 1,
          \ 'action__tab_nr' : i,
          \ 'action__directory' : cwd,
          \ })
  endfor

  return candidates
endfunction"}}}
function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return ['no-current']
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__Tab_title /\[.\{-}\]/
        \ contained containedin=uniteSource__Tab
  highlight default link uniteSource__Tab_title Function
  syntax match uniteSource__Tab_directory /(.\{-})/
        \ contained containedin=uniteSource__Tab
  highlight default link uniteSource__Tab_directory PreProc
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
