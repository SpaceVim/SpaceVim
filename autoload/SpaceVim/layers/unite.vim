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

  if g:spacevim_filemanager ==# 'vimfiler'
    call add(plugins, ['Shougo/vimfiler.vim',{'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1, 'on_cmd' : 'VimFiler'}])
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
