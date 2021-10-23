let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#gtags_tree_matcher#define()
  return s:matcher
endfunction

let s:matcher = {
      \ 'name'       : 'gtags_tree_matcher',
      \ 'description': 'matcher for gtags tree',
      \ }

" This function includes partial src in unite-outline
"   https://github.com/h1mesuke/unite-outline
function! s:matcher.filter(candidates, context)
  if empty(a:candidates) || empty(a:context.input)
    return a:candidates
  endif

  let l:patterns = split(a:context.input, '\\\@<! ')
  let l:candidates = copy(a:candidates)

  " Initialize each candidate
  for l:cand in l:candidates
    let l:cand['is_matched'] = 1
  endfor

  for input in split(a:context.input, '\\\@<! ')
    let input = substitute(input, '\\ ', ' ', 'g')
    if input =~ '^!'
      if input == '!'
        continue
      endif
      " Exclusion
      let input = unite#escape_match(input)
      let pred = 'v:val.word !~ ' . string(input[1:])
    elseif input =~ '\\\@<!\*'
      " Wildcard
      let input = unite#escape_match(input)
      let pred = 'v:val.word =~ ' . string(input)
    else
      let input = substitute(input, '\\\(.\)', '\1', 'g')
      let pred = &ignorecase ?
            \ printf('stridx(tolower(v:val.word), %s) != -1', string(tolower(input))) :
            \ printf('stridx(v:val.word, %s) != -1', string(input))
    endif
    if a:context.is_treelized
      call s:mark_tree_matching_candidate(l:candidates, pred)
    else
      call s:mark_normal_matching_candidate(l:candidates, pred)
    endif
  endfor
  return filter(l:candidates, 'v:val.is_matched')
endfunction

function! s:mark_normal_matching_candidate(candidates, pred)
  let pred = substitute(a:pred, '\<v:val\>', 'cand', 'g')
  for cand in a:candidates
    if !eval(pred)
      let cand.is_matched = 0
    endif
  endfor
endfunction

" set only is_matched 1 on <cand> which matches pred
function! s:mark_tree_matching_candidate(candidates, pred)
  let pred = substitute(a:pred, '\<v:val\>', 'cand', 'g')
  for cand in a:candidates

    if has_key(cand, 'children')
      " parent node
      let l:node = cand
      let l:mark_children = 0
    else
      if cand.is_matched && l:mark_children
        continue
      endif
    endif

    " when already marked as not matched, skip it
    if !cand.is_matched | continue | endif

    if eval(pred)
      if has_key(cand, 'children')
        " parent node
        let l:mark_children = 1
      else
        " leaf node
        let l:node.is_matched = 1
      endif
    else
      let cand.is_matched = 0
    endif
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
