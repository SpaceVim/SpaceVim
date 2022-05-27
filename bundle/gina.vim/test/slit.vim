"=============================================================================
"
" A small lib for git handling mainly for unittest
"
" Author:   lambdalisue <lambdalisue@hashnote.net>
" License:  MIT License
"
"=============================================================================
let s:is_windows = has('win32') || has('win64')
let s:separator = s:is_windows ? '\' : '/'

function! s:shellescape(x) abort
  return a:x !~# '\s' ? a:x : shellescape(a:x)
endfunction


let s:guard = {}

function! s:guard.restore() abort
  execute self.command
endfunction


let s:slit = {}

function! s:slit.cd() abort
  let guard = copy(s:guard)
  let guard.command = printf('cd %s', fnameescape(getcwd()))
  execute 'cd' fnameescape(self.worktree)
  return guard
endfunction

function! s:slit.lcd() abort
  let guard = copy(s:guard)
  let guard.command = printf('lcd %s', fnameescape(getcwd()))
  execute 'lcd' fnameescape(self.worktree)
  return guard
endfunction

function! s:slit.path(path) abort
  let path = s:is_windows
        \ ? fnamemodify(a:path, ':gs?/?\\?')
        \ : fnamemodify(a:path, ':gs?\\?/?')
  return simplify(self.worktree . s:separator . path)
endfunction

function! s:slit.read(path) abort
  return readfile(self.path(a:path))
endfunction

function! s:slit.write(path, content) abort
  let path = self.path(a:path)
  let dirpath = fnamemodify(path, ':p:h')
  if !isdirectory(dirpath)
    call mkdir(dirpath, 'p')
  endif
  return writefile(a:content, path)
endfunction

function! s:slit.execute(...) abort
  let expr = a:000[0]
  let terms = map(a:000[1:], 's:shellescape(v:val)')
  let command = empty(terms) ? expr : call('printf', [expr] + terms)
  let args = [
        \ 'git',
        \ '-c color.ui=false',
        \ '-c core.editor=false',
        \ '--no-pager',
        \]
  if !empty(get(self, 'worktree'))
    let args += ['-C', shellescape(self.worktree)]
  endif
  let output = system(join(args + [command]))
  return split(output, '\r\?\n')
endfunction

function! s:slit.init() abort
  call self.execute('init')
  return self
endfunction

function! s:slit.reset() abort
  call self.execute('reset --hard HEAD')
  call self.execute('clean -df')
  return self
endfunction

function! Slit(worktree, ...) abort
  let slit = copy(s:slit)
  let slit.worktree = resolve(fnamemodify(a:worktree, ':p'))
  let slit.repository = slit.worktree . s:separator . '.git'
  let slit.refname = fnamemodify(slit.worktree, ':t')
  if !isdirectory(slit.worktree)
    call mkdir(slit.worktree, 'p')
  endif
  lockvar slit
  return get(a:000, 0, 0) ? slit.init() : slit
endfunction

let g:git_version = matchstr(system('git --version'), '\%(\d\+\.\)\+\d')
let g:git_support_worktree = g:git_version !~# '^\%([01]\..*\|2\.4\..*\)$'
