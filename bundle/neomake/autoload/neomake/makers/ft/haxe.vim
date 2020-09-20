" vim: ts=4 sw=4 et

function! neomake#makers#ft#haxe#EnabledMakers() abort
    return ['haxe']
endfunction

function! neomake#makers#ft#haxe#haxe() abort
    return {
                \ 'errorformat': '%E%f:%l: characters %c-%n : %m'
                \ }
endfunction
