let g:neosnippet#snippets_directory = get(g:,'neosnippet#snippets_directory',
      \ '')
if empty(g:neosnippet#snippets_directory)
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
  let g:neosnippet#snippets_directory = [getcwd() . '/.Spacevim.d/snippets'] +
        \ g:neosnippet#snippets_directory
endif
let g:neosnippet#enable_snipmate_compatibility =
      \ get(g:, 'neosnippet#enable_snipmate_compatibility', 1)
let g:neosnippet#enable_complete_done =
      \ get(g:, 'neosnippet#enable_complete_done', 1)

if !exists('g:neosnippet#completed_pairs')
  let g:neosnippet#completed_pairs = {}
endif
let g:neosnippet#completed_pairs.java = {'(' : ')'}
if g:neosnippet#enable_complete_done
  let g:neopairs#enable = 0
endif

" vim:set et sw=2 cc=80:
