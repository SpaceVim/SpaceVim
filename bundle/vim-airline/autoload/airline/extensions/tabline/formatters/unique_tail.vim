" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#unique_tail#format(bufnr, buffers)
  let duplicates = {}
  let tails = {}
  let map = {}
  for nr in a:buffers
    let name = bufname(nr)
    if empty(name)
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, '[No Name]')
    else
      if name =~ 'term://'
        " Neovim Terminal
        let tail = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
      else
        let tail = fnamemodify(name, ':s?/\+$??:t')
      endif
      if has_key(tails, tail)
        let duplicates[nr] = nr
      endif
      let tails[tail] = 1
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, tail)
    endif
  endfor

  let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':p:.')
  for nr in values(duplicates)
    let name = bufname(nr)
    let fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
    if fnamecollapse
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g'))
    else
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, fnamemodify(name, fmod))
    endif
  endfor

  if has_key(map, a:bufnr)
    return map[a:bufnr]
  endif

  " if we get here, the buffer list isn't in sync with the selected buffer yet, fall back to the default
  return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
endfunction
