" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" PLugin: https://eclim.org
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':ProjectCreate')
  finish
endif

function! airline#extensions#eclim#creat_line(...)
  if &filetype == "tree"
    let builder = a:1
    call builder.add_section('airline_a', ' Project ')
    call builder.add_section('airline_b', ' %f ')
    call builder.add_section('airline_c', '')
  return 1
  endif
endfunction

function! airline#extensions#eclim#get_warnings()
  " Cache vavlues, so that it isn't called too often
  if exists("s:eclim_errors") &&
    \  get(b:,  'airline_changenr', 0) == changenr()
    return s:eclim_errors
  endif
  let eclimList = eclim#display#signs#GetExisting()
  let s:eclim_errors = ''

  if !empty(eclimList)
    " Remove any non-eclim signs (see eclim#display#signs#Update)
    " First check for just errors since they are more important.
    " If there are no errors, then check for warnings.
    let errorList = filter(copy(eclimList), 'v:val.name =~ "^\\(qf_\\)\\?\\(error\\)$"')

    if (empty(errorList))
      " use the warnings
      call filter(eclimList, 'v:val.name =~ "^\\(qf_\\)\\?\\(warning\\)$"')
      let type = 'W'
    else
      " Use the errors
      let eclimList = errorList
      let type = 'E'
    endif

    if !empty(eclimList)
      let errorsLine = eclimList[0]['line']
      let errorsNumber = len(eclimList)
      let errors = "[Eclim:" . type . " line:".string(errorsLine)." (".string(errorsNumber).")]"
      if !exists(':SyntasticCheck') || SyntasticStatuslineFlag() == ''
        let s:eclim_errors = errors.(g:airline_symbols.space)
      endif
    endif
  endif
  let b:airline_changenr = changenr()
  return s:eclim_errors
endfunction

function! airline#extensions#eclim#init(ext)
  call airline#parts#define_function('eclim', 'airline#extensions#eclim#get_warnings')
  call a:ext.add_statusline_func('airline#extensions#eclim#creat_line')
endfunction
