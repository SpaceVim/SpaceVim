"=============================================================================
" FILE: converter_relative_word.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_relative_word#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_relative_word',
      \ 'description' : 'relative path word converter',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  if a:context.input =~ '^\%(/\|\a\+:/\)'
    " Use full path.
    return unite#filters#converter_full_path#define().filter(
          \ a:candidates, a:context)
  endif

  try
    let directory = unite#util#substitute_path_separator(getcwd())
    let old_dir = directory
    if has_key(a:context, 'source__directory')
      let directory = substitute(a:context.source__directory, '*', '', 'g')

      if directory !=# old_dir && isdirectory(directory)
            \ && a:context.input == ''
        call unite#util#lcd(directory)
      endif
    endif

    if unite#util#has_lua()
      return unite#filters#converter_relative_word#lua(
            \ a:candidates, directory)
    endif

    for candidate in a:candidates
      let candidate.word = unite#util#substitute_path_separator(
            \ fnamemodify(get(candidate, 'action__path',
            \     candidate.word), ':~:.'))
    endfor
  finally
    if has_key(a:context, 'source__directory')
          \ && directory !=# old_dir
      call unite#util#lcd(old_dir)
    endif
  endtry

  return a:candidates
endfunction"}}}

function! unite#filters#converter_relative_word#lua(candidates, cwd) abort "{{{
  let cwd = a:cwd
  if cwd != '/' && cwd[-1:] != '/'
    let cwd .= '/'
  endif

  lua << EOF
  do
  local candidates = vim.eval('a:candidates')
  local cwd = vim.eval('cwd')
  local home = vim.eval('unite#util#substitute_path_separator(expand("~/"))')
  for candidate in candidates() do
    local path = candidate.action__path or candidate.word
    if path:find(cwd, 1, true) == 1 then
      candidate.word = path:sub(cwd:len() + 1)
    elseif path:find(home, 1, true) == 1 then
      candidate.word = path:sub(home:len() + 1)
    end
  end
end
EOF

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
