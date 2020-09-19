if exists('*defx#redraw')
  augroup defx_git
    autocmd!
    autocmd BufWritePost * call defx#redraw()
  augroup END
endif

scriptencoding utf-8
if exists('b:defx_git_loaded')
  finish
endif

let b:defx_git_loaded = 1

function! s:search(dir) abort
  let l:icons = get(g:, 'defx_git_indicators', {})
  let l:icons_pattern = join(values(l:icons), '\|')

  if !empty(l:icons_pattern)
    let l:direction = a:dir > 0 ? 'w' : 'bw'
    return search(printf('\(%s\)', l:icons_pattern), l:direction)
  endif
endfunction

function! s:git_cmd(cmd) abort
  let l:actions = {
        \ 'stage': '!git add',
        \ 'reset': '!git reset',
        \ 'discard': '!git checkout --'
        \ }
  let l:candidate = defx#get_candidate()
  let l:path = get(l:candidate, 'action__path')
  let l:word = get(l:candidate, 'word')
  let l:is_dir = get(l:candidate, 'is_directory')
  if empty(l:path)
    return
  endif

  let l:cmd = l:actions[a:cmd].' '.l:path
  if a:cmd !=? 'discard'
    call execute(l:cmd)
    return defx#call_action('redraw')
  endif

  let l:choice = confirm('Are you sure you want to discard all changes to '.l:word.'? ', "&Yes\n&No")
  if l:choice !=? 1
    return
  endif
  let l:status = system('git status --porcelain '.l:path)
  " File must be unstaged before discarding
  if !empty(l:status[0])
    call execute(l:actions['reset'].' '.l:path)
  endif

  call execute(l:cmd)
  return defx#call_action('redraw')
endfunction

nnoremap <buffer><silent><Plug>(defx-git-next) :<C-u>call <sid>search(1)<CR>
nnoremap <buffer><silent><Plug>(defx-git-prev) :<C-u>call <sid>search(-1)<CR>
nnoremap <buffer><silent><Plug>(defx-git-stage) :<C-u>call <sid>git_cmd('stage')<CR>
nnoremap <buffer><silent><Plug>(defx-git-reset) :<C-u>call <sid>git_cmd('reset')<CR>
nnoremap <buffer><silent><Plug>(defx-git-discard) :<C-u>call <sid>git_cmd('discard')<CR>

if !hasmapto('<Plug>(defx-git-prev)') && maparg('[c', 'n') ==? ''
  silent! nmap <buffer><unique><silent> [c <Plug>(defx-git-prev)
endif

if !hasmapto('<Plug>(defx-git-next)') && maparg(']c', 'n') ==? ''
  silent! nmap <buffer><unique><silent> ]c <Plug>(defx-git-next)
endif

if !hasmapto('<Plug>(defx-git-stage)') && maparg(']a', 'n') ==? ''
  silent! nmap <buffer><unique><silent> ]a <Plug>(defx-git-stage)
endif

if !hasmapto('<Plug>(defx-git-reset)') && maparg(']r', 'n') ==? ''
  silent! nmap <buffer><unique><silent> ]r <Plug>(defx-git-reset)
endif

if !hasmapto('<Plug>(defx-git-discard)') && maparg(']d', 'n') ==? ''
  silent! nmap <buffer><unique><silent> ]d <Plug>(defx-git-discard)
endif
