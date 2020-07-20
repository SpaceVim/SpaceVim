"=============================================================================
" util.vim --- SpaceVim utils
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:SYSTEM = SpaceVim#api#import('system')


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

fu! SpaceVim#util#check_if_expand_tab() abort
  let has_noexpandtab = search('^\t','wn')
  let has_expandtab = search('^    ','wn')
  if has_noexpandtab && has_expandtab
    let idx = inputlist ( ['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
          \ '1. expand (tab=space, recommended)',
          \ '2. noexpand (tab=\t, currently have risk)',
          \ '3. do nothing (I will handle it by myself)'])
    let tab_space = printf('%*s',&tabstop,'')
    if idx == 1
      let has_noexpandtab = 0
      let has_expandtab = 1
      silent exec '%s/\t/' . tab_space . '/g'
    elseif idx == 2
      let has_noexpandtab = 1
      let has_expandtab = 0
      silent exec '%s/' . tab_space . '/\t/g'
    else
      return
    endif
  endif
  if has_noexpandtab == 1 && has_expandtab == 0
    echomsg 'substitute space to TAB...'
    set noexpandtab
    echomsg 'done!'
  elseif has_noexpandtab == 0 && has_expandtab == 1
    echomsg 'substitute TAB to space...'
    set expandtab
    echomsg 'done!'
  else
    " it may be a new file
    " we use original vim setting
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
    if executable('git')
      let repo_home = fnamemodify(s:findDirInParent('.git', expand('%:p')), ':p:h:h')
      if repo_home !=# '' || !isdirectory(repo_home)
        let [remote_name, branch] = split(split(systemlist('git -C '. repo_home. ' branch -vv |grep "^*"')[0],'')[3], '/')
        let remotes = filter(systemlist('git -C '. repo_home. ' remote -v'),"match(v:val,'^' . remote_name[1:-2]) >= 0 && match(v:val,'fetch') > 0")
        if len(remotes) > 0
          let remote = remotes[0]
          if stridx(remote, '@') > -1
            let repo_url = split(split(remote, '@')[1], ':')[0]
            let repo_url = 'https://'. repo_url. '/'. split(split(remote,' ')[0],':')[1]
            let repo_url = strpart(repo_url, 0, len(repo_url) - 4)
          else
            let repo_url = split(remote,' ')[0]
            let repo_url = strpart(repo_url, stridx(repo_url, 'http'),len(repo_url) - 4 - stridx(repo_url, 'http'))
          endif
          let head_sha = systemlist('git rev-parse HEAD')[0] 
          let f_url =repo_url. '/blob/'. head_sha. '/'. strpart(expand('%:p'), len(repo_home) + 1, len(expand('%:p')))
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
            echo 'Copied to clipboard: ' . @+
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
      if !empty(@+) || filereadable(@+)
        echo 'Copied to clipboard ' . @+
      else
        echo 'buffer name is empty!'
      endif
    catch /^Vim\%((\a\+)\)\=:E354/
      if has('nvim')
        echohl WarningMsg | echom 'Can not find clipboard, for more info see :h clipboard' | echohl None
      else
        echohl WarningMsg | echom 'You need to compile your vim with +clipboard feature' | echohl None
      endif
    endtry
  endif
endf

fu! SpaceVim#util#Generate_ignore(ignore,tool, ...) abort
  let ignore = []
  if a:tool ==# 'ag'
    for ig in split(a:ignore,',')
      call add(ignore, '--ignore')
      call add(ignore, "'" . ig . "'")
    endfor
  elseif a:tool ==# 'rg'
    for ig in split(a:ignore,',')
      call add(ignore, '-g')
      if get(a:000, 0, 0) == 1
        call add(ignore, "'!" . ig . "'")
      else
        call add(ignore, '!' . ig)
      endif
    endfor
  endif
  return ignore
endf

function! SpaceVim#util#UpdateHosts(...) abort
  if len(a:000) == 0
    let url = get(g:,'spacevim_hosts_url', '')
  else
    let url = a:1
  endif
  let hosts = systemlist('curl -s ' . url)
    if s:SYSTEM.isWindows
    let local_hosts = $SystemRoot . expand('\System32\drivers\etc\hosts')
  else
    let local_hosts = '/etc/hosts'
  endif
  if writefile(hosts, local_hosts, 'a') == -1
    echo 'failed!'
  else
    echo 'successfully!'
  endif
endfunction

function! SpaceVim#util#listDirs(dir) abort
  let dir = fnamemodify(a:dir, ':p')
  if isdirectory(dir)
    let cmd = printf('ls -F %s | grep /$', dir)
    return map(systemlist(cmd), 'v:val[:-2]')
  endif
  return []
endfunction

" vim:set et sw=2 cc=80:
