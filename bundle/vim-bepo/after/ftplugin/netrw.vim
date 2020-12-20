" vim-bepo - Plugin vim pour disposition de clavier bépo
" Maintainer:       Micha Moskovic

" save old 's' mapping to enable sort
if !exists("s:s_map") "check needed to avoid mapping to remapped 's'
	let s:s_map = maparg("s","n")
endif
execute "nnoremap <silent> <buffer> k " . s:s_map
" on recent versions of netrw, mappings are registered only once per Vim
" session (instead of once per buffer), so unmapping will fail afterwards and
" errors need to be silenced
silent! nunmap <buffer> t
silent! nunmap <buffer> s
