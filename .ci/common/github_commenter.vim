exe 'set nocp'
set rtp+=/build/GitHub.vim
set rtp+=/API
so /build/GitHub.vim/plugin/github.vim
let s:LIST = SpaceVim#api#import('data#list')
let s:log = filereadable('build_log') ? system('cat build_log') : ''
let g:githubapi_verbose = 1
function! s:update_log(log, summary, new_log) abort
  let log = split(a:log, "\n")
  let begin = -1
  let end = -1
  for i in range(len(log))
    if log[i] =~ a:summary
      let begin = i
    endif
    if begin != -1 && log[i] ==# '</details>'
      let end = i
    endif
  endfor
  if begin != -1 && end != -1
    return s:LIST.replace(log, begin, end, split(a:new_log, "\n"))
  else
    return a:log . "\n" . a:new_log
  endif

endfunction
if !empty(s:log)
  if $LINT ==# 'vader'
    let s:summary = $VIM . ' ' . $LINT . ' build log'
  else
    let s:summary = $LINT . ' build log'
  endif
  let s:log = '<details><summary>' . s:summary . "</summary>\n" . s:log . "\n</details>"
  let s:comments = github#api#issues#List_comments('SpaceVim', 'SpaceVim',$TRAVIS_PULL_REQUEST ,'')
  if empty(s:comments)
    call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': s:log}, 'SpaceVimBot', $BOTSECRET)
  else
    let s:nr = 0
    for s:comment in s:comments
      if s:comment.user.login ==# 'SpaceVimBot'
        let s:nr = s:comment.id
        break
      endif
    endfor
    if s:nr == 0
      call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': s:log}, 'SpaceVimBot', $BOTSECRET)
    else
      call github#api#issues#Edit_comment('SpaceVim','SpaceVim', s:nr,
            \ {'body': s:update_log(s:comment.body, s:summary, s:log)}, 'SpaceVimBot', $BOTSECRET)
    endif
  endif
else
  if $LINT ==# 'vader'
    let s:summary = $VIM . ' ' . $LINT . ' build log'
  else
    let s:summary = $LINT . ' build log'
  endif
  let s:log = '<details><summary>' . s:summary . "</summary>\n" . s:log . "\n</details>"
  let s:comments = github#api#issues#List_comments('SpaceVim', 'SpaceVim',$TRAVIS_PULL_REQUEST ,'')
  if !empty(s:comments)
    let s:nr = 0
    for s:comment in s:comments
      if s:comment.user.login ==# 'SpaceVimBot'
        let s:nr = s:comment.id
        break
      endif
    endfor
    if s:nr != 0
      call github#api#issues#Edit_comment('SpaceVim','SpaceVim', s:nr,
            \ {'body': s:update_log(s:comment.body, s:summary, s:log)}, 'SpaceVimBot', $BOTSECRET)
    endif
  endif
endif
echom v:shell_error
quit
