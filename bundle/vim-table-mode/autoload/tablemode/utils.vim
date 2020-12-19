" Private Functions {{{1

" Public Functions {{{1
function! tablemode#utils#throw(string) abort "{{{2
  let v:errmsg = 'table-mode: ' . a:string
  throw v:errmsg
endfunction

function! tablemode#utils#line(row) "{{{2
  if type(a:row) == type('')
    return line(a:row)
  else
    return a:row
  endif
endfunction

function! tablemode#utils#strip(string) "{{{2
  return matchstr(a:string, '^\s*\zs.\{-}\ze\s*$')
endfunction

" function! tablemode#utils#strlen {{{2
" To count multibyte characters accurately
function! tablemode#utils#strlen(text)
  return strlen(substitute(a:text, '.', 'x', 'g'))
endfunction

function! tablemode#utils#StrDisplayWidth(string) "{{{2
  if exists('*strdisplaywidth')
    return strdisplaywidth(a:string)
  else
    " Implement the tab handling part of strdisplaywidth for vim 7.2 and
    " earlier - not much that can be done about handling doublewidth
    " characters.
    let rv = 0
    let i = 0

    for char in split(a:string, '\zs')
      if char == "\t"
        let rv += &ts - i
        let i = 0
      else
        let rv += 1
        let i = (i + 1) % &ts
      endif
    endfor

    return rv
  endif
endfunction

function! tablemode#utils#get_buffer_or_global_option(table_option) "{{{2
  return get(b:, a:table_option, get(g:, a:table_option))
endf

function tablemode#utils#MoveToLine(line) "{{{2
  let offset = tablemode#utils#line(a:line) - line('.')
  if offset > 0
    execute "normal! ".offset."j"
  elseif offset < 0
    execute "normal! ".(-offset)."k"
  endif
endfunction

function! tablemode#utils#SeparatorCount(str)
  return tablemode#utils#strlen(substitute(a:str, '\V\C\(\\' . escape(g:table_mode_separator, '\') . '\|\[^' . escape(g:table_mode_separator, ']^-\') . ']\)', '', 'g'))
endfunction
