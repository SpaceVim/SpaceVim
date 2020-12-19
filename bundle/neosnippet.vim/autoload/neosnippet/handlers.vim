"=============================================================================
" FILE: handlers.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#handlers#_cursor_moved() abort
  let expand_stack = neosnippet#variables#expand_stack()

  " Get patterns and count.
  if !&l:modifiable || !&l:modified
        \ || empty(expand_stack)
    return
  endif

  let expand_info = expand_stack[-1]
  if expand_info.begin_line == expand_info.end_line
        \ && line('.') != expand_info.begin_line
    call neosnippet#view#_clear_markers(expand_info)
  endif
endfunction

function! neosnippet#handlers#_all_clear_markers() abort
  if !&l:modifiable
    return
  endif

  let pos = getpos('.')

  try
    while !empty(neosnippet#variables#expand_stack())
      call neosnippet#view#_clear_markers(
            \ neosnippet#variables#expand_stack()[-1])
      stopinsert
    endwhile
  finally
    call setpos('.', pos)
  endtry
endfunction
