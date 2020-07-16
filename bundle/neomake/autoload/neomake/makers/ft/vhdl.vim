" vim: ts=4 sw=4 et

function! neomake#makers#ft#vhdl#EnabledMakers() abort
    return ['ghdl']
endfunction

function! neomake#makers#ft#vhdl#ghdl() abort
    return {
                \ 'args' : ['-s'],
                \ 'errorformat' : '%E%f:%l:%c: %m',
                \ }
endfunction
