function! neoformat#formatters#toml#enabled() abort
  return ['taplo']
endfunction

function! neoformat#formatters#toml#taplo() abort
  return {
        \ 'exe': 'taplo',
        \ 'args': ['fmt', '-'],
        \ 'stdin': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction
