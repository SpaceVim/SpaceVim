"=============================================================================
" layers.vim --- Develop script for update layer index
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:FILE = SpaceVim#api#import('file')
let s:SYS = SpaceVim#api#import('system')



let s:AUTODOC = SpaceVim#api#import('dev#autodoc')
let s:AUTODOC.autoformat = 1

function! SpaceVim#dev#layers#update() abort
  let s:AUTODOC.begin = '^<!-- SpaceVim layer list start -->$'
  let s:AUTODOC.end = '^<!-- SpaceVim layer list end -->$'
  let s:AUTODOC.content_func = function('s:generate_content')
  call s:AUTODOC.update()
endfunction

function! SpaceVim#dev#layers#updateCn() abort
  let s:AUTODOC.begin = '^<!-- SpaceVim layer cn list start -->$'
  let s:AUTODOC.end = '^<!-- SpaceVim layer cn list end -->$'
  let s:AUTODOC.content_func = function('s:generate_content_cn')
  call s:AUTODOC.update()
endfunction

function! SpaceVim#dev#layers#updatedocker() abort
  let [start, end] = s:find_docker_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_docker_content())
  endif
endfunction

function! s:find_position() abort
  let start = search('^<!-- SpaceVim layer list start -->$','bwnc')
  let end = search('^<!-- SpaceVim layer list end -->$','bnwc')
  return sort([start, end], 'n')
endfunction

function! s:find_docker_position() abort
  let start = search('^## -- SpaceVim layer list start$','bwnc')
  let end = search('^## -- SpaceVim layer list end$','bnwc')
  return sort([start, end], 'n')
endfunction

function! s:find_position_cn() abort
  let start = search('^<!-- SpaceVim layer cn list start -->$','bwnc')
  let end = search('^<!-- SpaceVim layer cn list end -->$','bnwc')
  return sort([start, end], 'n')
endfunction

function! s:generate_content() abort
  let content = ['', '## Available layers', '']
  let content += s:layer_list()
  let content += ['']
  return content
endfunction

function! s:generate_content_cn() abort
  let content = ['', '## 可用模块', '']
  let content += s:layer_list_cn()
  let content += ['']
  return content
endfunction

function! s:generate_docker_content() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/cn/layers/**/*.md')
  let list = [
        \ ]
  call remove(layers, index(layers, '/home/wsdjeg/.SpaceVim/docs/cn/layers/index.md'))
  for layer in layers
    let name = split(layer, '/docs/cn/layers/')[1][:-4] . '/'
    if name ==# 'language-server-protocol/'
      let name = 'lsp'
    endif
    let name = join(split(name, '/'), '#')
    let snippet = ['[[layers]]', '  name = "' . name . '"', '']
    let list += snippet
  endfor
  return list
endfunction

function! s:layer_list() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/layers/**/*.md')
  let list = [
        \ '| Name | Description |',
        \ '| ---------- | ------------ |'
        \ ]
  if s:SYS.isWindows
    let pattern = join(['', 'docs', 'layers', ''], s:FILE.separator . s:FILE.separator)
  else
    let pattern = join(['', 'docs', 'layers', ''], s:FILE.separator)
  endif
  for layer in layers
    let name = split(layer, pattern)[1][:-4] . s:FILE.separator
    let url = join(split(name, s:FILE.separator), '/') . '/'
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction

function! s:layer_list_cn() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/cn/layers/**/*.md')
  let list = [
        \ '| 名称 | 描述 |',
        \ '| ---------- | ------------ |'
        \ ]
  if s:SYS.isWindows
    let pattern = join(['', 'docs', 'cn', 'layers', ''], s:FILE.separator . s:FILE.separator)
  else
    let pattern = join(['', 'docs', 'cn', 'layers', ''], s:FILE.separator)
  endif
  for layer in layers
    let name = split(layer, pattern)[1][:-4] . s:FILE.separator
    let url = join(split(name, s:FILE.separator), '/') . '/'
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, s:FILE.separator), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction
