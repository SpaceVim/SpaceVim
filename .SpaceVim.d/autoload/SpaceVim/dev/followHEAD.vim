"=============================================================================
" followHEAD.vim --- generate follow HEAD page
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:AUTODOC = SpaceVim#api#import('dev#autodoc')
let s:AUTODOC.begin = '^<!-- SpaceVim follow HEAD en start -->$'
let s:AUTODOC.end = '^<!-- SpaceVim follow HEAD en end -->$'

function! s:generate_content() abort
  let content = s:follow_head_content()
  return content
endfunction

let s:AUTODOC.content_func = function('s:generate_content')
let s:AUTODOC.autoformat = 1

let s:lang = 'en'
function! SpaceVim#dev#followHEAD#update(lang) abort
  let s:lang = a:lang
  call s:AUTODOC.update()
endfunction


function! s:list_closed_prs(owner, repo, page) abort
  return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues?state=closed&page=' . a:page , [])
endfunction

function! s:get_list_of_PRs() abort
  let prs = []
  for i in range(1, 2)
    let issues = s:list_closed_prs('SpaceVim','SpaceVim', i)
    call extend(prs,
          \ filter(issues,
          \ "v:val['number'] > "
          \ . SpaceVim#dev#releases#last_release_number()
          \ . " && v:val['number'] < "
          \ . SpaceVim#dev#releases#current_release_number()
          \ . " && index(SpaceVim#dev#releases#unmerged_prs_since_current_release(), v:val['number']) == -1 "
          \ ))
  endfor
  for i in SpaceVim#dev#releases#get_unmerged_prs() 
    let pr = github#api#issues#Get_issue('SpaceVim', 'SpaceVim', i)
    if get(pr, 'state', '') ==# 'closed'
      call add(prs, pr)
    endif
  endfor
  return filter(prs, "has_key(v:val, 'pull_request')")
endfunction

let s:prs = []
function! s:follow_head_content() abort
  let md = []
  if s:prs == []
    let s:prs =s:get_list_of_PRs() 
  endif
  let md = md + SpaceVim#dev#releases#parser_prs(s:prs, s:lang)
  return md
endfunction
