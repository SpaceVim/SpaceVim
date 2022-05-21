"=============================================================================
" language.vim --- programming language information layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:self = {}

let s:self.__aliases = {
      \ 'typescript' : 'TypeScript',
      \ 'typescriptreact' : 'TypeScript React',
      \ 'python' : 'Python',
      \ 'java' : 'Java',
      \ 'smalltalk' : 'SmallTalk',
      \ 'objc' : 'Objective-C',
      \ 'postscript' : 'PostScript',
      \ }


function! s:self.get_alias(filetype) abort
  if !empty(a:filetype) && has_key(self.__aliases, a:filetype)
    return self.__aliases[a:filetype]
  else
    return a:filetype
  endif
endfunction

function! SpaceVim#api#language#get() abort
  return deepcopy(s:self)
endfunction


