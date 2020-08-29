"==============================================================
"    file: go.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-10 09:59:22
"==============================================================

function! cm_parser#erlang#parameters(completed_item) "{{{
    let info = a:completed_item['info']
    let list = matchlist(info, '\m\w\+\((.*)\).*->.*')
    return len(list) < 2 ? [] : [list[1]]
endfunction "}}}

function! cm_parser#erlang#parameter_delim() "{{{
    return ','
endfunction "}}}

function! cm_parser#erlang#parameter_begin() "{{{
    return '('
endfunction "}}}

function! cm_parser#erlang#parameter_end() "{{{
    return ')'
endfunction "}}}
