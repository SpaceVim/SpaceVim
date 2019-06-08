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


let &cpo = s:save_cpo
unlet s:save_cpo
