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
let g:deoplete#keyword_patterns = get(g:, 'deoplete#keyword_patterns', {})

" java && jsp
let g:deoplete#omni#input_patterns.java = get(g:deoplete#omni#input_patterns, 'java', [
      \'[^. \t0-9]\.\w*',
      \'[^. \t0-9]\->\w*',
      \'[^. \t0-9]\::\w*',
      \])
let g:deoplete#omni#input_patterns.jsp = get(g:deoplete#omni#input_patterns, 'jsp', ['[^. \t0-9]\.\w*'])
if g:spacevim_enable_javacomplete2_py
  let g:deoplete#ignore_sources.java = get(g:deoplete#ignore_sources, 'java', ['omni'])
  call deoplete#custom#source('javacomplete2', 'mark', '')
else
  let g:deoplete#ignore_sources.java = get(g:deoplete#ignore_sources, 'java', ['javacomplete2', 'around', 'member'])
  call deoplete#custom#source('omni', 'mark', '')
  call deoplete#custom#source('omni', 'rank', 9999)
endif

" sh
let g:deoplete#ignore_sources.sh = get(g:deoplete#ignore_sources, 'sh', ['around', 'member', 'tag', 'syntax'])

" go
let g:deoplete#ignore_sources.go = get(g:deoplete#ignore_sources, 'go', ['omni'])
call deoplete#custom#source('go', 'mark', '')
call deoplete#custom#source('go', 'rank', 9999)

" markdown
let g:deoplete#ignore_sources.markdown = get(g:deoplete#ignore_sources, 'markdown', ['tag'])

" perl
let g:deoplete#omni#input_patterns.perl = get(g:deoplete#omni#input_patterns, 'perl', [
      \'[^. \t0-9]\.\w*',
      \'[^. \t0-9]\->\w*',
      \'[^. \t0-9]\::\w*',
      \])

" javascript
"let g:deoplete#omni#input_patterns.javascript = get(g:deoplete#omni#input_patterns, 'javascript', ['[^. \t0-9]\.\w*'])
let g:deoplete#ignore_sources.javascript = get(g:deoplete#ignore_sources, 'javascript', ['omni'])
call deoplete#custom#source('ternjs', 'mark', 'tern')
call deoplete#custom#source('ternjs', 'rank', 9999)

" typescript
let g:deoplete#ignore_sources.typescript = get(g:deoplete#ignore_sources, 'typescript', ['tag','omni', 'syntax'])
call deoplete#custom#source('typescript', 'rank', 9999)


" php two types, 1. phpcd (default)  2. lsp
if SpaceVim#layers#lsp#check_filetype('php')
  if has('nvim')
    let g:deoplete#ignore_sources.php = get(g:deoplete#ignore_sources, 'php', ['omni', 'around', 'member'])
  else
    let g:deoplete#ignore_sources.php = get(g:deoplete#ignore_sources, 'php', ['around', 'member'])
  endif
else
  let g:deoplete#ignore_sources.php = get(g:deoplete#ignore_sources, 'php', ['phpcd', 'around', 'member'])
  "call deoplete#custom#source('phpcd', 'mark', '')
  "call deoplete#custom#source('phpcd', 'input_pattern', '\w*|[^. \t]->\w*|\w*::\w*')
endif
let g:deoplete#omni#input_patterns.php = get(g:deoplete#omni#input_patterns, 'php', [
      \'[^. \t0-9]\.\w*',
      \'[^. \t0-9]\->\w*',
      \'[^. \t0-9]\::\w*',
      \])

" gitcommit
let g:deoplete#omni#input_patterns.gitcommit = get(g:deoplete#omni#input_patterns, 'gitcommit', [
      \'[ ]#[ 0-9a-zA-Z]*',
      \])

let g:deoplete#ignore_sources.gitcommit = get(g:deoplete#ignore_sources, 'gitcommit', ['neosnippet'])

" lua
let g:deoplete#omni_patterns.lua = get(g:deoplete#omni_patterns, 'lua', '.')

" c c++
call deoplete#custom#source('clang2', 'mark', '')
let g:deoplete#ignore_sources.c = get(g:deoplete#ignore_sources, 'c', ['omni'])

" rust
let g:deoplete#ignore_sources.rust = get(g:deoplete#ignore_sources, 'rust', ['omni'])
call deoplete#custom#source('racer', 'mark', '')

" vim
let g:deoplete#ignore_sources.vim = get(g:deoplete#ignore_sources, 'vim', ['tag'])

" clojure
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

" ocaml
let g:deoplete#ignore_sources.ocaml = ['buffer', 'around', 'omni']

" public settings
call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#source('file/include', 'matchers', ['matcher_head'])
let g:deoplete#ignore_sources._ = get(g:deoplete#ignore_sources, '_', ['around', 'LanguageClient'])
for key in keys(g:deoplete#ignore_sources)
  if key != '_' && index(keys(get(g:, 'LanguageClient_serverCommands', {})), key) == -1
    let g:deoplete#ignore_sources[key] = g:deoplete#ignore_sources[key] + ['around', 'LanguageClient']
  endif
endfor
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
set isfname-==

" vim:set et sw=2:
