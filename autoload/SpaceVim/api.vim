"=============================================================================
" api.vim --- SpaceVim api
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section API, api
" SpaceVim contains a variety of public apis. To using the api, you need to
" make sure SpaceVim has been added to your &rtp. after that, you can use
" |SpaceVim#api#import| to import the API you need.
"
" @subsection usage
"
" This is just an example, and it works well in old version vim.
" >
"   let s:json = SpaceVim#api#import('data#json')
"   let rst = s:json.json_encode(onject)
"   let rst = s:json.json_decode(string)
" <
" 
" here is list of resources where SpaceVim comes from:
"
" - vital: https://github.com/vim-jp/vital.vim

let s:apis = {}

" the api itself is a dict, and it will be changed when user use the api. so
" every time when request a api, we should provide an clean api.


""
" Import API base the given {name}, and return the API object. for all
" available APIs please check |spacevim-api|
function! SpaceVim#api#import(name) abort
  if has_key(s:apis, a:name)
    return deepcopy(s:apis[a:name])
  endif
  let p = {}
  try
    let p = SpaceVim#api#{a:name}#get()
    let s:apis[a:name] = deepcopy(p)
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction

""
" Register new {api} named {name}, 1 will be returned if succeed. for all
" available APIs please check |spacevim-api|
"
" Example:
" >
"   let s:hello = {}
"   function! s:hello.say(who)
"     echo 'hello! ' . a:who
"   endfunction
"   call SpaceVim#api#register('hello', s:hello)
"
"   " after registering api, you can use this api
"   " in other vim scripts like this:
"   let s:H = SpaceVim#api#import('hello')
"   call s:H.say('wsdjeg')
" <
function! SpaceVim#api#register(name, api) abort
  " the name must be string
  if type(a:name) ==# type('') && strlen(a:name) >= 1
    if !empty(SpaceVim#api#import(a:name))
      call SpaceVim#logger#warn('API:' . a:name . ' already existed!')
    else
      let s:apis[a:name] = deepcopy(a:api)
    endif
  else
    call SpaceVim#logger#warn('failed to register api, the name must be a no empty string!')
  endif
endfunction

" vim:set fdm=marker sw=2 nowrap:
