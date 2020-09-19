" MIT License. Copyright (c) 2013-2019 Bjorn Neergaard, hallettj et al.
" Plugin: https://github.com/autozimu/LanguageClient-neovim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:error_symbol = get(g:, 'airline#extensions#languageclient#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#languageclient#warning_symbol', 'W:')
let s:show_line_numbers = get(g:, 'airline#extensions#languageclient#show_line_numbers', 1)

" Severity codes from the LSP spec
let s:severity_error = 1
let s:severity_warning = 2
let s:severity_info = 3
let s:severity_hint = 4

" After each LanguageClient state change `s:diagnostics` will be populated with
" a map from file names to lists of errors, warnings, informational messages,
" and hints.
let s:diagnostics = {}

function! s:languageclient_refresh()
  if get(g:, 'airline_skip_empty_sections', 0)
    exe ':AirlineRefresh!'
  endif
endfunction

function! s:record_diagnostics(state)
  " The returned message might not have the 'result' key
  if has_key(a:state, 'result')
    let result = json_decode(a:state.result)
    let s:diagnostics = result.diagnostics
  endif
  call s:languageclient_refresh()
endfunction

function! s:get_diagnostics()
  call LanguageClient#getState(function("s:record_diagnostics"))
endfunction

function! s:diagnostics_for_buffer()
  return get(s:diagnostics, expand('%:p'), [])
endfunction

function! s:airline_languageclient_count(cnt, symbol)
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! s:airline_languageclient_get_line_number(type) abort
  let linenumber_of_first_problem = 0
  for d in s:diagnostics_for_buffer()
    if has_key(d, 'severity') && d.severity == a:type
      let linenumber_of_first_problem = d.range.start.line
      break
    endif
  endfor

  if linenumber_of_first_problem == 0
    return ''
  endif

  let open_lnum_symbol  = get(g:, 'airline#extensions#languageclient#open_lnum_symbol', '(L')
  let close_lnum_symbol = get(g:, 'airline#extensions#languageclient#close_lnum_symbol', ')')

  return open_lnum_symbol . linenumber_of_first_problem . close_lnum_symbol
endfunction

function! airline#extensions#languageclient#get(type)
  let is_err = a:type == s:severity_error
  let symbol = is_err ? s:error_symbol : s:warning_symbol

  let cnt = 0
  for d in s:diagnostics_for_buffer()
    if has_key(d, 'severity') && d.severity == a:type
      let cnt += 1
    endif
  endfor

  if cnt == 0
    return ''
  endif

  if s:show_line_numbers == 1
    return s:airline_languageclient_count(cnt, symbol) . <sid>airline_languageclient_get_line_number(a:type)
  else
    return s:airline_languageclient_count(cnt, symbol)
  endif
endfunction

function! airline#extensions#languageclient#get_warning()
  return airline#extensions#languageclient#get(s:severity_warning)
endfunction

function! airline#extensions#languageclient#get_error()
  return airline#extensions#languageclient#get(s:severity_error)
endfunction

function! airline#extensions#languageclient#init(ext)
  call airline#parts#define_function('languageclient_error_count', 'airline#extensions#languageclient#get_error')
  call airline#parts#define_function('languageclient_warning_count', 'airline#extensions#languageclient#get_warning')
  augroup airline_languageclient
    autocmd!
    autocmd User LanguageClientDiagnosticsChanged call <sid>get_diagnostics()
  augroup END
endfunction
