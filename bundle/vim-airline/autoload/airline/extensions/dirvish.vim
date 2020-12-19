" MIT Licsense
" Plugin: https://github.com/justinmk/vim-dirvish
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_dirvish', 0)
  finish
endif

let s:spc = g:airline_symbols.space

function! airline#extensions#dirvish#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#dirvish#apply')
endfunction

function! airline#extensions#dirvish#apply(...) abort
  if &filetype ==# 'dirvish'
    let w:airline_section_a = 'Dirvish'

    let w:airline_section_b = exists('*airline#extensions#branch#get_head')
      \ ? '%{airline#extensions#branch#get_head()}'
      \ : ''

    let w:airline_section_c = '%{b:dirvish._dir}'

    let w:airline_section_x = ''
    let w:airline_section_y = ''

    let current_column_regex = ':%\dv'
    let w:airline_section_z = join(filter(
      \   split(get(w:, 'airline_section_z', g:airline_section_z)),
      \   'v:val !~ current_column_regex'
      \ ))
  endif
endfunction
