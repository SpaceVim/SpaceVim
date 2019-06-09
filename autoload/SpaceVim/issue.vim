"=============================================================================
" issue.vim --- issue reporter for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:CMP = SpaceVim#api#import('vim#compatible')

function! SpaceVim#issue#report() abort
  call s:open()
endfunction

function! s:open() abort
  exe 'silent tabnew ' . tempname() . '/issue_report.md'
  let b:spacevim_issue_template = 1
  let template = s:template()
  call setline(1, template)
  let @+ = join(template, "\n")
  silent w
endfunction

function! s:spacevim_status() abort
  let pwd = getcwd()
  try
    exe 'cd ' . fnamemodify(g:_spacevim_root_dir, ':p:h')
    let status = s:CMP.systemlist('git status')
  catch
    exe 'cd ~/.SpaceVim'
    let status = s:CMP.systemlist('git status')
  endtry
  exe 'cd ' . pwd
  if type(status) == 3
    return status
  else
    return [status]
  endif
endfunction

function! s:template() abort
  let info = [
        \ '<!-- please remove the issue template when request for a feature -->',
        \ '## Expected behavior, english is recommend',
        \ '',
        \ '## Environment Information',
        \ '',
        \ '- OS: ' . SpaceVim#api#import('system').name,
        \ '- vim version: ' . (has('nvim') ? '-' : s:CMP.version()),
        \ '- neovim version: ' . (has('nvim') ? s:CMP.version() : '-'),
        \ '- SpaceVim version: ' . g:spacevim_version,
        \ '- SpaceVim status: ',
        \ '',
        \ '```'
        \ ]
  let info = info + s:spacevim_status()
  let info = info + [
        \ '```',
        \ '',
        \ '## The reproduce ways from Vim starting (Required!)',
        \ '',
        \ '## Output of the `:SPDebugInfo!`',
        \ '']
        \ + split(s:CMP.execute(':SPDebugInfo'), "\n") +
        \ [
        \ '## Screenshots',
        \ '',
        \ 'If you have any screenshots for this issue please upload here. BTW you can use https://asciinema.org/ for recording video  in terminal.'
        \ ]
  return info
endfunction



function! SpaceVim#issue#new() abort
  if get(b:, 'spacevim_issue_template', 0) == 1
    let title = input('Issue title:')
    let username = input('github username:')
    let password = input('github password:')
    let issue = {'title' : title,
          \ 'body' : join(getline(1, '$'), "\n"),
          \ }
    let response = github#api#issues#Create('SpaceVim', 'SpaceVim', username, password, issue)
    if has_key(response, 'html_url')
      echo 'Issue created done: ' . response.html_url
    else
      echo 'Failed to create issue, please check the username and password'
    endif
  endif
endfunction


function! SpaceVim#issue#reopen(id) abort
  let issue = {
        \ 'state' : 'open'
        \ }
    let username = input('github username:')
    let password = input('github password:')
  call github#api#issues#Edit('SpaceVim', 'SpaceVim', a:id, username, password, issue)
endfunction

function! SpaceVim#issue#close(id) abort
  let issue = {
        \ 'state' : 'closed'
        \ }
    let username = input('github username:')
    let password = input('github password:')
  call github#api#issues#Edit('SpaceVim', 'SpaceVim', a:id, username, password, issue)
endfunction
