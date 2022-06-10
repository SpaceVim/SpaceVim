
function! s:test_restore_option()
	let conceallevel = &conceallevel
	let &conceallevel = 3
	call over#command_line#do("%s/mado/mado\<Esc>")
	echo &conceallevel
	OwlCheck &conceallevel == 3
	let &conceallevel = conceallevel
endfunction


function! s:test_setting_option()
	let conceallevel = &conceallevel
	let &conceallevel = 3
	call over#command_line#do("set conceallevel=0\<CR>")
	echo &conceallevel
	OwlCheck &conceallevel == 0
	let &conceallevel = conceallevel
endfunction

