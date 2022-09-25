" =============================================================================
" Filename: autoload/screensaver/util.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 07:26:31.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! screensaver#util#sum(xs) abort
  let n = 0
  for i in range(len(a:xs))
    let n += a:xs[i]
  endfor
  return n
endfunction

function! screensaver#util#message(msg) abort
  redraw
  echo ''
  for msg in split(a:msg, '\n')
    echom msg
  endfor
endfunction

function! screensaver#util#error(msg) abort
  redraw
  echo ''
  echohl ErrorMsg
  for msg in split(a:msg, '\n')
    echom msg
  endfor
  echohl None
endfunction

if exists('*strftime')
  function! screensaver#util#time() abort
    return [strftime('%H') * 1, strftime('%M') * 1, strftime('%S') * 1]
  endfunction
else
  function! screensaver#util#time() abort
    return [system('date "+%H"') * 1, system('date "+%M"') * 1, system('date "+%S"') * 1]
  endfunction
endif

function! screensaver#util#nmapall(mapping) abort
  let save_cpo = &cpo
  set cpo&vim
  let nmaps = split(screensaver#util#capture('nmap'), '\n')
  let cs = map(filter(map(nmaps, 'v:val[3:]'),
        \            'v:val !~# "screensaver\\|^<Plug>\\|^<[-A-Z]\\+> " && v:val =~# "^\\S\\S\\+"'),
        \     'substitute(v:val, "\\s.*", "", "")')
  for c in cs
    exec 'nmap <buffer> ' . c . ' ' . a:mapping
  endfor
  let cs = range(0, 57) + range(59, 255)
  for c in cs
    exec 'nmap <buffer> <Char-' . c . '> ' . a:mapping
    exec 'nmap <buffer> <S-Char-' . c . '> ' . a:mapping
    exec 'nmap <buffer> <C-Char-' . c . '> ' . a:mapping
  endfor
  let cs = [ 'Left', 'Right', 'Up', 'Down', 'Esc', 'Cr', 'Help', 'Undo',
           \ 'Home', 'End', 'Bs', 'Del', 'PageUp', 'PageDown', 'Bar', 'Insert', 'Mouse',
           \ 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
           \ ]
  for c in cs
    exec 'nmap <buffer> <' . c . '> ' . a:mapping
    exec 'nmap <buffer> <C-' . c . '> ' . a:mapping
    exec 'nmap <buffer> <S-' . c . '> ' . a:mapping
  endfor
  let &cpo = save_cpo
endfunction

function! screensaver#util#capture(cmd) abort
  let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
  try
    set verbose=0 verbosefile=
    redir => res
    silent! execute a:cmd
  finally
    redir END
    let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
  endtry
  return res
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
