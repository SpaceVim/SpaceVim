scriptencoding utf-8


let s:info = {
\   'source': {},
\   'col': 0,
\   'ft': '',
\   'preview_bufnr': -1,
\}


function! lf_neosnippet#source(...)
    let l:snippets = neosnippet#helpers#get_completion_snippets()
    let s:info.source = l:snippets
    return keys(l:snippets)
endfunction

function! lf_neosnippet#accept(line, arg) abort
    " from neosnippet.vim
    let l:cur_text = neosnippet#util#get_cur_text()
    let l:cur_keyword_str = matchstr(l:cur_text, '\S\+$')
    call neosnippet#view#_expand(
    \   l:cur_text . a:line[len(l:cur_keyword_str)], s:info.col, a:line)
endfunction

function! lf_neosnippet#preview(orig_buf_nr, orig_cursor, line, args) abort
    let l:info = get(s:info.source, a:line, {})
    let l:lines = split(get(l:info, 'snip', ''), "\n")
    silent call deletebufline(s:info.preview_bufnr, 1, '$')
    silent call setbufline(s:info.preview_bufnr, 1, l:lines)
    " [buf_number, line_num, jump_cmd]
    return [s:info.preview_bufnr, 1, '']
endfunction


function! lf_neosnippet#before_enter(args) abort
    " If you do it in the preview, it slows down the cursor movement.
    let l:bufnr = bufadd('lf_neosnippet_preview') 
    silent! call bufload(l:bufnr)

    try
        " from instance.py
        call setbufvar(l:bufnr, '&buflisted',   0)
        call setbufvar(l:bufnr, '&buftype',     'nofile')
        call setbufvar(l:bufnr, '&bufhidden',   'hide')
        call setbufvar(l:bufnr, '&undolevels',  -1)
        call setbufvar(l:bufnr, '&swapfile',    0)
        call setbufvar(l:bufnr, '&filetype',    &filetype)
    catch /*/
        " pass
    endtry

    let s:info.col = col('.')
    let s:info.preview_bufnr = l:bufnr
endfunction
