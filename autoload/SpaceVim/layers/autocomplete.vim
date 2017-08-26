""
" @section autocomplete, autocomplete
" @parentsection layers
" @subsection code completion
" SpaceVim uses neocomplete as the default completion engine if vim has lua
" support. If there is no lua support, neocomplcache will be used for the
" completion engine. Spacevim uses deoplete as the default completion engine
" for neovim. Deoplete requires neovim to be compiled with python support. For
" more information on python support, please read neovim's |provider-python|.
"
" SpaceVim includes YouCompleteMe, but it is disabled by default. To enable
" ycm, see |g:spacevim_enable_ycm|.
"
" @subsection snippet
" SpaceVim use neosnippet as the default snippet engine. The default snippets
" are provided by `Shougo/neosnippet-snippets`. For more information, please read
" |neosnippet|. Neosnippet support custom snippets, and the default snippets
" directory is `~/.SpaceVim/snippets/`. If `g:spacevim_force_global_config = 1`,
" SpaceVim will not append `./.SpaceVim/snippets` as default snippets directory.


function! SpaceVim#layers#autocomplete#plugins() abort
  let plugins = [
        \ ['honza/vim-snippets',          { 'on_event' : 'InsertEnter', 'loadconf_before' : 1}],
        \ ['Shougo/neco-syntax',          { 'on_event' : 'InsertEnter'}],
        \ ['ujihisa/neco-look',           { 'on_event' : 'InsertEnter'}],
        \ ['Shougo/context_filetype.vim', { 'on_event' : 'InsertEnter'}],
        \ ['Shougo/neoinclude.vim',       { 'on_event' : 'InsertEnter'}],
        \ ['Shougo/neosnippet-snippets',  { 'merged' : 0}],
        \ ['Shougo/neopairs.vim',         { 'on_event' : 'InsertEnter'}],
        \ ['Raimondi/delimitMate',        { 'merged' : 0}],
        \ ]
  " snippet
  if g:spacevim_snippet_engine ==# 'neosnippet'
    call add(plugins,  ['Shougo/neosnippet.vim', { 'on_event' : 'InsertEnter',
          \ 'on_ft' : 'neosnippet',
          \ 'loadconf' : 1,
          \ 'on_cmd' : 'NeoSnippetEdit'}])
  elseif g:spacevim_snippet_engine ==# 'ultisnips'
    call add(plugins, ['SirVer/ultisnips',{ 'loadconf_before' : 1,
          \ 'merged' : 0}])
  endif
  if g:spacevim_autocomplete_method ==# 'ycm'
    call add(plugins, ['ervandew/supertab',                 { 'loadconf_before' : 1, 'merged' : 0}])
    call add(plugins, ['Valloric/YouCompleteMe',            { 'loadconf_before' : 1, 'merged' : 0}])
  elseif g:spacevim_autocomplete_method ==# 'neocomplete'
    call add(plugins, ['Shougo/neocomplete', {
          \ 'on_event' : 'InsertEnter',
          \ 'loadconf' : 1,
          \ }])
  elseif g:spacevim_autocomplete_method ==# 'neocomplcache' "{{{
    call add(plugins, ['Shougo/neocomplcache.vim', {
          \ 'on_event' : 'InsertEnter',
          \ 'loadconf' : 1,
          \ }])
  elseif g:spacevim_autocomplete_method ==# 'deoplete'
    call add(plugins, ['Shougo/deoplete.nvim', {
          \ 'on_event' : 'InsertEnter',
          \ 'loadconf' : 1,
          \ }])
  endif
  call add(plugins, ['tenfyzhong/CompleteParameter.vim',  {'merged': 0}])
  return plugins
endfunction


function! SpaceVim#layers#autocomplete#config() abort
  imap <expr>( 
        \ pumvisible() ? 
        \ complete_parameter#pre_complete("()") : 
        \ (len(maparg('<Plug>delimitMate(', 'i')) == 0) ?
        \ "\<Plug>delimitMate(" :
        \ '('

  "mapping
  if s:tab_key_behavior ==# 'smart'
    imap <silent><expr><TAB> SpaceVim#mapping#tab()
    smap <expr><TAB>
          \ neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)" :
          \ (complete_parameter#jumpable(1) ?
          \ "\<plug>(complete_parameter#goto_next_parameter)" :
          \ "\<TAB>")
    imap <silent><expr><S-TAB> SpaceVim#mapping#shift_tab()
  elseif s:tab_key_behavior ==# 'complete'
    inoremap <expr> <Tab>       pumvisible() ? "\<C-y>" : "\<C-n>"
  elseif s:tab_key_behavior ==# 'cycle'
    inoremap <expr> <Tab>       pumvisible() ? "\<Down>" : "\<Tab>"
    inoremap <expr> <S-Tab>       pumvisible() ? "\<Up>" : ""
  elseif s:tab_key_behavior ==# 'nil'
  endif
  if s:return_key_behavior ==# 'smart'
    imap <silent><expr><CR> SpaceVim#mapping#enter()
  elseif s:return_key_behavior ==# 'complete'
    imap <silent><expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
  elseif s:return_key_behavior ==# 'nil'
  endif

  inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
  inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
  inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
  " in origin vim or neovim Alt + / will insert a /, this should be disabled.
  imap <expr> <M-/>
        \ neosnippet#expandable() ?
        \ "\<Plug>(neosnippet_expand)" : ""
  call SpaceVim#mapping#space#def('nnoremap', ['i', 's'], 'Unite neosnippet', 'insert sneppets', 1)
endfunction

let s:return_key_behavior = 'smart'
let s:tab_key_behavior = 'smart'
let s:key_sequence = 'nil'
let s:key_sequence_delay = 0.1

function! SpaceVim#layers#autocomplete#set_variable(var) abort

  let s:return_key_behavior = get(a:var,
        \ 'auto-completion-return-key-behavior',
        \ 'nil')
  let s:tab_key_behavior = get(a:var,
        \ 'auto-completion-tab-key-behavior',
        \ 'smart')
  let s:key_sequence = get(a:var,
        \ 'auto-completion-complete-with-key-sequence',
        \ 'nil')
  let s:key_sequence_delay = get(a:var,
        \ 'auto-completion-complete-with-key-sequence-delay',
        \ 0.1)

endfunction


" vim:set et sw=2 cc=80:
