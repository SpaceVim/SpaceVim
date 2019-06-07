scriptencoding utf-8
let s:SYSTEM = SpaceVim#api#import('system')
let s:save_cpo = &cpo
set cpo&vim
let g:unite_source_menu_menus =
      \ get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.CustomKeyMaps = {'description':
      \ 'Custom mapped keyboard shortcuts                   [unite]<SPACE>'}
let g:unite_source_menu_menus.CustomKeyMaps.command_candidates =
      \ get(g:unite_source_menu_menus.CustomKeyMaps,'command_candidates', [])
let g:unite_source_menu_menus.MyStarredrepos = {'description':
      \ 'All github repos starred by me                   <leader>ls'}
let g:unite_source_menu_menus.MyStarredrepos.command_candidates =
      \ get(g:unite_source_menu_menus.MyStarredrepos,'command_candidates', [])
let g:unite_source_menu_menus.MpvPlayer = {'description':
      \ 'Musics list                   <leader>lm'}
let g:unite_source_menu_menus.MpvPlayer.command_candidates =
      \ get(g:unite_source_menu_menus.MpvPlayer,'command_candidates', [])
fu! zvim#util#defineMap(type,key,value,desc,...) abort
  exec a:type . ' ' . a:key . ' ' . a:value
  let description = '➤ '
        \. a:desc
        \. repeat(' ', 80 - len(a:desc) - len(a:key))
        \. a:key
  let cmd = len(a:000) > 0 ? a:000[0] : a:value
  call add(g:unite_source_menu_menus.CustomKeyMaps.command_candidates, [description,cmd])

endf
fu! zvim#util#source_rc(file) abort
  if filereadable(g:_spacevim_root_dir. '/config/' . a:file)
    execute 'source ' . g:_spacevim_root_dir  . '/config/' . a:file
  endif
endf

fu! zvim#util#SmartClose() abort
  let ignorewin = get(g:,'spacevim_smartcloseignorewin',[])
  let ignoreft = get(g:, 'spacevim_smartcloseignoreft',[])
  let win_count = winnr('$')
  let num = win_count
  for i in range(1,win_count)
    if index(ignorewin , bufname(winbufnr(i))) != -1 || index(ignoreft, getbufvar(bufname(winbufnr(i)),'&filetype')) != -1
      let num = num - 1
    elseif getbufvar(winbufnr(i),'&buftype') ==# 'quickfix'
      let num = num - 1
    elseif getwinvar(i, '&previewwindow') == 1 && winnr() !=# i
      let num = num - 1
    endif
  endfor
  if num == 1
  else
    quit
  endif
endf

fu! zvim#util#check_if_expand_tab() abort
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

function! zvim#util#BufferEmpty() abort
  let l:current = bufnr('%')
  if ! getbufvar(l:current, '&modified')
    enew
    silent! execute 'bdelete '.l:current
  endif
endfunction

function! zvim#util#loadMusics() abort
  let musics = SpaceVim#util#globpath('~/Musics', '*.mp3')
  let g:unite_source_menu_menus.MpvPlayer.command_candidates = []
  for m in musics
    call add(g:unite_source_menu_menus.MpvPlayer.command_candidates,
          \ [fnamemodify(m, ':t'),
          \ "call zvim#mpv#play('" . m . "')"])
  endfor
endfunction

function! zvim#util#listDirs(dir) abort
  let dir = fnamemodify(a:dir, ':p')
  if isdirectory(dir)
    let cmd = printf('ls -F %s | grep /$', dir)
    return map(systemlist(cmd), 'v:val[:-2]')
  endif
  return []
endfunction

let s:plugins_argv = ['-update', '-openurl']

function! zvim#util#complete_plugs(ArgLead, CmdLine, CursorPos) abort
  call zvim#debug#completion_debug(a:ArgLead, a:CmdLine, a:CursorPos)
  if a:CmdLine =~# 'Plugin\s*$' || a:ArgLead =~# '^-[a-zA-Z]*'
    return join(s:plugins_argv, "\n")
  endif
  return join(plugins#list(), "\n")
endfunction

function! zvim#util#Plugin(...) abort
  let adds = []
  let updates = []
  let flag = 0
  for a in a:000
    if flag == 1
      call add(adds, a)
    elseif flag == 2
      call add(updates, a)
    endif
    if a ==# '-update'
      let flag = 1
    elseif a ==# '-openurl'
      let flag = 2
    endif
  endfor
  echo string(adds) . "\n" . string(updates)
endfunction

function! zvim#util#complete_project(ArgLead, CmdLine, CursorPos) abort
  call zvim#debug#completion_debug(a:ArgLead, a:CmdLine, a:CursorPos)
  let dir = get(g:,'spacevim_src_root', '~')
  "return globpath(dir, '*')
  let result = split(globpath(dir, '*'), "\n")
  let ps = []
  for p in result
    if isdirectory(p) && isdirectory(p. '\' . '.git')
      call add(ps, fnamemodify(p, ':t'))
    endif
  endfor
  return join(ps, "\n")
endfunction

function! zvim#util#OpenProject(p) abort
  let dir = get(g:, 'spacevim_src_root', '~') . a:p
  exe 'CtrlP '. dir
endfunction

function! zvim#util#UpdateHosts(...) abort
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
fu! zvim#util#Generate_ignore(ignore,tool, ...) abort
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

let &cpo = s:save_cpo
unlet s:save_cpo
