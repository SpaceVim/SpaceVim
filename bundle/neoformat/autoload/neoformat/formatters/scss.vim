function! neoformat#formatters#scss#enabled() abort
   return ['sassconvert', 'stylelint', 'stylefmt', 'prettier', 'prettydiff', 'csscomb']
endfunction

function! neoformat#formatters#scss#sassconvert() abort
    return {
            \ 'exe': 'sass-convert',
            \ 'args': ['-F scss', '-T scss', '--indent ' . (&expandtab ? shiftwidth() : 't')],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#scss#csscomb() abort
    return neoformat#formatters#css#csscomb()
endfunction

function! neoformat#formatters#scss#prettydiff() abort
    return neoformat#formatters#css#prettydiff()
endfunction

function! neoformat#formatters#scss#stylefmt() abort
    return neoformat#formatters#css#stylefmt()
endfunction

function! neoformat#formatters#scss#prettier() abort
    return neoformat#formatters#css#prettier()
endfunction

function! neoformat#formatters#scss#stylelint() abort
    return neoformat#formatters#css#stylelint()
endfunction
