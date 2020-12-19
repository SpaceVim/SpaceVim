function! neomake#makers#ft#markdown#SupersetOf() abort
    return 'text'
endfunction

function! neomake#makers#ft#markdown#EnabledMakers() abort
    let makers = executable('mdl') ? ['mdl'] : ['markdownlint']
    if executable('vale') | let makers += ['vale'] | endif
    return makers + neomake#makers#ft#text#EnabledMakers()
endfunction

function! neomake#makers#ft#markdown#mdl() abort
    let maker = {
                \
                \ 'errorformat':
                \   '%W%f:%l: %m,%-G%.%#',
                \ 'output_stream': 'stdout',
                \ }
    function! maker.postprocess(entry) abort
        if a:entry.text[0:1] ==# 'MD'
            let [code, text] = split(a:entry.text, '\v^MD\d+\zs ')
            let a:entry.nr = str2nr(code[2:])
            let a:entry.text = printf('%s (%s)', text, code)
        endif
        return a:entry
    endfunction
    return maker
endfunction

function! neomake#makers#ft#markdown#markdownlint() abort
    return {
                \ 'errorformat': '%f:%l %m,%f: %l: %m'
                \ }
endfunction

let s:alex_supports_stdin = {}
function! neomake#makers#ft#markdown#alex() abort
    let maker = {
                \ 'errorformat':
                \   '%P%f,'
                \   .'%-Q,'
                \   .'%*[ ]%l:%c-%*\d:%n%*[ ]%tarning%*[ ]%m,'
                \   .'%-G%.%#'
                \ }

    function! maker.supports_stdin(_jobinfo) abort
        let exe = exists('*exepath') ? exepath(self.exe) : self.exe
        let support = get(s:alex_supports_stdin, exe, -1)
        if support == -1
            let ver = neomake#compat#systemlist(['alex', '--version'])
            let ver_split = split(ver[0], '\.')
            if len(ver_split) > 1 && (ver_split[0] > 0 || +ver_split[1] >= 6)
                let support = 1
            else
                let support = 0
            endif
            let s:alex_supports_stdin[exe] = support
            call neomake#log#debug('alex: stdin support: '.support.'.')
        endif
        if support
            let self.args += ['--stdin']
            let self.tempfile_name = ''
        endif
        return support
    endfunction

    return maker
endfunction

function! neomake#makers#ft#markdown#ProcessVale(context) abort
    let entries = []
    for [filename, items] in items(a:context['json'])
        for data in items
            let entry = {
                        \ 'maker_name': 'vale',
                        \ 'filename': filename,
                        \ 'text': data.Message,
                        \ 'lnum': data.Line,
                        \ 'col': data.Span[0],
                        \ 'length': data.Span[1] - data.Span[0] + 1,
                        \ 'type': toupper(data.Severity[0])
                        \ }
            call add(entries, entry)
        endfor
    endfor
    return entries
endfunction

function! neomake#makers#ft#markdown#vale() abort
    return {
                \ 'args': [
                \   '--no-wrap',
                \   '--output', 'JSON'
                \ ],
                \ 'process_json': function('neomake#makers#ft#markdown#ProcessVale')
                \ }
endfunction
" vim: ts=4 sw=4 et
