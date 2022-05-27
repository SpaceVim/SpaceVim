let s:Dict = vital#gina#import('Data.Dict')
let s:File = vital#gina#import('System.File')
let s:String = vital#gina#import('Data.String')
let s:DIRECTION_PATTERN = printf('\<\%%(%s\)\>', join([
      \ 'lefta\%[bove]',
      \ 'abo\%[veleft]',
      \ 'rightb\%[elow]',
      \ 'bel\%[owright]',
      \ 'to\%[pleft]',
      \ 'bo\%[tright]',
      \], '\|')
      \)
let s:t_list = type([])
let s:timer_syncbind = v:null
let s:timer_diffupdate = v:null


function! gina#util#contain_direction(mods) abort
  return a:mods =~# s:DIRECTION_PATTERN
endfunction

function! gina#util#get(obj, key, ...) abort
  let val = get(a:obj, a:key, v:null)
  return val is# v:null ? get(a:000, 0, '') : val
endfunction

function! gina#util#map(lhs, rhs, ...) abort
  let options = extend({
        \ 'mode': '',
        \ 'noremap': 0,
        \ 'buffer': 1,
        \ 'nowait': 0,
        \ 'silent': 0,
        \ 'special': 0,
        \ 'script': 0,
        \ 'unique': 0,
        \ 'expr': 0,
        \}, get(a:000, 0, {})
        \)
  let command = join([
        \ options.mode . (options.noremap ? 'noremap' : 'map'),
        \ options.buffer ? '<buffer>' : '',
        \ options.nowait ? '<nowait>' : '',
        \ options.silent ? '<silent>' : '',
        \ options.special ? '<special>' : '',
        \ options.script ? '<script>' : '',
        \ options.unique ? '<unique>' : '',
        \ options.expr ? '<expr>' : '',
        \ a:lhs, a:rhs
        \])
  execute command
endfunction

function! gina#util#yank(value) abort
  call setreg(v:register, a:value)
endfunction

function! gina#util#open(uri) abort
  call s:File.open(a:uri)
endfunction

function! gina#util#filter(arglead, candidates, ...) abort
  let hidden_pattern = get(a:000, 0, '')
  let pattern = '^' . s:String.escape_pattern(a:arglead)
  let candidates = copy(a:candidates)
  if empty(a:arglead) && !empty(hidden_pattern)
    call filter(candidates, 'v:val !~# hidden_pattern')
  endif
  call filter(candidates, 'v:val =~# pattern')
  return candidates
endfunction

function! gina#util#shellescape(value, ...) abort
  if empty(a:value)
    return ''
  endif
  let value = type(a:value) == s:t_list
        \ ? join(map(copy(a:value), 'shellescape(v:val)'))
        \ : shellescape(a:value)
  let prefix = get(a:000, 0, '')
  return prefix . value
endfunction

function! gina#util#fnameescape(value, ...) abort
  if empty(a:value)
    return ''
  endif
  let value = type(a:value) == s:t_list
        \ ? join(map(copy(a:value), 'fnameescape(v:val)'))
        \ : fnameescape(a:value)
  let prefix = get(a:000, 0, '')
  return prefix . value
endfunction

function! gina#util#windo(expr) abort
  let winid = win_getid()
  try
    execute printf('windo %s', a:expr)
  finally
    call win_gotoid(winid)
  endtry
endfunction

function! gina#util#bufdo(expr, ...) abort
  let bang = a:0 ? '!' : ''
  let winid = win_getid()
  try
    execute printf('bufdo%s %s', bang, a:expr)
  finally
    call win_gotoid(winid)
  endtry
endfunction

function! gina#util#doautocmd(name, ...) abort
  let pattern = get(a:000, 0, '')
  let expr = '#' . a:name
  let eis = split(&eventignore, ',')
  if index(eis, a:name) != -1 || index(eis, 'all') != -1 || !exists(expr)
    " the specified event is ignored or does not exists
    return
  endif
  let is_pseudo_required = empty(pattern) && !exists('#' . a:name . '#*')
  if is_pseudo_required
    " NOTE:
    " autocmd XXXXX <pattern> exists but not sure if the current buffer name
    " match with the <pattern> so register an empty autocmd to prevent
    " 'No matching autocommands' warning
    augroup gina_internal_util_doautocmd
      autocmd! *
      execute printf('autocmd %s * :', a:name)
    augroup END
  endif
  let nomodeline = has('patch-7.4.438') && a:name ==# 'User'
        \ ? '<nomodeline> '
        \ : ''
  try
    execute printf('doautocmd %s %s %s', nomodeline, a:name, pattern)
  finally
    if is_pseudo_required
      augroup gina_internal_util_doautocmd
        autocmd! *
      augroup END
    endif
  endtry
endfunction

function! gina#util#winwidth(winnr) abort
  let width = winwidth(a:winnr)
  let width -= &foldcolumn
  let width -= s:is_sign_visible(winbufnr(a:winnr)) ? 2 : 0
  let width -= (&number || &relativenumber)
        \ ? len(string(line('$'))) + 1
        \ : 0
  return width
endfunction

function! gina#util#syncbind() abort
  " NOTE:
  " 'syncbind' does not work just after a buffer has opened
  " so use timer to delay the command.
  silent! call timer_stop(s:timer_syncbind)
  let s:timer_syncbind = timer_start(50, function('s:syncbind'))
endfunction

function! gina#util#diffthis() abort
  diffthis
  augroup gina_internal_util_diffthis_local
    autocmd! * <buffer>
    autocmd BufReadPost <buffer>
          \ if &diff && &foldmethod !=# 'diff' |
          \   setlocal foldmethod=diff |
          \ endif
  augroup END
endfunction

function! gina#util#diffupdate() abort
  " NOTE:
  " 'diffupdate' does not work just after a buffer has opened
  " so use timer to delay the command.
  silent! call timer_stop(s:timer_diffupdate)
  let s:timer_diffupdate = timer_start(100, function('s:diffupdate', [bufnr('%')]))
endfunction



" Private --------------------------------------------------------------------
function! s:syncbind(...) abort
  syncbind
  silent! wincmd p
  silent! wincmd p
endfunction

function! s:diffoff(update) abort
  augroup gina_internal_util_diffthis
    autocmd! * <buffer>
  augroup END
  diffoff
  if a:update
    call s:diffupdate(bufnr('%'))
  endif
endfunction

function! s:diffoff_all() abort
  let winid = win_getid()
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&diff')
      call win_gotoid(win_getid(winnr))
      call s:diffoff(0)
    endif
  endfor
  call win_gotoid(winid)
  call s:diffupdate(bufnr('%'))
endfunction

function! s:diffupdate(bufnr, ...) abort
  let winid = bufwinid(a:bufnr)
  if winid == -1
    return
  endif
  let winid_saved = win_getid()
  try
    if winid != winid_saved
      call win_gotoid(winid)
    endif
    diffupdate
    syncbind
  finally
    call win_gotoid(winid_saved)
  endtry
endfunction

function! s:diffcount() abort
  let indicators = map(
        \ range(1, winnr('$')),
        \ 'getwinvar(v:val, ''&diff'')'
        \)
  let indicators = filter(indicators, 'v:val')
  return len(indicators)
endfunction

function! s:call_super(cls, method, ...) abort dict
  return call(a:cls.__super[a:method], a:000, self)
endfunction

function! s:is_sign_visible(bufnr) abort
  if !exists('&signcolumn') || &signcolumn ==# 'auto'
    return len(split(execute('sign place buffer=' . a:bufnr), '\r\?\n')) > 1
  else
    return &signcolumn ==# 'yes'
  endif
endfunction
