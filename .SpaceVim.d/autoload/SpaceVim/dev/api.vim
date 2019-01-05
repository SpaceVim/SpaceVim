"=============================================================================
" api.vim --- Develop script for update api index
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:AUTODOC = SpaceVim#api#import('dev#autodoc')
let s:AUTODOC.begin = '^<!-- SpaceVim api list start -->$'
let s:AUTODOC.end = '^<!-- SpaceVim api list end -->$'
let s:AUTODOC.autoformat = 1

function! SpaceVim#dev#api#update() abort
  let s:AUTODOC.content_func = function('s:generate_content')
  call s:AUTODOC.update()
endfunction

function! SpaceVim#dev#api#updateCn() abort
  let s:AUTODOC.content_func = function('s:generate_content_cn')
  call s:AUTODOC.update()
endfunction


function! s:generate_content_cn() abort
  let content = ['', '## 可用 APIs', '']
  let content += s:layer_list_cn()
  let content += ['']
  return content
endfunction

function! s:generate_content() abort
  let content = ['', '## Available APIs', '', 'here is the list of all available APIs, and welcome to contribute to SpaceVim.', '']
  let content += s:layer_list()
  let content += ['']
  return content
endfunction

function! s:layer_list() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/api/**/*.md')
  let list = [
        \ '| Name | Description |',
        \ '| ---------- | ------------ |'
        \ ]
  for layer in layers
    let name = split(layer, '/docs/api/')[1][:-4] . '/'
    let url = name
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction

function! s:layer_list_cn() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/cn/api/**/*.md')
  let list = [
        \ '| 名称 | 描述 |',
        \ '| ---------- | ------------ |'
        \ ]
  for layer in layers
    let name = split(layer, '/docs/cn/api/')[1][:-4] . '/'
    let url = name
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction
