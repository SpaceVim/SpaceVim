"=============================================================================
" roadmap.vim --- genrate roadmap completed items
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#dev#roadmap#updateCompletedItems() abort
  let [start, end] = s:find_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_content())
    silent! Neoformat
  endif
endfunction

function! s:find_position() abort
  let start = search('^<!-- SpaceVim roadmap completed items start -->$','bwnc')
  let end = search('^<!-- SpaceVim roadmap completed items end -->$','bnwc')
  return sort([start, end])
endfunction

function! s:generate_content() abort
  let content = ['## Completed',
        \ ''
        \ ]
  let content += s:get_milestones()
  return content
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
