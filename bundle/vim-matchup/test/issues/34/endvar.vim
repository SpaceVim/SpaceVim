
function! s:InNumber() abort
	let l:line = getline('.')
	let l:col = col('.') - 1
	" virtcol for start of number
	let l:start = l:col
	" virtcol for last character in number
	let l:end = l:col
	if (l:line[l:col:] !~# '\d')
		return
	endif
	if (l:line[l:col] !~# '\d')
		" number in rest of line (not under cursor)
		let l:curCol = l:col + 1 " current column in for loop
		" while this might be confusing, it should work. Temporarily store the
		" length of l:line into l:end. Use this for the break condition for the
		" loop below. If th
		let l:end = len(l:line)
		" find the first number in rest of line
		" for l:ch in l:line[l:curCol:]
		while l:curCol < l:end
			let l:ch = l:line[l:curCol]
			if (l:ch =~# '\d')
				if (l:start !=# l:col)
					" l:start was not set yet, and current char is a number
					let l:start = l:curCol
				endif
			else
				if (l:start !=# l:col)
					" l:start was changed, and current char is not a number;
					" if this condition is never true, then l:start and l:end
					" were both already set to the correct values
					let l:end = l:curCol - 1
					break
				endif
			endif
		endwhile
		let l:curCol += 1
	else
		" number is under cursor
		" iterate backwards over all characters from 0 to l:curCol-1 in order to
		" find l:start
		let l:start = 0
		let l:curCol = l:col - 1
		" for l:ch in join(reverse(split(l:line[:l:curCol], '.\zs')))
		while (l:curCol >= 0)
			let l:ch = l:line[l:curCol]
			if (l:ch !~# '\d')
				" current char is not a number;
				" if this condition is never true, then l:start was set to the
				" correct value anyway
				let l:start = l:curCol + 1
				break
			endif
			let l:curCol -= 1
		endwhile
		" iterate forwards over all characters from l:curCol+1 to $ in order to
		" find l:end
		let l:end = len(l:line)
		let l:curCol = l:col + 1
		" for l:ch in l:line[l:curCol:]
		while l:curCol < l:end
			let l:ch = l:line[l:curCol]
			if (l:ch !~# '\d')
				" current char is not a number;
				" if this condition is never true, then l:end was set to the
				" correct value anyway
				let l:end = l:curCol - 1
				break
			endif
		endwhile
	endif
	" finally, just select the appropriate region on the line
	execute 'normal! '.l:start.'|v'.l:end.'|'
endfunction

