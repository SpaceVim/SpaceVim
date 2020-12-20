function! neoformat#formatters#ruby#enabled() abort
   return ['rufo', 'rubybeautify', 'rubocop']
endfunction

function! neoformat#formatters#ruby#rufo() abort
     return {
        \ 'exe': 'rufo',
        \ 'stdin': 1,
        \ 'valid_exit_codes': [0, 3]
        \ }
endfunction

function! neoformat#formatters#ruby#rubybeautify() abort
     return {
        \ 'exe': 'ruby-beautify',
        \ 'args': ['--spaces', '-c ' . shiftwidth()],
        \ }
endfunction

function! neoformat#formatters#ruby#rubocop() abort
     return {
        \ 'exe': 'rubocop',
        \ 'args': ['--auto-correct', '--stdin', '"%:p"', '2>/dev/null', '|', 'sed "1,/^====================$/d"'],
        \ 'stdin': 1,
        \ 'stderr': 1
        \ }
endfunction
