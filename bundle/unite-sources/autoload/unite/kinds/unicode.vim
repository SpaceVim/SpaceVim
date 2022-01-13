let s:kind = {
            \ 'name': 'unicode',
            \ 'default_action': 'execute',
            \ 'action_table': {},
            \ 'parents': [],
            \ }

let s:kind.action_table.execute = {
            \ 'is_selectable': 1,
            \ }

function! s:kind.action_table.execute.func(candidates)
    if len(a:candidates) != 1
        echo "Too many selections"
        return
    endif

    call unite#start(["unicodeSelect"], { "codeset" : a:candidates[0].word })
endfunction

function! unite#kinds#unicode#define()
    return s:kind
endfunction

