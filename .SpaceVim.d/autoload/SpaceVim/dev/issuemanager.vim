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
  let b:current_issue = issue
  call setline(1, map(content, "substitute(v:val, '$', '', 'g')"))
  augroup spacevim_dev_issuemanager
    autocmd!
    autocmd BufWritePost <buffer> call <SID>update_issue()
  augroup END
endfunction


function! s:update_issue() abort
  let issue = get(b:, 'current_issue', {})
  if !empty(issue)
    let new = {'title' : issue.title,
          \ 'body' : join(getline(1, '$'), "\n")}
    redraw
    call inputsave()
    let username = input('github username:')
    let password = input('github password:')
    call inputrestore()
    let respons = github#api#issues#Edit('SpaceVim', 'SpaceVim', issue.number, username, password, new)
    normal! :
    if !empty(respons) && get(respons, 'number', 0) == issue.number
      echon 'Issue ' . issue.number . ' has been updated!'
    elseif !empty(respons)
      let msg = get(respons, 'message', '')
      echon 'Failed to update issue ' . issue.number . ':' . msg
    endif
  endif
endfunction
