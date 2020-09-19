" vim: ts=4 sw=4 et

let s:highlights = {'file': {}, 'project': {}}
let s:highlight_types = {
    \ 'E': 'NeomakeError',
    \ 'W': 'NeomakeWarning',
    \ 'I': 'NeomakeInfo',
    \ 'M': 'NeomakeMessage'
    \ }

let s:nvim_api = exists('*nvim_buf_add_highlight')

" Used in tests.
function! neomake#highlights#_get() abort
    return s:highlights
endfunction

if s:nvim_api
    function! s:InitBufHighlights(type, buf) abort
        if !bufexists(a:buf)
            " The buffer might be wiped by now: prevent 'Invalid buffer id'.
            return
        endif
        if has_key(s:highlights[a:type], a:buf)
            call nvim_buf_clear_highlight(a:buf, s:highlights[a:type][a:buf], 0, -1)
        else
            let s:highlights[a:type][a:buf] = nvim_buf_add_highlight(a:buf, 0, '', 0, 0, -1)
        endif
    endfunction

    function! s:reset(type, buf) abort
        if has_key(s:highlights[a:type], a:buf)
            call nvim_buf_clear_highlight(a:buf, s:highlights[a:type][a:buf], 0, -1)
            unlet s:highlights[a:type][a:buf]
        endif
    endfunction
else
    function! s:InitBufHighlights(type, buf) abort
        let s:highlights[a:type][a:buf] = {
            \ 'NeomakeError': [],
            \ 'NeomakeWarning': [],
            \ 'NeomakeInfo': [],
            \ 'NeomakeMessage': []
            \ }
    endfunction

    function! s:reset(type, buf) abort
        if has_key(s:highlights[a:type], a:buf)
            unlet s:highlights[a:type][a:buf]
            call neomake#highlights#ShowHighlights()
        endif
    endfunction
endif

function! neomake#highlights#ResetFile(buf) abort
    call s:reset('file', a:buf)
endfunction
function! neomake#highlights#ResetProject(...) abort
    if a:0  " deprecated a:buf
        call neomake#log#warn_once('neomake#highlights#ResetProject does not use a:buf anymore.',
                    \ 'deprecated-highlight-resetproject')
    endif
    for buf in keys(s:highlights['project'])
        call s:reset('project', +buf)
    endfor
endfunction

function! neomake#highlights#AddHighlight(entry, type) abort
    " Some makers use line 0 for file warnings (which cannot be highlighted,
    " e.g. cpplint with "no copyright" warnings).
    if a:entry.lnum == 0
        return
    endif

    if !has_key(s:highlights[a:type], a:entry.bufnr)
        call s:InitBufHighlights(a:type, a:entry.bufnr)
    endif
    let hi = get(s:highlight_types, toupper(a:entry.type), 'NeomakeError')

    if a:entry.col > 0 && get(g:, 'neomake_highlight_columns', 1)
        let length = get(a:entry, 'length', 1)
        if s:nvim_api
            call nvim_buf_add_highlight(a:entry.bufnr, s:highlights[a:type][a:entry.bufnr], hi, a:entry.lnum - 1, a:entry.col - 1, a:entry.col + length - 1)
        else
            call add(s:highlights[a:type][a:entry.bufnr][hi], [a:entry.lnum, a:entry.col, length])
        endif
    elseif get(g:, 'neomake_highlight_lines', 0)
        if s:nvim_api
            call nvim_buf_add_highlight(a:entry.bufnr, s:highlights[a:type][a:entry.bufnr], hi, a:entry.lnum - 1, 0, -1)
        else
            call add(s:highlights[a:type][a:entry.bufnr][hi], a:entry.lnum)
        endif
    endif
endfunction

if s:nvim_api
    function! neomake#highlights#ShowHighlights() abort
    endfunction
else
    function! neomake#highlights#ShowHighlights() abort
        if exists('w:neomake_highlights')
            for highlight in w:neomake_highlights
                try
                    call matchdelete(highlight)
                catch /^Vim\%((\a\+)\)\=:E803/
                endtry
            endfor
        endif
        let w:neomake_highlights = []

        let buf = bufnr('%')
        for type in ['file', 'project']
            for [hi, locs] in items(filter(copy(get(s:highlights[type], buf, {})), '!empty(v:val)'))
                if exists('*matchaddpos')
                    call add(w:neomake_highlights, matchaddpos(hi, locs))
                else
                    for loc in locs
                        if len(loc) == 1
                            call add(w:neomake_highlights, matchadd(hi, '\%' . loc[0] . 'l'))
                        else
                            call add(w:neomake_highlights, matchadd(hi, '\%' . loc[0] . 'l\%' . loc[1] . 'c.\{' . loc[2] . '}'))
                        endif
                    endfor
                endif
            endfor
        endfor
    endfunction
endif

function! neomake#highlights#DefineHighlights() abort
    for [group, link] in items({
                \ 'NeomakeError': 'SpellBad',
                \ 'NeomakeWarning': 'SpellCap',
                \ 'NeomakeInfo': 'NeomakeWarning',
                \ 'NeomakeMessage': 'NeomakeWarning'
                \ })
        if !neomake#utils#highlight_is_defined(group)
            exe 'highlight link '.group.' '.link
        endif
    endfor
endfunction

function! s:wipe_highlights(bufnr) abort
    for type in ['file', 'project']
        if has_key(s:highlights[type], a:bufnr)
            unlet s:highlights[type][a:bufnr]
        endif
    endfor
endfunction
augroup neomake_highlights
    au!
    autocmd BufWipeout * call s:wipe_highlights(expand('<abuf>'))
augroup END

call neomake#highlights#DefineHighlights()
