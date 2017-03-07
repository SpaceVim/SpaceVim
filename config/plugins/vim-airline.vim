scriptencoding utf-8
let g:airline_powerline_fonts = g:spacevim_enable_powerline_fonts
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1
let g:Powerline_sybols = 'unicode'
if g:spacevim_buffer_index_type < 3
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#tabline#buffer_idx_format = {}
  for s:i in range(9)
    call extend(g:airline#extensions#tabline#buffer_idx_format,
          \ {s:i : SpaceVim#api#import('messletters').bubble_num(s:i,
          \ g:spacevim_buffer_index_type). ' '})
  endfor
  unlet s:i
elseif g:spacevim_buffer_index_type == 3
  let g:airline#extensions#tabline#buffer_idx_mode = 1
elseif g:spacevim_buffer_index_type == 4
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#tabline#buffer_idx_format = {
        \ '0': '0 ',
        \ '1': '1 ',
        \ '2': '2 ',
        \ '3': '3 ',
        \ '4': '4 ',
        \ '5': '5 ',
        \ '6': '6 ',
        \ '7': '7 ',
        \ '8': '8 ',
        \ '9': '9 '
        \}

endif
let g:airline#extensions#tabline#formatter = 'spacevim'
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#fnametruncate = 0
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
if get(g:, 'airline_powerline_fonts', 0)
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
  let g:airline_symbols.maxlinenr= ''
endif
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type= 2
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffers_label = 'BUFFERS'
let g:airline#extensions#tabline#tabs_label = 'TABS'
if g:spacevim_enable_os_fileformat_icon
  let s:sys = SpaceVim#api#import('system')
  let g:airline_section_y = " %{&fenc . ' ' . SpaceVim#api#import('system').fileformat()} "
endif

" vim:set et sw=2:
