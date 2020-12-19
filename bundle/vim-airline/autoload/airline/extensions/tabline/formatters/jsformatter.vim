" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#jsformatter#format(bufnr, buffers)
  let buf = bufname(a:bufnr)
  let filename = fnamemodify(buf, ':t')

  if filename == 'index.js' || filename == 'index.jsx' || filename == 'index.ts' || filename == 'index.tsx'
    return fnamemodify(buf, ':p:h:t') . '/i'
  else
    return airline#extensions#tabline#formatters#unique_tail_improved#format(a:bufnr, a:buffers)
  endif
endfunction
