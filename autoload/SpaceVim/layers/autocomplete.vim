"=============================================================================
" autocomplete.vim --- SpaceVim autocomplete layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section autocomplete, layers-autocomplete
" @parentsection layers
" This layer provides auto-completion in SpaceVim. This layer is enabled by
" default. To disable this layer, add following snippet to your configuration
" file:
" >
"   [[layers]]
"     name = "autocomplete"
"     enable = false
" <
" 
" The following completion engines are supported:
" 
" 1. nvim-cmp - neovim >= 0.9.0
" 2. neocomplete - vim with `+lua`
" 3. neocomplcache - vim without `+lua`
" 4. deoplete - neovim with `+python3`
" 5. coc - vim >= 8.1 or neovim >= 0.3.1
" 6. YouCompleteMe - disabled by default, to enable ycm, see
" @section(options-enable_ycm)
" 7. Completor - vim8 with `+python` or `+python3`
" 8. asyncomplete - vim8 or neovim with `timers`
" 
" Snippets are supported via neosnippet(https://github.com/Shougo/neosnippet.vim).
" 
" @subsection Completion engine
" 
" By default, SpaceVim will choose the completion engine automatically based
" on your vim version. But you can choose the completion engine to be used
" with the following variable:
" 
" - `autocomplete_method`: the possible values are:
" - `ycm`: for YouCompleteMe
" - `neocomplcache`
" - `coc`: coc.nvim which also provides language server protocol feature
" - `deoplete`
" - `asyncomplete`
" - `completor`
" - `nvim-cmp`
" 
" here is an example:
" >
"   [options]
"     autocomplete_method = "deoplete"
" <
" 
" @subsection Snippets engine
" 
" The default snippets engine is `neosnippet`, the also can be changed to `ultisnips`:
" >
"   [options]
"     snippet_engine = "ultisnips"
" <
" 
" The following snippets repos have been added by default:
" 
" - Shougo/neosnippet-snippets: neosnippet's default snippets.
" - honza/vim-snippets: extra snippets
" 
" If the `snippet_engine` is `neosnippet`, the following directories will be used:
" 
" - `~/.SpaceVim/snippets/`: SpaceVim runtime snippets.
" - `~/.SpaceVim.d/snippets/`: custom global snippets.
" - `./.SpaceVim.d/snippets/`: custom local snippets (project's snippets)
" 
" You can provide additional directories by setting the
" variable `g:neosnippet#snippets_directory` which can take a string
" in case of a single path or a list of paths.
" 
" If the `snippet_engine` is `ultisnips`, the following directories will be used:
" 
" - `~/.SpaceVim/UltiSnips/`: SpaceVim runtime snippets.
" - `~/.SpaceVim.d/UltiSnips/`: custom global snippets.
" - `./.SpaceVim.d/UltiSnips/`: custom local snippets (project's snippets)
" 
" @subsection Complete parens
" 
" By default, the parens will be completed automatically, to disabled this feature:
" >
"   [options]
"     autocomplete_parens = false
" <
" 
" @subsection Layer options
"
" You can customize the user experience of autocompletion with the following
" layer options:
" 
" `auto_completion_return_key_behavior`: set the action to perform when the
" <Enter> key is pressed. the possible values are:
"    1. `complete` completes with the current selection
"    2. `smart` completes with current selection and expand snippet or argvs
"    3. `nil`
" By default it is `complete`.
"
" `auto_completion_tab_key_behavior`: set the action to perform when the
" <Tab> key is pressed, the possible values are:
"    1. `smart` cycle candidates, expand snippets, jump parameters
"    2. `complete` completes with the current selection
"    3. `cycle` completes the common prefix and cycle between candidates
"    4. `nil` insert a carriage return
" By default it is `complete`.
" 
" `auto_completion_delay`: a number to delay the completion after input in
" milliseconds, by default it is 50 ms.
" 
" `auto_completion_complete_with_key_sequence`: a string of two characters
" denoting a key sequence that will perform a `complete` action if the
" sequence as been entered quickly enough. If its value is `nil` then the
" feature is disabled.
"
" NOTE: This option should not has same value as `escape_key_binding`
"
" `auto_completion_complete_with_key_sequence_delay`: the number of
" seconds to wait for the autocompletion key sequence to be entered.
" The default value is 1 seconds. This option is used for vim's
" `timeoutlen` option in insert mode.
" 
" The default configuration of the layer is:
" >
"   [[layers]]
"     name = "autocomplete"
"     auto_completion_return_key_behavior = "nil"
"     auto_completion_tab_key_behavior = "smart"
"     auto_completion_delay = 200
"     auto_completion_complete_with_key_sequence = "nil"
"     auto_completion_complete_with_key_sequence_delay = 0.1
" <
" 
" `jk` is a good candidate for `auto_completion_complete_with_key_sequence` if you don’t use it already.
" 
" @subsection Show snippets in auto-completion popup
" 
" By default, snippets are shown in the auto-completion popup.
" To disable this feature, set the variable `auto_completion_enable_snippets_in_popup` to false.
" >
"   [[layers]]
"     name = "autocomplete"
"     auto_completion_enable_snippets_in_popup = false
" <
" 
" @subsection Key bindings
" 
" code completion:
" >
"   Key bindings | Description
"   ------------ | -----------------------------------------------
"    Ctrl-n      | select next candidate
"    Ctrl-p      | select previous candidate
"    <Tab>       | based on  auto_completion_tab_key_behavior 
"    Shift-Tab   | select previous candidate
"    <Return>    | based on  auto_completion_return_key_behavior 
" <
" snippets:
" >
"    Key Binding   | Description
"   -------------- | ----------------------------------------
"    M-/           | Expand a snippet
"    SPC i s       | List all current snippets for inserting
"    <Leader> f s  | Fuzzy find snippets
" <
" NOTE: `SPC i s` requires that at least one fuzzy search layer be loaded.
" If the `snippet_engine` is `neosnippet`. The fuzzy finder layer can be
" `leaderf`, `denite` or `unite`. For `ultisnips`, you can use `leaderf`
" or `unite` layer.


if exists('s:return_key_behavior')
  finish
else
  let s:return_key_behavior = 'smart'
  let s:tab_key_behavior = 'smart'
  let g:_spacevim_key_sequence = 'nil'
  let s:key_sequence_delay = 1
  let g:_spacevim_autocomplete_delay = 50
  let s:timeoutlen = &timeoutlen
endif

let s:NVIM_VERSION = SpaceVim#api#import('neovim#version')

function! SpaceVim#layers#autocomplete#plugins() abort
  let plugins = [
        \ [g:_spacevim_root_dir . 'bundle/vim-snippets',          { 'on_event' : 'InsertEnter', 'loadconf_before' : 1}],
        \ [g:_spacevim_root_dir . 'bundle/neco-syntax',          { 'on_event' : 'InsertEnter'}],
        \ [g:_spacevim_root_dir . 'bundle/context_filetype.vim', { 'on_event' : 'InsertEnter'}],
        \ [g:_spacevim_root_dir . 'bundle/neoinclude.vim',       { 'on_event' : 'InsertEnter'}],
        \ [g:_spacevim_root_dir . 'bundle/neosnippet-snippets',  { 'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/neopairs.vim',         { 'on_event' : 'InsertEnter'}],
        \ ]
  call add(plugins, [g:_spacevim_root_dir . 'bundle/deoplete-dictionary',        { 'merged' : 0}])
  if g:spacevim_autocomplete_parens
    call add(plugins, [g:_spacevim_root_dir . 'bundle/delimitMate',        { 'merged' : 0}])
  endif
  " snippet
  if g:spacevim_snippet_engine ==# 'neosnippet'
    call add(plugins,  [g:_spacevim_root_dir . 'bundle/neosnippet.vim', { 'on_event' : 'InsertEnter',
          \ 'on_ft' : 'neosnippet',
          \ 'loadconf' : 1,
          \ 'on_cmd' : 'NeoSnippetEdit'}])
  elseif g:spacevim_snippet_engine ==# 'ultisnips'
    call add(plugins, ['SirVer/ultisnips',{ 'loadconf_before' : 1,
          \ 'merged' : 0}])
  endif
  if g:spacevim_autocomplete_method ==# 'ycm'
    call add(plugins, ['Valloric/YouCompleteMe',            { 'loadconf_before' : 1, 'merged' : 0}])
  elseif g:spacevim_autocomplete_method ==# 'neocomplete'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/neocomplete.vim', {
          \ 'on_event' : 'InsertEnter',
          \ 'loadconf' : 1,
          \ }])
  elseif g:spacevim_autocomplete_method ==# 'neocomplcache' "{{{
    call add(plugins, ['Shougo/neocomplcache.vim', {
          \ 'on_event' : 'InsertEnter',
          \ 'loadconf' : 1,
          \ }])
  elseif g:spacevim_autocomplete_method ==# 'coc'
    if executable('yarn')
      call add(plugins, ['neoclide/coc.nvim',  {'loadconf': 1, 'merged': 0, 'build': 'yarn install --frozen-lockfile'}])
    else
      " using https://github.com/neoclide/coc.nvim/tree/bbaa1d5d1ff3cbd9d26bb37cfda1a990494c4043
      " the release branch push on 2022-03-30
      call add(plugins, [g:_spacevim_root_dir . 'bundle/coc.nvim-release',  {'loadconf': 1, 'merged': 0}])
    endif
  elseif g:spacevim_autocomplete_method ==# 'deoplete'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/deoplete.nvim', {
          \ 'on_event' : 'InsertEnter',
          \ 'loadconf' : 1,
          \ }])
  elseif g:spacevim_autocomplete_method ==# 'nvim-cmp'
    " use bundle nvim-cmp
    call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-cmp', {
          \ 'merged' : 0,
          \ 'loadconf' : 1, 'on_event' : ['InsertEnter'],
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/cmp-buffer', {
          \ 'merged' : 0,
          \ 'on_event' : ['InsertEnter'],
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/cmp-path', {
          \ 'merged' : 0,
          \ 'on_event' : ['InsertEnter'],
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/cmp-cmdline', {
          \ 'merged' : 0,
          \ 'on_event' : ['InsertEnter'],
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/lspkind-nvim', {
          \ 'merged' : 0,
          \ 'loadconf' : 1, 'on_event' : ['InsertEnter'],
          \ }])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/cmp-dictionary', {
          \ 'merged' : 0,
          \ 'loadconf' : 1, 'on_event' : ['InsertEnter'],
          \ }])
    if g:spacevim_snippet_engine ==# 'neosnippet'
      call add(plugins, [g:_spacevim_root_dir . 'bundle/cmp-neosnippet', {
            \ 'merged' : 0,
            \ 'on_event' : ['InsertEnter'],
            \ }])
    endif
  elseif g:spacevim_autocomplete_method ==# 'asyncomplete'
    call add(plugins, ['prabirshrestha/asyncomplete.vim', {
          \ 'loadconf' : 1,
          \ 'merged' : 0,
          \ }])
    call add(plugins, ['prabirshrestha/asyncomplete-buffer.vim', {
          \ 'loadconf' : 1,
          \ 'merged' : 0,
          \ }])
    call add(plugins, ['yami-beta/asyncomplete-omni.vim', {
          \ 'loadconf' : 1,
          \ 'merged' : 0,
          \ }])
  elseif g:spacevim_autocomplete_method ==# 'completor'
    call add(plugins, ['maralla/completor.vim', {
          \ 'loadconf' : 1,
          \ 'merged' : 0,
          \ }])
    if g:spacevim_snippet_engine ==# 'neosnippet'
      call add(plugins, ['maralla/completor-neosnippet', {
            \ 'loadconf' : 1,
            \ 'merged' : 0,
            \ }])
    endif
  endif
  if has('patch-7.4.774')
    " both echodoc and CompleteParameter requires
    " vim patch-7.4.744
    " v:completed_item
    call add(plugins, [g:_spacevim_root_dir . 'bundle/echodoc.vim', {
          \ 'on_cmd' : ['EchoDocEnable', 'EchoDocDisable'],
          \ 'on_event' : 'CompleteDone',
          \ 'loadconf_before' : 1,
          \ }])
    if g:spacevim_autocomplete_method !=# 'nvim-cmp'
      " this plugin use same namespace as nvim-cmp
      call add(plugins, [g:_spacevim_root_dir . 'bundle/CompleteParameter.vim',
            \ { 'merged' : 0}])
    endif
  endif
  return plugins
endfunction

function! SpaceVim#layers#autocomplete#config() abort
  if g:spacevim_autocomplete_parens
    imap <expr> (
          \ pumvisible() ?
          \ has('patch-7.4.744') ?
          \ complete_parameter#pre_complete("()") : '(' :
          \ (len(maparg('<Plug>delimitMate(', 'i')) == 0) ?
          \ "\<Plug>delimitMate(" :
          \ '('
  endif

  "mapping
  "
  " 如果使用 nvim-cmp 作为补全引擎，那么 Tab 以及 Enter 快捷键的映射是在
  " ./lua/config/nvim-cmp.lua 内设置。
  if s:tab_key_behavior ==# 'smart'
    if has('patch-7.4.774')
      imap <silent><expr><TAB> SpaceVim#mapping#tab()
      imap <silent><expr><S-TAB> SpaceVim#mapping#shift_tab()
      if g:spacevim_snippet_engine ==# 'neosnippet'
        smap <expr><TAB>
              \ neosnippet#expandable_or_jumpable() ?
              \ "\<Plug>(neosnippet_expand_or_jump)" :
              \ (complete_parameter#jumpable(1) ?
              \ "\<plug>(complete_parameter#goto_next_parameter)" :
              \ "\<TAB>")
      elseif g:spacevim_snippet_engine ==# 'ultisnips'
        snoremap <silent> <TAB>
              \ <ESC>:call UltiSnips#JumpForwards()<CR>
        snoremap <silent> <S-TAB>
              \ <ESC>:call UltiSnips#JumpBackwards()<CR>
      endif
    else
      call SpaceVim#logger#info('smart tab in autocomplete layer need patch 7.4.774')
    endif
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
  let g:complete_parameter_use_ultisnips_mapping = 1
  if g:spacevim_snippet_engine ==# 'neosnippet'
    imap <expr> <M-/>
          \ neosnippet#expandable() ?
          \ "\<Plug>(neosnippet_expand)" : ""
  elseif g:spacevim_snippet_engine ==# 'ultisnips'
    inoremap <silent> <M-/> <C-R>=UltiSnips#ExpandSnippetOrJump()<cr>
  endif

  if !empty(g:_spacevim_key_sequence) && g:_spacevim_key_sequence !=# 'nil'
    if g:spacevim_escape_key_binding !=# g:_spacevim_key_sequence
      augroup spacevim_layer_autocomplete
        autocmd!
        autocmd InsertEnter * call s:apply_sequence_delay()
        autocmd InsertLeave * call s:restore_sequence_delay()
      augroup END
    else
      call SpaceVim#logger#warn('Can not use same value for escape_key_binding and auto_completion_complete_with_key_sequence')
    endif
  endif
  let g:_spacevim_mappings_space.x = {'name' : '+Text'}
  let g:_spacevim_mappings_space.x.s = {'name' : '+String/Snippet'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 's', 's'], 'NeoSnippetEdit', 'edit-snippet-file', 1)
endfunction

function! SpaceVim#layers#autocomplete#set_variable(var) abort

  let s:return_key_behavior = get(a:var,
        \ 'auto_completion_return_key_behavior',
        \ get(a:var,
        \ 'auto-completion-return-key-behavior',
        \ s:return_key_behavior))
  let s:tab_key_behavior = get(a:var,
        \ 'auto_completion_tab_key_behavior',
        \ get(a:var,
        \ 'auto-completion-tab-key-behavior',
        \ s:tab_key_behavior))
  let g:_spacevim_key_sequence = get(a:var,
        \ 'auto_completion_complete_with_key_sequence',
        \ get(a:var,
        \ 'auto-completion-complete-with-key-sequence',
        \ g:_spacevim_key_sequence))
  let g:_spacevim_key_sequence_delay = get(a:var,
        \ 'auto_completion_complete_with_key_sequence_delay',
        \ get(a:var,
        \ 'auto-completion-complete-with-key-sequence-delay',
        \ s:key_sequence_delay))
  let g:_spacevim_autocomplete_delay = get(a:var,
        \ 'auto_completion_delay', 
        \ get(a:var, 'auto-completion-delay', 
        \ g:_spacevim_autocomplete_delay))

endfunction

function! SpaceVim#layers#autocomplete#get_variable() abort
  
  return {
        \ 'auto_completion_tab_key_behavior' : s:tab_key_behavior,
        \ 'auto_completion_return_key_behavior' : s:return_key_behavior,
        \ }
  

endfunction

function! SpaceVim#layers#autocomplete#get_options() abort

  return ['return_key_behavior',
        \ 'tab_key_behavior',
        \ 'auto_completion_complete_with_key_sequence',
        \ 'auto_completion_complete_with_key_sequence_delay']

endfunction

function! SpaceVim#layers#autocomplete#getprfile() abort



endfunction

function! SpaceVim#layers#autocomplete#toggle_deoplete() abort
  if deoplete#custom#_get_option('auto_complete')
    call deoplete#custom#option('auto_complete', v:false)
  else
    call deoplete#custom#option('auto_complete', v:true)
  endif
endfunction

function! SpaceVim#layers#autocomplete#health() abort
  call SpaceVim#layers#autocomplete#getprfile()
  call SpaceVim#layers#autocomplete#plugins()
  call SpaceVim#layers#autocomplete#config()

  return 1

endfunction

function! s:apply_sequence_delay() abort
  let &timeoutlen =  s:key_sequence_delay * 1000
endfunction

function! s:restore_sequence_delay() abort
  let &timeoutlen = s:timeoutlen
endfunction
function! SpaceVim#layers#autocomplete#loadable() abort

  return 1

endfunction
" vim:set et sw=2 cc=80:
