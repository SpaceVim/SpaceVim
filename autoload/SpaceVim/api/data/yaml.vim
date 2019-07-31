"=============================================================================
" yaml.vim --- yaml api for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:save_cpo = &cpo
set cpo&vim

let s:self = {}

function! s:self.parse(text) abort
  let input = {
  \   'text': a:text,
  \   'p': 0,
  \   'length': strlen(a:text),
  \}
  return self._parse(input)
endfunction

function! s:self.parse_file(filename) abort
  if !filereadable(a:filename)
    throw printf("toml API: No such file `%s'.", a:filename)
  endif

  let text = join(readfile(a:filename), "\n")
  " fileencoding is always utf8
  return self.parse(iconv(text, 'utf8', &encoding))
endfunction
function! SpaceVim#api#data#toml#get() abort
  return deepcopy(s:self)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
