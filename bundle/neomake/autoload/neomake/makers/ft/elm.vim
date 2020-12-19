" vim: ts=4 sw=4 et

function! neomake#makers#ft#elm#EnabledMakers() abort
    return ['elmMake']
endfunction

function! neomake#makers#ft#elm#elmMake() abort
    return {
        \ 'exe': 'elm-make',
        \ 'args': ['--report=json', '--output=' . g:neomake#compat#dev_null],
        \ 'process_output': function('neomake#makers#ft#elm#ElmMakeProcessOutput')
        \ }
endfunction

function! neomake#makers#ft#elm#ElmMakeProcessOutput(context) abort
    let errors = []
    " output will be a List, containing either:
    " 1) A success message
    " 2) A string holding a JSON array for both warnings and errors

    for line in a:context.output
        if line[0] ==# '['
            let decoded = neomake#compat#json_decode(line)
            for item in decoded
                if get(item, 'type', '') ==# 'warning'
                    let code = 'W'
                else
                    let code = 'E'
                endif

                let compiler_error = item['tag']
                let message = item['overview']
                let filename = item['file']
                let region_start = item['region']['start']
                let region_end = item['region']['end']
                let row = region_start['line']
                let col = region_start['column']
                let length = region_end['column'] - region_start['column']

                let error = {
                            \ 'text': compiler_error . ' : ' . message,
                            \ 'type': code,
                            \ 'lnum': row,
                            \ 'col': col,
                            \ 'length': length,
                            \ 'filename': filename,
                            \ }
                call add(errors, error)
            endfor
        endif
    endfor
    return errors
endfunction
