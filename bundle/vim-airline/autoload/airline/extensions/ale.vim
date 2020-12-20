" MIT License. Copyright (c) 2013-2019 Bjorn Neergaard, w0rp et al.
" Plugin: https://github.com/dense-analysis/ale
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_ale_dont_use_this_in_other_plugins_please', 0)
  finish
endif

function! s:airline_ale_count(cnt, symbol)
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! s:legacy_airline_ale_get_line_number(cnt, type) abort
  " Before ALE introduced the FirstProblem API function, this is how
  " airline would get the line numbers:
  " 1. Get the whole loclist; 2. Filter it for the desired problem type.
  " 3. Return the line number of the first element in the filtered list.
  if a:cnt == 0
    return ''
  endif

  let buffer       = bufnr('')
  let problem_type = (a:type ==# 'error') ? 'E' : 'W'
  let problems     = copy(ale#engine#GetLoclist(buffer))

  call filter(problems, 'v:val.bufnr is buffer && v:val.type is# problem_type')

  if empty(problems)
    return ''
  endif

  let open_lnum_symbol  = get(g:, 'airline#extensions#ale#open_lnum_symbol', '(L')
  let close_lnum_symbol = get(g:, 'airline#extensions#ale#close_lnum_symbol', ')')

  return open_lnum_symbol . problems[0].lnum . close_lnum_symbol
endfunction

function! s:new_airline_ale_get_line_number(cnt, type) abort
  " The FirstProblem call in ALE is a far more efficient way
  " of obtaining line number data. If the installed ALE supports
  " it, we should use this method of getting line data.
  if a:cnt == 0
    return ''
  endif
  let l:buffer = bufnr('')

  " Try to get the first error from ALE.
  let l:result = ale#statusline#FirstProblem(l:buffer, a:type)
  if empty(l:result)
    " If there are no errors then try and check for style errors.
    let l:result =  ale#statusline#FirstProblem(l:buffer, 'style_' . a:type)
  endif

  if empty(l:result)
      return ''
  endif

  let l:open_lnum_symbol  =
    \ get(g:, 'airline#extensions#ale#open_lnum_symbol', '(L')
  let l:close_lnum_symbol =
    \ get(g:, 'airline#extensions#ale#close_lnum_symbol', ')')

  return open_lnum_symbol . l:result.lnum . close_lnum_symbol
endfunction

function! s:airline_ale_get_line_number(cnt, type) abort
  " Use the new ALE statusline API function if it is available.
  if exists("*ale#statusline#FirstProblem")
    return s:new_airline_ale_get_line_number(a:cnt, a:type)
  endif

  return s:legacy_airline_ale_get_line_number(a:cnt, a:type)
endfunction

function! airline#extensions#ale#get(type)
  if !exists(':ALELint')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#ale#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#ale#warning_symbol', 'W:')
  let checking_symbol = get(g:, 'airline#extensions#ale#checking_symbol', '...')
  let show_line_numbers = get(g:, 'airline#extensions#ale#show_line_numbers', 1)

  let is_err = a:type ==# 'error'

  if ale#engine#IsCheckingBuffer(bufnr('')) == 1
    return is_err ? '' : checking_symbol
  endif

  let symbol = is_err ? error_symbol : warning_symbol

  let counts = ale#statusline#Count(bufnr(''))
  if type(counts) == type({}) && has_key(counts, 'error')
    " Use the current Dictionary format.
    let errors = counts.error + counts.style_error
    let num = is_err ? errors : counts.total - errors
  else
    " Use the old List format.
    let num = is_err ? counts[0] : counts[1]
  endif

  if show_line_numbers == 1
    return s:airline_ale_count(num, symbol) . <sid>airline_ale_get_line_number(num, a:type)
  else
    return s:airline_ale_count(num, symbol)
  endif
endfunction

function! airline#extensions#ale#get_warning()
  return airline#extensions#ale#get('warning')
endfunction

function! airline#extensions#ale#get_error()
  return airline#extensions#ale#get('error')
endfunction

function! airline#extensions#ale#init(ext)
  call airline#parts#define_function('ale_error_count', 'airline#extensions#ale#get_error')
  call airline#parts#define_function('ale_warning_count', 'airline#extensions#ale#get_warning')
  augroup airline_ale
    autocmd!
    autocmd CursorHold,BufWritePost * call <sid>ale_refresh()
    autocmd User ALEJobStarted,ALELintPost call <sid>ale_refresh()
  augroup END
endfunction

function! s:ale_refresh()
  if get(g:, 'airline_skip_empty_sections', 0)
    exe ':AirlineRefresh!'
  endif
endfunction
