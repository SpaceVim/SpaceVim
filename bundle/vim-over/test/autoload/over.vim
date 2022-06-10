
function! s:test_parse_substitute()
	let owl_SID = owl#filename_to_SID("vim-over/autoload/over.vim")

	OwlCheck s:parse_substitute('/homu') == []
	OwlCheck s:parse_substitute('s/homu') == ["", "homu", "", ""]
	OwlCheck s:parse_substitute('%s/homu') == ["%", "homu", "", ""]
	OwlCheck s:parse_substitute("'<,'>s/homu") == ["'<,'>", "homu", "", ""]
	OwlCheck s:parse_substitute("'<,'>s/homu/mami") == ["'<,'>", "homu", "mami", ""]
	OwlCheck s:parse_substitute('''<,''>s/ho\/ou/ma\/mi') == ["'<,'>", 'ho\/ou', 'ma\/mi', ""]
	OwlCheck s:parse_substitute('%sa/a//g') == []
endfunction

