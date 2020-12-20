"=============================================================================
" FILE: file_include.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:source = {
      \ 'name' : 'file/include',
      \ 'kind' : 'manual',
      \ 'mark' : '[FI]',
      \ 'rank' : 150,
      \ 'sorters' : 'sorter_filename',
      \ 'converters' : ['converter_remove_overlap', 'converter_abbr'],
      \ 'min_pattern_length' : 0,
      \}

function! neocomplete#sources#file_include#define() abort
  return s:source
endfunction

function! s:source.get_complete_position(context) abort
  return neoinclude#file_include#get_complete_position(a:context.input)
endfunction

function! s:source.gather_candidates(context) abort
  return neoinclude#file_include#get_include_files(a:context.input)
endfunction
