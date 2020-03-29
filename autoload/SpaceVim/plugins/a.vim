"=============================================================================
" a.vim --- plugin for manager alternate file
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8


" Load SpaceVim API

let s:CMP = SpaceVim#api#import('vim#compatible')
let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')
let s:conf = '.project_alt.json'
let s:cache_path = g:spacevim_data_dir.'/SpaceVim/a.json'


" this is for saving the project configuration information. Use the path of
" the project_alt.json file as the key.
let s:project_config = {}


" saving cache

function! s:cache() abort
  call writefile([s:JSON.json_encode(s:project_config)], s:FILE.unify_path(s:cache_path, ':p'))
endfunction

function! s:load_cache() abort
  let s:project_config = s:JSON.json_decode(join(readfile(s:cache_path, ''), ''))
endfunction



" when this function is called, the project_config file name is changed, and
" the project_config info is cleared.
function! SpaceVim#plugins#a#set_config_name(name) abort
  let s:conf = a:name
  let s:project_config = {}
endfunction

function! s:get_project_config(conf_file) abort
  let project_config_conf = get(b:, 'project_alt_json', {})
  if !empty(project_config_conf)
    return project_config_conf
  endif
  return s:JSON.json_decode(join(readfile(a:conf_file), "\n"))
endfunction

function! SpaceVim#plugins#a#alt(request_paser,...) abort
  let type = get(a:000, 0, 'alternate')
  let conf_file_path = s:FILE.unify_path(s:conf, ':p')
  let file = s:FILE.unify_path(bufname('%'), ':.')
  let alt = SpaceVim#plugins#a#get_alt(file, conf_file_path, a:request_paser, type)
  if !empty(alt)
    exe 'e ' . alt
  endif
endfunction

function! s:paser(conf, root) abort
  for key in keys(a:conf)
    let searchpath = key
    if match(key, '/\*')
      let searchpath = substitute(key, '*', '**/*', 'g')
    endif
    for file in s:CMP.globpath('.', searchpath)
      let file = s:FILE.unify_path(file, ':.')
      let s:project_config[a:root][file] = {}
      if has_key(a:conf, file)
        for type in keys(a:conf[file])
          if len(begin_end) == 2
            let s:project_config[a:root][file][type] = a:conf[key][type]
          endif
        endfor
      else
        for type in keys(a:conf[key])
          let begin_end = split(key, '*')
          if len(begin_end) == 2
            let s:project_config[a:root][file][type] = s:get_type_path(begin_end, file, a:conf[key][type])
          endif
        endfor
      endif
    endfor
  endfor
  call s:cache()
endfunction

function! s:get_type_path(a, f, b) abort
  let begin_len = strlen(a:a[0])
  let end_len = strlen(a:a[1])
  "docs/*.md": {"alternate": "docs/cn/{}.md"},
  "begin_end = 5
  "end_len = 3
  "docs/index.md
  return substitute(a:b, '{}', a:f[begin_len : (end_len+1) * -1], 'g')
endfunction

function! SpaceVim#plugins#a#get_alt(file, conf_path, request_paser,...) abort
  if getftime(a:conf_path) < getftime(s:cache_path)
  endif
  if a:request_paser || !has_key(s:project_config, a:conf_path)
    let altconfa = s:get_project_config(a:conf_path)
    let s:project_config[a:conf_path] = {}
    call s:paser(altconfa, a:conf_path)
  endif
  try
    return s:project_config[a:conf_path][a:file][get(a:000, 0, 'alternate')]
  catch
    return ''
  endtry
endfunction


function! SpaceVim#plugins#a#get_root() abort
  return s:FILE.unify_path(s:conf, ':p')
endfunction

function! SpaceVim#plugins#a#complete(ArgLead, CmdLine, CursorPos) abort
  let file = s:FILE.unify_path(bufname('%'), ':.')
  let conf = s:FILE.unify_path(s:conf, ':p')

  if !has_key(s:project_config, conf )
    let altconfa = s:get_project_config(conf)
    let s:project_config[conf] = {}
    call s:paser(altconfa, conf)
  endif
  try
    let a = s:project_config[s:FILE.unify_path(s:conf, ':p')][file]
  catch
    let a = {}
  endtry
  return join(keys(a), "\n")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
