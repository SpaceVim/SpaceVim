function! gina#core#locator#find(origin) abort
  let nwinnr = winnr('$')
  if nwinnr == 1
    return 1
  endif
  let origin = a:origin == 0 ? winnr() : a:origin
  let former = range(origin, winnr('$'))
  let latter = reverse(range(1, origin - 1))
  for winnr in (former + latter)
    if gina#core#locator#is_suitable(winnr)
      return winnr
    endif
  endfor
  return 0
endfunction

function! gina#core#locator#focus(origin) abort
  let winnr = gina#core#locator#find(a:origin)
  if winnr == 0 || winnr == winnr()
    return 1
  endif
  call win_gotoid(win_getid(winnr))
endfunction

function! gina#core#locator#attach() abort
  augroup gina_core_locator_local_internal
    autocmd! * <buffer>
    autocmd WinLeave <buffer> call s:on_WinLeave()
  augroup END
endfunction

function! gina#core#locator#detach() abort
  augroup gina_core_locator_local_internal
    autocmd! * <buffer>
  augroup END
endfunction

function! gina#core#locator#is_suitable(winnr) abort
  if getbufvar(winbufnr(a:winnr), '&previewwindow')
        \ || winwidth(a:winnr) < g:gina#core#locator#winwidth_threshold
        \ || winheight(a:winnr) < g:gina#core#locator#winheight_threshold
    return 0
  endif
  return 1
endfunction

function! s:on_WinLeave() abort
  let s:info = {
        \ 'nwin': winnr('$'),
        \ 'previous': win_getid(winnr('#'))
        \}
endfunction

function! s:on_WinEnter() abort
  if exists('s:info') && winnr('$') < s:info.nwin
    call gina#core#locator#focus(win_id2win(s:info.previous) || winnr())
  endif
  silent! unlet! s:info
endfunction

augroup gina_core_locator_internal
  autocmd! *
  autocmd WinEnter * nested call s:on_WinEnter()
augroup END


call gina#config(expand('<sfile>'), {
      \ 'winwidth_threshold': &columns / 4,
      \ 'winheight_threshold': &lines / 3,
      \})
