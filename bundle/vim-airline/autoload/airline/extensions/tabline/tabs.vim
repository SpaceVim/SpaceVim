" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space
let s:current_bufnr = -1
let s:current_tabnr = -1
let s:current_modified = 0

function! airline#extensions#tabline#tabs#off()
  augroup airline_tabline_tabs
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#tabs#on()
  augroup airline_tabline_tabs
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#tabs#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#tabs#invalidate()
  let s:current_bufnr = -1
endfunction

function! airline#extensions#tabline#tabs#get()
  let curbuf = bufnr('%')
  let curtab = tabpagenr()
  try
    call airline#extensions#tabline#tabs#map_keys()
  catch
    " no-op
  endtry
  if curbuf == s:current_bufnr && curtab == s:current_tabnr && &columns == s:column_width
    if !g:airline_detect_modified || getbufvar(curbuf, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let b = airline#extensions#tabline#new_builder()

  call airline#extensions#tabline#add_label(b, 'tabs', 0)

  function! b.get_group(i) dict
    let curtab = tabpagenr()
    let group = 'airline_tab'
    if a:i == curtab
      let group = 'airline_tabsel'
      if g:airline_detect_modified
        for bi in tabpagebuflist(curtab)
          if getbufvar(bi, '&modified')
            let group = 'airline_tabmod'
          endif
        endfor
      endif
      let s:current_modified = (group == 'airline_tabmod') ? 1 : 0
    endif
    return group
  endfunction

  function! b.get_title(i) dict
    let val = '%('

    if get(g:, 'airline#extensions#tabline#show_tab_nr', 1)
      let tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
      let val .= airline#extensions#tabline#tabs#tabnr_formatter(tab_nr_type, a:i)
    endif

    return val.'%'.a:i.'T %{airline#extensions#tabline#title('.a:i.')} %)'
  endfunction

  call b.insert_titles(curtab, 1, tabpagenr('$'))

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')

  if get(g:, 'airline#extensions#tabline#show_close_button', 1)
    call b.add_section('airline_tab_right', ' %999X'.
          \ get(g:, 'airline#extensions#tabline#close_symbol', 'X').' ')
  endif

  if get(g:, 'airline#extensions#tabline#show_splits', 1) == 1
    let buffers = tabpagebuflist(curtab)
    for nr in buffers
      let group = airline#extensions#tabline#group_of_bufnr(buffers, nr) . "_right"
      call b.add_section_spaced(group, '%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)')
    endfor
    if get(g:, 'airline#extensions#tabline#show_buffers', 1)
      call airline#extensions#tabline#add_label(b, 'buffers', 1)
    endif
  endif
  call airline#extensions#tabline#add_tab_label(b)

  let s:current_bufnr = curbuf
  let s:current_tabnr = curtab
  let s:column_width = &columns
  let s:current_tabline = b.build()
  return s:current_tabline
endfunction

function! airline#extensions#tabline#tabs#map_keys()
  if maparg('<Plug>AirlineSelectTab1', 'n') is# ':1tabn<CR>'
    return
  endif
  let bidx_mode = get(g:, 'airline#extensions#tabline#buffer_idx_mode', 1)
  if bidx_mode == 1
    for i in range(1, 9)
      exe printf('noremap <silent> <Plug>AirlineSelectTab%d :%dtabn<CR>', i, i)
    endfor
  else
      for i in range(11, 99)
        exe printf('noremap <silent> <Plug>AirlineSelectTab%d :%dtabn<CR>', i, i-10)
      endfor
    endif
  noremap <silent> <Plug>AirlineSelectPrevTab gT
  " tabn {count} goes to count tab does not go {count} tab pages forward!
  noremap <silent> <Plug>AirlineSelectNextTab :<C-U>exe repeat(':tabn\|', v:count1)<cr>
endfunction

function! airline#extensions#tabline#tabs#tabnr_formatter(nr, i) abort
  let formatter = get(g:, 'airline#extensions#tabline#tabnr_formatter', 'tabnr')
  try
    return airline#extensions#tabline#formatters#{formatter}#format(a:nr, a:i)
  catch /^Vim\%((\a\+)\)\=:E117/	" catch E117, unknown function
    " Function not found
    return call(formatter, [a:nr, a:i])
  catch
    " something went wrong, return an empty string
    return ""
  endtry
endfunction
