" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
let s:fnametruncate = get(g:, 'airline#extensions#tabline#fnametruncate', 0)
let s:buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
let s:buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)
let s:buf_modified_symbol = g:airline_symbols.modified

function! airline#extensions#tabline#formatters#default#format(bufnr, buffers)
  let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
  let _ = ''

  let name = bufname(a:bufnr)
  if empty(name)
    let _ .= '[No Name]'
  elseif name =~ 'term://'
    " Neovim Terminal
    let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
  else
    if s:fnamecollapse
      " Does not handle non-ascii characters like Cyrillic: 'D/Учёба/t.c'
      "let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
      let _ .= pathshorten(fnamemodify(name, fmod))
    else
      let _ .= fnamemodify(name, fmod)
    endif
    if a:bufnr != bufnr('%') && s:fnametruncate && strlen(_) > s:fnametruncate
      let _ = strpart(_, 0, s:fnametruncate)
    endif
  endif

  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
endfunction

function! airline#extensions#tabline#formatters#default#wrap_name(bufnr, buffer_name)
  let _ = s:buf_nr_show ? printf(s:buf_nr_format, a:bufnr) : ''
  let _ .= substitute(a:buffer_name, '\\', '/', 'g')

  if getbufvar(a:bufnr, '&modified') == 1
    let _ .= s:buf_modified_symbol
  endif
  return _
endfunction
