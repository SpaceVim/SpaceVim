" File:		plugin/words_tools.vim
" Author:	Luc Hermitte <hermitte {at} free {dot} fr>
" 		<URL:http://code.google.com/p/lh-vim/>
" URL: http://hermitte.free.fr/vim/ressources/vim_dollar/plugin/words_tools.vim
"
" Last Update:	14th nov 2002
" Purpose:	Define functions better than expand("<cword>")
"
" Note:		They are expected to be used in insert mode (thanks to <c-r>
"               or <c-o>)
"
"===========================================================================

" Return the current keyword, uses spaces to delimitate {{{1
function! GetNearestKeyword()
  let c = col ('.')-1
  let ll = getline('.')
  let ll1 = strpart(ll,0,c)
  let ll1 = matchstr(ll1,'\k*$')
  let ll2 = strpart(ll,c,strlen(ll)-c+1)
  let ll2 = matchstr(ll2,'^\k*')
  " let ll2 = strpart(ll2,0,match(ll2,'$\|\s'))
  return ll1.ll2
endfunction

" Return the current word, uses spaces to delimitate {{{1
function! GetNearestWord()
  let c = col ('.')-1
  let l = line('.')
  let ll = getline(l)
  let ll1 = strpart(ll,0,c)
  let ll1 = matchstr(ll1,'\S*$')
  let ll2 = strpart(ll,c,strlen(ll)-c+1)
  let ll2 = strpart(ll2,0,match(ll2,'$\|\s'))
  ""echo ll1.ll2
  return ll1.ll2
endfunction

" Return the word before the cursor, uses spaces to delimitate {{{1
" Rem : <cword> is the word under or after the cursor
function! GetCurrentWord()
  let c = col ('.')-1
  let l = line('.')
  let ll = getline(l)
  let ll1 = strpart(ll,0,c)
  let ll1 = matchstr(ll1,'\S*$')
  if strlen(ll1) == 0
    return ll1
  else
    let ll2 = strpart(ll,c,strlen(ll)-c+1)
    let ll2 = strpart(ll2,0,match(ll2,'$\|\s'))
    return ll1.ll2
  endif
endfunction

" Return the keyword before the cursor, uses \k to delimitate {{{1
" Rem : <cword> is the word under or after the cursor
function! GetCurrentKeyword()
  let c = col ('.')-1
  let l = line('.')
  let ll = getline(l)
  let ll1 = strpart(ll,0,c)
  let ll1 = matchstr(ll1,'\k*$')
  if strlen(ll1) == 0
    return ll1
  else
    let ll2 = strpart(ll,c,strlen(ll)-c+1)
    let ll2 = matchstr(ll2,'^\k*')
    " let ll2 = strpart(ll2,0,match(ll2,'$\|\s'))
    return ll1.ll2
  endif
endfunction

" Extract the word before the cursor,  {{{1
" use keyword definitions, skip latter spaces (see "bla word_accepted ")
function! GetPreviousWord()
  let lig = getline(line('.'))
  let lig = strpart(lig,0,col('.')-1)
  return matchstr(lig, '\<\k*\>\s*$')
endfunction

" GetLikeCTRL_W() retrieves the characters that i_CTRL-W deletes. {{{1
" Initial need by Hari Krishna Dara <hari_vim@yahoo.com>
" Last ver:
" Pb: "if strlen(w) ==  " --> ") ==  " instead of just "==  ".
" There still exists a bug regarding the last char of a line. VIM bug ?
function! GetLikeCTRL_W()
  let lig = getline(line('.'))
  let lig = strpart(lig,0,col('.')-1)
  " treat ending spaces apart.
  let s = matchstr(lig, '\s*$')
  let lig = strpart(lig, 0, strlen(lig)-strlen(s))
  " First case : last characters belong to a "word"
  let w = matchstr(lig, '\<\k\+\>$')
  if strlen(w) == 0
    " otherwise, they belong to a "non word" (without any space)
    let w = substitute(lig, '.*\(\k\|\s\)', '', 'g')
  endif
  return w . s
endfunction

" }}}1
"========================================================================
" vim60: set fdm=marker:
