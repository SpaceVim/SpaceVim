" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Version control

let g:JavaComplete_ServerCompatibilityVersion = "2.4.1"

function! javacomplete#version#GetCompatibilityVerison()
  return g:JavaComplete_ServerCompatibilityVersion
endfunction

function! javacomplete#version#CompareVersions(scriptVersion, serverVersion)
  let scriptVersion = split(a:scriptVersion, '\.')
  let serverVersion = split(a:serverVersion, '\.')
  while len(scriptVersion) < len(serverVersion)
    call add(scriptVersion, '0')
  endwhile
  while len(serverVersion) < len(scriptVersion)
    call add(serverVersion, '0')
  endwhile
  let i = 0
  while i < len(scriptVersion)
    if i < len(serverVersion)
      if str2nr(scriptVersion[i]) < str2nr(serverVersion[i])
        return -1
      elseif str2nr(scriptVersion[i]) > str2nr(serverVersion[i])
        return 1
      endif
    else
      return 1
    endif
    let i += 1
  endwhile
  return 0
endfunction

function! javacomplete#version#CheckServerCompatibility(serverVersion)
  return 
        \ javacomplete#version#CompareVersions(
            \ g:JavaComplete_ServerCompatibilityVersion, 
            \ a:serverVersion) <= 0
endfunction

" vim:set fdm=marker sw=2 nowrap:
