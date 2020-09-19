" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#wordcount#formatters#default#update_fmt(...)
  let s:fmt = get(g:, 'airline#extensions#wordcount#formatter#default#fmt', '%s words')
  let s:fmt_short = get(g:, 'airline#extensions#wordcount#formatter#default#fmt_short', s:fmt == '%s words' ? '%sW' : s:fmt)
endfunction

" Reload format when statusline is rebuilt
call airline#extensions#wordcount#formatters#default#update_fmt()
if index(g:airline_statusline_funcrefs, function('airline#extensions#wordcount#formatters#default#update_fmt')) == -1
  " only add it, if not already done
  call airline#add_statusline_funcref(function('airline#extensions#wordcount#formatters#default#update_fmt'))
endif

if match(get(v:, 'lang', ''), '\v\cC|en') > -1
  let s:decimal_group = ','
elseif match(get(v:, 'lang', ''), '\v\cde|dk|fr|pt') > -1
  let s:decimal_group = '.'
else
  let s:decimal_group = ''
endif

function! airline#extensions#wordcount#formatters#default#to_string(wordcount)
  if airline#util#winwidth() > 85
    if a:wordcount > 999
      " Format number according to locale, e.g. German: 1.245 or English: 1,245
      let wordcount = substitute(a:wordcount, '\d\@<=\(\(\d\{3\}\)\+\)$', s:decimal_group.'&', 'g')
    else
      let wordcount = a:wordcount
    endif
    let str = printf(s:fmt, wordcount)
  else
    let str = printf(s:fmt_short, a:wordcount)
  endif
  return str . g:airline_symbols.space . g:airline_right_alt_sep . g:airline_symbols.space
endfunction
