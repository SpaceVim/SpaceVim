" Description: Teal linter based on `tl check`

" Based on https://github.com/dense-analysis/ale/blob/master/ale_linters/lua/luacheck.vim

call ale#Set('teal_tlcheck_executable', 'tl')
call ale#Set('teal_tlcheck_options', '')

function! ale_linters#teal#tlcheck#GetCommand(buffer) abort
    return '%e' . ale#Pad(ale#Var(a:buffer, 'teal_tlcheck_options'))
    \   . ' check %s'
endfunction

function! ale_linters#teal#tlcheck#Handle(buffer, lines) abort
    " Matches patterns line the following:
    "
    " artal.tl:159:17: shadowing definition of loop variable 'i' on line 106
    " artal.tl:182:7: unused loop variable 'i'
    let l:pattern = '^\(.\{-}\):\(\d\+\):\(\d\+\): \(.\+\)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'filename': l:match[1],
        \   'lnum': l:match[2] + 0,
        \   'col': l:match[3] + 0,
        \   'text': l:match[4],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('teal', {
\   'name': 'tlcheck',
\   'executable': {b -> ale#Var(b, 'teal_tlcheck_executable')},
\   'command': function('ale_linters#teal#tlcheck#GetCommand'),
\   'callback': 'ale_linters#teal#tlcheck#Handle',
\   'output_stream': 'both'
\})
