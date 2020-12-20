" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html

scriptencoding utf-8

let s:show_message = get(g:, 'airline#extensions#whitespace#show_message', 1)
let s:symbol = get(g:, 'airline#extensions#whitespace#symbol', g:airline_symbols.whitespace)
let s:default_checks = ['indent', 'trailing', 'mixed-indent-file', 'conflicts']

let s:enabled = get(g:, 'airline#extensions#whitespace#enabled', 1)
let s:skip_check_ft = {'make': ['indent', 'mixed-indent-file']}

function! s:check_mixed_indent()
  let indent_algo = get(g:, 'airline#extensions#whitespace#mixed_indent_algo', 0)
  if indent_algo == 1
    " [<tab>]<space><tab>
    " spaces before or between tabs are not allowed
    let t_s_t = '(^\t* +\t\s*\S)'
    " <tab>(<space> x count)
    " count of spaces at the end of tabs should be less than tabstop value
    let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
    return search('\v' . t_s_t . '|' . t_l_s, 'nw')
  elseif indent_algo == 2
    return search('\v(^\t* +\t\s*\S)', 'nw')
  else
    return search('\v(^\t+ +)|(^ +\t+)', 'nw')
  endif
endfunction

function! s:check_mixed_indent_file()
  let c_like_langs = get(g:, 'airline#extensions#c_like_langs',
        \ [ 'arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php' ])
  if index(c_like_langs, &ft) > -1
    " for C-like languages: allow /** */ comment style with one space before the '*'
    let head_spc = '\v(^ +\*@!)'
  else
    let head_spc = '\v(^ +)'
  endif
  let indent_tabs = search('\v(^\t+)', 'nw')
  let indent_spc  = search(head_spc, 'nw')
  if indent_tabs > 0 && indent_spc > 0
    return printf("%d:%d", indent_tabs, indent_spc)
  else
    return ''
  endif
endfunction

function! s:conflict_marker()
  " Checks for git conflict markers
  let annotation = '\%([0-9A-Za-z_.:]\+\)\?'
  if &ft is# 'rst'
    " rst filetypes use '=======' as header
    let pattern = '^\%(\%(<\{7} '.annotation. '\)\|\%(>\{7\} '.annotation.'\)\)$'
  else
    let pattern = '^\%(\%(<\{7} '.annotation. '\)\|\%(=\{7\}\)\|\%(>\{7\} '.annotation.'\)\)$'
  endif
  return search(pattern, 'nw')
endfunction

function! airline#extensions#whitespace#check()
  let max_lines = get(g:, 'airline#extensions#whitespace#max_lines', 20000)
  if &readonly || !&modifiable || !s:enabled || line('$') > max_lines
          \ || get(b:, 'airline_whitespace_disabled', 0)
    return ''
  endif
  let skip_check_ft = extend(s:skip_check_ft,
        \ get(g:, 'airline#extensions#whitespace#skip_indent_check_ft', {}), 'force')

  if !exists('b:airline_whitespace_check')
    let b:airline_whitespace_check = ''
    let checks = get(b:, 'airline_whitespace_checks', get(g:, 'airline#extensions#whitespace#checks', s:default_checks))

    let trailing = 0
    let check = 'trailing'
    if index(checks, check) > -1 && index(get(skip_check_ft, &ft, []), check) < 0
      try
        let regexp = get(g:, 'airline#extensions#whitespace#trailing_regexp', '\s$')
        let trailing = search(regexp, 'nw')
      catch
        call airline#util#warning(printf('Whitespace: error occurred evaluating "%s"', regexp))
        echomsg v:exception
        return ''
      endtry
    endif

    let mixed = 0
    let check = 'indent'
    if index(checks, check) > -1 && index(get(skip_check_ft, &ft, []), check) < 0
      let mixed = s:check_mixed_indent()
    endif

    let mixed_file = ''
    let check = 'mixed-indent-file'
    if index(checks, check) > -1 && index(get(skip_check_ft, &ft, []), check) < 0
      let mixed_file = s:check_mixed_indent_file()
    endif

    let long = 0
    if index(checks, 'long') > -1 && &tw > 0
      let long = search('\%>'.&tw.'v.\+', 'nw')
    endif

    let conflicts = 0
    if index(checks, 'conflicts') > -1
      let conflicts = s:conflict_marker()
    endif

    if trailing != 0 || mixed != 0 || long != 0 || !empty(mixed_file) || conflicts != 0
      let b:airline_whitespace_check = s:symbol
      if strlen(s:symbol) > 0
        let space = (g:airline_symbols.space)
      else
        let space = ''
      endif

      if s:show_message
        if trailing != 0
          let trailing_fmt = get(g:, 'airline#extensions#whitespace#trailing_format', '[%s]trailing')
          let b:airline_whitespace_check .= space.printf(trailing_fmt, trailing)
        endif
        if mixed != 0
          let mixed_indent_fmt = get(g:, 'airline#extensions#whitespace#mixed_indent_format', '[%s]mixed-indent')
          let b:airline_whitespace_check .= space.printf(mixed_indent_fmt, mixed)
        endif
        if long != 0
          let long_fmt = get(g:, 'airline#extensions#whitespace#long_format', '[%s]long')
          let b:airline_whitespace_check .= space.printf(long_fmt, long)
        endif
        if !empty(mixed_file)
          let mixed_indent_file_fmt = get(g:, 'airline#extensions#whitespace#mixed_indent_file_format', '[%s]mix-indent-file')
          let b:airline_whitespace_check .= space.printf(mixed_indent_file_fmt, mixed_file)
        endif
        if conflicts != 0
          let conflicts_fmt = get(g:, 'airline#extensions#whitespace#conflicts_format', '[%s]conflicts')
          let b:airline_whitespace_check .= space.printf(conflicts_fmt, conflicts)
        endif
      endif
    endif
  endif
  return airline#util#shorten(b:airline_whitespace_check, 120, 9)
endfunction

function! airline#extensions#whitespace#toggle()
  if s:enabled
    augroup airline_whitespace
      autocmd!
    augroup END
    augroup! airline_whitespace
    let s:enabled = 0
  else
    call airline#extensions#whitespace#init()
    let s:enabled = 1
  endif

  if exists("g:airline#extensions#whitespace#enabled")
    let g:airline#extensions#whitespace#enabled = s:enabled
    if s:enabled && match(g:airline_section_warning, '#whitespace#check') < 0
      let g:airline_section_warning .= airline#section#create(['whitespace'])
      call airline#update_statusline()
    endif
  endif
  call airline#util#warning(printf('Whitespace checking: %s',(s:enabled ? 'Enabled' : 'Disabled')))
endfunction

function! airline#extensions#whitespace#disable()
  if s:enabled
    call airline#extensions#whitespace#toggle()
  endif
endfunction

function! airline#extensions#whitespace#init(...)
  call airline#parts#define_function('whitespace', 'airline#extensions#whitespace#check')

  unlet! b:airline_whitespace_check
  augroup airline_whitespace
    autocmd!
    autocmd CursorHold,BufWritePost * call <sid>ws_refresh()
  augroup END
endfunction

function! s:ws_refresh()
  if get(b:, 'airline_ws_changedtick', 0) == b:changedtick
    return
  endif
  unlet! b:airline_whitespace_check
  if get(g:, 'airline_skip_empty_sections', 0)
    exe ':AirlineRefresh!'
  endif
  let b:airline_ws_changedtick = b:changedtick
endfunction
