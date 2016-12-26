if isdirectory(expand('~/DotFiles/snippets/'))
    let g:neosnippet#snippets_directory = expand('~/DotFiles/snippets/')
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
    if !empty(v:completed_item)
        let snippet = neosnippet#parser#_get_completed_snippet(v:completed_item,neosnippet#util#get_cur_text(), neosnippet#util#get_next_text())
        if snippet ==# ''
            return
        endif
        let [cur_text, col] = neosnippet#mappings#_pre_trigger()[0:1]
        call neosnippet#view#_insert(snippet, {}, cur_text, col)
    endif
endfunction"}}}
