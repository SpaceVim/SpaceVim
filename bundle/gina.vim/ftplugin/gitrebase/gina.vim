if get(g:, 'gina_gitrebase_support_mappings', 1) is# 0
  finish
endif

let s:COMMANDS = [
      \ 'p', 'pick',
      \ 'r', 'reword',
      \ 'e', 'edit',
      \ 's', 'squash',
      \ 'f', 'fixup',
      \ 'x', 'exec',
      \ 'd', 'drop',
      \]

function! s:find_commit() abort
  let line = getline('.')
  let prefix = printf('^\%%(%s\)', join(s:COMMANDS, '\|'))
  if line !~# prefix
    return
  endif
  return matchstr(line, prefix . ' \zs[0-9a-fA-F]\+')
endfunction

function! s:open_commit() abort
  let commit = s:find_commit()
  if empty(commit)
    return
  endif
  execute printf('Gina show --group=commit-preview --opener=vsplit +wincmd\ p %s', commit)
endfunction

function! s:open_changes() abort
  let commit = s:find_commit()
  if empty(commit)
    return
  endif
  execute printf('Gina changes --group=commit-preview --opener=vsplit +wincmd\ p %s', commit)
endfunction

function! s:round_command(value) abort
  let command = matchstr(getline('.'), '^\w\+')
  let index = index(s:COMMANDS, command)
  if index is# -1
    return
  endif
  let new_index = (index + a:value) % len(s:COMMANDS)
  execute printf('s/^%s/%s/', command, s:COMMANDS[new_index])
endfunction

nnoremap <buffer><silent> <Plug>(gina-rebase-open) :<C-u>call <SID>open_commit()<CR>
nnoremap <buffer><silent> <Plug>(gina-rebase-changes) :<C-u>call <SID>open_changes()<CR>
nnoremap <buffer><silent> <Plug>(gina-rebase-round-up) :<C-u>call <SID>round_command(2)<CR>
nnoremap <buffer><silent> <Plug>(gina-rebase-round-down) :<C-u>call <SID>round_command(-2)<CR>

nmap <buffer> <CR>  <Plug>(gina-rebase-open)
nmap <buffer> g<CR> <Plug>(gina-rebase-changes)
nmap <buffer> <C-a> <Plug>(gina-rebase-round-up)
nmap <buffer> <C-z> <Plug>(gina-rebase-round-down)
