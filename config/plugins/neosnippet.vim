let g:neosnippet#snippets_directory = get(g:,'neosnippet#snippets_directory', '')
if empty(g:neosnippet#snippets_directory)
  let g:neosnippet#snippets_directory = [expand('~/.SpaceVim/snippets/'), expand('~/.SpaceVim.d/snippets/')]
elseif type(g:spacevim_force_global_config) == type('')
  let g:neosnippet#snippets_directory = [expand('~/.SpaceVim/snippets/'), expand('~/.SpaceVim.d/snippets/')] + [g:neosnippet#snippets_directory]
elseif type(g:spacevim_force_global_config) == type([])
  let g:neosnippet#snippets_directory = [expand('~/.SpaceVim/snippets/'), expand('~/.SpaceVim.d/snippets/')] + g:neosnippet#snippets_directory
endif

if g:spacevim_force_global_config == 0
  let g:neosnippet#snippets_directory = [getcwd() . '/.Spacevim.d/snippets'] + g:neosnippet#snippets_directory
endif
let g:neosnippet#enable_snipmate_compatibility=1
let g:neosnippet#enable_complete_done = 1
let g:neosnippet#completed_pairs= {}
let g:neosnippet#completed_pairs.java = {'(' : ')'}
if g:neosnippet#enable_complete_done
  let g:neopairs#enable = 0
endif
augroup neosnippet_complete_done
  autocmd!
  autocmd CompleteDone * call s:my_complete_done()
augroup END
function! s:my_complete_done() abort "{{{
  if !empty(get(v:,'completed_item',''))
    let snippet = neosnippet#parser#_get_completed_snippet(v:completed_item,neosnippet#util#get_cur_text(), neosnippet#util#get_next_text())
    if snippet ==# ''
      return
    endif
    let [cur_text, col] = neosnippet#mappings#_pre_trigger()[0:1]
    call neosnippet#view#_insert(snippet, {}, cur_text, col)
  endif
endfunction"}}}

" vim:set et sw=2:
