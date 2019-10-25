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

let s:project_config = {}

function! SpaceVim#plugins#a#set_config_name(name) abort

  let s:conf = a:name

endfunction

function! SpaceVim#plugins#a#alt() abort
  let conf_file = s:FILE.unify_path(s:conf, ':p')
  let file = s:FILE.unify_path(bufname('%'), ':.')
  let alt = SpaceVim#plugins#a#get_alt(file, conf_file)
  if !empty(alt)
    exe 'e ' . alt
  endif
endfunction

function! s:paser(conf, root) abort
  for key in keys(a:conf)
    let searchpath = key
    if match(key, '/*')
        let searchpath = substitute(key, '*', '**/*', 'g')
    endif
    for file in s:CMP.globpath('.', searchpath)
      let file = s:FILE.unify_path(file, ':.')
      if has_key(a:conf, file)
        if has_key(a:conf[file], 'alternate')
          let s:project_config[a:root][file] = {'alternate' : a:conf[file]['alternate']}
          continue
        endif
      endif
      let conf = a:conf[key]
      if has_key(conf, 'alternate')
        let begin_end = split(key, '*')
        if len(begin_end) == 2
          let s:project_config[a:root][file] = {'alternate' : s:add_alternate_file(begin_end, file, a:conf[key]['alternate'])}
        endif
      endif
    endfor
  endfor
endfunction

function! s:add_alternate_file(a, f, b) abort
  let begin_len = strlen(a:a[0])
  let end_len = strlen(a:a[1])
  "docs/*.md": {"alternate": "docs/cn/{}.md"},
  "begin_end = 5
  "end_len = 3
  "docs/index.md
  return substitute(a:b, '{}', a:f[begin_len : (end_len+1) * -1], 'g')
endfunction

function! Log() abort
  return s:project_config
endfunction

function! SpaceVim#plugins#a#get_alt(file, root) abort
  if !has_key(s:project_config, a:root)
    let altconfa = s:JSON.json_decode(join(readfile(a:root), "\n"))
    let s:project_config[a:root] = {}
    call s:paser(altconfa, a:root)
  endif
  try
    return s:project_config[a:root][a:file]['alternate']
  catch
    return ''
  endtry
endfunction


function! SpaceVim#plugins#a#get_root() abort
  return s:FILE.unify_path(s:conf, ':p')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
