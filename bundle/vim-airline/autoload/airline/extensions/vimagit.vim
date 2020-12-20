" MIT License. Copyright (c) 2016-2019 Jerome Reybert et al.
" Plugin: https://github.com/jreybert/vimagit
" vim: et ts=2 sts=2 sw=2

" This plugin replaces the whole section_a when in vimagit buffer
scriptencoding utf-8

if !get(g:, 'loaded_magit', 0)
  finish
endif

let s:commit_mode = {'': 'STAGING', 'CC': 'COMMIT', 'CA': 'AMEND'}

function! airline#extensions#vimagit#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#vimagit#apply')
endfunction

function! airline#extensions#vimagit#get_mode() abort
  if ( exists("*magit#get_current_mode") )
    return magit#get_current_mode()
  else
    return get(s:commit_mode, b:magit_current_commit_mode, '???')
  endif
endfunction

function! airline#extensions#vimagit#apply(...) abort
  if ( &filetype == 'magit' )
    let w:airline_section_a = '%{airline#extensions#vimagit#get_mode()}'
  endif
endfunction
