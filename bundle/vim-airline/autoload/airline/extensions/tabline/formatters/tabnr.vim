" MIT License. Copyright (c) 2017-2019 Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#tabnr#format(tab_nr_type, nr)
  let spc=g:airline_symbols.space
  if a:tab_nr_type == 0 " nr of splits
    return spc. '%{len(tabpagebuflist('.a:nr.'))}'
  elseif a:tab_nr_type == 1 " tab number
    return spc. a:nr
  else "== 2 splits and tab number
    return spc. a:nr. '.%{len(tabpagebuflist('.a:nr.'))}'
  endif
endfunction
