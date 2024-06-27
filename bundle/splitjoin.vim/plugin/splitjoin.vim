if exists("g:loaded_splitjoin") || &cp
  finish
endif

let g:loaded_splitjoin = '1.2.0' " version number
let s:keepcpo          = &cpo
set cpo&vim

" Defaults:
" =========

let g:splitjoin_default_settings = {
      \ 'quiet':                    0,
      \ 'disabled_split_callbacks': [],
      \ 'disabled_join_callbacks':  [],
      \ 'mapping_fallback':         1,
      \
      \ 'normalize_whitespace':                    1,
      \ 'trailing_comma':                          0,
      \ 'align':                                   0,
      \ 'curly_brace_padding':                     1,
      \ 'ruby_curly_braces':                       1,
      \ 'ruby_heredoc_type':                       '<<~',
      \ 'ruby_trailing_comma':                     0,
      \ 'ruby_hanging_args':                       1,
      \ 'ruby_do_block_split':                     1,
      \ 'ruby_options_as_arguments':               0,
      \ 'ruby_expand_options_in_arrays':           0,
      \ 'c_argument_split_first_newline':          0,
      \ 'c_argument_split_last_newline':           0,
      \ 'coffee_suffix_if_clause':                 1,
      \ 'perl_brace_on_same_line':                 1,
      \ 'php_method_chain_full':                   0,
      \ 'python_brackets_on_separate_lines':       0,
      \ 'handlebars_closing_bracket_on_same_line': 0,
      \ 'handlebars_hanging_arguments':            0,
      \ 'html_attribute_bracket_on_new_line':      0,
      \ 'java_argument_split_first_newline':       0,
      \ 'java_argument_split_last_newline':        0,
      \ 'vim_split_whitespace_after_backslash':    1,
      \ }

if !exists('g:splitjoin_join_mapping')
  let g:splitjoin_join_mapping = 'gJ'
endif

if !exists('g:splitjoin_split_mapping')
  let g:splitjoin_split_mapping = 'gS'
endif

" Public Interface:
" =================

command! SplitjoinSplit call sj#Split()
command! SplitjoinJoin  call sj#Join()

nnoremap <silent> <plug>SplitjoinSplit :<c-u>call sj#Split()<cr>
nnoremap <silent> <plug>SplitjoinJoin  :<c-u>call sj#Join()<cr>

if g:splitjoin_join_mapping != ''
  exe 'nnoremap <silent> '.g:splitjoin_join_mapping.' :<c-u>call <SID>Mapping(g:splitjoin_join_mapping, "sj#Join")<cr>'
endif

if g:splitjoin_split_mapping != ''
  exe 'nnoremap <silent> '.g:splitjoin_split_mapping.' :<c-u>call <SID>Mapping(g:splitjoin_split_mapping, "sj#Split")<cr>'
endif

" Internal Functions:
" ===================

" Used to create a mapping for the given a:function that falls back to the
" built-in key sequence (a:mapping) if the function returns 0, meaning it
" didn't do anything.
"
function! s:Mapping(mapping, function)
  if !sj#settings#Read('mapping_fallback')
    call call(a:function, [])
    return
  endif

  if !v:count
    if !call(a:function, [])
      execute 'normal! '.a:mapping
    endif
  else
    execute 'normal! '.v:count.a:mapping
  endif
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
