" Vim completion script for java
" Maintainer: artur shaik <ashaihullin@gmail.com>
"
" Work with attention highlights

let s:matchesCount = 0
let s:signId = 271992
sign define jc2signparseproblem text=->

function! s:Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call javacomplete#logger#Log("[highlights] ". log)
endfunction

function! javacomplete#highlights#Drop()
  if s:matchesCount > 0 && !empty(getmatches())
      lclose
      exe "sign unplace * file=". expand("%:p")
      call clearmatches()
      call setloclist(0, [], 'f')
      let s:matchesCount = len(getmatches())
  endif
endfunction

function! javacomplete#highlights#ShowProblems(problems)
  let loclist = []
  let matchposlist = []
  for problem in a:problems
    call extend(loclist,[{
          \ 'bufnr':bufnr('%'),
          \ 'lnum': problem['lnum'],
          \ 'col': problem['col'],
          \ 'text': problem['message']}])
    call add(matchposlist,[problem['lnum'], problem['col']])
    exe ":sign place ".s:signId." line=".problem['lnum'].
                \ " name=jc2signparseproblem file=" . expand("%:p")
  endfor
  if !empty(matchposlist)
      let s:matchesCount = len(matchposlist)
      call setloclist(0, loclist, 'r')
      call matchaddpos("SpellBad", matchposlist)
      lopen
  endif
endfunction
