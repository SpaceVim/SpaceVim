"=============================================================================
" FILE: output_shellcmd.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
let g:unite_source_output_shellcmd_colors =
      \ get(g:, 'unite_source_output_shellcmd_colors', [
        \ '#6c6c6c', '#ff6666', '#66ff66', '#ffd30a',
        \ '#1e95fd', '#ff13ff', '#1bc8c8', '#c0c0c0',
        \ '#383838', '#ff4444', '#44ff44', '#ffb30a',
        \ '#6699ff', '#f820ff', '#4ae2e2', '#ffffff',
        \])
"}}}

function! unite#sources#output_shellcmd#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'output/shellcmd',
      \ 'description' : 'candidates from shell command output',
      \ 'default_action' : 'yank',
      \ 'default_kind' : 'word',
      \ 'syntax' : 'uniteSource__Output_Shellcmd',
      \ 'hooks' : {},
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  let command = join(filter(copy(a:args), "v:val !=# '!'"))
  if command == ''
    let command = unite#util#input(
          \ 'Please input shell command: ', '', 'shellcmd')
    redraw
  endif
  let a:context.source__command = command
  let a:context.source__is_dummy =
        \ (get(a:args, -1, '') ==# '!')

  if !a:context.source__is_dummy
    call unite#print_source_message(
          \ 'command: ' . command, s:source.name)
  endif
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  let highlight_table = {
        \ '0' : ' cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE',
        \ '1' : ' cterm=BOLD gui=BOLD',
        \ '3' : ' cterm=ITALIC gui=ITALIC',
        \ '4' : ' cterm=UNDERLINE gui=UNDERLINE',
        \ '7' : ' cterm=REVERSE gui=REVERSE',
        \ '8' : ' ctermfg=0 ctermbg=0 guifg=#000000 guibg=#000000',
        \ '9' : ' gui=UNDERCURL',
        \ '21' : ' cterm=UNDERLINE gui=UNDERLINE',
        \ '22' : ' gui=NONE',
        \ '23' : ' gui=NONE',
        \ '24' : ' gui=NONE',
        \ '25' : ' gui=NONE',
        \ '27' : ' gui=NONE',
        \ '28' : ' ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE',
        \ '29' : ' gui=NONE',
        \ '39' : ' ctermfg=NONE guifg=NONE',
        \ '49' : ' ctermbg=NONE guibg=NONE',
        \}
  for color in range(30, 37)
    " Foreground color pattern.
    let highlight_table[color] = printf(' ctermfg=%d guifg=%s',
          \ color - 30, g:unite_source_output_shellcmd_colors[color - 30])
    for color2 in [1, 3, 4, 7]
      " Type;Foreground color pattern
      let highlight_table[color2 . ';' . color] =
            \ highlight_table[color2] . highlight_table[color]
    endfor
  endfor
  for color in range(40, 47)
    " Background color pattern.
    let highlight_table[color] = printf(' ctermbg=%d guibg=%s',
          \ color - 40, g:unite_source_output_shellcmd_colors[color - 40])
    for color2 in range(30, 37)
      " Foreground;Background color pattern.
      let highlight_table[color2 . ';' . color] =
            \ highlight_table[color2] . highlight_table[color]
    endfor
  endfor

  syntax match uniteSource__Output_Shellcmd_Conceal
        \ contained conceal    '\e\[[0-9;]*m'
        \ containedin=uniteSource__Output_Shellcmd

  syntax match uniteSource__Output_Shellcmd_Conceal
        \ contained conceal    '\e\[?1h'
        \ containedin=uniteSource__Output_Shellcmd

  syntax match uniteSource__Output_Shellcmd_Ignore
        \ contained conceal    '\e\[?\d[hl]\|\e=\r\|\r\|\e>'
        \ containedin=uniteSource__Output_Shellcmd

  for [key, highlight] in items(highlight_table)
    let syntax_name = 'uniteSource__Output_Shellcmd_Color'
          \ . substitute(key, ';', '_', 'g')
    let syntax_command = printf('start=+\e\[0\?%sm+ end=+\ze\e[\[0*m]\|$+ ' .
          \ 'contains=uniteSource__Output_Shellcmd_Conceal ' .
          \ 'containedin=uniteSource__Output_Shellcmd oneline', key)

    execute 'syntax region' syntax_name syntax_command
    execute 'highlight' syntax_name highlight
  endfor
endfunction"}}}
function! s:source.gather_candidates(args, context) abort "{{{
  if !unite#util#has_vimproc()
    call unite#print_source_message(
          \ 'vimproc plugin is not installed.', self.name)
    let a:context.is_async = 0
    return []
  endif

  if a:context.is_redraw
    let a:context.is_async = 1
  endif

  let cwd = getcwd()
  try
    if a:context.path != ''
      call unite#util#lcd(a:context.path)
    endif
    let a:context.source__proc = vimproc#plineopen2(
          \ vimproc#util#iconv(
          \   a:context.source__command, &encoding, 'char'), 1)
  catch
    call unite#util#lcd(cwd)
    call unite#print_error(v:exception)
    let a:context.is_async = 0
    return []
  endtry

  return self.async_gather_candidates(a:args, a:context)
endfunction"}}}
function! s:source.async_gather_candidates(args, context) abort "{{{
  let stdout = a:context.source__proc.stdout
  if stdout.eof
    " Disable async.
    let a:context.is_async = 0
    call a:context.source__proc.waitpid()
  endif

  let lines = map(unite#util#read_lines(stdout, 1000),
          \ "substitute(unite#util#iconv(v:val, 'char', &encoding),
          \   '\\e\\[\\u', '', 'g')")
  " echomsg string(lines)

  return map(lines, "{
        \ 'word' : substitute(v:val, '\\e\\[[0-9;]*m', '', 'g'),
        \ 'abbr' : v:val,
        \ 'is_dummy' : a:context.source__is_dummy,
        \ }")
endfunction"}}}
function! s:source.hooks.on_close(args, context) abort "{{{
  if has_key(a:context, 'source__proc')
    call a:context.source__proc.kill()
  endif
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
