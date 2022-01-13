function! neoformat#formatters#v#enabled() abort
  return ['vformat']
endfunction

function! neoformat#formatters#v#vformat() abort
  return {
        \ 'exe': 'v',
        \ 'args': ['fmt', '-w'],
        \ 'replace': 1
        \ }
endfunction
