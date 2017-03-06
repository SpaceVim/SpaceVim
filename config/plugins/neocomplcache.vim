"---------------------------------------------------------------------------
" neocomplache.vim
"
let g:neocomplcache_enable_at_startup = 1
" Use smartcase
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Use fuzzy completion.
let g:neocomplcache_enable_fuzzy_completion = 1

" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
" Set auto completion length.
let g:neocomplcache_auto_completion_start_length = 2
" Set manual completion length.
let g:neocomplcache_manual_completion_start_length = 0
" Set minimum keyword length.
let g:neocomplcache_min_keyword_length = 3
" let g:neocomplcache_enable_cursor_hold_i = v:version > 703 ||
"       \ v:version == 703 && has('patch289')
let g:neocomplcache_enable_cursor_hold_i = 0
let g:neocomplcache_cursor_hold_i_time = 300
let g:neocomplcache_enable_insert_char_pre = 1
let g:neocomplcache_enable_prefetch = 1
let g:neocomplcache_skip_auto_completion_time = '0.6'

" For auto select.
let g:neocomplcache_enable_auto_select = 0

let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_disable_auto_select_buffer_name_pattern =
      \ '\[Command Line\]'
"let g:neocomplcache_disable_auto_complete = 0
let g:neocomplcache_max_list = 100
let g:neocomplcache_force_overwrite_completefunc = 1
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
if !exists('g:neocomplcache_omni_functions')
  let g:neocomplcache_omni_functions = {}
endif
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_enable_auto_close_preview = 1
" let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.java = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.java = '[^. *\t]\.\w*\|\h\w*::'

" For clang_complete.
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_use_library   = 1

" Define keyword pattern.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '[0-9a-zA-Z:#_]\+'
let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#enable_multibyte_completion = 1

let g:neocomplcache_vim_completefuncs = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimShellExecute' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellInteractive' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellTerminal' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShell' : 'vimshell#complete',
      \ 'VimFiler' : 'vimfiler#complete',
      \ 'Vinarise' : 'vinarise#complete',
      \}

" vim:set et sw=2:
