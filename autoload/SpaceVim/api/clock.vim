"=============================================================================
" clock.vim --- clock API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section clock, api-clock
" @parentsection api
" The `clock` api provides basic functions to manage clock. The following
" functions can be used:
"
" - `start()`: start a new clock.
" - `pause()`: pause current clock.
" - `continue()`: continue current clock.
" - `end()`: stop current clock, and return the time.
"
" Example:
" >
"   let s:CLOCK = SpaceVim#api#import('clock')
"   call s:CLOCK.start()
"   " do something
"   echo s:CLOCK.end()
" <

let s:self = {}
let s:self.__begin = 0
let s:self.__long = 0

function! s:self.start() abort
  let self.__begin = reltime()
  let self.__long = 0
endfunction

function! s:self.pause() abort
  let self.__long = reltimefloat(reltime(self.__begin))
endfunction

function! s:self.continue() abort
  let self.__begin = reltime()
endfunction

function! s:self.end() abort
  let self.__end = reltimefloat(reltime(self.__begin))
  return self.__end + self.__long
endfunction


function! SpaceVim#api#clock#get() abort
  return deepcopy(s:self)
endfunction

