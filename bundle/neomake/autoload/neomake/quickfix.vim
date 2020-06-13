" vim: ts=4 sw=4 et
scriptencoding utf-8

let s:is_enabled = 0

let s:match_base_priority = 10

" args: a:1: force enabling?  (used in tests and for VimEnter callback)
function! neomake#quickfix#enable(...) abort
    if has('vim_starting') && !(a:0 && a:1)
        " Delay enabling for our FileType autocommand to happen as late as
        " possible, since placing signs triggers a redraw, and together with
        " vim-qf_resize this causes flicker.
        " https://github.com/vim/vim/issues/2763
        augroup neomake_qf
            autocmd!
            autocmd VimEnter * call neomake#quickfix#enable(1)
        augroup END
        return
    endif
    call neomake#log#debug('enabling custom quickfix list handling.')
    let s:is_enabled = 1
    augroup neomake_qf
        autocmd!
        autocmd FileType qf if get(b:, 'current_syntax', '') !=# 'neomake_qf'
                    \ | call neomake#quickfix#FormatQuickfix()
                    \ | endif
    augroup END
    if &filetype ==# 'qf'
        call neomake#quickfix#FormatQuickfix()
    endif
endfunction

function! neomake#quickfix#disable() abort
    call neomake#log#debug('disabling custom quickfix list handling.')
    let s:is_enabled = 0
    if &filetype ==# 'qf'
        call neomake#quickfix#FormatQuickfix()
    endif
    if exists('#neomake_qf')
        autocmd! neomake_qf
        augroup! neomake_qf
    endif
endfunction

function! neomake#quickfix#is_enabled() abort
    return s:is_enabled
endfunction

function! s:highlight_cursor_listnr() abort
    if col('.') <= b:neomake_start_col + 1
        call cursor(line('.'), b:neomake_start_col + 2)
    endif

    " Update neomakeCursorListNr, but not with :syntax-off.
    if empty(get(b:, 'current_syntax', ''))
        return
    endif
    if exists('w:_neomake_cursor_match_id')
        silent! call matchdelete(w:_neomake_cursor_match_id)
    endif
    if exists('*matchaddpos')
        let w:_neomake_cursor_match_id = matchaddpos('neomakeCursorListNr',
                    \ [[line('.'), (b:neomake_start_col - b:neomake_number_len) + 2, b:neomake_number_len]],
                    \ s:match_base_priority+3)
    else
        let w:_neomake_cursor_match_id = matchadd('neomakeCursorListNr',
                    \  '\%' . line('.') . 'c'
                    \. '\%' . ((b:neomake_start_col - b:neomake_number_len) + 2) . 'c'
                    \. '.\{' . b:neomake_number_len . '}',
                    \ s:match_base_priority+3)
    endif
endfunction

function! s:set_qf_lines(lines) abort
    let ul = &l:undolevels
    setlocal modifiable nonumber undolevels=-1

    call setline(1, a:lines)

    let &l:undolevels = ul
    setlocal nomodifiable nomodified
endfunction

function! s:clean_qf_annotations() abort
    call neomake#log#debug('cleaning qf annotations.', {'bufnr': bufnr('%')})
    if exists('b:_neomake_qf_orig_lines')
        call s:set_qf_lines(b:_neomake_qf_orig_lines)
        unlet b:_neomake_qf_orig_lines
    endif
    unlet b:neomake_qf
    augroup neomake_qf
        autocmd! * <buffer>
    augroup END

    call s:clean_matches()
endfunction

function! s:clean_matches() abort
    if exists('w:_neomake_maker_match_id')
        silent! call matchdelete(w:_neomake_maker_match_id)
    endif
    if exists('w:_neomake_gutter_match_id')
        silent! call matchdelete(w:_neomake_gutter_match_id)
    endif
    if exists('w:_neomake_bufname_match_id')
        silent! call matchdelete(w:_neomake_bufname_match_id)
    endif
    if exists('w:_neomake_cursor_match_id')
        silent! call matchdelete(w:_neomake_cursor_match_id)
    endif
    call neomake#signs#ResetFile(bufnr('%'))
endfunction

function! neomake#quickfix#_get_list() abort
    if has('patch-7.4.2215')
        let is_loclist = getwininfo(win_getid())[0].loclist
        if is_loclist
            let qflist = getloclist(0)
        else
            let qflist = getqflist()
        endif
    else
        let is_loclist = 1
        let qflist = getloclist(0)
        if empty(qflist)
            let is_loclist = 0
            let qflist = getqflist()
        endif
    endif
    return [is_loclist, qflist]
endfunction

function! neomake#quickfix#FormatQuickfix() abort
    if !s:is_enabled || &filetype !=# 'qf'
        if exists('b:neomake_qf')
            call s:clean_qf_annotations()
        endif
        return
    endif

    let [is_loclist, qflist] = neomake#quickfix#_get_list()

    if empty(qflist) || qflist[0].text !~# ' nmcfg:{.\{-}}$'
        if exists('b:neomake_qf')
            call neomake#log#debug('Resetting custom qf for non-Neomake change.')
            call s:clean_qf_annotations()
        endif
        return
    endif

    if is_loclist
        let b:neomake_qf = 'file'
        let src_buf = qflist[0].bufnr
    else
        let b:neomake_qf = 'project'
        let src_buf = 0
    endif

    let lines = []
    let signs = []
    let i = 0
    let lnum_width = 0
    let col_width = 0
    let maker_width = 0
    let nmcfg = {}
    let makers = {}

    for item in qflist
        " Look for marker at end of entry.
        if item.text[-1:] ==# '}'
            let idx = strridx(item.text, ' nmcfg:{')
            if idx != -1
                let config = item.text[idx+7:]
                try
                    let nmcfg = eval(config)
                    if !has_key(makers, nmcfg.name)
                        let makers[nmcfg.name] = 0
                    endif
                    let item.text = idx == 0 ? '' : item.text[:(idx-1)]
                catch
                    call neomake#log#exception(printf(
                                \ 'Error when evaluating nmcfg (%s): %s.',
                                \ config, v:exception))
                endtry
            endif
        endif

        " Count entries.
        if !empty(nmcfg)
            let makers[nmcfg.name] += 1
        endif

        let item.maker_name = get(nmcfg, 'short', '????')
        let maker_width = max([len(item.maker_name), maker_width])

        if item.lnum
            let lnum_width = max([len(item.lnum), lnum_width])
            let col_width = max([len(item.col), col_width])
        endif

        let i += 1
    endfor

    let syntax = keys(makers)
    if src_buf
        for ft in split(neomake#compat#getbufvar(src_buf, '&filetype', ''), '\.')
            if !empty(ft) && index(syntax, ft) == -1
                call add(syntax, ft)
            endif
        endfor
    endif

    let current_syntax = get(b:, 'current_syntax', '')
    if !empty(current_syntax)  " not with :syntax-off.
        runtime! syntax/neomake/qf.vim
        for name in syntax
            execute 'runtime! syntax/neomake/'.name.'.vim '
                        \  . 'syntax/neomake/'.name.'/*.vim'
        endfor
    endif

    if maker_width + lnum_width + col_width > 0
        let b:neomake_start_col = maker_width + lnum_width + col_width + 2
        let b:neomake_number_len = lnum_width + col_width + 2
        let blank_col = repeat(' ', lnum_width + col_width + 1)
    else
        let b:neomake_start_col = 0
        let b:neomake_number_len = 0
        let blank_col = ''
    endif

    " Count number of different buffers and cache their names.
    let buffers = neomake#compat#uniq(sort(
                \ filter(map(copy(qflist), 'v:val.bufnr'), 'v:val != 0')))
    let buffer_names = {}
    if len(buffers) > 1
        for b in buffers
            let bufname = bufname(b)
            if empty(bufname)
                let bufname = 'buf:'.b
            else
                let bufname = fnamemodify(bufname, ':t')
                if len(bufname) > 15
                    let bufname = bufname[0:13].'…'
                endif
            endif
            let buffer_names[b] = bufname
        endfor
    endif

    let i = 1
    let buf = bufnr('%')
    let last_bufnr = -1
    for item in qflist
        if item.lnum
            call add(signs, {'lnum': i, 'bufnr': buf, 'type': item.type})
        endif
        let i += 1

        let text = item.text
        if item.bufnr != 0 && !empty(buffer_names)
            if last_bufnr != item.bufnr
                let text = printf('[%s] %s', buffer_names[item.bufnr], text)
                let last_bufnr = item.bufnr
            endif
        endif

        if !item.lnum
            call add(lines, printf('%*s %s %s',
                        \ maker_width, item.maker_name,
                        \ blank_col, text))
        else
            call add(lines, printf('%*s %*s:%*s %s',
                        \ maker_width, item.maker_name,
                        \ lnum_width, item.lnum,
                        \ col_width, item.col ? item.col : '-',
                        \ text))
        endif
    endfor

    if !exists('b:_neomake_qf_orig_lines')
        let b:_neomake_qf_orig_lines = getbufline('%', 1, '$')
    endif
    call s:set_qf_lines(lines)

    if exists('+breakindent')
        " Keeps the text aligned with the fake gutter.
        setlocal breakindent linebreak
        let &breakindentopt = 'shift:'.(b:neomake_start_col + 1)
    endif

    call neomake#signs#Reset(buf, 'file')
    call neomake#signs#PlaceSigns(buf, signs, 'file')

    augroup neomake_qf
        autocmd! * <buffer>
        autocmd CursorMoved <buffer> call s:highlight_cursor_listnr()

        if !empty(current_syntax)  " not with :syntax-off.
            call s:add_window_matches(maker_width)

            " Annotate in new window, e.g. with "tab sp".
            " It keeps the syntax there, so should also have the rest.
            " This happens on Neovim already through CursorMoved being invoked
            " always then.
            if exists('##WinNew')
                exe 'autocmd WinNew <buffer> call s:add_window_matches('.maker_width.')'
            endif

            " Clear matches when opening another buffer in the same window, with
            " the original window/buffer still being visible (e.g. in another
            " tab).
            autocmd BufLeave <buffer> call s:on_bufleave()
        endif
    augroup END

    " Set title.
    " Fallback without patch-7.4.2200, fix for without 8.0.1831.
    if !has('patch-7.4.2200') || !exists('w:quickfix_title') || w:quickfix_title[0] ==# ':'
        let maker_info = []
        for [maker, c] in items(makers)
            call add(maker_info, maker.'('.c.')')
        endfor
        let maker_info_str = join(maker_info, ', ')
        if is_loclist
            let prefix = 'file'
        else
            let prefix = 'project'
        endif
        let w:quickfix_title = neomake#list#get_title(prefix, src_buf, maker_info_str)
    endif
endfunction

function! s:on_bufleave() abort
    let s:left_winnr = winnr()
    augroup neomake_qf
        autocmd BufEnter * call s:on_bufenter_after_bufleave()
    augroup END
endfunction

function! s:on_bufenter_after_bufleave() abort
    if winnr() == s:left_winnr
        call s:clean_matches()
    endif
    unlet s:left_winnr
    augroup neomake_qf
        autocmd! BufEnter
    augroup END
endfunction

function! s:add_window_matches(maker_width) abort
    if !b:neomake_start_col
        return
    endif
    if exists('w:_neomake_maker_match_id')
        silent! call matchdelete(w:_neomake_maker_match_id)
    endif
    let w:_neomake_maker_match_id = matchadd('neomakeMakerName',
                \ '.*\%<'.(a:maker_width + 1).'c',
                \ s:match_base_priority+1)
    if exists('w:_neomake_gutter_match_id')
        silent! call matchdelete(w:_neomake_gutter_match_id)
    endif
    let w:_neomake_gutter_match_id = matchadd('neomakeListNr',
                \ '\%>'.(a:maker_width).'c'
                \ .'.*\%<'.(b:neomake_start_col + 2).'c',
                \ s:match_base_priority+2)
    if exists('w:_neomake_bufname_match_id')
        silent! call matchdelete(w:_neomake_bufname_match_id)
    endif
    let w:_neomake_bufname_match_id = matchadd('neomakeBufferName',
                \ '.*\%<'.(a:maker_width + 1).'c',
                \ s:match_base_priority+3)

    call s:highlight_cursor_listnr()
endfunction
