"==============================================================
"    file: rust.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2017-06-11 19:32:37
"==============================================================

" ycm
" {'word': 'gen_range', 'menu': 'fn gen_range<T: PartialOrd + SampleRange>(&mut self, low: T, high: T) -> T where Self: Sized', 'info': '', 'kind': 'f', 'abbr': ''}
" {'word': 'trim', 'menu': 'pub fn trim(&self) -> &str', 'info': '', 'kind': 'f', 'abbr': ''}
"
" deoplete
" {'word': 'from_raw_parts', 'menu': '[Rust] pub unsafe fn from_raw_parts(ptr: *mut T', 'info': 'pub unsafe fn from_raw_parts(ptr: *mut T, length: usize, capacity: usize) -> Vec<T>', 'kind': 'Function', 'abbr': 'from_raw_parts'})'
"
" neocomplete+vim-racer
" {'word': 'from_raw_parts(', 'menu': '[O] unsafe from_raw_parts(ptr: *mut T, length: usize, capacity: usize) -> Vec<T>', 'info': 'pub unsafe fn from_raw_parts(ptr: *mut T, length: usize, capacity: usize) -> Vec<T>', 'kind': 'f', 'abbr': 'from_raw_parts'}
'
function! s:parse(word, param) "{{{
    " check is fn or not
    let param = substitute(a:param, '\m.*'.a:word.'\%(<.*>\)\?\(([^)]*)\).*', '\1', '')
    while param =~# '\m<.*>'
        let param = substitute(param, '\m<[^>]*>', '', 'g')
    endwhile
    let param = substitute(param, '\m:\s*[^,)]*', '', 'g')
    let param = substitute(param, '\m(&\?\%(\s*\&''\w\+\s*\)\?\%(\s*mut\s\+\)\?self\s*\([,)]\)', '(\1', '')
    let param = substitute(param, '\m(\s*,\s*', '(', '')
    return [param]
endfunction "}}}

" TODO support template
function! cm_parser#rust#parameters(completed_item) "{{{
    let menu = get(a:completed_item, 'menu', '')
    let word = get(a:completed_item, 'word', '')
    let kind = get(a:completed_item, 'kind', '')
    let info = get(a:completed_item, 'info', '')
    let l:abbr = get(a:completed_item, 'abbr', '')
    if kind ==# 'f' && !empty(word) && menu =~# '(.*)' && empty(info)
        " ycm
        return <SID>parse(word, menu)
    elseif kind ==# 'f' && !empty(l:abbr) && word =~# l:abbr.'(' && !empty(info)
        return <SID>parse(l:abbr, info)
    elseif kind ==# 'Function' && !empty(word) && info =~# '(.*)'
        " deoplete
        return <SID>parse(word, info)
    endif
    return []
endfunction "}}}

function! cm_parser#rust#parameter_delim() "{{{
    return ','
endfunction "}}}

function! cm_parser#rust#parameter_begin() "{{{
    return '('
endfunction "}}}

function! cm_parser#rust#parameter_end() "{{{
    return ')'
endfunction "}}}

function! cm_parser#rust#echos(completed_item) "{{{
    let menu = get(a:completed_item, 'menu', '')
    let word = get(a:completed_item, 'word', '')
    let kind = get(a:completed_item, 'kind', '')
    let info = get(a:completed_item, 'info', '')
    let l:abbr = get(a:completed_item, 'abbr', '')
    if kind ==# 'f' && !empty(word) && menu =~# '(.*)' && empty(info)
        " ycm
        return [menu]
    elseif kind ==# 'f' && !empty(l:abbr) && word =~# l:abbr.'(' && !empty(info)
        return [info]
    elseif kind ==# 'Function' && !empty(word) && info =~# '(.*)'
        " deoplete
        return [info]
    endif
    return []
endfunction "}}}
