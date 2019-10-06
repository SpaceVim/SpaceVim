"=============================================================================
" vim.vim --- vim api for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:self = {}
let s:CMP = SpaceVim#api#import('vim#compatible')

function! s:self.jumps() abort
    let result = []
    for jump in split(s:CMP.execute('jumps'), '\n')[1:]
        let list = split(jump)
        if len(list) < 4
            continue
        endif

        let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
        let lines = getbufline(file_text, linenr)
        let path = file_text
        let bufnr = bufnr(file_text)
        if empty(lines)
            if stridx(join(split(getline(linenr))), file_text) == 0
                let lines = [file_text]
                let path = bufname('%')
                let bufnr = bufnr('%')
            elseif filereadable(path)
                let bufnr = 0
                let lines = ['buffer unloaded']
            else
                " Skip.
                continue
            endif
        endif

        if getbufvar(bufnr, '&filetype') ==# 'unite'
            " Skip unite buffer.
            continue
        endif

        call add(result, [linenr, col, file_text, path, bufnr, lines])
    endfor
    return result
endfunction

function! s:self.parse_string(line) abort
    let expr = '`[^`]*`'
    let i = 0
    let line = []
    while i < strlen(a:line) || i != -1
        let [rst, m, n] = matchstrpos(a:line, expr, i)
        if m == -1
            call add(line, a:line[ i : -1 ])
            break
        else
            call add(line, a:line[ i : m-1])
            try
                let rst = eval(rst[1:-2])
            catch
                let rst = ''
            endtry
            call add(line, rst)
        endif
        let i = n
    endwhile
    return join(line, '')
endfunction


if exists('*nvim_win_set_cursor')
    function! s:self.win_set_cursor(win, pos) abort
        call nvim_win_set_cursor(a:win, a:pos)
    endfunction
elseif exists('*win_execute')
    function! s:self.win_set_cursor(win, pos) abort
        " @fixme use g` to move to cursor line
        " this seem to be a bug of vim
        " https://github.com/vim/vim/issues/5022
        call win_execute(a:win, ':call cursor(' . a:pos[0] . ', ' . a:pos[1] . ')')
        " call win_execute(a:win, ':' . a:pos[0])
        call win_execute(a:win, ':normal! g"')
    endfunction
elseif has('lua')
    function! s:self.win_set_cursor(win, pos) abort
        lua local winindex = vim.eval("win_id2win(a:win) - 1")
        lua local w = vim.window(winindex)
        lua w.line = vim.eval("a:pos[0]")
        lua w.col = vim.eval("a:pos[1]")
    endfunction
else
    function! s:self.win_set_cursor(win, pos) abort

    endfunction
endif

if exists('*nvim_buf_line_count')
    function! s:self.buf_line_count(buf) abort
        return nvim_buf_line_count(a:buf)
    endfunction
elseif has('lua')
    function! s:self.buf_line_count(buf) abort
        " lua numbers are floats, so use float2nr
        return float2nr(luaeval('#vim.buffer(vim.eval("a:buf"))'))
    endfunction
else
    function! s:self.buf_line_count(buf) abort
      return len(getbufline(a:buf, 1, '$'))
    endfunction
endif

function! SpaceVim#api#vim#get() abort
    return deepcopy(s:self)
endfunction
