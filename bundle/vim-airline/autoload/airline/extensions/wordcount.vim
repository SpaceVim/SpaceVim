" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 fdm=marker

scriptencoding utf-8

" get wordcount {{{1
if exists('*wordcount')
  function! s:get_wordcount(visual_mode_active)
    if get(g:, 'actual_curbuf', '') != bufnr('')
      return
    endif
    let query = a:visual_mode_active ? 'visual_words' : 'words'
    return get(wordcount(), query, 0)
  endfunction
else  " Pull wordcount from the g_ctrl-g stats
  function! s:get_wordcount(visual_mode_active)
    let pattern = a:visual_mode_active
          \ ? '^.\D*\d\+\D\+\d\+\D\+\zs\d\+'
          \ : '^.\D*\%(\d\+\D\+\)\{5}\zs\d\+'

    let save_status = v:statusmsg
    if !a:visual_mode_active && col('.') == col('$')
      let save_pos = getpos('.')
      execute "silent normal! g\<c-g>"
      call setpos('.', save_pos)
    else
      execute "silent normal! g\<c-g>"
    endif
    let stats = v:statusmsg
    let v:statusmsg = save_status

    return str2nr(matchstr(stats, pattern))
  endfunction
endif

" format {{{1
let s:formatter = get(g:, 'airline#extensions#wordcount#formatter', 'default')

" wrapper function for compatibility; redefined below for old-style formatters
function! s:format_wordcount(wordcount)
  return airline#extensions#wordcount#formatters#{s:formatter}#to_string(a:wordcount)
endfunction

" check user-defined formatter exists with appropriate functions, otherwise
" fall back to default
if s:formatter !=# 'default'
  execute 'runtime! autoload/airline/extensions/wordcount/formatters/'.s:formatter.'.vim'
  if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#to_string')
    if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#format')
      let s:formatter = 'default'
    else
      " redefine for backwords compatibility
      function! s:format_wordcount(_)
        if mode() ==? 'v'
          return b:airline_wordcount
        else
          return airline#extensions#wordcount#formatters#{s:formatter}#format()
        endif
      endfunction
    endif
  endif
endif

" update {{{1
let s:wordcount_cache = 0  " cache wordcount for performance when force_update=0
function! s:update_wordcount(force_update)
  let wordcount = s:get_wordcount(0)
  if wordcount != s:wordcount_cache || a:force_update
    let s:wordcount_cache = wordcount
    let b:airline_wordcount =  s:format_wordcount(wordcount)
  endif
endfunction

function airline#extensions#wordcount#get()
  if get(g:, 'airline#visual_active', 0)
    return s:format_wordcount(s:get_wordcount(1))
  else
    if get(b:, 'airline_changedtick', 0) != b:changedtick
      call s:update_wordcount(0)
      let b:airline_changedtick = b:changedtick
    endif
    return get(b:, 'airline_wordcount', '')
  endif
endfunction

" airline functions {{{1
" default filetypes:
function! airline#extensions#wordcount#apply(...)
  let filetypes = get(g:, 'airline#extensions#wordcount#filetypes', 
    \ ['asciidoc', 'help', 'mail', 'markdown', 'org', 'rst', 'plaintex', 'tex', 'text'])
  " export current filetypes settings to global namespace
  let g:airline#extensions#wordcount#filetypes = filetypes

  " Check if filetype needs testing
  if did_filetype()
    " correctly test for compound filetypes (e.g. markdown.pandoc)
    let ft = substitute(&filetype, '\.', '\\|', 'g')

    " Select test based on type of "filetypes": new=list, old=string
    if type(filetypes) == get(v:, 't_list', type([]))
          \ ? match(filetypes, '\<'. ft. '\>') > -1 || index(filetypes, 'all') > -1
          \ : match(&filetype, filetypes) > -1
      let b:airline_changedtick = -1
      call s:update_wordcount(1) " force update: ensures initial worcount exists
    elseif exists('b:airline_wordcount') " cleanup when filetype is removed
      unlet b:airline_wordcount
    endif
  endif

  if exists('b:airline_wordcount')
    call airline#extensions#prepend_to_section(
          \ 'z', '%{airline#extensions#wordcount#get()}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
endfunction
