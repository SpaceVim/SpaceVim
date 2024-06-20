"=============================================================================
" gitcommit.vim --- omni plugin for git commit
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:list = SpaceVim#api#import('data#list')

let s:pr_kind = g:spacevim_gitcommit_pr_icon
let s:issue_kind = g:spacevim_gitcommit_issue_icon
let s:cache = {}
let s:pr_cache = {}

let s:github_cache = {}

let s:commit_types = [
      \ {
        \ 'word' : 'feat',
        \ 'menu' : 'A new feature'
        \ },
      \ {
        \ 'word' : 'fix',
        \ 'menu' : 'A bug fix'
        \ },
      \ {
        \ 'word' : 'docs',
        \ 'menu' : 'Documentation only changes'
        \ },
      \ {
        \ 'word' : 'style',
        \ 'menu' : 'Changes that do not affect the meaning of the code'
        \ },
      \ {
        \ 'word' : 'refactor',
        \ 'menu' : 'A code change that neither fixes a bug nor adds a feature'
        \ },
      \ {
        \ 'word' : 'perf',
        \ 'menu' : 'A code change that improves performance'
        \ },
      \ {
        \ 'word' : 'test',
        \ 'menu' : 'Adding missing tests or correcting existing tests'
        \ },
      \ {
        \ 'word' : 'build',
        \ 'menu' : 'Changes that affect the build system or external dependencies'
        \ },
      \ {
        \ 'word' : 'ci',
        \ 'menu' : 'Changes to our CI configuration files and scripts'
        \ },
      \ {
        \ 'word' : 'chore',
        \ 'menu' : 'Other changes that do not modify src or test files'
        \ },
      \ {
        \ 'word' : 'revert',
        \ 'menu' : 'Reverts a previous commit'
        \ },
      \ ]


" https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors
" https://stackoverflow.com/questions/58525836/git-magic-keywords-in-commit-messages-signed-off-by-co-authored-by-fixes
" https://www.reddit.com/r/git/comments/13d565i/git_trailers_what_are_they_for/
" https://alchemists.io/articles/git_trailers
" https://git-scm.com/docs/git-interpret-trailers
" https://gitlab.com/gitlab-org/gitlab-foss/-/issues/31640
" https://archive.kernel.org/oldwiki/git.wiki.kernel.org/index.php/CommitMessageConventions.html
let s:git_trailers = [
      \ {
      \   'word' : 'Co-Authored-By:',
      \   'menu' : 'multiple commit author'
      \ },
      \ ]

function! s:find_last_branch() abort
  let reflog = systemlist('git reflog')
  for log in reflog
    " e059b76ca HEAD@{15}: checkout: moving from doc-help to master
    if log =~# 'HEAD@{\d\+}: checkout: '
      return matchstr(log, 'HEAD@{\d\+}: checkout: moving from \zs\S*')
    endif
  endfor
  return ''
endfunction

function! s:generate_co_author() abort
  let last_branch = s:find_last_branch()
  call SpaceVim#logger#info('last branch:' . last_branch)
  return s:list.uniq(systemlist('git log -n 5 --format="%aN <%aE>" ' . last_branch))
endfunction

function! SpaceVim#plugins#gitcommit#complete(findstart, base) abort
  if a:findstart
    let s:complete_ol = 0
    let s:complete_type = 0
    let s:complete_trailers = 0
    let s:complete_co_author = 0
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] !=# ' ' && line[start - 1] !=# '#' && line[start - 1] !=# ':'
      let start -= 1
    endwhile
    if line[start - 1] ==# '#'
      let s:complete_ol = 1
    elseif line('.') ==# 1 && start ==# 0
      let s:complete_type = 1
    elseif line('.') !=# 1 && start ==# 0
      let s:complete_trailers = 1
    elseif getline('.') =~# '^Co-Authored-By:' && start >= 14
      let s:complete_co_author = 1
    endif
    return start
  else
    if s:complete_ol == 1
      return s:complete_pr(a:base)
    elseif s:complete_type == 1
      return s:complete('types')
    elseif s:complete_trailers == 1
      return s:complete('trailers')
    elseif s:complete_co_author == 1
      return s:complete('co-author')
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

function! s:complete(what) abort
  if a:what ==# 'types'
    return s:commit_types
  elseif a:what ==# 'trailers'
    return s:git_trailers
  elseif a:what ==# 'co-author'
    return s:generate_co_author()
  else
    return []
  endif
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
    let repo_home = s:find_repo_home(expand('%:p'))
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
fu! s:find_repo_home(path) abort " {{{2
  if filereadable(a:path)
    let where = fnamemodify(a:path, ':p:h')
  elseif isdirectory(a:path)
    let where = a:path
  else
    let where = getcwd()
  endif
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let dir = finddir('.git', escape(where, ' ') . ';')
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


function! Test(str) abort
  exe a:str
endfunction
