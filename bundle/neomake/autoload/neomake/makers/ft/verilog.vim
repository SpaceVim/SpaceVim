function! neomake#makers#ft#verilog#EnabledMakers() abort
    return ['iverilog']
endfunction

function! neomake#makers#ft#verilog#iverilog() abort
    return {
                \ 'args' : ['-tnull', '-Wall', '-y./'],
                \ 'cwd' : '%:h',
                \ 'errorformat' : '%f:%l: %trror: %m,' .
                \ '%f:%l: %tarning: %m,' .
                \ '%E%f:%l:      : %m,' .
                \ '%W%f:%l:        : %m,' .
                \ '%f:%l: %m',
                \ }
endfunction
" vim: ts=4 sw=4 et
