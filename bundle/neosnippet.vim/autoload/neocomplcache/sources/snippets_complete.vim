"=============================================================================
" FILE: snippets_complete.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:source = {
      \ 'name' : 'snippets_complete',
      \ 'kind' : 'complfunc',
      \ 'min_pattern_length' :
      \     g:neocomplcache_auto_completion_start_length,
      \}

function! s:source.initialize() abort
  " Initialize.
  call neocomplcache#set_dictionary_helper(
        \ g:neocomplcache_source_rank, 'snippets_complete', 8)
  call neocomplcache#set_completion_length('snippets_complete',
        \ g:neocomplcache_auto_completion_start_length)
endfunction

function! s:source.get_keyword_pos(cur_text) abort
  let cur_word = matchstr(a:cur_text, '\w\+$')
  let word_candidates = neocomplcache#keyword_filter(
        \ filter(values(neosnippet#helpers#get_snippets()),
        \ 'v:val.options.word'), cur_word)
  if !empty(word_candidates)
    return match(a:cur_text, '\w\+$')
  endif

  return match(a:cur_text, '\S\+$')
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str) abort
  let list = s:keyword_filter(neosnippet#helpers#get_snippets(), a:cur_keyword_str)

  for snippet in list
    let snippet.dup = 1

    let snippet.menu = neosnippet#util#strwidthpart(
          \ snippet.menu_template, winwidth(0)/3)
  endfor

  return list
endfunction

function! s:keyword_filter(snippets, cur_keyword_str) abort
  " Uniq by real_name.
  let dict = {}

  " Use default filter.
  let list = neocomplcache#keyword_filter(
        \ values(a:snippets), a:cur_keyword_str)

  " Add cur_keyword_str snippet.
  if has_key(a:snippets, a:cur_keyword_str)
    call add(list, a:snippets[a:cur_keyword_str])
  endif

  for snippet in neocomplcache#dup_filter(list)
    if !has_key(dict, snippet.real_name) ||
          \ len(dict[snippet.real_name].word) > len(snippet.word)
      let dict[snippet.real_name] = snippet
    endif
  endfor

  return values(dict)
endfunction

function! neocomplcache#sources#snippets_complete#define() abort
  return s:source
endfunction
