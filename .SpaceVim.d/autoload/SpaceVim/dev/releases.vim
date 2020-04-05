"=============================================================================
" releases.vim --- release script for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

" 2017-08-05 v0.4.0 is released at https://github.com/SpaceVim/SpaceVim/pull/768
" 2017-11-16 v0.5.0 is released at https://github.com/SpaceVim/SpaceVim/pull/966
" v0.6.0 is released at https://github.com/SpaceVim/SpaceVim/pull/1205
" v0.7.0 is released at https://github.com/SpaceVim/SpaceVim/pull/1610
" v0.8.0 is released at https://github.com/SpaceVim/SpaceVim/pull/1841
" 2018-09-26 v0.9.0 is released at https://github.com/SpaceVim/SpaceVim/pull/2203
" 2018-12-25 v1.0.0 is released at https://github.com/SpaceVim/SpaceVim/pull/2377
" 2019-04-08 v1.1.0 is released at https://github.com/SpaceVim/SpaceVim/pull/2726
" 2019-07-17 v1.2.0 is released at https://github.com/SpaceVim/SpaceVim/pull/2947

" these options can be changed when going to release new tag
let s:last_release_number = 3432
" 这是所有 ID 小于上一次 release ID，并且还未被合并的 ID，在新的release
" 之后，需要把已经合并了的删除！
let s:unmerged_prs_since_last_release = [2014, 2232, 2242, 2307,
      \ 2396, 2407, 2447, 2627, 2655, 2664, 2792, 2819, 2825, 2861, 2868, 2906, 2910, 2927, 2984, 3004, 3064, 3076,
      \ 3083, 3092, 3107, 3170, 3195, 3260, 3271, 3290, 3300, 3318, 3340, 3371, 3379
      \ ]
" 当要新建一个 release 时，修改为该release 的ID，通常为 -1。
let s:current_release_number = -1
" this is a list of pull request number which > last_release_number and <
" current_release_number
" next time when I release v1.1.0, only need to update following option
let s:unmerged_prs_since_current_release = []

" the logic should be from last_release_number to current_release_number,
" include prs in unmerged_prs_since_last_release which is merged.
" exclude prs in unmerged_prs_since_current_release

function! SpaceVim#dev#releases#get_unmerged_prs() abort
  return deepcopy(s:unmerged_prs_since_last_release)
endfunction

function! SpaceVim#dev#releases#last_release_number() abort
  return s:last_release_number
endfunction

function! SpaceVim#dev#releases#current_release_number() abort
  return s:current_release_number > 0 ? s:current_release_number : 999999
endfunction

function! SpaceVim#dev#releases#unmerged_prs_since_current_release() abort
return  s:unmerged_prs_since_current_release
endfunction

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
  for i in range(1, 20)
    let issues = s:list_closed_prs('SpaceVim','SpaceVim', i)
    call extend(prs,
          \ filter(issues,
          \ "v:val['number'] > "
          \ . s:last_release_number
          \ . " && v:val['number'] < "
          \ . s:current_release_number
          \ . " && index(s:unmerged_prs_since_current_release, v:val['number']) == -1 "
          \ ))
    " remove
    " !empty(get(v:val, 'merged_at', ''))
    " @ todo add a way to check if the pr is merged
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
let s:prs = []
function! SpaceVim#dev#releases#content() abort
  let md = [
        \ '### SpaceVim release ' . g:spacevim_version
        \ ]
  if s:prs == []
    let s:prs =s:get_list_of_PRs() 
  endif
  let md = md + SpaceVim#dev#releases#parser_prs(s:prs, 'en')
  return join(md, "\n")
endfunction

" this function is to generate markdown form pull request list
function! SpaceVim#dev#releases#parser_prs(prs, ...) abort
  let is_cn = get(a:000, 0, '') ==# 'cn'
  let g:is_cn = is_cn
  let md = []
  let adds = []
  let changes = []
  let fixs = []
  let others = []
  for pr in a:prs
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
    call add(md, is_cn ? '#### 新特性' : '#### New Features')
    call add(md, '')
    call extend(md, adds)
    call add(md, '')
  endif
  if !empty(changes)
    call add(md, '')
    call add(md, is_cn ? '#### 改变' : '#### Feature Changes')
    call add(md, '')
    call extend(md, changes)
    call add(md, '')
  endif
  if !empty(fixs)
    call add(md, '')
    call add(md, is_cn ? '#### 问题修复' : '#### Bug Fixs')
    call add(md, '')
    call extend(md, fixs)
    call add(md, '')
  endif
  if !empty(others)
    call add(md, '')
    call add(md, is_cn ? '#### 未知' : '#### Unmarked PRs')
    call add(md, '')
    call extend(md, others)
    call add(md, '')
  endif
  return md
endfunction
