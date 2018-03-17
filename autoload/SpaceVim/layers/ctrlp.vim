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
                \ ['mattn/ctrlp-register'],
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
  nnoremap <silent> <C-p> :Denite file_rec<cr>
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'Denite colorscheme', 'fuzzy find colorschemes', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
endfunction
