let g:neosnippet#snippets_directory = get(g:,'neosnippet#snippets_directory',
      \ '')
if empty(g:neosnippet#snippets_directory)
  unlet g:neosnippet#snippets_directory
  let g:neosnippet#snippets_directory = [expand('~/.SpaceVim/snippets/'),
        \ expand('~/.SpaceVim.d/snippets/')]
elseif type(g:spacevim_force_global_config) == type('')
  let g:neosnippet#snippets_directory = [expand('~/.SpaceVim/snippets/'),
        \ expand('~/.SpaceVim.d/snippets/')] +
        \ [g:neosnippet#snippets_directory]
elseif type(g:spacevim_force_global_config) == type([])
  let g:neosnippet#snippets_directory = [expand('~/.SpaceVim/snippets/'),
        \ expand('~/.SpaceVim.d/snippets/')] +
        \ g:neosnippet#snippets_directory
endif

if g:spacevim_force_global_config == 0
  let g:neosnippet#snippets_directory = [getcwd() . '/.SpaceVim.d/snippets'] +
        \ g:neosnippet#snippets_directory
endif
let g:neosnippet#enable_snipmate_compatibility =
      \ get(g:, 'neosnippet#enable_snipmate_compatibility', 1)

if !exists('g:neosnippet#completed_pairs')
  let g:neosnippet#completed_pairs = {}
endif
let g:neosnippet#completed_pairs.java = {'(' : ')'}

" vim:set et sw=2 cc=80:
