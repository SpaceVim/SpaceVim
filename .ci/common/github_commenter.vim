set nocp
set rtp+=build/GitHub.vim
so build/GitHub.vim/plugin/github.vim
function! s:update_comment() abort
  let log = system('cat build_log')
  if !empty(log)
    let summary = $LINT . ' build log'
    let log = "<details><summary>" . summary . "</summary>" . log . "</details>"
    let comments = github#api#issues#List_comments('SpaceVim', 'SpaceVim',$TRAVIS_PULL_REQUEST ,'')
    if empty(comments)
      call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': log}, 'SpaceVimBot', $BOTSECRET)
    else
      let nr = 0
      for comment in comments
        if comment.user.login == 'SpaceVimBot'
          let nr = comment.id
        endif
      endfor
      if nr == 0
        call github#api#issues#Create_comment('SpaceVim','SpaceVim', $TRAVIS_PULL_REQUEST, {'body': log}, 'SpaceVimBot', $BOTSECRET)
      else
        call github#api#issues#Edit_comment('SpaceVim','SpaceVim', nr, {'body': log}, 'SpaceVimBot', $BOTSECRET)
      endif
    endif
  endif
endfunction
call s:update_comment()
quit
