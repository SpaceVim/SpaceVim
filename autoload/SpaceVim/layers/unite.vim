"=============================================================================
" unite.vim --- SpaceVim unite layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#unite#plugins() abort
  let plugins = [
        \ ['Shougo/unite.vim',{ 'merged' : 0 , 'loadconf' : 1}],
        \ ['Shougo/neoyank.vim'],
        \ ['soh335/unite-qflist'],
        \ ['SpaceVim/unite-unicode'],
        \ ['ujihisa/unite-equery'],
        \ ['m2mdas/unite-file-vcs'],
        \ ['Shougo/neomru.vim'],
        \ ['andreicristianpetcu/vim-van'],
        \ ['kmnk/vim-unite-svn'],
        \ ['basyura/unite-rails'],
        \ ['nobeans/unite-grails'],
        \ ['choplin/unite-vim_hacks'],
        \ ['mattn/webapi-vim'],
        \ ['mattn/gist-vim', {'loadconf' : 1}],
        \ ['henices/unite-stock'],
        \ ['mattn/wwwrenderer-vim'],
        \ ['thinca/vim-openbuf'],
        \ ['ujihisa/unite-haskellimport'],
        \ ['oppara/vim-unite-cake'],
        \ ['thinca/vim-ref', {'loadconf' : 1}],
        \ ['heavenshell/unite-zf'],
        \ ['heavenshell/unite-sf2'],
        \ ['osyo-manga/unite-vimpatches'],
        \ ['rhysd/unite-emoji.vim'],
        \ ['Shougo/unite-outline'],
        \ ['hewes/unite-gtags' ,{'loadconf' : 1}],
        \ ['rafi/vim-unite-issue'],
        \ ['joker1007/unite-pull-request'],
        \ ['tsukkee/unite-tag'],
        \ ['ujihisa/unite-launch'],
        \ ['ujihisa/unite-gem'],
        \ ['osyo-manga/unite-filetype'],
        \ ['thinca/vim-unite-history'],
        \ ['Shougo/neobundle-vim-recipes'],
        \ ['Shougo/unite-help'],
        \ ['ujihisa/unite-locate'],
        \ ['kmnk/vim-unite-giti'],
        \ ['ujihisa/unite-font'],
        \ ['t9md/vim-unite-ack'],
        \ ['mileszs/ack.vim',{'on_cmd' : 'Ack'}],
        \ ['albfan/ag.vim',{'on_cmd' : 'Ag' , 'loadconf' : 1}],
        \ ['dyng/ctrlsf.vim',{'on_cmd' : 'CtrlSF', 'on_map' : '<Plug>CtrlSF', 'loadconf' : 1 , 'loadconf_before' : 1}],
        \ ['daisuzu/unite-adb'],
        \ ['osyo-manga/unite-airline_themes'],
        \ ['mattn/unite-vim_advent-calendar'],
        \ ['mattn/unite-remotefile'],
        \ ['sgur/unite-everything'],
        \ ['wsdjeg/unite-dwm'],
        \ ['raw1z/unite-projects'],
        \ ['SpaceVim/unite-ctags'],
        \ ['Shougo/unite-session'],
        \ ['osyo-manga/unite-quickfix'],
        \ ['ujihisa/unite-colorscheme'],
        \ ['mattn/unite-gist'],
        \ ['tacroe/unite-mark'],
        \ ['tacroe/unite-alias'],
        \ ['tex/vim-unite-id'],
        \ ['sgur/unite-qf'],
        \ ['lambdalisue/vim-gista-unite'],
        \ ['wsdjeg/unite-radio.vim', {'loadconf' : 1}],
        \ ['lambdalisue/unite-grep-vcs', {
        \ 'autoload': {
        \    'unite_sources': ['grep/git', 'grep/hg'],
        \ }}],
        \ ['lambdalisue/vim-gista', {
        \ 'on_cmd': 'Gista'
        \ }],
        \ ]
  if g:spacevim_enable_googlesuggest
    call add(plugins, ['mopp/googlesuggest-source.vim'])
    call add(plugins, ['mattn/googlesuggest-complete-vim'])
  endif

  return plugins
endfunction

function! SpaceVim#layers#unite#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['!'], 'call call('
        \ . string(s:_function('s:run_shell_cmd')) . ', [])',
        \ 'shell cmd(current dir)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', '!'], 'call call('
        \ . string(s:_function('s:run_shell_cmd_project')) . ', [])',
        \ 'shell cmd(project root)', 1)
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fr
        \ :<C-u>Unite -buffer-name=resume resume<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['Unite -buffer-name=resume resume',
        \ 'resume unite window',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  if has('nvim')
    nnoremap <silent> <Leader>ff
          \ :<C-u>Unite file_rec/neovim<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings.f.f = ['Unite file_rec/neovim',
          \ 'fuzzy find file',
          \ [
          \ '[Leader f f ] is to fuzzy find file',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  else
    nnoremap <silent> <Leader>ff
          \ :<C-u>Unite file_rec/async<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings.f.f = ['Unite file_rec/async',
          \ 'fuzzy find file',
          \ [
          \ '[Leader f f ] is to fuzzy find file',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
  endif
  nnoremap <silent> <Leader>fe  :<C-u>Unite
        \ -buffer-name=register register<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.e = ['Unite register',
        \ 'fuzzy find register',
        \ [
        \ '[Leader f e] is to fuzzy find content in register',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fh
        \ :<C-u>Unite history/yank<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.h = ['Unite history/yank',
        \ 'fuzzy find history/yank',
        \ [
        \ '[Leader f h] is to fuzzy find history and yank content',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fj
        \ :<C-u>Unite jump<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.j = ['Unite jump',
        \ 'fuzzy find jump list',
        \ [
        \ '[Leader f j] is to fuzzy find jump list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fl
        \ :<C-u>Unite locationlist<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.l = ['Unite locationlist',
        \ 'fuzzy find location list',
        \ [
        \ '[Leader f l] is to fuzzy find location list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fm
        \ :<C-u>Unite output:message<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.m = ['Unite output:message',
        \ 'fuzzy find message',
        \ [
        \ '[Leader f m] is to fuzzy find message',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fq
        \ :<C-u>Unite quickfix<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.q = ['Unite quickfix',
        \ 'fuzzy find quickfix list',
        \ [
        \ '[Leader f q] is to fuzzy find quickfix list',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fo  :<C-u>Unite -buffer-name=outline
        \ -start-insert -auto-preview -split outline<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['Unite outline',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction

function! s:run_shell_cmd() abort
  let cmd = input('Please input shell command:', '', 'customlist,SpaceVim#plugins#bashcomplete#complete')
  if !empty(cmd)
    call unite#start([['output/shellcmd', cmd]], {'log': 1, 'wrap': 1,'start_insert':0})
  endif
endfunction

function! s:run_shell_cmd_project() abort
  let cmd = input('Please input shell command:', '', 'customlist,SpaceVim#plugins#bashcomplete#complete')
  if !empty(cmd)
    call unite#start([['output/shellcmd', cmd]], {
          \ 'log': 1,
          \ 'wrap': 1,
          \ 'start_insert':0,
          \ 'path' : SpaceVim#plugins#projectmanager#current_root(),
          \ })
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
