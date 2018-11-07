"=============================================================================
" api.vim --- Develop script for update api index
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

function! SpaceVim#dev#api#update() abort

  let [start, end] = s:find_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_content())
    silent! Neoformat
  endif

endfunction

function! SpaceVim#dev#api#updateCn() abort

  let [start, end] = s:find_position_cn()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_content_cn())
    silent! Neoformat
  endif

endfunction

function! s:find_position() abort
  let start = search('^<!-- SpaceVim api list start -->$','bwnc')
  let end = search('^<!-- SpaceVim api list end -->$','bnwc')
  return sort([start, end])
endfunction

function! s:find_position_cn() abort
  let start = search('^<!-- SpaceVim api cn list start -->$','bwnc')
  let end = search('^<!-- SpaceVim api cn list end -->$','bnwc')
  return sort([start, end])
endfunction

function! s:generate_content() abort
  let content = ['', '## Available APIs', '', 'here is the list of all available APIs, and welcome to contribute to SpaceVim.', '']
  let content += s:layer_list()
  let content += ['']
  return content
endfunction

function! s:generate_content_cn() abort
  let content = ['', '## 可用 APIs', '']
  let content += s:layer_list_cn()
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
