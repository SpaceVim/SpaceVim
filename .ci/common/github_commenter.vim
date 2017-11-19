exe 'set nocp'
set rtp+=build/GitHub.vim
so build/GitHub.vim/plugin/github.vim
so build/GitHub.vim/autoload/github/api/issues.vim
so build/GitHub.vim/autoload/github/api/util.vim
let s:log = system('cat build_log')
if !empty(s:log)
  let s:summary = $LINT . ' build log'
  let s:log = '<details><summary>' . s:summary . '</summary>' . s:log . '</details>'
  let s:comments = github#api#issues#List_comments('SpaceVim', 'SpaceVim',$TRAVIS_PULL_REQUEST ,'')
  if empty(s:comments)
    call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': s:log}, 'SpaceVimBot', $BOTSECRET)
  else
    let s:nr = 0
    for s:comment in s:comments
      if s:comment.user.login ==# 'SpaceVimBot'
        let s:nr = s:comment.id
      endif
    endfor
    if s:nr == 0
      call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': s:log}, 'SpaceVimBot', $BOTSECRET)
    else
      call github#api#issues#Edit_comment('SpaceVim','SpaceVim', s:nr, {'body': s:log}, 'SpaceVimBot', $BOTSECRET)
    endif
  endif
endif
quit
