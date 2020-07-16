
for l:pattern in l:completer.patterns
	if l:line =~# l:pattern
		let s:completer = l:completer
		while l:pos > 0
			if l:line[l:pos - 1] =~# '{\|,\|\[\|\\'
						\ || l:line[l:pos-2:l:pos-1] ==# ', '
				let s:completer.context = matchstr(l:line, '\S*$')
				return l:pos
			else
				let l:pos -= 1
			endif
		endwhile
		return -2
	endif
endfor



