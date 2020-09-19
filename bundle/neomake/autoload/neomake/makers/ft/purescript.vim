" vim: ts=4 sw=4 et

function! neomake#makers#ft#purescript#EnabledMakers() abort
    return ['pulp']
endfunction

function! neomake#makers#ft#purescript#pulp() abort
    " command is `pulp build --no-psa -- --json-errors`
    " as indicated in https://github.com/nwolverson/atom-ide-purescript/issues/136
    let maker = {
        \ 'args': ['build', '--no-psa', '--', '--json-errors'],
        \ 'append_file': 0,
        \ 'process_output': function('neomake#makers#ft#purescript#PSProcessOutput'),
        \ }

    " Find project root, since files are reported relative to it.
    let bower_file = neomake#utils#FindGlobFile('bower.json')
    if !empty(bower_file)
        let maker.cwd = fnamemodify(bower_file, ':h')
    endif

    return maker
endfunction

function! neomake#makers#ft#purescript#PSProcessOutput(context) abort
    let errors = []
    for line in a:context.output
        if line[0] !=# '{'
            continue
        endif
        let decoded = neomake#compat#json_decode(line)
        for [key, values] in items(decoded)
            let code = key ==# 'warnings' ? 'W' : 'E'
            for item in values
                let compiler_error = item['errorCode']
                let message = item['message']
                let position = item['position']
                let filename = item['filename']
                if  position is g:neomake#compat#json_null
                    let row = 1
                    let col = 1
                    let end_col = 1
                    let length = 1
                else
                    let row = position['startLine']
                    let col = position['startColumn']
                    let end_col = position['endColumn']
                    let length = end_col - col
                endif

                call add(errors, {
                            \ 'text': compiler_error . ' : ' . message,
                            \ 'type': code,
                            \ 'lnum': row,
                            \ 'col': col,
                            \ 'length': length,
                            \ 'filename': filename,
                            \ })
            endfor
        endfor
    endfor
    return errors
endfunction
