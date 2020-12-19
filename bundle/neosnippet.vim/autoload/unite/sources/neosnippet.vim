"=============================================================================
" FILE: neosnippet.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#neosnippet#define() abort
  let kind = {
        \ 'name' : 'neosnippet',
        \ 'default_action' : 'expand',
        \ 'action_table': {},
        \ 'parents': ['jump_list', 'completion'],
        \ 'alias_table' : { 'edit' : 'open' },
        \ }
  call unite#define_kind(kind)

  return s:source
endfunction

" neosnippet source.
let s:source = {
      \ 'name': 'neosnippet',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ }

function! s:source.hooks.on_init(args, context) abort
  let a:context.source__cur_keyword_pos =
        \ s:get_keyword_pos(neosnippet#util#get_cur_text())
  let a:context.source__snippets =
        \ sort(values(neosnippet#helpers#get_completion_snippets()))
endfunction

function! s:source.gather_candidates(args, context) abort
  return map(copy(a:context.source__snippets), "{
        \   'word' : v:val.word,
        \   'abbr' : printf('%-50s %s', v:val.word, v:val.menu_abbr),
        \   'kind' : 'neosnippet',
        \   'action__complete_word' : v:val.word,
        \   'action__complete_pos' : a:context.source__cur_keyword_pos,
        \   'action__path' : v:val.action__path,
        \   'action__pattern' : v:val.action__pattern,
        \   'source__menu' : v:val.menu_abbr,
        \   'source__snip' : v:val.snip,
        \   'source__snip_ref' : v:val,
        \ }")
endfunction

" Actions
let s:action_table = {}

let s:action_table.expand = {
      \ 'description' : 'expand snippet',
      \ }
function! s:action_table.expand.func(candidate) abort
  let cur_text = neosnippet#util#get_cur_text()
  let cur_keyword_str = matchstr(cur_text, '\S\+$')
  let context = unite#get_context()
  call neosnippet#view#_expand(
        \ cur_text . a:candidate.action__complete_word[len(cur_keyword_str)],
        \ context.col, a:candidate.action__complete_word)
endfunction

let s:action_table.preview = {
      \ 'description' : 'preview snippet',
      \ 'is_selectable' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:action_table.preview.func(candidates) abort
  for snip in a:candidates
    echohl String
    echo snip.action__complete_word
    echohl None
    echo snip.source__snip
    echo ' '
  endfor
endfunction

let s:action_table.unite__new_candidate = {
      \ 'description' : 'add new snippet',
      \ 'is_quit' : 1,
      \ }
function! s:action_table.unite__new_candidate.func(candidate) abort
  let trigger = unite#util#input('Please input snippet trigger: ')
  if trigger ==# ''
    echo 'Canceled.'
    return
  endif

  call unite#take_action('open', a:candidate)
  if &filetype !=# 'snippet'
    " Open failed.
    return
  endif

  if getline('$') !=# ''
    " Append line.
    call append('$', '')
  endif

  call append('$', [
        \ 'snippet     ' . trigger,
        \ 'abbr        ' . trigger,
        \ 'options     head',
        \ '    '
        \ ])

  call cursor(line('$'), 0)
  call cursor(0, col('$'))
endfunction


let s:source.action_table = s:action_table
unlet! s:action_table


function! unite#sources#neosnippet#start_complete() abort
  if !exists(':Unite')
    call neosnippet#util#print_error(
          \ 'unite.vim is not installed.')
    call neosnippet#util#print_error(
          \ 'Please install unite.vim Ver.1.5 or above.')
    return ''
  endif

  return unite#start_complete(['neosnippet'],
        \ { 'input': neosnippet#util#get_cur_text(), 'buffer_name' : '' })
endfunction

function! s:get_keyword_pos(cur_text) abort
  let cur_keyword_pos = match(a:cur_text, '\S\+$')
  if cur_keyword_pos < 0
    " Empty string.
    return len(a:cur_text)
  endif

  return cur_keyword_pos
endfunction
