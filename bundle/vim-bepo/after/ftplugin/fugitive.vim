" vim-bepo - Plugin vim pour disposition de clavier bépo
" Maintainer:       Micha Moskovic

" save old 's' mapping to enable sort
if !exists("s:s_map") "check needed to avoid mapping to remapped 's'
	let s:s_map = maparg("s","n")
endif
execute "nnoremap <silent> <buffer> k " . s:s_map
nunmap <buffer> s
