let s:_ = choosewin#util#get()

" Misc:
function! s:win_swap(tab, win) "{{{1
  let [ tab_dst, win_dst ] = [ a:tab, a:win]
  let [ tab_src, win_src ] = [ tabpagenr(), winnr() ]
  let buf_src = bufnr('')

  " go
  call s:goto_tabwin(tab_dst, win_dst)
  let  buf_dst = bufnr('')
  call s:goto_tabwin(tab_src, win_src)
  silent execute 'hide buffer' buf_dst
  call s:goto_tabwin(tab_dst, win_dst)
  silent execute 'hide buffer' buf_src
endfunction

function! s:goto_tabwin(tab, win) "{{{1
  call s:goto_tab(a:tab)
  call s:goto_win(a:win)
endfunction

function! s:goto_tab(num) "{{{1
  if a:num is tabpagenr()
    return
  endif
  silent execute 'tabnext' a:num
endfunction

function! s:goto_win(num, ...) "{{{1
  if choosewin#noop()
    return
  endif
  silent execute a:num 'wincmd w'
endfunction
"}}}

" Action:
let s:ac = {}

function! s:ac.init(app) "{{{1
  let self.app = a:app
  return self
endfunction

function! s:ac.do_win(num) "{{{1
  call s:goto_win(a:num)
  throw 'CHOSE ' . a:num
endfunction

function! s:ac.do_win_land() "{{{1
  cal self.do_win(winnr())
endfunction

function! s:ac.do_tab(num) "{{{1
  call s:goto_tab(a:num)
  call self.app.wins.set(range(1, winnr('$')))
endfunction

function! s:ac.do_tab_first() "{{{1
  call self.do_tab(1)
endfunction

function! s:ac.do_tab_prev() "{{{1
  call self.do_tab(max([1, tabpagenr() - 1]))
endfunction

function! s:ac.do_tab_next() "{{{1
  call self.do_tab(min([tabpagenr('$'), tabpagenr() + 1]))
endfunction

function! s:ac.do_tab_last() "{{{1
  call self.do_tab(tabpagenr('$'))
endfunction

function! s:ac.do_tab_close() "{{{1
  silent! tabclose
  call self.do_tab(tabpagenr())
endfunction

function! s:ac.do_previous() "{{{1
  if !has_key(self.app, 'previous')
    throw 'NO_PREVIOUS_WINDOW'
  endif

  let [ tab_dst, win_dst ] = self.app.previous
  call s:goto_tabwin(tab_dst, win_dst)
  throw 'CHOSE ' . win_dst
endfunction

function! s:ac._swap(tab, win) "{{{1
  call s:win_swap(a:tab, a:win)
  throw 'SWAP'
endfunction

function! s:ac.do_swap() "{{{1
  if self.app.conf['swap']
    " if user invoke do_swap() twice then swap with previous window
    if empty(self.app.previous)
      throw 'NO_PREVIOUS_WINDOW'
    endif
    let [ tab_dst, win_dst ] = self.app.previous
    call self._swap(tab_dst, win_dst)
  else
    let self.app.conf['swap'] = 1
  endif
endfunction

function! s:ac.do_swap_stay() "{{{1
  let self.app.conf['swap_stay'] = 1
  call self.do_swap()
endfunction

function! s:ac.do_cancel() "{{{1
  call s:goto_tab(self.app.src.tab)
  throw 'CANCELED'
endfunction

function! s:ac._goto_tabwin(tab, win) "{{{1
  call s:goto_tabwin(a:tab, a:win)
endfunction
"}}}

" API:
function! choosewin#action#init(...) "{{{1
  return call(s:ac.init, a:000, s:ac)
endfunction
"}}}

" vim: foldmethod=marker
