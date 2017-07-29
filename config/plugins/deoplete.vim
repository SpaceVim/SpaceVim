" deoplete options
let g:deoplete#enable_at_startup = get(g:, 'deoplete#enable_at_startup', 1)
let g:deoplete#enable_ignore_case = get(g:, 'deoplete#enable_ignore_case', 1)
let g:deoplete#enable_smart_case = get(g:, 'deoplete#enable_smart_case', 1)
let g:deoplete#enable_camel_case = get(g:, 'deoplete#enable_camel_case', 1)
let g:deoplete#enable_refresh_always = get(g:, 'deoplete#enable_refresh_always', 1)
let g:deoplete#max_abbr_width = get(g:, 'deoplete#max_abbr_width', 0)
let g:deoplete#max_menu_width = get(g:, 'deoplete#max_menu_width', 0)
" init deoplet option dict
let g:deoplete#ignore_sources = get(g:,'deoplete#ignore_sources',{})
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})

" java && jsp
let g:deoplete#omni#input_patterns.java = get(g:deoplete#omni#input_patterns, 'java', [
      \'[^. \t0-9]\.\w*',
      \'[^. \t0-9]\->\w*',
      \'[^. \t0-9]\::\w*',
      \])
let g:deoplete#omni#input_patterns.jsp = get(g:deoplete#omni#input_patterns, 'jsp', ['[^. \t0-9]\.\w*'])
if g:spacevim_enable_javacomplete2_py
  let g:deoplete#ignore_sources.java = get(g:deoplete#ignore_sources, 'java', ['omni'])
  call deoplete#custom#set('javacomplete2', 'mark', '')
else
  let g:deoplete#ignore_sources.java = get(g:deoplete#ignore_sources, 'java', ['javacomplete2', 'around', 'member'])
  call deoplete#custom#set('omni', 'mark', '')
  call deoplete#custom#set('omni', 'rank', 9999)
endif

" go
let g:deoplete#ignore_sources.go = get(g:deoplete#ignore_sources, 'go', ['omni'])
call deoplete#custom#set('go', 'mark', '')
call deoplete#custom#set('go', 'rank', 9999)

" perl
let g:deoplete#omni#input_patterns.perl = get(g:deoplete#omni#input_patterns, 'perl', [
      \'[^. \t0-9]\.\w*',
      \'[^. \t0-9]\->\w*',
      \'[^. \t0-9]\::\w*',
      \])

" javascript
"let g:deoplete#omni#input_patterns.javascript = get(g:deoplete#omni#input_patterns, 'javascript', ['[^. \t0-9]\.\w*'])
let g:deoplete#ignore_sources.javascript = get(g:deoplete#ignore_sources, 'javascript', ['omni'])
call deoplete#custom#set('ternjs', 'mark', 'tern')
call deoplete#custom#set('ternjs', 'rank', 9999)

" php
let g:deoplete#omni#input_patterns.php = get(g:deoplete#omni#input_patterns, 'php', [
      \'[^. \t0-9]\.\w*',
      \'[^. \t0-9]\->\w*',
      \'[^. \t0-9]\::\w*',
      \])
let g:deoplete#ignore_sources.php = get(g:deoplete#ignore_sources, 'php', ['phpcd', 'around', 'member'])
"call deoplete#custom#set('phpcd', 'mark', '')
"call deoplete#custom#set('phpcd', 'input_pattern', '\w*|[^. \t]->\w*|\w*::\w*')

" gitcommit
let g:deoplete#omni#input_patterns.gitcommit = get(g:deoplete#omni#input_patterns, 'gitcommit', [
      \'[ ]#[ 0-9a-zA-Z]*',
      \])

let g:deoplete#ignore_sources.gitcommit = ['neosnippet']

" lua
let g:deoplete#omni_patterns.lua = get(g:deoplete#omni_patterns, 'lua', '.')

" c c++
call deoplete#custom#set('clang2', 'mark', '')
let g:deoplete#ignore_sources.c = get(g:deoplete#ignore_sources, 'c', ['omni'])

" rust
let g:deoplete#ignore_sources.rust = get(g:deoplete#ignore_sources, 'rust', ['omni'])
call deoplete#custom#set('racer', 'mark', '')

" public settings
call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
let g:deoplete#ignore_sources._ = get(g:deoplete#ignore_sources, '_', ['around'])
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
set isfname-==

" vim:set et sw=2:
