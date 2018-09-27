"=============================================================================
" releases.vim --- release script for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" v0.4.0 is released at https://github.com/SpaceVim/SpaceVim/pull/768
" v0.5.0 is released at https://github.com/SpaceVim/SpaceVim/pull/966
" v0.6.0 is released at https://github.com/SpaceVim/SpaceVim/pull/1205
" v0.7.0 is released at https://github.com/SpaceVim/SpaceVim/pull/1610
" v0.8.0 is released at https://github.com/SpaceVim/SpaceVim/pull/1841

" this option can only be changed after release
let s:unmerged_prs_since_last_release = [1306, 1697, 1725, 1777, 1786, 1802, 1833, 1838]
" these options can be changed when going to release new tag
let s:last_release_number = 1841
let s:current_release_number = 2203
let s:unmerged_prs_since_current_release = [1926, 1963, 1977, 1993, 2004, 2014, 2016, 2056, 2092, 2101, 2131, 2150, 2155, 2164, 2165, 2190]

" the logic should be from last_release_number to current_release_number,
" include prs in unmerged_prs_since_last_release which is merged.
" exclude prs in unmerged_prs_since_current_release

function! s:body() abort
  return 'SpaceVim development (pre-release:' . g:spacevim_version . ') build.'
endfunction
function! SpaceVim#dev#releases#open() abort
  let username = input('github username:')
  let password = input('github password:')
  let is_dev = g:spacevim_version =~# 'dev'
  let releases = {
        \ 'tag_name': (is_dev ? 'nightly' : g:spacevim_version),
        \ 'target_commitish': 'master',
        \ 'name': (is_dev ? 'nightly' : 'SpaceVim v' . g:spacevim_version),
        \ 'body': (is_dev ? s:body() : SpaceVim#dev#releases#content()),
        \ 'draft': v:false,
        \ 'prerelease': (is_dev ? v:true : v:false)
        \ }
  let response = github#api#repos#releases#Create('SpaceVim', 'SpaceVim',
        \ username, password, releases)
  if !empty(response)
    echomsg 'releases successed! ' . response.url
  else
    echom 'releases failed!'
  endif
endfunction

function! s:list_closed_prs(owner, repo, page) abort
  return github#api#util#Get('repos/' . a:owner . '/' . a:repo . '/issues?state=closed&page=' . a:page , [])
endfunction

function! s:get_list_of_PRs() abort
  let prs = []
  for i in range(1, 10)
    let issues = s:list_closed_prs('SpaceVim','SpaceVim', i)
    call extend(prs,
          \ filter(issues,
          \ "v:val['number'] > "
          \ . s:last_release_number
          \ . " && v:val['number'] < "
          \ . s:current_release_number
          \ . " && index(s:unmerged_prs_since_current_release, v:val['number']) == -1 "
          \ ))
  endfor
  for i in s:unmerged_prs_since_last_release
    let pr = github#api#issues#Get_issue('SpaceVim', 'SpaceVim', i)
    if get(pr, 'state', '') ==# 'closed'
      call add(prs, pr)
    endif
  endfor
  return filter(prs, "has_key(v:val, 'pull_request')")
endfunction

function! s:pr_to_list(pr) abort
  return '- ' . a:pr.title . ' [#' . a:pr.number . '](' . a:pr.html_url . ')'
endfunction
let g:wsd = []
function! SpaceVim#dev#releases#content() abort
  let md = [
        \ '### SpaceVim release ' . g:spacevim_version
        \ ]
  let adds = []
  let changes = []
  let fixs = []
  let others = []
  if g:wsd == []
    let g:wsd =s:get_list_of_PRs() 
  endif
  for pr in g:wsd
    if pr.title =~? '^ADD'
      call add(adds, s:pr_to_list(pr))
    elseif pr.title =~? '^CHANGE'
      call add(changes, s:pr_to_list(pr))
    elseif pr.title =~? '^FIX'
      call add(fixs, s:pr_to_list(pr))
    else
      call add(others, s:pr_to_list(pr))
    endif
  endfor
  if !empty(adds)
    call add(md, '')
    call add(md, '#### New Features')
    call add(md, '')
    call extend(md, adds)
    call add(md, '')
  endif
  if !empty(changes)
    call add(md, '')
    call add(md, '#### Feature Changes')
    call add(md, '')
    call extend(md, changes)
    call add(md, '')
  endif
  if !empty(fixs)
    call add(md, '')
    call add(md, '#### Bug Fixs')
    call add(md, '')
    call extend(md, fixs)
    call add(md, '')
  endif
  if !empty(others)
    call add(md, '')
    call add(md, '#### Unmarked PRs')
    call add(md, '')
    call extend(md, others)
    call add(md, '')
  endif
  return join(md, "\n")

endfunction
