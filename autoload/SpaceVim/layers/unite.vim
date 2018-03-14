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
    return
    if has('nvim')
      nnoremap <silent> [unite]f
            \ :<C-u>Unite file_rec/neovim<cr>
      let lnum = expand('<slnum>') + s:unite_lnum - 4
      let g:_spacevim_mappings_unite.f = ['Unite file_rec/neovim',
            \ 'file_rec',
            \ [
            \ '[UNITE f ] is to open unite file_rec source',
            \ '',
            \ 'Definition: ' . s:file . ':' . lnum,
            \ ]
            \ ]
    else
      nnoremap <silent> [unite]f
            \ :<C-u>Unite file_rec/async<cr>
      let lnum = expand('<slnum>') + s:unite_lnum - 4
      let g:_spacevim_mappings_unite.f = ['Unite file_rec/async',
            \ 'file_rec',
            \ [
            \ '[UNITE f ] is to open unite file_rec source',
            \ '',
            \ 'Definition: ' . s:file . ':' . lnum,
            \ ]
            \ ]
    endif
    nnoremap <silent> [unite]i
          \ :<C-u>Unite file_rec/git<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.i = ['Unite file_rec/git',
          \ 'git files',
          \ [
          \ '[UNITE f ] is to open unite file_rec source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]g
          \ :<C-u>Unite grep<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.g = ['Unite grep',
          \ 'unite grep',
          \ [
          \ '[UNITE g ] is to open unite grep source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]u
          \ :<C-u>Unite source<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.u = ['Unite source',
          \ 'unite source',
          \ [
          \ '[UNITE u ] is to open unite source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]t
          \ :<C-u>Unite tag<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.t = ['Unite tag',
          \ 'unite tag',
          \ [
          \ '[UNITE t ] is to open unite tag source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]T
          \ :<C-u>Unite tag/include<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.T = ['Unite tag/include',
          \ 'unite tag/include',
          \ [
          \ '[UNITE T ] is to open unite tag/include source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]l
          \ :<C-u>Unite locationlist<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.l = ['Unite locationlist',
          \ 'unite locationlist',
          \ [
          \ '[UNITE l ] is to open unite locationlist source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]q
          \ :<C-u>Unite quickfix<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.q = ['Unite quickfix',
          \ 'unite quickfix',
          \ [
          \ '[UNITE q ] is to open unite quickfix source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]e  :<C-u>Unite
          \ -buffer-name=register register<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.e = ['Unite register',
          \ 'unite register',
          \ [
          \ '[UNITE l ] is to open unite locationlist source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]j
          \ :<C-u>Unite jump<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.j = ['Unite jump',
          \ 'unite jump',
          \ [
          \ '[UNITE j ] is to open unite jump source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]h
          \ :<C-u>Unite history/yank<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.h = ['Unite history/yank',
          \ 'unite history/yank',
          \ [
          \ '[UNITE h ] is to open unite history/yank source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]<C-h>
          \ :<C-u>UniteWithCursorWord help<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite['<C-h>'] = ['UniteWithCursorWord help',
          \ 'unite with cursor word help',
          \ [
          \ '[UNITE <c-h> ] is to open unite help source for cursor word',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]s
          \ :<C-u>Unite session<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.s = ['Unite session',
          \ 'unite session',
          \ [
          \ '[UNITE s ] is to open unite session source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]o  :<C-u>Unite -buffer-name=outline
          \ -start-insert -auto-preview -split outline<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.o = ['Unite outline',
          \ 'unite outline',
          \ [
          \ '[UNITE o ] is to open unite outline source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]

    " menu
    nnoremap <silent> [unite]ma
          \ :<C-u>Unite mapping<CR>
    nnoremap <silent> [unite]me
          \ :<C-u>Unite output:message<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 6
    let g:_spacevim_mappings_unite.m = {'name' : '+Menus',
          \ 'a' : ['Unite mapping', 'unite mappings',
          \ [
          \ '[UNITE m a ] is to open unite mapping menu',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ],
          \ 'e' : ['Unite output:message', 'unite messages',
          \ [
          \ '[UNITE o ] is to open unite message menu',
          \ '',
          \ 'Definition: ' . s:file . ':' . (lnum + 2),
          \ ]
          \ ]
          \ }

    nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir
          \ -buffer-name=files buffer bookmark file<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.c =
          \ ['UniteWithCurrentDir -buffer-name=files buffer bookmark file',
          \ 'unite files in current dir',
          \ [
          \ '[UNITE c ] is to open unite outline source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir
          \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.b =
          \ ['UniteWithBufferDir -buffer-name=files' .
          \ ' buffer bookmark file',
          \ 'unite files in current dir',
          \ [
          \ '[UNITE b ] is to open unite buffer and bookmark source with cursor',
          \ 'word',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]n
          \ :<C-u>Unite session/new<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite.n = ['Unite session/new',
          \ 'unite session/new',
          \ [
          \ '[UNITE n ] is to create new vim session',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]/
          \ :Unite grep:.<cr>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite['/'] = ['Unite grep:.',
          \ 'unite grep with preview',
          \ [
          \ '[UNITE / ] is to open unite grep source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent> [unite]w
          \ :<C-u>Unite -buffer-name=files -no-split
          \ jump_point file_point buffer_tab
          \ file_rec:! file file/new<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 6
    let g:_spacevim_mappings_unite.w= ['Unite -buffer-name=files -no-split' .
          \ ' jump_point file_point buffer_tab file_rec:! file file/new',
          \ 'unite all file and jump',
          \ [
          \ '[UNITE w ] is to open unite jump_point file_point and buffer_tab',
          \ 'source',
          \ '',
          \ 'Definition: ' . s:file . ':' . lnum,
          \ ]
          \ ]
    nnoremap <silent>[unite]<Space> :Unite -silent -ignorecase -winheight=17
          \ -start-insert menu:CustomKeyMaps<CR>
    let lnum = expand('<slnum>') + s:unite_lnum - 4
    let g:_spacevim_mappings_unite['[SPC]'] = ['Unite -silent -ignorecase' .
          \ ' -winheight=17 -start-insert menu:CustomKeyMaps',
          \ 'unite customkeymaps',
          \ [
          \ '[UNITE o ] is to open unite outline source',
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
