" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:airline#extensions#quickfix#quickfix_text')
  let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
endif

if !exists('g:airline#extensions#quickfix#location_text')
  let g:airline#extensions#quickfix#location_text = 'Location'
endif

function! airline#extensions#quickfix#apply(...)
  if &buftype == 'quickfix'
    let w:airline_section_a = airline#extensions#quickfix#get_type()
    let w:airline_section_b = '%{get(w:, "quickfix_title", "")}'
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  endif
endfunction

function! airline#extensions#quickfix#init(ext)
  call a:ext.add_statusline_func('airline#extensions#quickfix#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#quickfix#inactive_qf_window')
endfunction

function! airline#extensions#quickfix#inactive_qf_window(...)
  if getbufvar(a:2.bufnr, '&filetype') is# 'qf' && !empty(airline#util#getwinvar(a:2.winnr, 'quickfix_title', ''))
    call setwinvar(a:2.winnr, 'airline_section_c', '[%{get(w:, "quickfix_title", "")}] %f %m')
  endif
endfunction

function! airline#extensions#quickfix#get_type()
  if exists("*win_getid") && exists("*getwininfo")
    let dict = getwininfo(win_getid())
    if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
      return g:airline#extensions#quickfix#quickfix_text
    elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
      return g:airline#extensions#quickfix#location_text
    endif
  endif
  redir => buffers
  silent ls
  redir END

  let nr = bufnr('%')
  for buf in split(buffers, '\n')
    if match(buf, '\v^\s*'.nr) > -1
      if match(buf, '\cQuickfix') > -1
        return g:airline#extensions#quickfix#quickfix_text
      else
        return g:airline#extensions#quickfix#location_text
      endif
    endif
  endfor
  return ''
endfunction
