"=============================================================================
" roadmap.vim --- genrate roadmap completed items
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:AUTODOC = SpaceVim#api#import('dev#autodoc')
let s:AUTODOC.begin = '^<!-- SpaceVim roadmap completed items start -->$'
let s:AUTODOC.end = '^<!-- SpaceVim roadmap completed items end -->$'

function! s:generate_content() abort
  let content = ['## Completed',
        \ ''
        \ ]
  let content += s:get_milestones()
  return content
endfunction

let s:AUTODOC.content_func = function('s:generate_content')
let s:AUTODOC.autoformat = 1

function! SpaceVim#dev#roadmap#updateCompletedItems() abort
  call s:AUTODOC.update()
endfunction

function! s:get_milestones() abort
  let milestones = github#api#issues#ListAllMilestones('SpaceVim', 'SpaceVim', 'closed', 'due_on', 'asc')
  let line = []

  for milestone in milestones
    call add(line, '### [' . milestone.title . '](' . milestone.html_url . ')' )
    call add(line, '')
    if !empty(get(milestone, 'description', ''))
      let line += split(milestone.description, "\n")
      call add(line, '')
    endif
    call add(line, 'release note: [' . milestone.title . '](http://spacevim.org/SpaceVim-release-' . milestone.title . '/)' )
    call add(line, '')
  endfor
  if line[-1] !=# ''
    let line += ['']
  endif
  return line
endfunction
