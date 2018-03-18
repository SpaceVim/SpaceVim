"=============================================================================
" ctrlp.vim --- SpaceVim ctrlp layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#ctrlp#plugins() abort
    let plugins = [
                \ ['ctrlpvim/ctrlp.vim', {'loadconf' : 1}],
                \ ['mattn/ctrlp-register', {'on_cmd' : 'CtrlPRegister'}],
                \ ['DeaR/ctrlp-jumps', {'on_cmd' : 'CtrlPJump'}],
                \ ['voronkovich/ctrlp-nerdtree.vim', { 'on_cmd' : 'CtrlPNerdTree'}],
                \ ['h14i/vim-ctrlp-buftab',          { 'on_cmd' : 'CtrlPBufTab'}],
                \ ['vim-scripts/ctrlp-cmdpalette',   { 'on_cmd' : 'CtrlPCmdPalette'}],
                \ ['mattn/ctrlp-windowselector',     { 'on_cmd' : 'CtrlPWindowSelector'}],
                \ ['the9ball/ctrlp-gtags',           { 'on_cmd' : ['CtrlPGtagsX','CtrlPGtagsF','CtrlPGtagsR']}],
                \ ['thiderman/ctrlp-project',        { 'on_cmd' : 'CtrlPProject'}],
                \ ['mattn/ctrlp-google',             { 'on_cmd' : 'CtrlPGoogle'}],
                \ ['ompugao/ctrlp-history',          { 'on_cmd' : ['CtrlPCmdHistory','CtrlPSearchHistory']}],
                \ ['pielgrzym/ctrlp-sessions',       { 'on_cmd' : ['CtrlPSessions','MkS']}],
                \ ['tacahiroy/ctrlp-funky',          { 'on_cmd' : 'CtrlPFunky'}],
                \ ['mattn/ctrlp-launcher',           { 'on_cmd' : 'CtrlPLauncher'}],
                \ ['sgur/ctrlp-extensions.vim',      { 'on_cmd' : ['CtrlPCmdline','CtrlPMenu','CtrlPYankring']}],
                \ ['FelikZ/ctrlp-py-matcher'],
                \ ['lambdalisue/vim-gista-ctrlp',    { 'on_cmd' : 'CtrlPGista'}],
                \ ['elentok/ctrlp-objects.vim',      { 'on_cmd' : [
                \'CtrlPModels',
                \'CtrlPViews',
                \'CtrlPControllers',
                \'CtrlPTemplates',
                \'CtrlPPresenters']}],
                \ ]
    if !has('nvim')
        call add(plugins, ['wsdjeg/ctrlp-unity3d-docs',  { 'on_cmd' : 'CtrlPUnity3DDocs'}])
    endif
    return plugins
endfunction

function! SpaceVim#layers#ctrlp#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Denite outline', 'jump to a definition in buffer', 1)
  " This is definded in plugin config
  " nnoremap <silent> <C-p> :Ctrlp<cr>
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'Denite colorscheme', 'fuzzy find colorschemes', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
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
  nnoremap <silent> <Leader>fh
        \ :<C-u>FZFNeoyank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['FZFNeoyank',
        \ 'fuzzy find yank history',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fm
        \ :<C-u>FzfMessages<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['FzfMessages',
        \ 'fuzzy find message',
        \ [
        \ '[Leader f m] is to fuzzy find message',
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
  nnoremap <silent> <Leader>fl
        \ :<C-u>FzfLocationList<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.l = ['FzfLocationList',
        \ 'fuzzy find location list',
        \ [
        \ '[Leader f l] is to fuzzy find location list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fo  :<C-u>FzfOutline<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['FzfOutline',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction
