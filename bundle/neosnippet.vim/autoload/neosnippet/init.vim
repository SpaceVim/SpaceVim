"=============================================================================
" FILE: init.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#init#_initialize() abort
  let s:is_initialized = 1

  call s:initialize_others()
  call s:initialize_cache()
endfunction

function! neosnippet#init#check() abort
  if !exists('s:is_initialized')
    call neosnippet#init#_initialize()
  endif
endfunction

function! s:initialize_cache() abort
  " Make cache for _ snippets.
  call neosnippet#commands#_make_cache('_')

  " Initialize check.
  call neosnippet#commands#_make_cache(&filetype)
endfunction
function! s:initialize_others() abort
  augroup neosnippet
    autocmd!
    " Set make cache event.
    autocmd FileType *
          \ call neosnippet#commands#_make_cache(&filetype)
    " Re make cache events
    autocmd BufWritePost *.snip,*.snippets
          \ call neosnippet#variables#set_snippets({})
    autocmd BufEnter *
          \ call neosnippet#mappings#_clear_select_mode_mappings()
  augroup END

  if g:neosnippet#enable_auto_clear_markers
    autocmd neosnippet CursorMoved,CursorMovedI *
          \ call neosnippet#handlers#_cursor_moved()
    autocmd neosnippet BufWritePre *
          \ call neosnippet#handlers#_all_clear_markers()
  endif

  augroup neosnippet
    autocmd BufNewFile,BufRead,Syntax *
          \ execute 'syntax match neosnippetExpandSnippets'
          \  "'".neosnippet#get_placeholder_marker_pattern(). '\|'
          \ .neosnippet#get_sync_placeholder_marker_pattern().'\|'
          \ .neosnippet#get_mirror_placeholder_marker_pattern()."'"
          \ 'containedin=ALL oneline'
    if g:neosnippet#enable_conceal_markers && has('conceal')
      let start = '<`0\|<`\|<{\d\+:\=\%(#:\|TARGET:\?\)\?\|%\w\+(<|'
      let end = '\(:\w\+\|:#:\w\+\)\?`>\|}>\||>)\?'
      execute ' autocmd BufNewFile,BufRead,Syntax * ' .
            \ ' syntax region neosnippetConcealExpandSnippets ' .
            \ ' matchgroup=neosnippetExpandSnippets ' .
            \ printf(' start=%s end=%s', string(start), string(end)) .
            \ ' containedin=ALL ' .
            \ ' cchar=' . g:neosnippet#conceal_char .
            \ ' concealends oneline'
    endif
  augroup END
  doautocmd neosnippet BufRead

  hi def link neosnippetExpandSnippets Special

  call neosnippet#mappings#_clear_select_mode_mappings()

  if g:neosnippet#enable_complete_done
    autocmd neosnippet CompleteDone * call neosnippet#complete_done()
  endif

  if g:neosnippet#enable_snipmate_compatibility
    " For snipMate function.
    function! Filename(...) abort
      let filename = expand('%:t:r')
      if filename ==# ''
        return a:0 == 2 ? a:2 : ''
      elseif a:0 == 0 || a:1 ==# ''
        return filename
      else
        return substitute(a:1, '$1', filename, 'g')
      endif
    endfunction
  endif
endfunction
