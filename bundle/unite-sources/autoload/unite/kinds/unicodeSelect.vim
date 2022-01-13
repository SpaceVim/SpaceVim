let s:kind = {
            \ 'name': 'unicodeSelect',
            \ 'default_action': 'execute',
            \ 'action_table': {},
            \ 'parents': [],
            \ }

let s:kind.action_table.execute = {
            \ 'is_selectable': 1,
            \ }

function! s:kind.action_table.execute.func(candidates)
    for line in a:candidates
        let glyph = matchstr(line.word, ';\x\{4,5}')
        let writable = nr2char(str2nr(glyph[1:], 16))

        exe "norm a" . eval("\"" . writable . "\"")
        " echo printf("%s%s", writable, glyph)
    endfor
endfunction

function! unite#kinds#unicodeSelect#define()
    return s:kind
endfunction

