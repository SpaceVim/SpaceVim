let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni#input_patterns.java = [
            \'[^. \t0-9]\.\w*',
            \'[^. \t0-9]\->\w*',
            \'[^. \t0-9]\::\w*',
            \]
let g:deoplete#omni#input_patterns.jsp = ['[^. \t0-9]\.\w*']
let g:deoplete#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:deoplete#ignore_sources = {}
if g:spacevim_enable_javacomplete2_py
    let g:deoplete#ignore_sources.java = ['omni']
    call deoplete#custom#set('javacomplete2', 'mark', '')
else
    let g:deoplete#ignore_sources.java = ['javacomplete2']
    call deoplete#custom#set('omni', 'mark', '')
endif
call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
let g:deoplete#ignore_sources._ = ['around']
"call deoplete#custom#set('omni', 'min_pattern_length', 0)
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
set isfname-==
