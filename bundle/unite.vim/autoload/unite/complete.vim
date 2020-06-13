"=============================================================================
" FILE: complete.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#complete#source(arglead, cmdline, cursorpos) abort "{{{
  let ret = unite#helper#parse_options_args(a:cmdline)[0]
  let source_name = ret[-1][0]
  let source_args = ret[-1][1:]

  let _ = []

  if a:arglead !~ ':'
    " Option names completion.
    let _ += copy(unite#variables#options())

    " Source name completion.
    if mode() ==# 'c' || unite#util#is_cmdwin() || &l:filetype ==# 'unite'
      let _ += keys(filter(unite#init#_sources([], ''),
            \ 'v:val.is_listed'))
    endif
  else
    " Add "{source-name}:".
    let _  = map(_, 'source_name.":".v:val')
  endif

  if source_name != '' && (mode() ==# 'c' ||
        \ unite#util#is_cmdwin() || &l:filetype ==# 'unite')
    " Source args completion.
    let args = source_name . ':' . join(source_args[: -2], ':')
    if args !~ ':$'
      let args .= ':'
    endif

    let _ += map(unite#args_complete(
          \ [insert(copy(source_args), source_name)],
          \ join(source_args, ':'), args, a:cursorpos),
          \ "args . escape(v:val, ':')")
  endif

  return sort(filter(_, 'stridx(v:val, a:arglead) == 0'))
endfunction"}}}

function! unite#complete#buffer_name(arglead, cmdline, cursorpos) abort "{{{
  let _ = map(filter(range(1, bufnr('$')),
        \ 'getbufvar(v:val, "&filetype") ==# "unite"'),
        \ 'getbufvar(v:val, "unite").buffer_name')
  let _ += unite#variables#options()

  return filter(_, printf('stridx(v:val, %s) == 0', string(a:arglead)))
endfunction"}}}

function! unite#complete#vimfiler(sources, arglead, cmdline, cursorpos) abort "{{{
  let context = {}
  let context = unite#init#_context(context,
        \ unite#helper#get_source_names(a:sources))
  let context.unite__is_interactive = 0
  let context.unite__is_complete = 1

  try
    call unite#init#_current_unite(a:sources, context)
  catch /^unite.vim: Invalid /
    return
  endtry

  let _ = []
  for source in unite#loaded_sources_list()
    if has_key(source, 'vimfiler_complete')
      let _ += source.vimfiler_complete(
            \ source.args, context, a:arglead, a:cmdline, a:cursorpos)
    endif
  endfor

  return _
endfunction"}}}

function! unite#complete#args(sources, arglead, cmdline, cursorpos) abort "{{{
  let context = {}
  let context = unite#init#_context(context,
        \ unite#helper#get_source_names(a:sources))

  let save_interactive = context.unite__is_interactive
  let save_is_complete = context.unite__is_complete
  try
    let context.unite__is_interactive = 0
    let context.unite__is_complete = 1

    try
      call unite#init#_current_unite(a:sources, context)
    catch /^unite.vim: Invalid /
      return []
    endtry

    let _ = []

    let args = unite#helper#parse_options_args(a:cmdline)[0]
    for source in unite#init#_loaded_sources(args, context)
      if has_key(source, 'complete')
        let _ += source.complete(
              \ source.args, context, a:arglead, a:cmdline, a:cursorpos)
      endif
    endfor
  finally
    let context.unite__is_interactive = save_interactive
    let context.unite__is_complete = save_is_complete
  endtry

  return _
endfunction"}}}

function! unite#complete#gather(candidates, input) abort "{{{
  return unite#util#has_lua() ?
        \ unite#complete#gather_lua(a:candidates, a:input) :
        \ unite#complete#gather_vim(a:candidates, a:input)
endfunction"}}}

function! unite#complete#gather_vim(candidates, input) abort "{{{
  let dup = {}
  let _ = []
  let search_input = tolower(a:input)
  let len_input = len(a:input)
  for candidate in a:candidates
    let start = match(candidate.word, '\h\w*')
    while start >= 0
      let end = matchend(candidate.word, '\h\w*', start)
      let str = candidate.word[start : end -1]
      if len(str) > len_input
            \ && stridx(tolower(str), search_input) == 0
            \ && !has_key(dup, str)
        let dup[str] = 1
        call add(_, str)
      endif

      let start = match(candidate.word, '\h\w*', end)
    endwhile
  endfor

  call add(_, a:input)

  return _
endfunction"}}}

function! unite#complete#gather_lua(candidates, input) abort "{{{
  let _ = []

  lua << EOF
do
  local dup = {}
  local _ = vim.eval('_')
  local candidates = vim.eval('a:candidates')
  local len_input = vim.eval('len(a:input)')
  local search_input = vim.eval('tolower(a:input)')
  for i = 0, #candidates-1, 1 do
    local start_index, end_index = string.find(
         candidates[i].word, '[a-zA-Z_][0-9a-zA-Z_]*')

    while start_index ~= nil and start_index >= 1 do
      local str = string.sub(candidates[i].word, start_index, end_index)

      if string.len(str) > len_input
            and string.sub(string.lower(str), 1, len_input) == search_input
            and dup[str] == nil then
        dup[str] = 1
        _:add(str)
      end

      start_index = end_index + 1
      start_index, end_index = string.find(
          candidates[i].word, '[a-zA-Z_][0-9a-zA-Z_]*', start_index)
    end
  end
end
EOF

  return _
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
