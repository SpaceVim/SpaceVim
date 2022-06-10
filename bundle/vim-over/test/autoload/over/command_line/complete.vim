
function! s:test_parse_line()
	let owl_SID = owl#filename_to_SID("vim-over/autoload/over/command_line/complete.vim")
	
	OwlCheck s:parse_line("homu/h") == [5, "h"]
	OwlCheck s:parse_line("homu") == [0, "homu"]
	OwlCheck s:parse_line("//") == [2, ""]

endfunction

