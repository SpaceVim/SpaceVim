"=============================================================================
" FILE: neoyank.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Variables
let s:VERSION = '2.0'

let s:yank_histories = {}
let s:yank_histories_old = {}

" the last modified time of the yank histories file.
let s:yank_histories_file_mtime = 0

let s:prev_registers = {}
let s:prev_yankpost_event = {}

let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
function! s:set_default(var, val, ...) abort
  if !exists(a:var) || type({a:var}) != type(a:val)
    let alternate_var = get(a:000, 0, '')
    unlet! {a:var}

    let {a:var} = exists(alternate_var) ?
          \ {alternate_var} : a:val
  endif
endfunction
function! s:substitute_path_separator(path) abort
  return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction
let s:base = expand(($XDG_CACHE_HOME != '' ?
        \   $XDG_CACHE_HOME . '/neoyank' : '~/.cache/neoyank'), 1)

call s:set_default(
      \ 'g:neoyank#file',
      \ s:substitute_path_separator(s:base.'/history_yank'))

call s:set_default('g:neoyank#limit', 100)

call s:set_default('g:neoyank#length', 10000)

function! neoyank#default_register_from_clipboard()
  if &clipboard == 'unnamed'
    return "*"
  elseif  &clipboard == 'unnamedplus'
    return "+"
  else
    return '"'
  endif
endfunction

call s:set_default(
      \ 'g:neoyank#save_registers',
      \ [neoyank#default_register_from_clipboard()])


function! neoyank#update() abort
  call neoyank#_append()
endfunction

function! neoyank#_append() abort
  call neoyank#_load()

  for register in g:neoyank#save_registers
    call s:add_register(register,
          \ [getreg(register), getregtype(register)])
  endfor

  call neoyank#_save()
endfunction
function! neoyank#_yankpost() abort
  if v:event == s:prev_yankpost_event
    return
  endif
  for register in g:neoyank#save_registers
    call s:add_register(register,
          \ [getreg(register), getregtype(register)])
  endfor
  let s:prev_yankpost_event = v:event
endfunction

function! neoyank#_get_yank_histories() abort
  return s:yank_histories
endfunction

function! neoyank#_save() abort
  if g:neoyank#file == ''
        \ || s:is_sudo()
        \ || (exists('g:neoyank#disable_write') && g:neoyank#disable_write)
        \ || s:yank_histories ==# s:yank_histories_old
    return
  endif

  call s:writefile(g:neoyank#file,
        \ [s:VERSION, s:vim2json(s:yank_histories)])
  let s:yank_histories_file_mtime =
        \ getftime(g:neoyank#file)
  let s:yank_histories_old = copy(s:yank_histories)
endfunction
function! neoyank#_load() abort
  if !filereadable(g:neoyank#file)
        \ || s:yank_histories_file_mtime == getftime(g:neoyank#file)
    return
  endif

  let file = readfile(g:neoyank#file)

  " Version check.
  if empty(file) || len(file) != 2 || file[0] !=# s:VERSION
    return
  endif

  try
    let yank_histories = s:json2vim(file[1])
  catch
    unlet! yank_histories
    let yank_histories = {}
  endtry
  if type(yank_histories) != type({})
    unlet! yank_histories
    let yank_histories = {}
  endif

  for register in g:neoyank#save_registers
    if !has_key(s:yank_histories, register)
      let s:yank_histories[register] = []
    endif
    let s:yank_histories[register] =
          \ get(yank_histories, register, []) + s:yank_histories[register]
    call s:uniq(register)
  endfor

  let s:yank_histories_file_mtime =
        \ getftime(g:neoyank#file)
endfunction

function! s:add_register(name, reg) abort
  " Append register value.
  if !has_key(s:yank_histories, a:name)
    let s:yank_histories[a:name] = []
  endif

  if get(s:yank_histories[a:name], 0, []) ==# a:reg
    " Skip same register value.
    return
  endif

  let len_history = len(a:reg[0])
  " Ignore too long yank.
  if len_history < 2 || len_history > g:neoyank#length
        \ || a:reg[0] =~ '[\x00-\x08\x10-\x1a\x1c-\x1f]\{3,}'
    return
  endif

  " Error check
  try
    call s:vim2json(a:reg)
  catch
    return
  endtry

  let s:prev_registers[a:name] = a:reg

  call insert(s:yank_histories[a:name], a:reg)
  call s:uniq(a:name)
endfunction

function! s:uniq(name) abort
  let history = s:uniq_by(s:yank_histories[a:name], 'v:val')
  if g:neoyank#limit < len(history)
    let history = history[ : g:neoyank#limit - 1]
  endif
  let s:yank_histories[a:name] = history
endfunction

function! s:is_sudo() abort
  return $SUDO_USER != '' && $USER !=# $SUDO_USER
        \ && $HOME !=# expand('~'.$USER)
        \ && $HOME ==# expand('~'.$SUDO_USER)
endfunction

" Removes duplicates from a list.
function! s:uniq_by(list, f) abort
  let list = map(copy(a:list), printf('[v:val, %s]', a:f))
  let i = 0
  let seen = {}
  while i < len(list)
    let key = string(list[i][1])
    if has_key(seen, key)
      call remove(list, i)
    else
      let seen[key] = 1
      let i += 1
    endif
  endwhile
  return map(list, 'v:val[0]')
endfunction

function! s:writefile(path, list) abort
  let path = fnamemodify(a:path, ':p')
  if !isdirectory(fnamemodify(path, ':h'))
    call mkdir(fnamemodify(path, ':h'), 'p')
  endif

  call writefile(a:list, path)
endfunction

function! s:vim2json(expr) abort
  return exists('*json_encode') ? json_encode(a:expr) : string(a:expr)
endfunction
function! s:json2vim(expr) abort
  sandbox return (exists('*json_encode') ? json_decode(a:expr) : eval(a:expr))
endfunction
