"==============================================================
"    file: go.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-10 09:59:22
"==============================================================

" youcompleteme
" {'word': 'Scan', 'menu': 'func(a ...interface{}) (n int, err error)', 'info': 'Scan func(a ...interface{}) (n int, err error) func', 'kind': 'f', 'abbr': 'Scan'}
" completor
" {'word': 'Scanf', 'menu': 'func(format string, a ...interface{}) (n int, err error)', 'info': '', 'kind': '', 'abbr': ''}
" neocomplete
" {'word': 'Scan(', 'menu': '[O] ', 'info': 'func Scan(a ...interface{}) (n int, err error)', 'kind': '', 'abbr': 'func Scan(a ...interface{}) (n int, err error)'}
" deoplete
" {'word': 'Errorf', 'menu': '', 'info': 'func(format string, a ...interface{}) error', 'kind': 'func', 'abbr': 'Errorf(format string, a ...interface{}) error'}
function! s:parser1(info) "{{{
    if empty(a:info)
        return []
    endif
    let param = substitute(a:info, '\m^func\%( \w*\)\?\(.*\)', '\1', '')
    while param =~# '\m\<func\>'
        let param = substitute(param, '\<func\>\s*([^()]*)\s*\%(\w*|([^()]*)\)\?', '', 'g')
    endwhile

    let param = substitute(param, '\m^\(([^()]*)\).*', '\1', '')
    " remove type
    let param = substitute(param, '\m\(\w\+\)\s*[^,)]*', '\1', 'g')
    return [param]
endfunction "}}}

function! cm_parser#go#parameters(completed_item) "{{{
    let menu = get(a:completed_item, 'menu', '')
    let info = get(a:completed_item, 'info', '')
    if menu =~# '^func'
        return <SID>parser1(menu)
    elseif info =~# '^func'
        return <SID>parser1(info)
    else
        return []
    endif
endfunction "}}}

function! cm_parser#go#parameter_delim() "{{{
    return ','
endfunction "}}}

function! cm_parser#go#parameter_begin() "{{{
    return '('
endfunction "}}}

function! cm_parser#go#parameter_end() "{{{
    return ')'
endfunction "}}}

function! cm_parser#go#echos(completed_item) "{{{
    let menu = get(a:completed_item, 'menu', '')
    let info = get(a:completed_item, 'info', '')
    if menu =~# '^func'
        return [menu]
    elseif info =~# '^func'
        return [info]
    endif
    return []
endfunction "}}}
