"=============================================================================
" html.vim --- SpaceVim html API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:self = {}
let s:XML = SpaceVim#api#import('web#xml')
let s:HTTP = SpaceVim#api#import('web#http')

function! s:self.decodeEntityReference(str) abort
  let str = a:str
  let str = substitute(str, '&gt;', '>', 'g')
  let str = substitute(str, '&lt;', '<', 'g')
  let str = substitute(str, '&quot;', '"', 'g')
  let str = substitute(str, '&apos;', "'", 'g')
  let str = substitute(str, '&nbsp;', ' ', 'g')
  let str = substitute(str, '&yen;', '\&#65509;', 'g')
  let str = substitute(str, '&#\(\d\+\);', '\=s:nr2enc_char(submatch(1))', 'g')
  let str = substitute(str, '&amp;', '\&', 'g')
  let str = substitute(str, '&raquo;', '>', 'g')
  let str = substitute(str, '&laquo;', '<', 'g')
  return str
endfunction

function! s:self.encodeEntityReference(str) abort
  let str = a:str
  let str = substitute(str, '&', '\&amp;', 'g')
  let str = substitute(str, '>', '\&gt;', 'g')
  let str = substitute(str, '<', '\&lt;', 'g')
  let str = substitute(str, "\n", '\&#x0d;', 'g')
  let str = substitute(str, '"', '\&quot;', 'g')
  let str = substitute(str, "'", '\&apos;', 'g')
  let str = substitute(str, ' ', '\&nbsp;', 'g')
  return str
endfunction

function! s:self.parse(html) abort
  let html = substitute(a:html, '<\(area\|base\|basefont\|br\|nobr\|col\|frame\|hr\|img\|input\|isindex\|link\|meta\|param\|embed\|keygen\|command\)\([^>]*[^/]\|\)>', '<\1\2/>', 'g')
  return s:XML.parse(html)
endfunction

function! s:self.parseFile(file) abort
    return self.parse(join(readfile(a:file), "\n"))
endfunction

function! s:self.parseURL(url) abort
    return self.parse(s:HTTP.get(a:url).content)
endfunction

function! SpaceVim#api#web#html#get() abort
    return deepcopy(s:self)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
