function! neoformat#formatters#sass#enabled() abort
   return ['sassconvert', 'stylelint', 'csscomb']
endfunction

function! neoformat#formatters#sass#sassconvert() abort
    return {
            \ 'exe': 'sass-convert',
            \ 'args': ['-F sass', '-T sass', '-s'],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#sass#csscomb() abort
    return neoformat#formatters#css#csscomb()
endfunction

function! neoformat#formatters#sass#stylelint() abort
    return neoformat#formatters#css#stylelint()
endfunction
