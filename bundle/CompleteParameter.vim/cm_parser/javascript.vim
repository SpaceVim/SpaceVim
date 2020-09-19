"==============================================================
"    file: javascript.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-11 21:14:37
"==============================================================

function! s:process_param(param)
    let param = a:param
    " remove fn
    while param =~# '\<fn('
        let param = substitute(param, '\m\<fn([^)]*)', '', 'g')
    endwhile

    " both parameter and the type is object
    " remove type
    while param =~# '{[^{}]*}\s*:\s*{[^{}]*}'
        let param = substitute(param, '\m\({[^{}]*}\)\s*:\s*{[^{}]*}', '\1', 'g')
    endwhile

    " if the type of parameter is an object
    " return object but not parameter
    while param =~# '\w\+\s*:\s*{[^{}]*}'
        let param = substitute(param, '\m\w\+:\s\({[^{}]*}\)', '\1', 'g')
    endwhile
    let param = substitute(param, '\m?\?:\s*[^,(){}]*', '', 'g')
    return param
endfunction

" ycm
function! s:parser0(menu) "{{{
    let param = substitute(a:menu, '\m^fn\((.*)\)\%(\s*->.*\)\?', '\1', '')
    let param = <sid>process_param(param)
    return [param]
endfunction "}}}

" deoplete
function! s:check_parentheses_pairs(line) "{{{
    let left = 0
    let right = 0
    let i = 0
    while i < len(a:line)
        if a:line[i] ==# '('
            let left += 1
        elseif a:line[i] ==# ')'
            let right += 1
        endif
        let i += 1
    endwhile
    return left == right
endfunction "}}}

function! s:parser1(info) "{{{
    let info_lines = split(a:info, '\n')
    let func = info_lines[0]
    for line in info_lines[1:]
        if <SID>check_parentheses_pairs(func)
            break
        endif
        let func .= line
    endfor
    let param = substitute(func, '\m^fn\((.*)\)\%(\s*->.*\)\?', '\1', '')
    let param = <sid>process_param(param)
    return [param]
endfunction "}}}

function! s:parser2(menu) "{{{
    let param = '(' . a:menu . ')'
    let param = <SID>process_param(param)
    return [param]
endfunction "}}}

function! cm_parser#javascript#parameters(completed_item) "{{{
    let menu = get(a:completed_item, 'menu', '')
    let info = get(a:completed_item, 'info', '')
    let kind = get(a:completed_item, 'kind', '')
    let word = get(a:completed_item, 'word', '')
    if menu =~# '\m^fn('
        return <SID>parser0(menu)
    elseif info =~# '\m^fn('
        return <SID>parser1(info)
    elseif word =~# '\m\w\+(' && empty(info) && kind ==# 'f' && !empty(menu)
        " ycm omni
        " {'word': 'add(', 'menu': 'a, b', 'info': '', 'kind': 'f', 'abbr': ''}
        return <SID>parser2(menu)
    endif
    return []
endfunction "}}}

function! cm_parser#javascript#parameter_delim() "{{{
    return ','
endfunction "}}}

function! cm_parser#javascript#parameter_begin() "{{{
    return '({'
endfunction "}}}

function! cm_parser#javascript#parameter_end() "{{{
    return ')}'
endfunction "}}}

function! cm_parser#javascript#echos(completed_item) "{{{
    let menu = get(a:completed_item, 'menu', '')
    let info = get(a:completed_item, 'info', '')
    let kind = get(a:completed_item, 'kind', '')
    let word = get(a:completed_item, 'word', '')
    if menu =~# '\m^fn('
        return [menu]
    elseif info =~# '\m^fn('
        return [info]
    elseif word =~# '\m\w\+(' && empty(info) && kind ==# 'f' && !empty(menu)
        return [word.menu.')']
    endif
    return []
endfunction "}}}
