"=============================================================================
" util.vim --- SpaceVim utils
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#util#globpath(path, expr) abort
  if has('patch-7.4.279')
    return globpath(a:path, a:expr, 1, 1)
  else
    return split(globpath(a:path, a:expr), '\n')
  endif
endfunction

function! SpaceVim#util#findFileInParent(what, where) abort
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let file = findfile(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return file
endfunction

fu! SpaceVim#util#loadConfig(file) abort
  if filereadable(g:_spacevim_root_dir. '/config/' . a:file)
    execute 'source ' . g:_spacevim_root_dir  . '/config/' . a:file
  endif
endf

function! SpaceVim#util#findDirInParent(what, where) abort
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let dir = finddir(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return dir
endfunction

function! SpaceVim#util#echoWarn(msg) abort
  echohl WarningMsg
  echo a:msg
  echohl None
endfunction

let s:cache_pyx_libs = {}
function! SpaceVim#util#haspyxlib(lib) abort
  if has_key(s:cache_pyx_libs, a:lib)
    return s:cache_pyx_libs[a:lib]
  endif
  try
    exe 'pyx import ' . a:lib
  catch
    let s:cache_pyx_libs[a:lib] = 0
    return 0
  endtry
  let s:cache_pyx_libs[a:lib] = 1
  return 1
endfunction

let s:cache_py_libs = {}
function! SpaceVim#util#haspylib(lib) abort
  if has_key(s:cache_py_libs, a:lib)
    return s:cache_py_libs[a:lib]
  endif
  try
    exe 'py import ' . a:lib
  catch
    let s:cache_py_libs[a:lib] = 0
    return 0
  endtry
  let s:cache_py_libs[a:lib] = 1
  return 1
endfunction


let s:cache_py3_libs = {}
function! SpaceVim#util#haspy3lib(lib) abort
  if has_key(s:cache_py3_libs, a:lib)
    return s:cache_py3_libs[a:lib]
  endif
  try
    exe 'py3 import ' . a:lib
  catch
    let s:cache_py3_libs[a:lib] = 0
    return 0
  endtry
  let s:cache_py3_libs[a:lib] = 1
  return 1
endfunction

fu! s:findFileInParent(what, where) abort " {{{2
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let file = findfile(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return file
endf " }}}2
fu! s:findDirInParent(what, where) abort " {{{2
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let dir = finddir(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return dir
endf " }}}2
fu! SpaceVim#util#CopyToClipboard(...) abort
  if a:0
    echom 1
    if executable('git')
      let repo_home = fnamemodify(s:findDirInParent('.git', expand('%:p')), ':p:h:h')
      if repo_home !=# '' || !isdirectory(repo_home)
        let branch = split(systemlist('git -C '. repo_home. ' branch -a |grep "*"')[0],' ')[1]
        let remotes = filter(systemlist('git -C '. repo_home. ' remote -v'),"match(v:val,'^origin') >= 0 && match(v:val,'fetch') > 0")
        if len(remotes) > 0
          let remote = remotes[0]
          if stridx(remote, '@') > -1
            let repo_url = 'https://github.com/'. split(split(remote,' ')[0],':')[1]
            let repo_url = strpart(repo_url, 0, len(repo_url) - 4)
          else
            let repo_url = split(remote,' ')[0]
            let repo_url = strpart(repo_url, stridx(repo_url, 'http'),len(repo_url) - 4 - stridx(repo_url, 'http'))
          endif
          let f_url =repo_url. '/blob/'. branch. '/'. strpart(expand('%:p'), len(repo_home) + 1, len(expand('%:p')))
          if s:SYSTEM.isWindows
            let f_url = substitute(f_url, '\', '/', 'g')
          endif
          if a:1 == 2
            let current_line = line('.')
            let f_url .= '#L' . current_line
          elseif a:1 == 3
            let f_url .= '#L' . getpos("'<")[1] . '-L' . getpos("'>")[1]
          endif
          try
            let @+=f_url
            echo 'Copied to clipboard'
          catch /^Vim\%((\a\+)\)\=:E354/
            if has('nvim')
              echohl WarningMsg | echom 'Cannot find clipboard, for more info see :h clipboard' | echohl None
            else
              echohl WarningMsg | echom 'You need to compile your vim with +clipboard feature' | echohl None
            endif
          endtry
        else
          echohl WarningMsg | echom 'This git repo has no remote host' | echohl None
        endif
      else
        echohl WarningMsg | echom 'This file is not in a git repo' | echohl None
      endif
    else
      echohl WarningMsg | echom 'You need to install git!' | echohl None
    endif
  else
    try
      let @+=expand('%:p')
      echo 'Copied to clipboard ' . @+
    catch /^Vim\%((\a\+)\)\=:E354/
      if has('nvim')
        echohl WarningMsg | echom 'Can not find clipboard, for more info see :h clipboard' | echohl None
      else
        echohl WarningMsg | echom 'You need to compile you vim with +clipboard feature' | echohl None
      endif
    endtry
  endif
endf

" vim:set et sw=2 cc=80:
