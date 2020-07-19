scriptencoding utf8

let s:highlight_types = {
    \ 'E': 'NeomakeVirtualtextError',
    \ 'W': 'NeomakeVirtualtextWarning',
    \ 'I': 'NeomakeVirtualtextInfo',
    \ 'M': 'NeomakeVirtualtextMessage'
    \ }

function! neomake#virtualtext#show(...) abort
    let list = neomake#list#get()
    if empty(list)
        echom 'Neomake: no annotations to show (no list)'
        return
    endif

    let filter = a:0 ? a:1 : ''
    if empty(filter)
        let entries = list.entries
    else
        let entries = map(copy(list.entries), filter)
    endif

    if empty(entries)
        echom 'Neomake: no annotations to show (no errors)'
        return
    endif

    for entry in entries
        let buf_info = getbufvar(entry.bufnr, '_neomake_info', {})

        call neomake#virtualtext#add_entry(entry, s:all_ns)

        " Keep track of added entries, because stacking is not supported.
        let set_buf_info = 0
        if !has_key(buf_info, 'virtual_text_entries')
            let buf_info.virtual_text_entries = []
        endif
        if index(buf_info.virtual_text_entries, entry.lnum) == -1
            " Do not add it, but define it still - could return here also later.
            call add(buf_info.virtual_text_entries, entry.lnum)
            let set_buf_info = 1
        endif

        if set_buf_info
            call setbufvar(entry.bufnr, '_neomake_info', buf_info)
        endif
    endfor
endfunction

function! neomake#virtualtext#add_entry(entry, src_id) abort
    let hi = get(s:highlight_types, toupper(a:entry.type), 'NeomakeVirtualtextMessage')
    let prefix = get(g:, 'neomake_virtualtext_prefix', '❯ ')
    let text = prefix . a:entry.text
    let used_src_id = nvim_buf_set_virtual_text(a:entry.bufnr, a:src_id, a:entry.lnum-1, [[text, hi]], {})
    return used_src_id
endfunction

function! neomake#virtualtext#show_errors() abort
    call neomake#virtualtext#show('v:val ==? "e"')
endfunction

function! neomake#virtualtext#hide() abort
    let bufnr = bufnr('%')
    let buf_info = getbufvar(bufnr, '_neomake_info', {})
    call nvim_buf_clear_highlight(bufnr, s:all_ns, 0, -1)
    if !empty(get(buf_info, 'virtual_text_entries', []))
        let buf_info.virtual_text_entries = []
        call setbufvar(bufnr, '_neomake_info', buf_info)
    endif
endfunction

if exists('*nvim_create_namespace')  " Includes nvim_buf_set_virtual_text.
    let s:current_ns = nvim_create_namespace('neomake-virtualtext-current')
    let s:all_ns = nvim_create_namespace('neomake-virtualtext-all')
    let s:cur_virtualtext = []

    function! neomake#virtualtext#handle_current_error() abort
        " Clean always.
        if !empty(s:cur_virtualtext)
            if bufexists(s:cur_virtualtext[0])
                call nvim_buf_clear_highlight(s:cur_virtualtext[0], s:cur_virtualtext[1], 0, -1)
            endif
        endif
        if !get(g:, 'neomake_virtualtext_current_error', 1)
            return
        endif
        let entry = neomake#get_nearest_error()
        if empty(entry)
            let s:cur_virtualtext = []
        else
            " Only add it when there is none already (stacking is not
            " supported).  https://github.com/neovim/neovim/issues/9285
            let buf_info = getbufvar(entry.bufnr, '_neomake_info', {})
            if index(get(buf_info, 'virtual_text_entries', []), entry.lnum) == -1
                let src_id = neomake#virtualtext#add_entry(entry, s:current_ns)
                let s:cur_virtualtext = [bufnr('%'), src_id]
            endif
        endif
    endfunction
else
    function! neomake#virtualtext#handle_current_error() abort
    endfunction
endif

function! neomake#virtualtext#DefineHighlights() abort
    " NOTE: linking to SpellBad etc is bad/distracting (with undercurl).
    call neomake#utils#define_derived_highlights('NeomakeVirtualtext%s', ['NONE', 'NONE'])
endfunction

call neomake#virtualtext#DefineHighlights()

" vim: ts=4 sw=4 et
