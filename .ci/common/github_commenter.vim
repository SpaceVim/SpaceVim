set nocp
set rtp+=build/GitHub.vim
so build/GitHub.vim/plugin/github.vim
let log = system('cat build_log')
if !empty(log)
  let comments = github#api#issues#List_comments('SpaceVim', 'SpaceVim',$TRAVIS_PULL_REQUEST ,'')
  if empty(comments)
    call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': log}, 'SpaceVimBot', $BOTSECET)
  else
    let nr = 0
    for comment in comments
      if comment.user.login == 'SpaceVimBot'
        let nr = comment.id
      endif
    endfor
    if nr == 0
      call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': log}, 'SpaceVimBot', $BOTSECET)
    else
      call github#api#issues#Edit_comment('SpaceVim','SpaceVim', nr, {'body': log}, 'SpaceVimBot', $BOTSECET)
    endif
  endif
endif
