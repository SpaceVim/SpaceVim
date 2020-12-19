" vim: ts=4 sw=4 et

" Credo error types.
" F -> Refactoring opportunities
" W -> Warnings
" C -> Convention violation
" D -> Software design suggestions
" R -> Readability suggestions
" Map structure {CredoError: NeomakeType, ...}
let s:neomake_elixir_credo_config_typemap = {
    \ 'F': 'W',
    \ 'C': 'W',
    \ 'D': 'I',
    \ 'R': 'I'}

function! neomake#makers#ft#elixir#PostprocessEnforceMaxBufferLine(entry) abort
    let buffer_lines = str2nr(line('$'))
    if (buffer_lines < a:entry.lnum)
        let a:entry.lnum = buffer_lines
    endif
endfunction

function! neomake#makers#ft#elixir#PostprocessCredo(entry) abort
    let type = toupper(a:entry.type)
    let type_map = extend(s:neomake_elixir_credo_config_typemap,
                \ get(g:, 'neomake_elixir_credo_config_typemap', {}))
    if has_key(type_map, type)
        let a:entry.type = type_map[type]
    endif
endfunction

function! neomake#makers#ft#elixir#EnabledMakers() abort
    return ['mix']
endfunction

function! neomake#makers#ft#elixir#elixir() abort
    return {
        \ 'errorformat':
            \ '%E** %s %f:%l: %m,'.
            \ '%W%f:%l: warning: %m'
        \ }
endfunction

function! neomake#makers#ft#elixir#credo() abort
    return {
      \ 'exe': 'mix',
      \ 'args': ['credo', 'list', '--format=oneline'],
      \ 'postprocess': function('neomake#makers#ft#elixir#PostprocessCredo'),
      \ 'errorformat':
          \'[%t] %. %f:%l:%c %m,' .
          \'[%t] %. %f:%l %m'
      \ }
endfunction

function! neomake#makers#ft#elixir#mix() abort
    return {
      \ 'exe' : 'mix',
      \ 'args': ['compile', '--warnings-as-errors'],
      \ 'postprocess': function('neomake#makers#ft#elixir#PostprocessEnforceMaxBufferLine'),
      \ 'errorformat':
        \ '** %s %f:%l: %m,'.
        \ '%Ewarning: %m,%C  %f:%l,%Z'
      \ }
endfunction

function! neomake#makers#ft#elixir#dogma() abort
    return {
      \ 'exe': 'mix',
      \ 'args': ['dogma', '--format=flycheck'],
      \ 'errorformat': '%E%f:%l:%c: %.: %m'
      \ }
endfunction
