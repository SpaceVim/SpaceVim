"=============================================================================
" followHEAD.vim --- generate follow HEAD page
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:AUTODOC = SpaceVim#api#import('dev#autodoc')
let s:AUTODOC.begin = '^<!-- SpaceVim follow HEAD start -->$'
let s:AUTODOC.end = '^<!-- SpaceVim follow HEAD end -->$'


function! s:generate_content(lang) abort
  if a:lang == 'cn'
    let features = ['## 新特性', '']
    let bugfixs = ['', '## 问题修复', '']
    let docs = ['', '## 文档更新', '']
    let tests = ['', '## 测试', '']
    let others = ['', '## 其他', '']
    let breakchanges = ['', '## 非兼容变更']
  else
    let features = ['## New features', '']
    let bugfixs = ['', '## Bugfixs', '']
    let docs = ['', '## Docs', '']
    let tests = ['', '## Tests', '']
    let others = ['', '## Others', '']
    let breakchanges = ['', '## Breakchanges']
  endif
  let logs = systemlist('git log --oneline --pretty="- %s" 2a2deac2..HEAD')
  for l in logs
    if l =~ '^- [^(]*([^)]*)!:'
      call add(breakchanges, l)
    elseif l =~ '^- feat(' || l =~ '^- perf('
      call add(features, l)
    elseif l =~ '^- fix('
      call add(bugfixs, l)
    elseif l =~ '^- docs('
      call add(docs, l)
    elseif l =~ '^- test('
      call add(tests, l)
    else
      call add(others, l)
    endif
  endfor

  return features + bugfixs + docs + tests + others + breakchanges
endfunction

let s:AUTODOC.content_func = function('s:generate_content')
let s:AUTODOC.autoformat = 1

function! SpaceVim#dev#followHEAD#update(lang) abort
  call s:AUTODOC.update(a:lang)
endfunction


