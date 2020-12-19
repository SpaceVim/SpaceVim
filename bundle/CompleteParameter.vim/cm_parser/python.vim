"==============================================================
"    file: python.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-11 18:11:12
"==============================================================

" pexpect
" interact(self, escape_character=chr(29),             input_filter=None,
" output_filter=None)
function! s:signature(info) "{{{
  let info_lines = split(a:info, '\n')
  let func = ''
  let match = 0
  let l:finish = 0

  if info_lines[0] !~# '('
    if info_lines[0] !~# '```' || len(info_lines) == 1 || info_lines[1] !~# '('
      return func
    endif
  endif

  " there are maybe some () in the parameters
  " if the count of `(` equal to `)` 
  " then the parameters has finished
  for line in info_lines
    for i in range(len(line))
      if line[i] ==# '('
        let match += 1
      elseif line[i] ==# ')'
        let match -= 1
        if match == 0
          let l:finish = 1
          break
        endif
      endif
    endfor
    if l:finish == 0
      let func .= line
    else
      let func .= line[:i]
      break
    endif
  endfor
  return func
endfunction "}}}

function! s:parser0(info) "{{{
  let func = <SID>signature(a:info)

  " remove function name, begin `(` and end `)`
  let param = substitute(func, '\m[^(]*(\(.*\))[^)]*', '\1', '')

  let keep_default_value = get(g:, 'complete_parameter_py_keep_value', 1)
  let remove_default_parameter = get(g:, 'complete_parameter_py_remove_default', 1)

  if !keep_default_value
    " remove `()`
    while param =~# '(.*)'
      let param = substitute(param, '(.*)', '', 'g')
    endwhile
  endif

  " add begin`(` and end`)`
  let param = '(' . param . ')'

  if remove_default_parameter
    let param = substitute(param, '\m\s*,\?\s*\w*\s*=.*', ')', '')
    let param = substitute(param, '\m\s*,\?\s*\.\.\..*', ')', '')
    let param = substitute(param, '\m\s*,\?\s*\*args.*', ')', '')
  elseif !keep_default_value
    let param = substitute(param, '\m\s*=\s*[^,()]*', '', 'g')
  endif

  " remove `[` and `]`
  let param = substitute(param, '\m\[\|\]', '', 'g')

  " remove self,cls
  let param = substitute(param, '\m(\s*\<self\>\s*,\?', '(', '')
  let param = substitute(param, '\m(\s*\<cls\>\s*,\?', '(', '')
  " remove space
  let param = substitute(param, '\m\s\+', ' ', 'g')
  let param = substitute(param, '\m\s,', ',', 'g')

  let param = substitute(param, '\m(\s', '(', '')
  let param = substitute(param, '\m,\s*)', ')', '')
  let param = substitute(param, '\m,\(\S\)', ', \1', 'g')
  return [param]
endfunction "}}}

" deoplete
" {'word': 'call_tracing(', 'menu': '', 'info': 'call_tracing(func, args) -> object^@^@Call func(*args), while tracing is enabled.  The tracing state is^@saved, and restored afterwards.  This is intended to be called from^@a debugger from a checkpoint, to recursively debug some other code.', 'kind': '', 'abbr': 'call_tracing(func, args)'}
function! cm_parser#python#parameters(completed_item) "{{{
  let menu = get(a:completed_item, 'menu', '')
  let info = get(a:completed_item, 'info', '')
  let word = get(a:completed_item, 'word', '')
  let abbr = get(a:completed_item, 'abbr', '')
  let kind = get(a:completed_item, 'kind', '')
  if (menu =~# '\m^\%(function:\|def \)' || word =~# '\m^\w\+($' || menu =~? '\[jedi\]\s*') && !empty(info)
    return s:parser0(info)
  " From language server.
  elseif  menu =~? '\[LS\]' && !empty(info)
    return s:parser0(info)
  elseif word ==# '(' && empty(menu) && info ==# ' ' && empty(kind) && !empty(abbr)
    " ycm omni called
    " {'word': '(', 'menu': '', 'info': ' ', 'kind': '', 'abbr': 'add(a,b)'}
    return s:parser0(abbr)
  endif
  return []
endfunction "}}}

function! cm_parser#python#parameter_delim() "{{{
  return ','
endfunction "}}}

function! cm_parser#python#parameter_begin() "{{{
  return '('
endfunction "}}}

function! cm_parser#python#parameter_end() "{{{
  return ')'
endfunction "}}}

function! cm_parser#python#echos(completed_item)  "{{{
  let menu = get(a:completed_item, 'menu', '')
  let info = get(a:completed_item, 'info', '')
  let word = get(a:completed_item, 'word', '')
  let abbr = get(a:completed_item, 'abbr', '')
  let kind = get(a:completed_item, 'kind', '')
  if (menu =~# '\m^\%(function:\|def \)' || word =~# '\m^\w\+($' || menu =~? '\[jedi\]\s*') && !empty(info)
    return [s:signature(info)]
  elseif word ==# '(' && empty(menu) && info ==# ' ' && empty(kind) && !empty(abbr)
    " ycm omni called
    " {'word': '(', 'menu': '', 'info': ' ', 'kind': '', 'abbr': 'add(a,b)'}
    return [s:signature(abbr)]
  endif
  return []
endfunction "}}}
