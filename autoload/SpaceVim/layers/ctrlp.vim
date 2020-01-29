"=============================================================================
" ctrlp.vim --- SpaceVim ctrlp layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#ctrlp#plugins() abort
  let plugins = [
        \ ['ctrlpvim/ctrlp.vim', {'loadconf' : 1, 'merged' : 0}],
        \ ['FelikZ/ctrlp-py-matcher', {'merged' : 0}],
        \ ['mattn/ctrlp-register', {'on_cmd' : 'CtrlPRegister'}],
        \ ['DeaR/ctrlp-jumps', {'on_cmd' : 'CtrlPJump'}],
        \ ['SpaceVim/vim-ctrlp-help', {'on_cmd' : 'CtrlPHelp'}],
        \ ['hara/ctrlp-colorscheme', {'on_cmd' : 'CtrlPColorscheme'}],
        \ ]
  call add(plugins, ['wsdjeg/ctrlp-menu', {'merged' : 0}])
  call add(plugins, ['Shougo/neoyank.vim', {'merged' : 0}])
  call add(plugins, ['wsdjeg/ctrlp-yank', {'merged' : 0}])
  call add(plugins, ['wsdjeg/vim-ctrlp-message', {'merged' : 0}])
  return plugins
endfunction

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#ctrlp#config() abort

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['?'], 'call call('
        \ . string(s:_function('s:get_menu')) . ', ["CustomKeyMaps", "[SPC]"])',
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
  nmap <Space>h<Space> [SPC]h[SPC]

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'CtrlPBuffer',
        \ ['list-buffer',
        \ [
        \ 'SPC b b is to open buffer list',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'r'], 'CtrlPMRU',
        \ ['open-recent-file',
        \ [
        \ 'SPC f r is to open recent file list',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'CtrlPBufTag',
        \ ['jump-to-definition-in-buffer',
        \ [
        \ 'SPC j i is to jump to a definition in buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)

  "@todo add resume support for ctrlp: SPC r l


  "@fixme ctrlp colorschemes support
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'CtrlPColorscheme',
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
        \ "exe 'CtrlP ' . fnamemodify(bufname('%'), ':h')",
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
        \ 'CtrlP',
        \ ['find-files-in-project',
        \ [
        \ '[SPC p f] is to find files in the root of the current project',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)

  " This is definded in plugin config
  " nnoremap <silent> <C-p> :Ctrlp<cr>

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
endfunction

function! s:get_help_with_cursor_symbol() abort
  let save_ctrlp_default_input = get(g:, 'ctrlp_default_input', '')
  let g:ctrlp_default_input = expand('<cword>')
  CtrlPHelp
  let g:ctrlp_default_input = save_ctrlp_default_input
endfunction

function! s:get_help(word) abort
  let save_ctrlp_default_input = get(g:, 'ctrlp_default_input', '')
  let g:ctrlp_default_input = a:word
  CtrlPHelp
  let g:ctrlp_default_input = save_ctrlp_default_input
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


  "@todo add Leader f r for resume ctrlp


  nnoremap <silent> <Leader>fe
        \ :<C-u>CtrlPRegister<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.e = ['CtrlPRegister',
        \ 'fuzzy find registers',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fh
        \ :<C-u>CtrlPNeoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['CtrlPNeoyank',
        \ 'fuzzy find yank history',
        \ [
        \ '[Leader f h] is to fuzzy find history and yank content',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>CtrlPJump<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['CtrlPJump',
        \ 'fuzzy find jump list',
        \ [
        \ '[Leader f j] is to fuzzy find jump list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]

 "@todo add Leader f l for ctrlp location list

  nnoremap <silent> <Leader>fm
        \ :<C-u>CtrlPMessage<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['CtrlPMessage',
        \ 'fuzzy find and yank message history',
        \ [
        \ '[Leader f m] is to fuzzy find and yank message history',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]

  nnoremap <silent> <Leader>fq
        \ :<C-u>CtrlPQuickfix<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.q = ['CtrlPQuickfix',
        \ 'fuzzy find quickfix list',
        \ [
        \ '[Leader f q] is to fuzzy find quickfix list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]

  nnoremap <silent> <Leader>fo  :<C-u>CtrlPBufTag<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['CtrlPBufTag',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]

  nnoremap <silent> <Leader>f<Space> :CtrlPMenu CustomKeyMaps<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f['[SPC]'] = ['CtrlPMenu CustomKeyMaps',
        \ 'fuzzy find custom key bindings',
        \ [
        \ '[Leader f SPC] is to fuzzy find custom key bindings',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]

  nnoremap <silent> <Leader>fp  :<C-u>CtrlPMenu AddedPlugins<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.p = ['CtrlPMenu AddedPlugins',
        \ 'fuzzy find vim packages',
        \ [
        \ '[Leader f p] is to fuzzy find vim packages installed in SpaceVim',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]

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
