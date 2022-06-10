"=============================================================================
" edit.vim --- SpaceVim edit layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section edit, layers-edit
" @parentsection layers
" The `edit` layer provides basic feature for editing files.
" This layer is loaded by default. To disable this layer:
" >
"   [[layers]]
"     name = 'edit'
"     enable = false
" <
" @subsection Configuration
" 1. `autosave_timeout`: set the timeoutlen of autosave plugin. By default it
" is 0. And autosave is disabled. timeoutlen must be given in millisecods and
" can't be > 100*60*1000 (100 minutes) or < 1000 (1 second). For example,
" setup timer with 5 minutes:
" >
"   [[layers]]
"     name = 'edit'
"     autosave_timeout = 300000
" <
" 2. `autosave_events`: set the events on which autosave will perform a save.
" This option is an empty list by default. you can trigger saving based
" on vim's events, for example:
" >
"   [[layers]]
"     name = 'edit'
"     autosave_events = ['InsertLeave', 'TextChanged']
" <
" 3. `autosave_all_buffers`: By default autosave plugin only save current buffer.
" If you want to save all buffers automatically. Set this option to `true`.
" >
"   [[layers]]
"     name = 'edit'
"     autosave_all_buffers = true
" <
" 4. `autosave_location`: set the directory where to save changed files. By
" default it is empty string, that means saving to the original file. If this
" option is not an empty string. files will me saved to that directory
" automatically. and the format is:
" >
"   autosave_location/path+=to+=filename.ext.backup
" <
" 5. `enable_hop`: by default, spacevim use easymotion plugin. and if you are
" using neovim 0.6.0 or above, hop.nvim will be enabled. You can disabled this
" plugin and still using easymotion.
"
" @subsection key bindings
"
" The `edit` layer also provides many key bindings:
" >
"   key binding       description
"   SPC x c           count in the selection region
" <
"
" The following key binding is to jump to targets. The default plugin is
" `easymotion`, and if you are using neovim 0.6.0 or above. The `hop.nvim` will
" be used.
" >
"   key binding       description
"   SPC j j           jump or select a character
"   SPC j J           jump to suite of two characters
"   SPC j l           jump or select to a line
"   SPC j w           jump to a word
"   SPC j u           jump to a url
" <

scriptencoding utf-8
if exists('s:autosave_timeout')
  finish
endif

let s:PASSWORD = SpaceVim#api#import('password')
let s:NUMBER = SpaceVim#api#import('data#number')
let s:LIST = SpaceVim#api#import('data#list')
let s:VIM = SpaceVim#api#import('vim')
let s:CMP = SpaceVim#api#import('vim#compatible')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:HI = SpaceVim#api#import('vim#highlight')

let s:autosave_timeout = 0
let s:autosave_events = []
let s:autosave_all_buffers = 0
let s:autosave_location = ''
let s:enable_hop = 1

function! SpaceVim#layers#edit#health() abort
  call SpaceVim#layers#edit#plugins()
  call SpaceVim#layers#edit#config()
  return 1
endfunction

function! SpaceVim#layers#edit#plugins() abort
  let plugins = [
        \ [g:_spacevim_root_dir . 'bundle/vim-surround'],
        \ [g:_spacevim_root_dir . 'bundle/vim-repeat'],
        \ [g:_spacevim_root_dir . 'bundle/vim-emoji'],
        \ [g:_spacevim_root_dir . 'bundle/vim-expand-region', { 'loadconf' : 1}],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-user'],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-indent'],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-line'],
        \ [g:_spacevim_root_dir . 'bundle/vim-table-mode'],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-entire'],
        \ [g:_spacevim_root_dir . 'bundle/wildfire.vim',{'on_map' : '<Plug>(wildfire-'}],
        \ [g:_spacevim_root_dir . 'bundle/editorconfig-vim', { 'merged' : 0, 'if' : has('python') || has('python3')}],
        \ [g:_spacevim_root_dir . 'bundle/vim-jplus', { 'on_map' : '<Plug>(jplus' }],
        \ [g:_spacevim_root_dir . 'bundle/tabular',           { 'merged' : 0}],
        \ ['andrewradev/splitjoin.vim',{ 'on_cmd':['SplitjoinJoin', 'SplitjoinSplit'],'merged' : 0, 'loadconf' : 1}],
        \ ]
  if has('nvim-0.6.0') && s:enable_hop
    call add(plugins,[g:_spacevim_root_dir . 'bundle/hop.nvim',        { 'merged' : 0, 'loadconf' : 1}])
  else
    call add(plugins,[g:_spacevim_root_dir . 'bundle/vim-easymotion',        { 'merged' : 0}])
    call add(plugins,[g:_spacevim_root_dir . 'bundle/vim-easyoperator-line',        { 'merged' : 0}])
  endif
  if executable('fcitx')
    call add(plugins,[g:_spacevim_root_dir . 'bundle/fcitx.vim',        { 'on_event' : 'InsertEnter'}])
  endif
  if g:spacevim_enable_bepo_layout
    call add(plugins,[g:_spacevim_root_dir . 'bundle/vim-bepo',        { 'merged' : 0}])
  endif
  if s:CMP.has('python3') || s:CMP.has('python')
    call add(plugins,[g:_spacevim_root_dir . 'bundle/vim-mundo',        { 'on_cmd' : 'MundoToggle'}])
  else
    call add(plugins,[g:_spacevim_root_dir . 'bundle/undotree',        { 'on_cmd' : 'UndotreeToggle'}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#edit#set_variable(var) abort
  let s:autosave_timeout = get(a:var, 'autosave_timeout', s:autosave_timeout)
  let s:autosave_events = get(a:var, 'autosave_events', s:autosave_events)
  let s:autosave_all_buffers = get(a:var, 'autosave_all_buffers', s:autosave_all_buffers)
  let s:autosave_location = get(a:var, 'autosave_location', s:autosave_location)
  let s:enable_hop = get(a:var, 'enable_hop', s:enable_hop)
endfunction

function! SpaceVim#layers#edit#get_options() abort
  return ['autosave_all_buffers', 'autosave_timeout', 'autosave_events']
endfunction
function! SpaceVim#layers#edit#config() abort
  " autosave plugins options
  let autosave_opt = {
        \ 'timeoutlen' : s:autosave_timeout,
        \ 'save_all_buffers' : s:autosave_all_buffers,
        \ 'backupdir' : s:autosave_location,
        \ 'event' : s:autosave_events,
        \ }
  call SpaceVim#plugins#autosave#config(autosave_opt)


  let g:multi_cursor_next_key=get(g:, 'multi_cursor_next_key', '<C-n>')
  let g:multi_cursor_prev_key=get(g:, 'multi_cursor_prev_key', '<C-m>')
  let g:multi_cursor_skip_key=get(g:, 'multi_cursor_skip_key', '<C-x>')
  let g:multi_cursor_quit_key=get(g:, 'multi_cursor_quit_key', '<Esc>')
  let g:user_emmet_install_global = 0
  let g:user_emmet_mode='a'
  let g:user_emmet_settings = {
        \ 'javascript': {
          \ 'extends': 'jsx',
          \ },
          \ 'jsp' : {
            \ 'extends': 'html',
            \ },
            \ }

  "noremap <SPACE> <Plug>(wildfire-fuel)
  vnoremap <C-SPACE> <Plug>(wildfire-water)
  let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']

  " osyo-manga/vim-jplus {{{
  nmap <silent> J <Plug>(jplus)
  vmap <silent> J <Plug>(jplus)
  " }}}


  if s:CMP.has('python3') || s:CMP.has('python')
    nnoremap <silent> <F7> :MundoToggle<CR>
  else
    nnoremap <silent> <F7> :UndotreeToggle<CR>
  endif
  let g:_spacevim_mappings_space.x = {'name' : '+Text'}
  let g:_spacevim_mappings_space.x.a = {'name' : '+align'}
  let g:_spacevim_mappings_space.x.d = {'name' : '+delete'}
  let g:_spacevim_mappings_space.x.i = {'name' : '+change symbol style'}
  nnoremap <silent> <Plug>CountSelectionRegion :call <SID>count_selection_region()<Cr>
  xnoremap <silent> <Plug>CountSelectionRegion :<C-u>call <SID>count_selection_region()<Cr>
  call SpaceVim#mapping#space#def('nmap', ['x', 'c'], '<Plug>CountSelectionRegion', 'count in the selection region', 0, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '#'], 'Tabularize /#', 'align-region-at-#', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '%'], 'Tabularize /%', 'align-region-at-%', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '&'], 'Tabularize /&', 'align-region-at-&', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '('], 'Tabularize /(', 'align-region-at-(', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ')'], 'Tabularize /)', 'align-region-at-)', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '['], 'Tabularize /[', 'align-region-at-[', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ']'], 'Tabularize /]', 'align-region-at-]', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '{'], 'Tabularize /{', 'align-region-at-{', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '}'], 'Tabularize /}', 'align-region-at-}', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ','], 'Tabularize /,', 'align-region-at-,', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '.'], 'Tabularize /\.', 'align-region-at-dot', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ':'], 'Tabularize /:', 'align-region-at-:', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ';'], 'Tabularize /;', 'align-region-at-;', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '='], 'Tabularize /===\|<=>\|\(&&\|||\|<<\|>>\|\/\/\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.?-]\?=[#?]\?/l1r1', 'align-region-at-=', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', 'o'], 'Tabularize /&&\|||\|\.\.\|\*\*\|<<\|>>\|\/\/\|[-+*/.%^><&|?]/l1r1', 'align-region-at-operator, such as +,-,*,/,%,^,etc', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '¦'], 'Tabularize /¦', 'align-region-at-¦', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '<Bar>'], 'Tabularize /[|｜]', 'align-region-at-|', 1, 1)
  call SpaceVim#mapping#space#def('nmap', ['x', 'a', '[SPC]'], 'Tabularize /\s\ze\S/l0', 'align-region-at-space', 1, 1)
  " @fixme SPC x a SPC make vim flick
  nmap <Space>xa<Space> [SPC]xa[SPC]
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', 'r'], 'call call('
        \ . string(s:_function('s:align_at_regular_expression')) . ', [])',
        \ 'align-region-at-user-specified-regexp', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', 'w'], 'StripWhitespace', 'delete trailing whitespaces', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', '[SPC]'], 'silent call call('
        \ . string(s:_function('s:delete_extra_space')) . ', [])',
        \ 'delete extra space arround cursor', 1)
  nmap <Space>xd<Space> [SPC]xd[SPC]
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'c'], 'silent call call('
        \ . string(s:_function('s:lowerCamelCase')) . ', [])',
        \ 'change symbol style to lowerCamelCase', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'C'], 'silent call call('
        \ . string(s:_function('s:UpperCamelCase')) . ', [])',
        \ 'change symbol style to UpperCamelCase', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', '_'], 'silent call call('
        \ . string(s:_function('s:under_score')) . ', [])',
        \ 'change symbol style to under_score', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'u'], 'silent call call('
        \ . string(s:_function('s:under_score')) . ', [])',
        \ 'change symbol style to under_score', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'U'], 'silent call call('
        \ . string(s:_function('s:up_case')) . ', [])',
        \ 'change symbol style to UP_CASE', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'k'], 'silent call call('
        \ . string(s:_function('s:kebab_case')) . ', [])',
        \ 'change symbol style to kebab-case', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', '-'], 'silent call call('
        \ . string(s:_function('s:kebab_case')) . ', [])',
        \ 'change symbol style to kebab-case', 1)

  " justification
  let g:_spacevim_mappings_space.x.j = {'name' : '+Justification'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'j', 'l'], 'silent call call('
        \ . string(s:_function('s:set_justification_to')) . ', ["left"])',
        \ 'set-the-justification-to-left', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'j', 'c'], 'silent call call('
        \ . string(s:_function('s:set_justification_to')) . ', ["center"])',
        \ 'set-the-justification-to-center', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'j', 'r'], 'silent call call('
        \ . string(s:_function('s:set_justification_to')) . ', ["right"])',
        \ 'set-the-justification-to-right', 1)

  nnoremap <silent> <Plug>Lowercase  :call <SID>toggle_case(0, -1)<Cr>
  vnoremap <silent> <Plug>Lowercase  :call <SID>toggle_case(1, -1)<Cr>
  nnoremap <silent> <Plug>Uppercase  :call <SID>toggle_case(0, 1)<Cr>
  vnoremap <silent> <Plug>Uppercase  :call <SID>toggle_case(1, 1)<Cr>
  nnoremap <silent> <Plug>ToggleCase :call <SID>toggle_case(0, 0)<Cr>
  vnoremap <silent> <Plug>ToggleCase :call <SID>toggle_case(1, 0)<Cr>
  call SpaceVim#mapping#space#def('nmap' , ['x' , 'u'] , '<Plug>Lowercase'  , 'lowercase-text'   , 0, 1)
  call SpaceVim#mapping#space#def('nmap' , ['x' , 'U'] , '<Plug>Uppercase'  , 'uppercase-text'   , 0, 1)
  call SpaceVim#mapping#space#def('nmap' , ['x' , '~'] , '<Plug>ToggleCase' , 'toggle-case-text' , 0, 1)

  " word
  let g:_spacevim_mappings_space.x.w = {'name' : '+Word'}
  call SpaceVim#mapping#space#def('vnoremap', ['x', 'w', 'c'], 'normal! ' . ":'<,'>s/\\\w\\+//gn" . "\<cr>", 'count the words in the select region', 1)
  let g:_spacevim_mappings_space.x.s = {'name' : '+String/Snippet'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 's', 'j'], 'call call('
        \ . string(s:_function('s:join_string_with')) . ', [])',
        \ 'join-string-with', 1)

  " line
  let g:_spacevim_mappings_space.x.l = {'name' : '+Line'}
  nnoremap <silent> <Plug>DuplicateLines :call <SID>duplicate_lines(0)<Cr>
  vnoremap <silent> <Plug>DuplicateLines :call <SID>duplicate_lines(1)<Cr>
  call SpaceVim#mapping#space#def('nmap', ['x', 'l', 'd'], '<Plug>DuplicateLines',
        \ 'duplicate-line-or-region', 0, 1)
  nnoremap <silent> <Plug>ReverseLines :ReverseLines<cr>
  vnoremap <silent> <Plug>ReverseLines :ReverseLines<cr>
  call SpaceVim#mapping#space#def('nmap' , ['x' , 'l' , 'r'] , '<Plug>ReverseLines'  , 'reverse-lines'                  , 0, 1)
  call SpaceVim#mapping#space#def('nnoremap' , ['x' , 'l' , 's'] , 'sort i'  , 'sort lines (ignorecase)'                    , 1)
  call SpaceVim#mapping#space#def('nnoremap' , ['x' , 'l' , 'S'] , 'sort'    , 'sort lines (case-sensitive)'                , 1)
  nnoremap <silent> <Plug>UniquifyIgnoreCaseLines :call <SID>uniquify_lines(0, 1)<Cr>
  vnoremap <silent> <Plug>UniquifyIgnoreCaseLines :call <SID>uniquify_lines(1, 1)<Cr>
  nnoremap <silent> <Plug>UniquifyCaseSenstiveLines :call <SID>uniquify_lines(0, 0)<Cr>
  vnoremap <silent> <Plug>UniquifyCaseSenstiveLines :call <SID>uniquify_lines(1, 0)<Cr>
  call SpaceVim#mapping#space#def('nmap', ['x', 'l', 'u'], '<Plug>UniquifyIgnoreCaseLines',
        \ 'uniquify-lines (ignorecase)', 0, 1)
  call SpaceVim#mapping#space#def('nmap', ['x', 'l', 'U'], '<Plug>UniquifyCaseSenstiveLines',
        \ 'uniquify-lines (case-senstive)', 0, 1)

  let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
  let g:_spacevim_mappings_space.i.l = {'name' : '+Lorem-ipsum'}
  let g:_spacevim_mappings_space.i.p = {'name' : '+Passwords'}
  let g:_spacevim_mappings_space.i.U = {'name' : '+UUID'}
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 1], 'call call('
        \ . string(s:_function('s:insert_simple_password')) . ', [])',
        \ 'insert-simple-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 2], 'call call('
        \ . string(s:_function('s:insert_stronger_password')) . ', [])',
        \ 'insert-stronger-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 3], 'call call('
        \ . string(s:_function('s:insert_paranoid_password')) . ', [])',
        \ 'insert-password-for-paranoids', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'p'], 'call call('
        \ . string(s:_function('s:insert_phonetically_password')) . ', [])',
        \ 'insert-a-phonetically-easy-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'n'], 'call call('
        \ . string(s:_function('s:insert_numerical_password')) . ', [])',
        \ 'insert-a-numerical-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'U', 'U'], 'call call('
        \ . string(s:_function('s:uuidgen_U')) . ', [])',
        \ 'uuidgen-4', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 'l'], 'call call('
        \ . string(s:_function('s:insert_lorem_ipsum_list')) . ', [])',
        \ 'insert-lorem-ipsum-list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 'p'], 'call call('
        \ . string(s:_function('s:insert_lorem_ipsum_paragraph')) . ', [])',
        \ 'insert-lorem-ipsum-paragraph', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 's'], 'call call('
        \ . string(s:_function('s:insert_lorem_ipsum_sentence')) . ', [])',
        \ 'insert-lorem-ipsum-sentence', 1)
  " move line
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'J'], 'call call('
        \ . string(s:_function('s:move_text_down_transient_state')) . ', [])',
        \ 'move-text-down(enter-transient-state)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'K'], 'call call('
        \ . string(s:_function('s:move_text_up_transient_state')) . ', [])',
        \ 'move-text-up(enter-transient-state)', 1)

  " transpose
  let g:_spacevim_mappings_space.x.t = {'name' : '+transpose'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'c'], 'call call('
        \ . string(s:_function('s:transpose_with_previous')) . ', ["character"])',
        \ 'swap-current-character-with-previous-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'w'], 'call call('
        \ . string(s:_function('s:transpose_with_previous')) . ', ["word"])',
        \ 'swap-current-word-with-previous-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'l'], 'call call('
        \ . string(s:_function('s:transpose_with_previous')) . ', ["line"])',
        \ 'swap-current-line-with-previous-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'C'], 'call call('
        \ . string(s:_function('s:transpose_with_next')) . ', ["character"])',
        \ 'swap-current-character-with-next-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'W'], 'call call('
        \ . string(s:_function('s:transpose_with_next')) . ', ["word"])',
        \ 'swap-current-word-with-next-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'L'], 'call call('
        \ . string(s:_function('s:transpose_with_next')) . ', ["line"])',
        \ 'swap-current-line-with-next-one', 1)

  " splitjoin
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'o'],
        \ 'SplitjoinJoin', 'join into a single-line statement', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'm'],
        \ 'SplitjoinSplit', 'split a one-liner into multiple lines', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'k'], 'j==', 'goto-next-line-and-indent', 0)

  if has('nvim-0.6.0') && s:enable_hop
    call SpaceVim#mapping#space#def('nmap', ['j', 'j'], 'HopChar1', 'jump-or-select-to-a-character', 1, 1)
    call SpaceVim#mapping#space#def('nmap', ['j', 'J'], 'HopChar2', 'jump-to-suite-of-two-characters', 1, 1)
    call SpaceVim#mapping#space#def('nmap', ['j', 'l'], 'HopLine', 'jump-or-select-to-a-line', 1, 1)
    call SpaceVim#mapping#space#def('nmap', ['j', 'w'], 'HopWord', 'jump-to-a-word', 1, 1)
  else
    " call SpaceVim#mapping#space#def('nmap', ['j', 'j'], '<Plug>(easymotion-overwin-f)', 'jump to a character', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'j'], '<Plug>(better-easymotion-overwin-f)', 'jump-or-select-to-a-character', 0, 1)
    nnoremap <silent> <Plug>(better-easymotion-overwin-f) :call <SID>better_easymotion_overwin_f(0)<Cr>
    xnoremap <silent> <Plug>(better-easymotion-overwin-f) :<C-U>call <SID>better_easymotion_overwin_f(1)<Cr>
    call SpaceVim#mapping#space#def('nmap', ['j', 'J'], '<Plug>(easymotion-overwin-f2)', 'jump-to-suite-of-two-characters', 0)
    " call SpaceVim#mapping#space#def('nmap', ['j', 'l'], '<Plug>(easymotion-overwin-line)', 'jump to a line', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'l'], '<Plug>(better-easymotion-overwin-line)', 'jump-or-select-to-a-line', 0, 1)
    nnoremap <silent> <Plug>(better-easymotion-overwin-line) :call <SID>better_easymotion_overwin_line(0)<Cr>
    xnoremap <silent> <Plug>(better-easymotion-overwin-line) :<C-U>call <SID>better_easymotion_overwin_line(1)<Cr>
    call SpaceVim#mapping#space#def('nmap', ['j', 'v'], '<Plug>(easymotion-overwin-line)', 'jump-to-a-line', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'w'], '<Plug>(easymotion-overwin-w)', 'jump-to-a-word', 0)
    call SpaceVim#mapping#space#def('nmap', ['j', 'q'], '<Plug>(easymotion-overwin-line)', 'jump-to-a-line', 0)
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'u'], 'call call('
        \ . string(s:_function('s:jump_to_url')) . ', [])',
        \ 'jump-to-url', 1)
endfunction

if has('nvim-0.6.0')
" Hop
lua << EOF
-- Like hop.jump_target.regex_by_line_start_skip_whitespace() except it also
-- marks empty or whitespace only lines
function regexLines()
  return {
    oneshot = true,
    match = function(str)
      return vim.regex("http[s]*://"):match_str(str)
    end
  }
end

-- Like :HopLineStart except it also jumps to empty or whitespace only lines
function hintLines(opts)
  -- Taken from override_opts()
  opts = setmetatable(opts or {}, {__index = require'hop'.opts})

  local gen = require'hop.jump_target'.jump_targets_by_scanning_lines
  require'hop'.hint_with(gen(regexLines()), opts)
end
EOF


  " See `:h forced-motion` for these operator-pending mappings
  function! s:jump_to_url() abort
    lua hintLines()
  endfunction
else
  function! s:jump_to_url() abort
    let g:EasyMotion_re_anywhere = 'http[s]*://'
    call feedkeys("\<Plug>(easymotion-jumptoanywhere)")
  endfunction
endif

function! s:transpose_with_previous(type) abort
  let l:save_register = @"
  if a:type ==# 'line'
    if line('.') > 1
      normal! kddp
    endif
  elseif a:type ==# 'word'
    normal! yiw
    let l:cw = @"
    normal! geyiw
    let l:tw = @"
    if l:cw !=# l:tw
      let @" = l:cw
      normal! viwp
      let @" = l:tw
      normal! eviwp
    endif
  elseif a:type ==# 'character'
    if col('.') > 1
      normal! hxp
    endif
  endif
  let @" = l:save_register
endfunction

function! s:transpose_with_next(type) abort
  let l:save_register = @"
  if a:type ==# 'line'
    if line('.') < line('$')
      normal! ddp
    endif
  elseif a:type ==# 'word'
    normal! yiw
    let l:cw = @"
    normal! wyiw
    let l:nw = @"
    if l:cw !=# l:nw
      let @" = l:cw
      normal! viwp
      let @" = l:nw
      normal! geviwp
    endif
  elseif a:type ==# 'character'
    if col('.') < col('$')-1
      normal! xp
    endif
  endif
  let @" = l:save_register
endfunction

function! s:better_easymotion_overwin_line(is_visual) abort
  let current_line = line('.')
  try
    if a:is_visual
      call EasyMotion#Sol(0, 2)
    else
      call EasyMotion#overwin#line()
    endif
    " clear cmd line
    noautocmd normal! :
    if a:is_visual
      let last_line = line('.')
      exe current_line
      if last_line > current_line
        exe 'normal! V' . (last_line - current_line) . 'j'
      else
        exe 'normal! V' . (current_line - last_line) . 'k'
      endif
    endif
  catch /^Vim\%((\a\+)\)\=:E117/

  endtry
endfunction

function! s:better_easymotion_overwin_f(is_visual) abort
  let [current_line, current_col] = getpos('.')[1:2]
  try
    call EasyMotion#OverwinF(1)
    " clear cmd line
    noautocmd normal! :
    if a:is_visual
      let last_line = line('.')
      let [last_line, last_col] = getpos('.')[1:2]
      call cursor(current_line, current_col)
      if last_line > current_line        
        exe 'normal! v' . (last_line - current_line) . 'j0' . last_col . '|'
      else
        exe 'normal! v' . (current_line - last_line) . 'k0' . last_col . '|' 
      endif
    endif
  catch /^Vim\%((\a\+)\)\=:E117/

  endtry
endfunction

function! s:move_text_down_transient_state() abort   
  if line('.') == line('$')
  else
    let l:save_register = @"
    normal! ddp
    let @" = l:save_register
  endif
  call s:text_transient_state()
endfunction

function! s:move_text_up_transient_state() abort
  if line('.') > 1
    let l:save_register = @"
    normal! ddkP
    let @" = l:save_register
  endif
  call s:text_transient_state()
endfunction

function! s:text_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Move Text Transient State')
  call state.defind_keys(
        \ {
          \ 'layout' : 'vertical split',
          \ 'left' : [
            \ {
              \ 'key' : 'J',
              \ 'desc' : 'move text down',
              \ 'func' : '',
              \ 'cmd' : 'noautocmd silent! m .+1',
              \ 'exit' : 0,
              \ },
              \ ],
              \ 'right' : [
                \ {
                  \ 'key' : 'K',
                  \ 'func' : '',
                  \ 'desc' : 'move text up',
                  \ 'cmd' : 'noautocmd silent! m .-2',
                  \ 'exit' : 0,
                  \ },
                  \ ],
                  \ }
                  \ )
  call state.open()
endfunction

function! s:lowerCamelCase() abort
  " fooFzz
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~# '\s'
    return
  endif
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let rst = [cword[0]]
    if len(cword) > 1
      let rst += map(cword[1:], "substitute(v:val, '^.', '\\u&', 'g')")
    endif
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:UpperCamelCase() abort
  " FooFzz
  if strcharpart(getline('.')[col('.') - 1:], 0, 1) =~# '\s'
    return
  endif
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let rst = map(cword, "substitute(v:val, '^.', '\\u&', 'g')")
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:kebab_case() abort
  " foo-fzz
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~# '\s'
    return
  endif
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '-')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:under_score() abort
  " foo_fzz
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:up_case() abort
  " FOO_FZZ
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~# '\s'
    return
  endif
  let cword =map(s:parse_symbol(expand('<cword>')), 'toupper(v:val)')
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

let s:STRING = SpaceVim#api#import('data#string')
function! s:parse_symbol(symbol) abort
  if a:symbol =~# '^[a-z]\+\(-[a-zA-Z]\+\)*$'
    return split(a:symbol, '-')
  elseif a:symbol =~# '^[a-z]\+\(_[a-zA-Z]\+\)*$'
    return split(a:symbol, '_')
  elseif a:symbol =~# '^[a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = s:STRING.string2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        call add(rst, tolower(word))
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  elseif a:symbol =~# '^[A-Z][a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = s:STRING.string2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        if !empty(word)
          call add(rst, tolower(word))
        endif
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  else
    return [a:symbol]
  endif
endfunction

function! s:count_selection_region() abort
  call feedkeys("gvg\<c-g>\<Esc>", 'ti')
endfunction


function! s:delete_extra_space() abort
  if !empty(getline('.'))
    if getline('.')[col('.')-1] ==# ' '
      execute "normal! \"_ciw\<Space>\<Esc>"
    endif
  endif
endfunction

function! s:set_justification_to(align) abort
  let l:startlinenr = line("'{")
  let l:endlinenr = line("'}")
  if getline(l:startlinenr) ==# ''
    let l:startlinenr += 1
  endif
  if getline(l:endlinenr) ==# ''
    let l:endlinenr -= 1
  endif
  let l:lineList = map(getline(l:startlinenr, l:endlinenr), 'trim(v:val)')
  let l:maxlength = 0
  for l:line in l:lineList
    let l:length = strdisplaywidth(l:line)
    if l:length > l:maxlength
      let l:maxlength = l:length
    endif
  endfor

  if a:align ==# 'left'
    execute l:startlinenr . ',' . l:endlinenr . ":left\<cr>"
  elseif a:align ==# 'center'
    execute l:startlinenr . ',' . l:endlinenr . ':center ' . l:maxlength . "\<cr>"
  elseif a:align ==# 'right'
    execute l:startlinenr . ',' . l:endlinenr . ':right  ' . l:maxlength . "\<cr>"
  endif

  unlet l:startlinenr
  unlet l:endlinenr
  unlet l:lineList
  unlet l:maxlength
endfunction

let s:local_lorem_ipsum = [
      \ 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
      \ 'Donec hendrerit tempor tellus.',
      \ 'Donec pretium posuere tellus.',
      \ 'Proin quam nisl, tincidunt et, mattis eget, convallis nec, purus.',
      \ 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
      \ 'Nulla posuere.',
      \ 'Donec vitae dolor.',
      \ 'Nullam tristique diam non turpis.',
      \ 'Cras placerat accumsan nulla.',
      \ 'Nullam rutrum.',
      \ 'Nam vestibulum accumsan nisl.',
      \ 'Pellentesque dapibus suscipit ligula.',
      \ 'Donec posuere augue in quam.',
      \ 'Etiam vel tortor sodales tellus ultricies commodo.',
      \ 'Suspendisse potenti.',
      \ 'Aenean in sem ac leo mollis blandit.',
      \ 'Donec neque quam, dignissim in, mollis nec, sagittis eu, wisi.',
      \ 'Phasellus lacus.',
      \ 'Etiam laoreet quam sed arcu.',
      \ 'Phasellus at dui in ligula mollis ultricies.',
      \ 'Integer placerat tristique nisl.',
      \ 'Praesent augue.',
      \ 'Fusce commodo.',
      \ 'Vestibulum convallis, lorem a tempus semper, dui dui euismod elit, vitae placerat urna tortor vitae lacus.',
      \ 'Nullam libero mauris, consequat quis, varius et, dictum id, arcu.',
      \ 'Mauris mollis tincidunt felis.',
      \ 'Aliquam feugiat tellus ut neque.',
      \ 'Nulla facilisis, risus a rhoncus fermentum, tellus tellus lacinia purus, et dictum nunc justo sit amet elit.',
      \ 'Aliquam erat volutpat.',
      \ 'Nunc eleifend leo vitae magna.',
      \ 'In id erat non orci commodo lobortis.',
      \ 'Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.',
      \ 'Sed diam.',
      \ 'Praesent fermentum tempor tellus.',
      \ 'Nullam tempus.',
      \ 'Mauris ac felis vel velit tristique imperdiet.',
      \ 'Donec at pede.',
      \ 'Etiam vel neque nec dui dignissim bibendum.',
      \ 'Vivamus id enim.',
      \ 'Phasellus neque orci, porta a, aliquet quis, semper a, massa.',
      \ 'Phasellus purus.',
      \ 'Pellentesque tristique imperdiet tortor.',
      \ 'Nam euismod tellus id erat.',
      \ 'Nullam eu ante vel est convallis dignissim.',
      \ 'Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio.',
      \ 'Nunc porta vulputate tellus.',
      \ 'Nunc rutrum turpis sed pede.',
      \ 'Sed bibendum.',
      \ 'Aliquam posuere.',
      \ 'Nunc aliquet, augue nec adipiscing interdum, lacus tellus malesuada massa, quis varius mi purus non odio.',
      \ 'Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.',
      \ 'Curabitur vulputate vestibulum lorem.',
      \ 'Fusce sagittis, libero non molestie mollis, magna orci ultrices dolor, at vulputate neque nulla lacinia eros.',
      \ 'Sed id ligula quis est convallis tempor.',
      \ 'Curabitur lacinia pulvinar nibh.',
      \ 'Nam a sapien.',
      \ ]

let s:lorem_ipsum_paragraph_separator = "\n\n"
let s:lorem_ipsum_sentence_separator = '  '
let s:lorem_ipsum_list_beginning = ''
let s:lorem_ipsum_list_bullet = '* '
let s:lorem_ipsum_list_item_end = "\n"
let s:lorem_ipsum_list_end = ''

function! s:insert_lorem_ipsum_list() abort
  let save_register = @k
  let @k =  '* ' . s:local_lorem_ipsum[s:NUMBER.random(0, len(s:local_lorem_ipsum))] . "\n"
  normal! "kgP
  let @k = save_register
endfunction

function! s:insert_lorem_ipsum_paragraph() abort
  let save_register = @k
  let pids = len(s:local_lorem_ipsum) / 11
  let pid = s:NUMBER.random(0, pids) * 11
  let @k = join(s:LIST.listpart(s:local_lorem_ipsum, pid, 11), s:lorem_ipsum_sentence_separator) . s:lorem_ipsum_paragraph_separator
  normal! "kgP
  let @k = save_register
endfunction

function! s:insert_lorem_ipsum_sentence() abort
  let save_register = @k
  let @k =  s:local_lorem_ipsum[s:NUMBER.random(0, len(s:local_lorem_ipsum))] . s:lorem_ipsum_sentence_separator
  normal! "kgP
  let @k = save_register
endfunction

function! s:insert_simple_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_simple(v:count ? v:count : 8)
  normal! "kPl
  let @k = save_register
endfunction

function! s:duplicate_lines(visual) abort
  if a:visual
    call setline('.', getline("'<"))
  elseif line('.') > 1
    call setline('.', getline(line('.') - 1))
  endif
endfunction

command! -nargs=0 -range=% ReverseLines :<line1>,<line2>call <sid>reverse_lines()
function! s:reverse_lines() range
  let rst = getline(a:firstline, a:lastline)
  call reverse(rst)
  call s:BUFFER.buf_set_lines(bufnr('.'), a:firstline-1 , a:lastline, 0, rst)
endfunction

function! s:uniquify_lines(visual, ignorecase) abort
  if a:visual
    let start_line = line("'<")
    let end_line = line("'>")
    let rst = []
    for l in range(start_line, end_line)
      if index(rst, getline(l), 0, a:ignorecase) ==# -1
        call add(rst, getline(l))
      endif
    endfor
    call s:BUFFER.buf_set_lines(bufnr('.'), start_line-1 , end_line, 0, rst)
  else
    if line('.') > 1
      if a:ignorecase
        if getline('.') ==? getline(line('.') - 1)
          normal! dd
        endif
      else
        if getline('.') ==# getline(line('.') - 1)
          normal! dd
        endif
      endif
    endif
  endif
endfunction

function! s:toggle_case(visual, uppercase) abort
  if a:visual
    if a:uppercase == 1
      normal! gvgU
    elseif a:uppercase == -1
      normal! gvgu
    elseif a:uppercase == 0
      normal! gv~
    endif
  else
    if a:uppercase == 1
      normal! gUl
    elseif a:uppercase == -1
      normal! gul
    elseif a:uppercase == 0
      normal! ~
    endif
  endif
endfunction

function! s:insert_stronger_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_strong(v:count ? v:count : 12)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_paranoid_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_paranoid(v:count ? v:count : 20)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_numerical_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_numeric(v:count ? v:count : 4)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_phonetically_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_phonetic(v:count ? v:count : 8)
  normal! "kPl
  let @k = save_register
endfunction

function! s:uuidgen_U() abort
  let uuid = system('uuidgen')
  let save_register = @k
  let @k = uuid
  normal! "kPl
  let @k = save_register
endfunction

function! s:align_at_regular_expression() abort
  let re = input(':Tabularize /')
  if !empty(re)
    exe 'Tabularize /' . re
  else
    normal! :
    echo 'empty input, canceled!'
  endif
endfunction


function! s:join_string_with() abort
  if s:HI.is_string(line('.'), col('.'))
    let c = col('.')
    let a = 0
    let b = 0
    let _c = c
    while c > 0
      if s:HI.is_string(line('.'), c)
        let c -= 1
      else
        let a = c
        break
      endif
    endwhile
    let c = _c
    while c > 0
      if s:HI.is_string(line('.'), c)
        let c += 1
      else
        let b = c
        break
      endif
    endwhile
    let l:save_register_m = @m
    let line = getline('.')[:a] . join(split(getline('.')[a+1 : b]), '-') .  getline('.')[b :]
    call setline('.', line)
    let @m = l:save_register_m
  endif
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

augroup spacevim_layer_edit
  au!
  autocmd FileType * call <SID>add_buffer_head()
augroup END
let s:ft_head_tp = {}
function! s:add_buffer_head() abort
  if has_key(s:ft_head_tp, &ft) && getline(1) ==# '' && line('$')  == 1
    let head = s:ft_head_tp[&ft]
    call setline(1, map(head, 's:parse(v:val)'))
    call cursor(len(head), 0)
  endif
endfunction

function! s:parse(line) abort
  return s:VIM.parse_string(a:line)
endfunction

function! SpaceVim#layers#edit#add_ft_head_tamplate(ft, tamp) abort
  call extend(s:ft_head_tp, {a:ft : a:tamp})
endfunction
