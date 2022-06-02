"=============================================================================
" telescope.vim --- telescope support for spacevim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:file')
  finish
endif

""
" @section telescope, layers-telescope
" @parentsection layers
" This layer provides fuzzy finder feature which is based on |telescope|, and this
" This layer is not loaded by default. To use this layer:
" >
"   [[layers]]
"     name = 'telescope'
" <
" @subsection Key bindings
"
" The following key bindings will be enabled when this layer is loaded:
" >
"   Key bindings      Description
"   SPC p f / Ctrl-p  search files in current directory
"   <Leader> f SPC    Fuzzy find menu:CustomKeyMaps
"   <Leader> f e      Fuzzy find register
"   <Leader> f h      Fuzzy find history/yank
"   <Leader> f j      Fuzzy find jump, change
"   <Leader> f l      Fuzzy find location list
"   <Leader> f m      Fuzzy find output messages
"   <Leader> f o      Fuzzy find functions
"   <Leader> f t      Fuzzy find tags
"   <Leader> f q      Fuzzy find quick fix
"   <Leader> f r      Resumes Unite window
" <

function! SpaceVim#layers#telescope#loadable() abort

  return has('nvim-0.7.0')

endfunction

function! SpaceVim#layers#telescope#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/telescope.nvim', {'merged' : 0, 'loadconf' : 1}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/plenary.nvim', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/telescope-menu', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/telescope-ctags-outline.nvim', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/neoyank.vim',        { 'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/telescope-fzf-native.nvim',        { 'merged' : 0}])
  return plugins
endfunction

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#telescope#config() abort

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['?'], 'Telescope menu menu=CustomKeyMaps default_text=[SPC]',
        \ ['show-mappings',
        \ [
          \ 'SPC ? is to show mappings',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['h', '[SPC]'], 'call call('
        \ . string(s:_function('s:get_help')) . ', ["SpaceVim"])',
        \ ['find-SpaceVim-help',
        \ [
          \ 'SPC h SPC is to find SpaceVim help',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)
  " @fixme SPC h SPC make vim flick
  exe printf('nmap %sh%s [SPC]h[SPC]', g:spacevim_default_custom_leader, g:spacevim_default_custom_leader)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'Telescope buffers',
        \ ['list-buffer',
        \ [
          \ 'SPC b b is to open buffer list',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'r'], 'Telescope oldfiles',
        \ ['open-recent-file',
        \ [
          \ 'SPC f r is to open recent file list',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Telescope ctags_outline outline',
        \ ['jump-to-definition-in-buffer',
        \ [
          \ 'SPC j i is to jump to a definition in buffer',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'Telescope colorscheme',
        \ ['fuzzy-find-colorschemes',
        \ [
          \ 'SPC T s is to fuzzy find colorschemes',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'],
        \ "exe 'Telescope find_files cwd=' . fnamemodify(bufname('%'), ':p:h')",
        \ ['find-files-in-buffer-directory',
        \ [
          \ '[SPC f f] is to find files in the directory of the current buffer',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ]
          \ , 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'],
        \ 'Telescope find_files',
        \ ['find-files-in-project',
        \ [
          \ '[SPC p f] is to find files in the root of the current project',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ]
          \ , 1)

  nnoremap <silent> <C-p> :<C-u>Telescope find_files<cr>

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'i'], 'call call('
        \ . string(s:_function('s:get_help_with_cursor_symbol')) . ', [])',
        \ ['get-help-for-cursor-symbol',
        \ [
          \ '[SPC h i] is to get help with the symbol at point',
          \ '',
          \ 'Definition: ' . s:filename . ':' . lnum,
          \ ]
          \ ],
          \ 1)

  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()

  augroup spacevim_telescope_layer
    autocmd!
    " https://github.com/nvim-telescope/telescope.nvim/issues/161
    autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)
  augroup END
endfunction

function! s:get_help_with_cursor_symbol() abort
  call v:lua.require('telescope.builtin').help_tags({ 'default_text' : expand('<cword>')}) 
endfunction

function! s:get_help(word) abort
  call v:lua.require('telescope.builtin').help_tags({ 'default_text' : a:word}) 
endfunction

function! s:get_menu(menu, input) abort
  let save_ctrlp_default_input = get(g:, 'ctrlp_default_input', '')
  let g:ctrlp_default_input = a:input
  exe 'CtrlPMenu ' . a:menu
  let g:ctrlp_default_input = save_ctrlp_default_input
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort

  nnoremap <silent> <Leader>fe
        \ :<C-u>Telescope registers<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.e = ['Telescope registers',
        \ 'fuzzy find registers',
        \ [
          \ '[Leader f e ] is to fuzzy find registers',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  nnoremap <silent> <Leader>fr
        \ :<C-u>Telescope resume<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['Telescope resume',
        \ 'resume telescope window',
        \ [
          \ '[Leader f r ] is to resume telescope window',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  nnoremap <silent> <Leader>fh
        \ :<C-u>Telescope neoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['Telescope neoyank',
        \ 'fuzzy find yank history',
        \ [
          \ '[Leader f h] is to fuzzy find history and yank content',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>Telescope jumplist<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['Telescope jumplist',
        \ 'fuzzy find jump list',
        \ [
          \ '[Leader f j] is to fuzzy find jump list',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  nnoremap <silent> <Leader>fl
        \ :<C-u>Telescope loclist<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.l = ['Telescope loclist',
        \ 'fuzzy find local list',
        \ [
          \ '[Leader f q] is to fuzzy find local list',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  nnoremap <silent> <Leader>fm
        \ :<C-u>Telescope messages<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['Telescope messages',
        \ 'fuzzy find and yank message history',
        \ [
          \ '[Leader f m] is to fuzzy find and yank message history',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  nnoremap <silent> <Leader>fq
        \ :<C-u>Telescope quickfix<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.q = ['Telescope quickfix',
        \ 'fuzzy find quickfix list',
        \ [
          \ '[Leader f q] is to fuzzy find quickfix list',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  nnoremap <silent> <Leader>fo  :<C-u>Telescope ctags_outline outline<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['Telescope ctags_outline outline',
        \ 'fuzzy find outline',
        \ [
          \ '[Leader f o] is to fuzzy find outline',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  nnoremap <silent> <Leader>f<Space> :Telescope menu menu=CustomKeyMaps<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f['[SPC]'] = ['Telescope menu menu=CustomKeyMaps',
        \ 'fuzzy find custom key bindings',
        \ [
          \ '[Leader f SPC] is to fuzzy find custom key bindings',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  nnoremap <silent> <Leader>fp  :<C-u>Telescope menu menu=AddedPlugins<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.p = ['Telescope menu menu=AddedPlugins',
        \ 'fuzzy find vim packages',
        \ [
          \ '[Leader f p] is to fuzzy find vim packages installed in SpaceVim',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

  let lnum = expand('<slnum>') + s:unite_lnum - 4
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'v', 's'], 'Telescope scriptnames',
        \ ['open-custom-configuration',
        \ [
          \ '[SPC f v d] is to open the custom configuration file for SpaceVim',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
          \ , 1)

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


function! SpaceVim#layers#telescope#health() abort

  return 1

endfunction
