function! neoformat#formatters#zig#enabled() abort
	return ['zigfmt']
endfunction

function! neoformat#formatters#zig#zigfmt() abort
return {
	\ 'exe': 'zig',
	\ 'args': ['fmt'],
	\ 'replace': 1
	\ }
endfunction
