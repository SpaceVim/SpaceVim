function! SpaceVim#issue#report() abort
  call s:open()
endfunction

function! s:open() abort
  exe 'tabnew ' . tempname() . '/issue_report.md'
  let b:spacevim_issue_template = 1
  call setline(1, s:template())
  w
endfunction


function! s:template() abort
  let info = [
        \ '<!-- please remove the issue template when request for a feature -->',
        \ '## Expected behavior, english is recommend',
        \ '',
        \ '## Environment Information',
        \ '',
        \ '- OS:' . SpaceVim#api#import('system').name(),
        \ '- vim version:' . (has('nvim') ? '' : v:version),
        \ '- neovim version:' . (has('nvim') ? v:version : ''),
        \ '',
        \ '## The reproduce ways from Vim starting (Required!)',
        \ '',
        \ '## Output of the `:SPDebugInfo!`',
        \ '']
        \ + split(SpaceVim#api#import('vim#compatible').execute(':SPDebugInfo'), "\n") +
        \ [
        \ '## Screenshots',
        \ '',
        \ 'If you have any screenshots for this issue please upload here. BTW you can use https://asciinema.org/ for recording video  in terminal.'
        \ ]
  return info
endfunction



function! SpaceVim#issue#new()
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
