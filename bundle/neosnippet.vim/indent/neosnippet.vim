"=============================================================================
" FILE: snippets.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Only load this indent file when no other was loaded.
if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

if !exists('b:undo_indent')
  let b:undo_indent = ''
else
  let b:undo_indent .= '|'
endif

setlocal autoindent
setlocal indentexpr=SnippetsIndent()
setlocal indentkeys=o,O,=include\ ,=snippet\ ,=abbr\ ,=prev_word\ ,=delete\ ,=alias\ ,=options\ ,=regexp\ ,!^F

let b:undo_indent .= 'setlocal
    \ autoindent<
    \ indentexpr<
    \ indentkeys<
    \'

function! SnippetsIndent() abort "{{{
  let line = getline('.')
  let prev_line = (line('.') == 1)? '' : getline(line('.')-1)
  let syntax = '\%(include\|snippet\|abbr\|prev_word\|delete\|alias\|options\|regexp\)\s'
  let defining = '\%(snippet\|abbr\|prev_word\|alias\|options\|regexp\)\s'

  "for indentkeys o,O
  if s:is_empty(line)
    if prev_line =~ '^' . defining
      return shiftwidth()
    else
      return -1
    endif

    "for indentkeys =words
  else
    if line =~ '^\s*' . syntax
          \ && (s:is_empty(prev_line)
          \ || prev_line =~ '^' . defining)
      return 0
    else
      return -1
    endif
  endif
endfunction"}}}

function! s:is_empty(line)
  return a:line =~ '^\s*$'
endfunction
