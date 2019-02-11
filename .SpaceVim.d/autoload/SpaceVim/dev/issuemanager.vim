"=============================================================================
" issuemanager.vim --- issue manager for SpaceVim development
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#dev#issuemanager#edit(id) abort
  let issue = github#api#issues#Get_issue('SpaceVim', 'SpaceVim', a:id)
  exe 'silent tabnew ++ff=unix ' . tempname() . '/issue_' . a:id . '.md'
  let content = split(issue.body, "\n")
  call setline(1, map(content, "substitute(v:val, '$', '', 'g')"))
endfunction
