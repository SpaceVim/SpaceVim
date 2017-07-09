" ============================================================================
" File:        api.vim
" Description: SpaceVim api core file
" Author:      Shidong Wang <wsdjeg@outlook.com>
" Website:     https://spacevim.org
" License:     MIT
" ============================================================================

""
" @section API, api
" SpaceVim contains a variety of public apis. here is a list of all the apis.
" @subsection usage
" This is just an example, and it works well in old version vim.
" >
"   let s:json = SpaceVim#api#import('data#json')
"   let rst = s:json.json_encode(onject)
"   let rst = s:json.json_decode(string)
" <

let s:apis = {}

function! SpaceVim#api#import(name) abort
  if has_key(s:apis, a:name)
    return deepcopy(s:apis[a:name])
  endif
  let p = {}
  try
    let p = SpaceVim#api#{a:name}#get()
    let s:apis[a:name] = p
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction

function! SpaceVim#api#register(name, api) abort
  if !empty(SpaceVim#api#import(a:name))
    echoerr '[SpaceVim api] Api : ' . a:name . ' already existed!'
  else
    let s:apis[a:name] = deepcopy(a:api)
  endif
endfunction

" vim:set fdm=marker sw=2 nowrap:
