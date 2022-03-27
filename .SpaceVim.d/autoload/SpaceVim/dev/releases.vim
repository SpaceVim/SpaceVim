"=============================================================================
" releases.vim --- release script for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:log_pretty = 'tformat:%h%- %s'

function! s:get_logs() abort
  let cmd = ['git', 'log', '--graph', '--date=relative', '--pretty=' . s:log_pretty] + ['v1.8.0..HEAD'] 
  return systemlist(cmd)
endfunction

function! Tget() abort
  return s:get_logs()
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

function! SpaceVim#dev#releases#content() abort
  let md = [
        \ '### SpaceVim release ' . g:spacevim_version
        \ ]
  let md = md + SpaceVim#dev#releases#parser_prs(s:get_logs(), 'en')
  return join(md, "\n")
endfunction

function! SpaceVim#dev#releases#parser_prs(...) abort
  let is_cn = get(a:000, 0, '') ==# 'cn'
  let feat = []
  let fix = []
  let docs = []
  let doc = []
  let style = []
  let refactor = []
  let pref = []
  let test = []
  let build = []
  let ci = []
  let chore = []
  let revert = []
  for log in s:get_logs()
    let type = matchstr(log, '^\*\s\+\S*\s\zs[a-z]*')
    try
      exe printf('call add(%s, "%s")', type, log)
    catch
    endtry
  endfor
  let md = []
  call add(md, is_cn ? '#### 新特性' : '#### New Features')
  let md = md + feat
  call add(md, is_cn ? '#### 问题修复' : '#### Bug Fixs')
  let md = md + fix
"
" -  if !empty(adds)
" -    call add(md, '')
" -    call add(md, '')
" -    call extend(md, adds)
" -    call add(md, '')
" -  endif
" -  if !empty(changes)
" -    call add(md, '')
" -    call add(md, is_cn ? '#### 改变' : '#### Feature Changes')
" -    call add(md, '')
" -    call extend(md, changes)
" -    call add(md, '')
" -  endif
" -  if !empty(fixs)
" -    call add(md, '')
" -    call add(md, '')
" -    call extend(md, fixs)
" -    call add(md, '')
" -  endif
" -  if !empty(others)
" -    call add(md, '')
" -    call add(md, is_cn ? '#### 未知' : '#### Unmarked PRs')
" -    call add(md, '')
" -    call extend(md, others)
" -    call add(md, '')
" -  endif
 return md
  
endfunction
