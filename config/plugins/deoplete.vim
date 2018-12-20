let g:deoplete#enable_at_startup = get(g:, 'deoplete#enable_at_startup', 1)

" deoplete options
let s:profile = SpaceVim#layers#autocomplete#getprfile()
call deoplete#custom#option({
      \ 'auto_complete_delay' :  g:_spacevim_autocomplete_delay,
      \ 'ignore_case'         :  get(g:, 'deoplete#enable_ignore_case', 1),
      \ 'smart_case'          :  get(g:, 'deoplete#enable_smart_case', 1),
      \ 'camel_case'          :  get(g:, 'deoplete#enable_camel_case', 1),
      \ 'refresh_always'      :  get(g:, 'deoplete#enable_refresh_always', 1)
      \ })

" let g:deoplete#max_abbr_width = get(g:, 'deoplete#max_abbr_width', 0)
" let g:deoplete#max_menu_width = get(g:, 'deoplete#max_menu_width', 0)
" init deoplet option dict
let g:deoplete#ignore_sources = get(g:,'deoplete#ignore_sources',{})
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
let g:deoplete#keyword_patterns = get(g:, 'deoplete#keyword_patterns', {})

" java && jsp
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'java': [
      \           '[^. \t0-9]\.\w*',
      \           '[^. \t0-9]\->\w*',
      \           '[^. \t0-9]\::\w*',
      \         ],
      \ 'jsp':  ['[^. \t0-9]\.\w*'],
      \})
if g:spacevim_enable_javacomplete2_py
  call deoplete#custom#option('ignore_sources', {'java': ['omni']})
  call deoplete#custom#source('javacomplete2', 'mark', '')
else
  call deoplete#custom#option('ignore_sources', {'java': ['javacomplete2', 'around', 'member']})
  call deoplete#custom#source('omni', 'mark', '')
  call deoplete#custom#source('omni', 'rank', 9999)
endif

" sh
call deoplete#custom#option('ignore_sources', {'sh': ['around', 'member', 'tag', 'syntax']})

" go
call deoplete#custom#option('ignore_sources', {'go': ['omni']})
call deoplete#custom#source('go', 'mark', '')
call deoplete#custom#source('go', 'rank', 9999)

" markdown
call deoplete#custom#option('ignore_sources', {'markdown': ['tag']})

" perl
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'perl': [
      \           '[^. \t0-9]\.\w*',
      \           '[^. \t0-9]\->\w*',
      \           '[^. \t0-9]\::\w*',
      \         ],
      \})

" javascript
call deoplete#custom#option('ignore_sources', {'javascript': ['omni']})
call deoplete#custom#source('ternjs', 'mark', 'tern')
call deoplete#custom#source('ternjs', 'rank', 9999)

" typescript
call deoplete#custom#option('ignore_sources', {'typescript': ['tag','omni', 'syntax']})
call deoplete#custom#source('typescript', 'rank', 9999)


" php two types, 1. phpcd (default)  2. lsp
if SpaceVim#layers#lsp#check_filetype('php')
  if has('nvim')
    call deoplete#custom#option('ignore_sources', {'php': ['omni', 'around', 'member']})
  else
    call deoplete#custom#option('ignore_sources', {'php': ['around', 'member']})
  endif
else
  call deoplete#custom#option('ignore_sources', {'php': ['omni', 'around', 'member']})
endif

" gitcommit
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'gitcommit': [
      \       '[ ]#[ 0-9a-zA-Z]*',
      \ ],
      \})

call deoplete#custom#option('ignore_sources', {'gitcommit': ['neosnippet']})

" lua
let g:deoplete#omni_patterns.lua = get(g:deoplete#omni_patterns, 'lua', '.')

" c c++
call deoplete#custom#source('clang2', 'mark', '')
call deoplete#custom#option('ignore_sources', {'c': ['omni']})

" rust
call deoplete#custom#option('ignore_sources', {'rust': ['omni']})
call deoplete#custom#source('racer', 'mark', '')

" vim
call deoplete#custom#option('ignore_sources', {'vim': ['tag']})

" clojure
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

" ocaml
call deoplete#custom#option('ignore_sources', {'ocaml': ['buffer', 'around', 'omni']})

" erlang
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'erlang': [
      \   '[^. \t0-9]\.\w*',
      \ ],
      \})

" public settings
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#source('file/include', 'matchers', ['matcher_head'])

inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
set isfname-==

" vim:set et sw=2:
