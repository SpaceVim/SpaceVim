function! sj#vue#SplitCssDefinition()
  if s:GetVueSection() != 'style'
    return 0
  endif
  return sj#css#SplitDefinition()
endfunction

function! sj#vue#JoinCssDefinition()
  if s:GetVueSection() != 'style'
    return 0
  endif
  return sj#css#JoinDefinition()
endfunction

function! sj#vue#SplitCssMultilineSelector()
  if s:GetVueSection() != 'style'
    return 0
  endif
  return sj#css#SplitMultilineSelector()
endfunction

function! sj#vue#JoinCssMultilineSelector()
  if s:GetVueSection() != 'style'
    return 0
  endif
  return sj#css#JoinMultilineSelector()
endfunction

function! s:GetVueSection()
  let l:startofsection = search('\v^\<(template|script|style)\>', 'bnW')
  return substitute(getline(startofsection), '\v[<>]', '', 'g')
endfunction
