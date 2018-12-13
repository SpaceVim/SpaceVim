" ============================================================================
" File:        help.vim
" Description: plugin for generate vim help file
" Author:      Shidong Wang <wsdjeg@outlook.com>
" Website:     https://spacevim.org
" License:     GPLv3
" ============================================================================

let s:JSON = SpaceVim#api#import('data#json')


function! SpaceVim#dev#help#generate() abort
  let profile = s:get_profile()
  if !empty(profile)
    let content = SpaceVim#dev#help#content#parser(profile, '.')
  endif
  call writefile(content, 'doc/' . profile.name  . '.txt')
endfunction


function! s:get_profile() abort
  let info = s:JSON.json_decode(join(readfile('addon-info.json')))
  if !empty(info)
    return info
  endif
endfunction
