""
" @section autocomplete, autocomplete
" @parentsection layers
" @subsection code completion
" SpaceVim use neocomplete as default completion engine for vim with lua
" support, if has no lua support neocomplcache will be the completion engine.
" SpaceVim use deoplete as default completion engine for nevoim. to make
" neovim support python, please read neovim's |provider-python|.
"
" SpaceVim include YouCompleteMe, but it is disabled by default, to enable
" ycm, see |g:spacevim_enable_ycm|.
"
" @subsection snippet
" SpaceVim use neosnippet as default snippet engine, and the default snippets
" is `Shougo/neosnippet-snippets`. for more information, please read
" |neosnippet|. neosnippet support custtom snippets, and the default snippets
" directory is `~/.SpaceVim.d/snippets/` and if
" g:spacevim_force_global_config = 1, SpaceVim will not append
" `./.SpaceVim.d/snippets` as default snippets directory.



function! SpaceVim#layers#autocomplete#plugins() abort
    let plugins = [
                \ ['honza/vim-snippets', {'on_i' : 1, 'loadconf_before' : 1}],
                \ ['Shougo/neco-syntax',           { 'on_i' : 1}],
                \ ['ujihisa/neco-look',            { 'on_i' : 1}],
                \ ['Shougo/context_filetype.vim',  { 'on_i' : 1}],
                \ ['Shougo/neoinclude.vim',        { 'on_i' : 1}],
                \ ['Shougo/neosnippet-snippets',   { 'merged' : 0}],
                \ ['Shougo/neopairs.vim',          { 'on_i' : 1}],
                \ ]
    if g:spacevim_autocomplete_method ==# 'ycm'
        call add(plugins, ['SirVer/ultisnips', {'loadconf_before' : 1, 'merged' : 0}])
        call add(plugins, ['ervandew/supertab', {'loadconf_before' : 1, 'merged' : 0}])
        call add(plugins, ['Valloric/YouCompleteMe', {'loadconf_before' : 1, 'merged' : 0}])
    elseif g:spacevim_autocomplete_method ==# 'neocomplete' "{{{
        call add(plugins, ['Shougo/neocomplete', {
                    \ 'on_i' : 1,
                    \ 'loadconf' : 1,
                    \ }])
    elseif g:spacevim_autocomplete_method ==# 'neocomplcache' "{{{
        call add(plugins, ['Shougo/neocomplcache.vim', {
                    \ 'on_i' : 1,
                    \ 'loadconf' : 1,
                    \ }])
    elseif g:spacevim_autocomplete_method ==# 'deoplete'
        call add(plugins, ['Shougo/deoplete.nvim', {
                    \ 'on_i' : 1,
                    \ 'loadconf' : 1,
                    \ }])
    endif
    return plugins
endfunction
