"==============================================================
"    file: c.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-13 19:52:45
"==============================================================

" ycm macro
" {'word': 'CMP', 'menu': '', 'info': ' CMP( a, b )^@', 'kind': 'm', 'abbr': 'CMP( a, b )'}
function! s:parse_macro(word, info)
  let param = substitute(a:info, '\m\s*'.a:word.'\(([^()]*)\).*', '\1', 'g')
  let param = substitute(param, '\m( *', '(', 'g')
  let param = substitute(param, '\m *)', ')', 'g')
  return [param]
endfunction


function! s:parse(abbr) "{{{
    let param = substitute(a:abbr, '\m\%(\w\+\s*\)\?\w\+\((.*)\).*', '\1', '') " get parameters
    let param = substitute(param, '\m\([(,]\)\s*\%(\w\+\s\+\)*\s*\(\w\+\s*\)\s*\(\**\)\(\s*[,)]\)', '\1\2 \3\2\4', 'g')
    let param = substitute(param, '\m\s*\%(\w\+\s\+\)*\s*\**\s*\(\%(\w\+\)\s*[,)]\)', '\1', 'g')
    let param = substitute(param, '\s\+', '', 'g')
    let param = substitute(param, '\m,', ', ', 'g')
    return [param]
endfunction "}}}

" deoplete 
" {'word': 'time', 'menu': '[clang] ', 'info': 'time(time_t *)', 'kind': 'f time_t', 'abbr': 'time(time_t *)'}
" clang_complete
" {'word': 'timevalsub', 'menu': 'void timevalsub(struct timeval *t1, struct timeval *t2)', 'info': 'timevalsub(struct timeval *t1, struct timeval *t2)', 'kind': 'f', 'abbr': 'timevalsub'}
function! cm_parser#c#parameters(completed_item) "{{{
    let kind = get(a:completed_item, 'kind', '')
    let l:abbr = get(a:completed_item, 'abbr', '')
    let word = get(a:completed_item, 'word', '')
    let l:menu = get(a:completed_item, 'menu', '')
    let info = get(a:completed_item, 'info', '')
    if empty(l:abbr)
      return []
    endif
    if kind ==# 'f' && l:abbr == word
      " clang_complete
      return <SID>parse(l:menu)
    elseif kind ==# 'f'
      " ycm
      return <SID>parse(l:abbr)
    elseif kind =~# '\m^f .*' && l:menu ==# '[clang] ' && !empty(word) && l:abbr =~# '\m^'.word.'(.*)'
      " deoplete
      return <SID>parse(l:abbr)
    elseif kind ==# 'm'
      return <SID>parse_macro(word, info)
    endif
    return []
endfunction "}}}

function! cm_parser#c#parameter_delim() "{{{
    return ','
endfunction "}}}

function! cm_parser#c#parameter_begin() "{{{
    return '('
endfunction "}}}

function! cm_parser#c#parameter_end() "{{{
    return ')'
endfunction "}}}

function! cm_parser#c#echos(completed_item) "{{{
    let kind = get(a:completed_item, 'kind', '')
    let l:abbr = get(a:completed_item, 'abbr', '')
    let word = get(a:completed_item, 'word', '')
    let l:menu = get(a:completed_item, 'menu', '')
    if kind ==# 'f' && l:abbr == word
        " clang_complete
        return [l:menu]
    elseif kind ==# 'f'
        " ycm
        return [l:abbr]
    elseif kind =~# '\m^f .*' && l:menu ==# '[clang] ' && !empty(word) && l:abbr =~# '\m^'.word.'(.*)'
        " deoplete
        return [l:abbr]
    endif
    return []
endfunction "}}}
