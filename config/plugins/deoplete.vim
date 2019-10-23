"=============================================================================
" deoplete.vim --- deoplete default config in spacevim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
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
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'lua': '.',
      \})

" c c++
call deoplete#custom#source('clang2', 'mark', '')
call deoplete#custom#option('ignore_sources', {'c': ['omni']})

" rust
call deoplete#custom#option('ignore_sources', {'rust': ['omni']})
call deoplete#custom#source('racer', 'mark', '')

" vim
call deoplete#custom#option('ignore_sources', {'vim': ['tag']})

" denite
call deoplete#custom#option('ignore_sources', {'denite-filter': ['denite', 'buffer', 'around', 'member', 'neosnippet']})

" clojure
call deoplete#custom#option('keyword_patterns', {
      \ 'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*',
      \})

" ocaml
call deoplete#custom#option('ignore_sources', {'ocaml': ['buffer', 'around', 'omni']})

" erlang
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'erlang': [
      \   '[^. \t0-9]\.\w*',
      \ ],
      \})

" c#
call deoplete#custom#option('sources', {'cs': ['omnisharp']})

" public settings
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#source('file/include', 'matchers', ['matcher_head'])

if g:spacevim_autocomplete_parens && exists('g:loaded_delimitMate')
  imap <expr><C-h> deoplete#smart_close_popup()."<Plug>delimitMateBS"
  imap <expr><BS> deoplete#smart_close_popup()."<Plug>delimitMateBS"
else
  inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
endif
set isfname-==

" vim:set et sw=2:
