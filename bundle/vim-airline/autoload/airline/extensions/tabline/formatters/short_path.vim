" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)

function! airline#extensions#tabline#formatters#short_path#format(bufnr, buffers)
  let _ = ''

  let name = bufname(a:bufnr)
  if empty(name)
    let _ .= '[No Name]'
  elseif name =~ 'term://'
    " Neovim Terminal
    let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
  else
    let _ .= fnamemodify(name, ':p:h:t') . '/' . fnamemodify(name, ':t')
  endif

  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
endfunction
