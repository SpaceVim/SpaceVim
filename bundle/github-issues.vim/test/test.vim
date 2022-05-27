function! s:run_tests()
	exec ":Gissues"
	let line = getline(".")
	
	call s:expectEqual(getline("."), "No results found in jaxbot/test")

	exec ":Giadd"

	call s:expectEqual(getline("."), "#  (new)")

	exec "normal iTest Issue for Gissues"
	exec ":w"

	call s:expectEqual(getline("7"), "No comments.")

	exec ":4"
	normal $a enhancement
	normal GoTest comment

	exec ":w"
	call s:expectEqual(getline("8"), "Test comment")
	call s:expectEqual(getline("4"), "## Labels: enhancement")
	
	exec ":Gissues"
	normal ee
	call s:expectEqual(expand("<cword>"), "Test")

	exec "normal \<cr>"

	call s:expectEqual(getline("3"), "## State: open")
	normal cc
	call s:expectEqual(getline("3"), "## State: closed")

	echom "Finished!"
	exec ":messages"
endfunction

function! s:expectEqual(actual, expected)
	if a:actual == a:expected
	else
		throw "Assertion failed: Expected " . a:expected . ", got " . a:actual
	endif
endfunction

edit ~/www/test/README.md
call s:run_tests()

