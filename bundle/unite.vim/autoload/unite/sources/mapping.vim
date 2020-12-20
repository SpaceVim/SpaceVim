"=============================================================================
" FILE: mapping.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#mapping#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'mapping',
      \ 'description' : 'candidates from Vim mappings',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'default_kind' : 'command',
      \ }

let s:cached_result = []
function! s:source.hooks.on_init(args, context) abort "{{{
  " Get buffer number.
  let bufnr = get(a:args, 0, bufnr('%'))
  let oldnr = bufnr('%')
  if bufnr != bufnr('%')
    let oldnr = bufnr('%')
    execute 'buffer' bufnr
  endif

  " Get mapping list.
  let redir = unite#util#redir('nmap')

  if oldnr != bufnr('%')
    execute 'buffer' oldnr
  endif

  let s:cached_result = []
  let mapping_lines = split(redir, '\n')
  let mapping_lines = filter(copy(mapping_lines),
        \ "v:val =~ '\\s\\+\\*\\?@'")
        \ + filter(copy(mapping_lines),
        \ "v:val !~ '\\s\\+\\*\\?@'")

  for line in map(mapping_lines,
        \ "substitute(v:val, '<NL>', '<C-J>', 'g')")
    let map = matchstr(line, '^\a*\s*\zs\S\+')
    if map =~ '^<SNR>' || map =~ '^<Plug>'
      continue
    endif
    let map = substitute(map, '<NL>', '<C-j>', 'g')
    let map = substitute(map, '\(<.*>\)', '\\\1', 'g')

    call add(s:cached_result, {
          \ 'word' : line,
          \ 'action__command' : 'call feedkeys("' . map . '")',
          \ 'action__mapping' : map,
          \ })
  endfor
endfunction"}}}
function! s:source.gather_candidates(args, context) abort "{{{
  return s:cached_result
endfunction"}}}
function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction"}}}

" Actions "{{{
let s:source.action_table.preview = {
      \ 'description' : 'view the help documentation',
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.preview.func(candidate) abort "{{{
  let winnr = winnr()

  try
    execute 'help' matchstr(
        \ a:candidate.word, '<Plug>\S\+')
    normal! zv
    normal! zt
    setlocal previewwindow
  catch /^Vim\%((\a\+)\)\?:E149/
    " Ignore
  endtry

  execute winnr.'wincmd w'
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
