"=============================================================================
" gitcommit.vim --- omni plugin for git commit
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:pr_kind = g:spacevim_gitcommit_pr_icon
let s:issue_kind = g:spacevim_gitcommit_issue_icon
let s:cache = {}
let s:pr_cache = {}

let s:github_cache = {}


function! SpaceVim#plugins#gitcommit#complete(findstart, base) abort
  if a:findstart
    let s:complete_ol = 0
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] !=# ' ' && line[start - 1] !=# '#'
      let start -= 1
    endwhile
    if line[start - 1] ==# '#'
      let s:complete_ol = 1
    endif
    return start
  else
    if s:complete_ol == 1
      return s:complete_pr(a:base)
    endif
    let res = []
    for m in s:cache_commits()
      if m =~ a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfunction

function! s:cache_commits() abort
  let rst = systemlist("git log --oneline -n 50 --pretty=format:'%h %s' --abbrev-commit")
  return rst
endfunction

function! s:complete_pr(base) abort
  let [user,repo] = s:current_repo()
  let s:user = user
  let s:repo = repo
  if !has_key(s:pr_cache, user . '_' . repo)
    call s:cache_prs(user, repo)
  endif
  let prs = get(s:pr_cache, user . '_' . repo, {})
  let rst = []
  for pr in values(prs)
    let item = {
          \ 'word' : pr.number . '',
          \ 'abbr' : '#' . pr.number,
          \ 'menu' : pr.title,
          \ 'kind' : (has_key(pr, 'pull_request') ? s:pr_kind : s:issue_kind),
          \ }
    if pr.number . pr.title =~? a:base
      call add(rst, item)
    endif
  endfor
  return rst
endfunction

function! s:current_repo() abort
  if executable('git')
    let repo_home = fnamemodify(s:findDirInParent('.git', expand('%:p')), ':p:h:h')
    if repo_home !=# '' || !isdirectory(repo_home)
      let remotes = filter(systemlist('git -C '. repo_home. ' remote -v'),"match(v:val,'^origin') >= 0 && match(v:val,'fetch') > 0")
      if len(remotes) > 0
        let remote = remotes[0]
        if stridx(remote, '@') > -1
          let repo_url = split(split(remote,' ')[0],':')[1]
          let repo_url = strpart(repo_url, 0, len(repo_url) - 4)
        else
          let repo_url = split(remote,' ')[0]
          let repo_url = strpart(repo_url, stridx(repo_url, 'http'),len(repo_url) - 4 - stridx(repo_url, 'http'))
        endif
        let repo = split(repo_url, '/')
        return [repo[-2], repo[-1]]
      endif
    endif
  endif
endfunction
fu! s:findDirInParent(what, where) abort " {{{2
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let dir = finddir(a:what, escape(a:where, ' ') . ';')
  let &suffixesadd = old_suffixesadd
  return dir
endf " }}}2

function! s:cache_prs(user, repo) abort
  " let prs = github#api#issues#List_All_for_Repo(user, repo)
  if !has_key(s:pr_cache, a:user . '_' . a:repo)
    call extend(s:pr_cache, {a:user . '_' . a:repo : {}})
  endif
  call github#api#issues#async_list_opened(a:user, a:repo, function('s:callback'))
endfunction

function! s:callback(data) abort
  call s:list_callback(s:user, s:repo, a:data)
endfunction

" data is a list a PRs in one page
function! s:list_callback(user, repo, data) abort
  for pr in a:data
    if !has_key(s:pr_cache[a:user . '_' . a:repo], pr.number)
      call extend(s:pr_cache[a:user . '_' . a:repo], {pr.number : pr})
    endif
  endfor
endfunction
