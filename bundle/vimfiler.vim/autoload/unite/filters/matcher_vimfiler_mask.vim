"=============================================================================
" FILE: matcher_vimfiler_mask.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#filters#matcher_vimfiler_mask#define() abort
  return s:matcher
endfunction

let s:matcher = {
      \ 'name' : 'matcher_vimfiler/mask',
      \ 'description' : 'vimfiler mask matcher',
      \}

function! s:matcher.filter(candidates, context) abort
  if a:context.input == ''
    return a:candidates
  endif

  let candidates = filter(copy(a:candidates),
        \ "v:val.vimfiler__is_directory")
  let input = a:context.input
  if &ignorecase
    let input = tolower(input)
  endif
  let masks = map(split(input, '\\\@<! '),
          \ 'substitute(v:val, "\\\\ ", " ", "g")')
  for candidate in filter(copy(a:candidates),
        \ "!v:val.vimfiler__is_directory")
    let matched = 0
    for mask in masks
      if mask =~ '^!'
        if mask == '!'
          continue
        endif

        " Exclusion.
        let mask = unite#util#escape_match(mask)
        if candidate.vimfiler__abbr !~ mask
          let matched = 1
          break
        endif
      elseif mask =~ '\\\@<!\*'
        " Wildcard.
        let mask = unite#util#escape_match(mask)
        if candidate.vimfiler__abbr =~ mask
          let matched = 1
          break
        endif
      else
        let mask = substitute(mask, '\\\(.\)', '\1', 'g')
        if stridx((&ignorecase ?
              \ tolower(candidate.vimfiler__abbr) :
              \ candidate.vimfiler__abbr), mask) != -1
          let matched = 1
          break
        endif
      endif
    endfor

    if matched
      call add(candidates, candidate)
    endif
  endfor

  return candidates
endfunction
