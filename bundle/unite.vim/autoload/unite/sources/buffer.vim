"=============================================================================
" FILE: buffer.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
call unite#util#set_default(
      \ 'g:unite_source_buffer_time_format',
      \ '(%Y/%m/%d %H:%M:%S) ')
"}}}

function! unite#sources#buffer#define() abort "{{{
  return [s:source_buffer_all, s:source_buffer_tab]
endfunction"}}}

let s:source_buffer_all = {
      \ 'name' : 'buffer',
      \ 'description' : 'candidates from buffer list',
      \ 'syntax' : 'uniteSource__Buffer',
      \ 'hooks' : {},
      \ 'default_kind' : 'buffer',
      \}

function! s:source_buffer_all.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_bang =
        \ (get(a:args, 0, '') ==# '!')
  let a:context.source__is_question =
        \ (get(a:args, 0, '') ==# '?')
  let a:context.source__is_plus =
        \ (get(a:args, 0, '') ==# '+')
  let a:context.source__is_minus =
        \ (get(a:args, 0, '') ==# '-')
  let a:context.source__is_terminal =
        \ (get(a:args, 0, '') ==# 't')
  let a:context.source__buffer_list =
        \ s:get_buffer_list(a:context.source__is_bang,
        \                   a:context.source__is_question,
        \                   a:context.source__is_plus,
        \                   a:context.source__is_minus,
        \                   a:context.source__is_terminal)
endfunction"}}}
function! s:source_buffer_all.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__Buffer_Name /[^/ \[\]]\+\s/
        \ contained containedin=uniteSource__Buffer
  highlight default link uniteSource__Buffer_Name Function
  syntax match uniteSource__Buffer_Prefix /\d\+\s\%(\S\+\)\?/
        \ contained containedin=uniteSource__Buffer
  highlight default link uniteSource__Buffer_Prefix Constant
  syntax match uniteSource__Buffer_Info /\[.\{-}\] /
        \ contained containedin=uniteSource__Buffer
  highlight default link uniteSource__Buffer_Info PreProc
  syntax match uniteSource__Buffer_Modified /\[.\{-}+\]/
        \ contained containedin=uniteSource__Buffer
  highlight default link uniteSource__Buffer_Modified Statement
  syntax match uniteSource__Buffer_NoFile /\[nofile\]/
        \ contained containedin=uniteSource__Buffer
  highlight default link uniteSource__Buffer_NoFile Function
  syntax match uniteSource__Buffer_Time /(.\{-}) /
        \ contained containedin=uniteSource__Buffer
  highlight default link uniteSource__Buffer_Time Statement
endfunction"}}}
function! s:source_buffer_all.hooks.on_post_filter(args, context) abort "{{{
  for candidate in a:context.candidates
    let candidate.action__path =
          \ unite#util#substitute_path_separator(
          \       fnamemodify(s:make_word(candidate.action__buffer_nr), ':p'))
    let candidate.action__directory =
          \ unite#helper#get_buffer_directory(candidate.action__buffer_nr)
  endfor
endfunction"}}}

function! s:source_buffer_all.gather_candidates(args, context) abort "{{{
  if a:context.is_redraw
    " Recaching.
    let a:context.source__buffer_list =
          \ s:get_buffer_list(a:context.source__is_bang,
          \                   a:context.source__is_question,
          \                   a:context.source__is_plus,
          \                   a:context.source__is_minus,
          \                   a:context.source__is_terminal)
  endif

  let candidates = map(a:context.source__buffer_list, "{
        \ 'word' : unite#util#substitute_path_separator(
        \         s:make_word(v:val.action__buffer_nr)),
        \ 'abbr' : s:make_abbr(v:val.action__buffer_nr, v:val.source__flags)
        \        . s:format_time(v:val.source__time),
        \ 'action__buffer_nr' : v:val.action__buffer_nr,
        \}")

  return candidates
endfunction"}}}
function! s:source_buffer_all.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return ['!', '?', '+', '-', 't']
endfunction"}}}

let s:source_buffer_tab = deepcopy(s:source_buffer_all)
let s:source_buffer_tab.name = 'buffer_tab'
let s:source_buffer_tab.description =
      \ 'candidates from buffer list in current tab'

function! s:source_buffer_tab.gather_candidates(args, context) abort "{{{
  if a:context.is_redraw
    " Recaching.
    let a:context.source__buffer_list =
          \ s:get_buffer_list(a:context.source__is_bang,
          \                   a:context.source__is_question,
          \                   a:context.source__is_plus,
          \                   a:context.source__is_minus,
          \                   a:context.source__is_terminal)
  endif

  if !exists('g:loaded_tabpagebuffer') && !exists('g:CtrlSpaceLoaded')
    call unite#print_source_message(
          \ 'tabpagebuffer or ctrlspace plugin is not installed.', self.name)
    return []
  endif

  if exists('t:tabpagebuffer')
    let bufferlist = t:tabpagebuffer
  elseif exists('t:CtrlSpaceList')
    let bufferlist = t:CtrlSpaceList
  else
    return []
  endif

  let list = filter(copy(a:context.source__buffer_list),
        \ 'has_key(bufferlist, v:val.action__buffer_nr)')

  let candidates = map(list, "{
        \ 'word' : unite#util#substitute_path_separator(
        \       fnamemodify(s:make_word(v:val.action__buffer_nr), ':p')),
        \ 'abbr' : s:make_abbr(v:val.action__buffer_nr, v:val.source__flags)
        \        . s:format_time(v:val.source__time),
        \ 'action__buffer_nr' : v:val.action__buffer_nr,
        \}")

  return candidates
endfunction"}}}

" Misc
function! s:make_word(bufnr) abort "{{{
  let filetype = getbufvar(a:bufnr, '&filetype')
  if filetype ==# 'vimfiler'
    let path = unite#util#substitute_path_separator(
          \ simplify(getbufvar(a:bufnr, 'vimfiler').current_dir))
    let path = unite#util#substitute_path_separator(
          \ simplify(bufname(a:bufnr))) . ' ' . path . '/'
  elseif filetype ==# 'vimshell'
    let path = unite#util#substitute_path_separator(
          \ simplify(getbufvar(a:bufnr, 'vimshell').current_dir))
    let path = unite#util#substitute_path_separator(
          \ simplify(bufname(a:bufnr))) . ' ' . path . '/'
  else
    let path = unite#util#substitute_path_separator(
          \ simplify(bufname(a:bufnr)))
  endif

  return path
endfunction"}}}
function! s:make_abbr(bufnr, flags) abort "{{{
  let bufname = fnamemodify(bufname(a:bufnr), ':t')
  if bufname == ''
    let bufname = bufname(a:bufnr)
  endif

  let filetype = getbufvar(a:bufnr, '&filetype')
  if filetype ==# 'vimfiler' || filetype ==# 'vimshell'
    if filetype ==# 'vimfiler'
      let vimfiler = getbufvar(a:bufnr, 'vimfiler')
      let path = vimfiler.current_dir
      if vimfiler.source !=# 'file'
        let path = vimfiler.source . ':' . path
      endif
    else
      let path = simplify(getbufvar(a:bufnr, 'vimshell').current_dir)
    endif

    let path = printf('%s [%s : %s]', bufname, path, filetype)
  else
    let path = bufname(a:bufnr) == '' ? 'No Name' :
          \ simplify(fnamemodify(bufname(a:bufnr), ':~:.'))
    if a:flags != ''
      " Format flags so that buffer numbers are aligned on the left.
      " example: '42 a% +' => '42 a%+ '
      "          '3 h +'   => ' 3 h+  '
      let nowhitespace = substitute(a:flags, '\s*', '', 'g')
      let path = substitute(nowhitespace, '\(\d\+\)\(.*\)',
            \ '\=printf("%*s %-*s", len(bufnr("$")),
            \    submatch(1), 4, submatch(2))', 'g') . path
    endif

    if filetype != ''
      let path .= ' [' . filetype . ']'
    endif
  endif

  return (getbufvar(a:bufnr, '&buftype') =~# 'nofile' ? '[nofile] ' : '' ) .
         \ unite#util#substitute_path_separator(path) . ' '
endfunction"}}}
function! s:compare(candidate_a, candidate_b) abort "{{{
  return a:candidate_a.action__buffer_nr == unite#get_current_unite().prev_bufnr ?  1 :
      \ (a:candidate_b.action__buffer_nr == unite#get_current_unite().prev_bufnr ? -1 :
      \ a:candidate_b.source__time - a:candidate_a.source__time)
endfunction"}}}
function! s:get_buffer_list(is_bang, is_question, is_plus, is_minus, is_terminal) abort "{{{
  " Get :ls flags.
  let flag_dict = {}
  for out in map(split(unite#util#redir('ls'), '\n'), 'split(v:val)')
    let flag_dict[out[0]] = matchstr(join(out), '^.*\ze\s\+"')
  endfor

  " Make buffer list.
  let list = []
  let bufnr = 1
  let buffer_list = unite#sources#buffer#variables#get_buffer_list()
  while bufnr <= bufnr('$')
    if s:is_listed(a:is_bang, a:is_question, a:is_plus, a:is_minus, a:is_terminal, bufnr)
      let dict = get(buffer_list, bufnr, {
            \ 'action__buffer_nr' : bufnr,
            \ 'source__time' : 0,
            \ })
      let dict.source__flags = get(flag_dict, bufnr, '')

      call add(list, dict)
    endif
    let bufnr += 1
  endwhile

  call sort(list, 's:compare')

  return list
endfunction"}}}

function! s:is_listed(is_bang, is_question, is_plus, is_minus, is_terminal, bufnr) abort "{{{
  let bufname = bufname(a:bufnr)
  let buftype = getbufvar(a:bufnr, '&buftype')
  return bufexists(a:bufnr) &&
        \ (a:is_question ? !buflisted(a:bufnr) :
        \    (a:is_bang || buflisted(a:bufnr)))
        \ && (!a:is_plus || getbufvar(a:bufnr, '&mod'))
        \ && (!a:is_minus || buftype == ''
        \                     && bufname != ''
        \                     && !isdirectory(bufname))
        \ && (!a:is_terminal || buftype ==# 'terminal' )
        \ && (getbufvar(a:bufnr, '&filetype') !=# 'unite'
        \      || getbufvar(a:bufnr, 'unite').buffer_name !=#
        \         unite#get_current_unite().buffer_name)
endfunction"}}}

function! s:format_time(time) abort "{{{
  if empty(a:time)
    return ''
  endif
  return strftime(g:unite_source_buffer_time_format, a:time)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
