

function! SpaceVim#dev#help#content#parser(profile, dir) abort
  let head = [
        \ '*' . a:profile.name . '*',
        \ ] + split(a:profile.description, "\n")
        \ +
        \ [
        \ a:profile.author . repeat(' ', 72 - strdisplaywidth(a:profile.author . a:profile.name )) . '*' . a:profile.name  . '*'
        \ ]
  return head
endfunction

