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

function! SpaceVim#api#import(name) abort
  let p = {}
  try
    let p = SpaceVim#api#{a:name}#get()
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction

" vim:set fdm=marker sw=2 nowrap:
