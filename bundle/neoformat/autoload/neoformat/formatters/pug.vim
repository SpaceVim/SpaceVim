function! neoformat#formatters#pug#enabled() abort
   return ['pugbeautifier']
endfunction

function! neoformat#formatters#pug#pugbeautifier() abort
    return {
        \ 'exe': 'pug-beautifier',
        \ 'args': ['-s 2'],
        \ 'stdin': 1,
        \ }
endfunction
