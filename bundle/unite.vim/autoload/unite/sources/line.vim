"=============================================================================
" FILE: line.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
"          t9md <taqumd at gmail.com>
" License: MIT license
"=============================================================================

" original verion is http://d.hatena.ne.jp/thinca/20101105/1288896674

call unite#util#set_default(
      \ 'g:unite_source_line_enable_highlight', 0)

let s:supported_search_direction =
      \ ['forward', 'backward', 'all', 'buffers', 'args']

function! unite#sources#line#define() abort "{{{
  return s:source_line
endfunction "}}}

" line source. "{{{
let s:source_line = {
      \ 'name' : 'line',
      \ 'syntax' : 'uniteSource__Line',
      \ 'hooks' : {},
      \ 'max_candidates': 1000,
      \ 'default_kind' : 'jump_list',
      \ 'matchers' : 'matcher_regexp',
      \ 'sorters' : 'sorter_nothing',
      \ }

function! s:source_line.hooks.on_init(args, context) abort "{{{
  let a:context.source__linenr = line('.')
  let a:context.source__linemax = line('$')
  let a:context.source__is_bang =
        \ (get(a:args, 0, '') ==# '!')

  let options = filter(copy(a:args), "v:val != '!'")
  let direction = get(options, 0, '')
  if direction == ''
    let direction = 'all'
  endif
  let a:context.source__wrap = get(options, 1,
        \ (&wrapscan ? 'wrap' : 'nowrap')) ==# 'wrap'

  if index(s:supported_search_direction, direction) == -1
    let direction = 'all'
  endif

  let a:context.source__bufnrs =
        \ (direction ==# 'buffers') ?
        \    filter(range(1, bufnr('$')), 'buflisted(v:val)') :
        \ (direction ==# 'args') ?
        \    filter(map(argv(), "bufnr(v:val)"), 'v:val > 0') :
        \ [bufnr('%')]
  " Dummy loading
  call s:dummy_loading(a:context.source__bufnrs)

  if len(a:context.source__bufnrs) == 1
    let a:context.source__syntax =
          \ getbufvar(a:context.source__bufnrs[0], '&l:syntax')
  endif

  let a:context.source__input = a:context.input
  if a:context.source__linemax > 10000 && a:context.source__input == ''
    " Note: In huge buffer, you must input narrowing text.
    let a:context.source__input = unite#util#input('Narrowing text: ', '')
  endif

  if a:context.source__input != ''
    call unite#print_source_message(
          \ 'Narrowing text: ' . a:context.source__input,
          \ s:source_line.name)
  endif

  if len(a:context.source__bufnrs) == 1
    call unite#print_source_message(
          \ 'Target: ' . bufname(a:context.source__bufnrs[0]),
          \ s:source_line.name)
  endif

  let a:context.source__direction = direction
endfunction"}}}
function! s:source_line.hooks.on_syntax(args, context) abort "{{{
  let highlight = get(a:context, 'custom_line_enable_highlight',
        \ g:unite_source_line_enable_highlight)

  if len(a:context.source__bufnrs) > 1
    syntax match uniteSource__LineFile /^[^:]*:/ contained
          \ containedin=uniteSource__Line
          \ nextgroup=uniteSource__LineSeparator
    highlight default link uniteSource__LineFile Comment
  endif
  syntax match uniteSource__LineLineNR /\d\+:/ contained
        \ containedin=uniteSource__Line
  syntax match uniteSource__LineSeparator /:/ contained conceal
        \ containedin=uniteSource__LineFile,uniteSource__LineLineNR
  highlight default link uniteSource__LineLineNR LineNR

  if !highlight || len(a:context.source__bufnrs) > 1
    return
  endif

  let save_current_syntax = get(b:, 'current_syntax', '')
  unlet! b:current_syntax

  try
    execute 'silent! syntax include @LineSyntax' 'syntax/'
          \ . a:context.source__syntax . '.vim'
    syntax region uniteSource__Line_LineSyntax
          \ start='' end='$'
          \ contains=@LineSyntax
          \ containedin=uniteSource__Line contained
  finally
    let b:current_syntax = save_current_syntax
  endtry
endfunction"}}}

function! s:source_line.hooks.on_post_filter(args, context) abort "{{{
  for candidate in a:context.candidates
    let candidate.is_multiline = 1
    let candidate.action__col_pattern = a:context.source__input
    let candidate.action__buffer_nr = candidate.source__info[0]
    let candidate.action__line = candidate.source__info[1][0]
    let candidate.action__text = candidate.source__info[1][1]
  endfor
endfunction"}}}

function! s:source_line.gather_candidates(args, context) abort "{{{
  let direction = a:context.source__direction
  let start = a:context.source__linenr

  let _ = s:get_context_lines(a:context, direction, start)

  let a:context.source__format =
        \ (len(a:context.source__bufnrs) > 1) ?
        \ '%s:%4s: %s' :
        \ '%' . strlen(len(_)) . 'd: %s'

  return direction ==# 'backward' ? reverse(_) : _
endfunction"}}}

function! s:source_line.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return s:supported_search_direction
endfunction"}}}

function! s:source_line.source__converter(candidates, context) abort "{{{
  if len(a:context.source__bufnrs) > 1
    for candidate in a:candidates
      let candidate.abbr = printf(a:context.source__format,
            \  unite#util#substitute_path_separator(
            \     fnamemodify(bufname(candidate.source__info[0]), ':.')),
            \ candidate.source__info[1][0],
            \ substitute(candidate.source__info[1][1], '\s\+$', '', ''))
    endfor
  else
    for candidate in a:candidates
      let candidate.abbr = printf(a:context.source__format,
            \ candidate.source__info[1][0],
            \ substitute(candidate.source__info[1][1], '\s\+$', '', ''))
    endfor
  endif

  return a:candidates
endfunction"}}}

let s:source_line.converters = [s:source_line.source__converter]
"}}}

" Misc. "{{{
function! s:on_gather_candidates(direction, context, start, max) abort "{{{
  let candidates = []
  for bufnr in a:context.source__bufnrs
    " source__info = [bufnr, [line, text]]
    let candidates += map(s:get_lines(a:context, a:direction,
          \ bufnr, a:start, a:max), "{
          \ 'word' : v:val[1],
          \ 'source__info' : [bufnr, v:val],
          \ }")
  endfor

  return candidates
endfunction"}}}
function! s:get_lines(context, direction, bufnr, start, max) abort "{{{
  let [start, end] =
        \ a:direction ==# 'forward' ?
        \ [a:start, (a:max == 0 ? '$' : a:start + a:max - 1)] :
        \ [((a:max == 0 || a:start == a:max) ?
        \    1 : a:start - a:max), a:start]

  let _ = []
  let linenr = start
  let input = tolower(a:context.source__input)
  let is_expr = input =~ '[~\\.^$\[\]*]'
  for line in getbufline(a:bufnr, start, end)
    if input == ''
          \ || (!is_expr && stridx(tolower(line), input) >= 0)
          \ || line =~? input
      call add(_, [linenr, line])
    endif

    let linenr += 1
  endfor

  return _
endfunction"}}}

function! s:get_context_lines(context, direction, start) abort "{{{
  if a:direction !=# 'forward' && a:direction !=# 'backward'
    let lines = s:on_gather_candidates('forward', a:context, 1, 0)
  else
    let lines = s:on_gather_candidates(a:direction, a:context, a:start, 0)

    if a:context.source__wrap
      let start = ((a:direction ==# 'backward') ?
            \       1 : a:context.source__linemax)
      let max = ((a:direction ==# 'backward') ?
            \       a:context.source__linenr-1 :
            \       a:context.source__linemax-a:context.source__linenr-1)
      if max != 0
        let lines += s:on_gather_candidates(a:direction, a:context, start, max)
      endif
    endif
  endif

  return lines
endfunction"}}}
function! s:dummy_loading(bufnrs) abort "{{{
  let load_bufnrs = filter(copy(a:bufnrs), '!bufloaded(v:val)')
  if empty(load_bufnrs)
    return
  endif

  let prev_bufnr = bufnr('%')
  try
    silent bufdo echo
  finally
    execute 'buffer' prev_bufnr
  endtry
endfunction"}}}
"}}}

" vim: foldmethod=marker
