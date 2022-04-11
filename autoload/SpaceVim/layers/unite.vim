"=============================================================================
" unite.vim --- SpaceVim unite layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section unite, layers-unite
" @parentsection layers
" This layer provides fuzzy finder feature which is based on |unite|. This
" layer is not loaded by default, to use this layer, you need to load `unite`
" layer in your configuration file.
" >
"   [[layers]]
"     name = 'unite'
" <
"
" @subsection Key bindings
" >
"   | Key bindings         | Discription                   |
"   | -------------------- | ----------------------------- |
"   | `<Leader> f <Space>` | Fuzzy find menu:CustomKeyMaps |
"   | `<Leader> f e`       | Fuzzy find register           |
"   | `<Leader> f h`       | Fuzzy find history/yank       |
"   | `<Leader> f j`       | Fuzzy find jump, change       |
"   | `<Leader> f l`       | Fuzzy find location list      |
"   | `<Leader> f m`       | Fuzzy find output messages    |
"   | `<Leader> f o`       | Fuzzy find outline            |
"   | `<Leader> f q`       | Fuzzy find quick fix          |
"   | `<Leader> f r`       | Resumes Unite window          |
" <
"



function! SpaceVim#layers#unite#plugins() abort
  " The default sources:
  " file: <Leader>ff
  " register: <Leader>fe
  " jump: <Leader>fj
  " messages: <Leader>fm
  let plugins = [
        \ [g:_spacevim_root_dir . 'bundle/unite.vim', { 'merged' : 0, 'loadconf' : 1}],
        \ [g:_spacevim_root_dir . 'bundle/unite-sources', { 'merged' : 0}],
        \ ]

  if g:spacevim_filemanager !=# 'vimfiler'
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vimproc.vim', {'build' : [(executable('gmake') ? 'gmake' : 'make')]}])
  endif
  " \ ['mileszs/ack.vim',{'on_cmd' : 'Ack'}],
  " \ ['albfan/ag.vim',{'on_cmd' : 'Ag' , 'loadconf' : 1}],
  " \ ['dyng/ctrlsf.vim',{'on_cmd' : 'CtrlSF', 'on_map' : '<Plug>CtrlSF', 'loadconf' : 1 , 'loadconf_before' : 1}],

  " history/yank source <Leader>fh
  call add(plugins, [g:_spacevim_root_dir . 'bundle/neoyank.vim', {'merged' : 0}])
  " quickfix source <Leader>fq
  call add(plugins, ['osyo-manga/unite-quickfix', {'merged' : 0}])
  " outline source <Leader>fo
  call add(plugins, ['Shougo/unite-outline', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/neomru.vim', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-van', {'merged' : 0}])

  if g:spacevim_enable_googlesuggest
    call add(plugins, ['mopp/googlesuggest-source.vim'])
    call add(plugins, ['mattn/googlesuggest-complete-vim'])
  endif

  return plugins
endfunction

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#unite#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['?'], 'Unite menu:CustomKeyMaps -input=[SPC]', 'show mappings', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', '[SPC]'], 'Unite help -input=SpaceVim', 'unite-SpaceVim-help', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'm'], 'Unite manpage', 'search available man pages', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'Unite buffer', 'buffer list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['h', 'i'], 'UniteWithCursorWord help', 'get help with the symbol at point', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'u'], 'Unite unicode', 'search-and-insert-unicode', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'r'], 'Unite file_mru', 'open-recent-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['r', 'l'], 'Unite resume', 'resume unite buffer', 1)
  let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'u'], 'Unite unicode', 'search-and-insert-unicode', 1)
  if g:spacevim_snippet_engine ==# 'neosnippet'
    call SpaceVim#mapping#space#def('nnoremap', ['i', 's'], 'Unite neosnippet', 'insert snippets', 1)
  elseif g:spacevim_snippet_engine ==# 'ultisnips'
    call SpaceVim#mapping#space#def('nnoremap', ['i', 's'], 'Unite ultisnips', 'insert snippets', 1)
  endif
  if has('nvim')
    let cmd = 'Unite file_rec/neovim'
  else
    let cmd = 'Unite file_rec/async'
  endif
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'],
        \ cmd,
        \ ['find files in current project',
        \ [
        \ '[SPC p f] is to find files in the root of the current project',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['!'], 'call call('
        \ . string(s:_function('s:run_shell_cmd')) . ', [])',
        \ 'shell cmd(current dir)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', '!'], 'call call('
        \ . string(s:_function('s:run_shell_cmd_project')) . ', [])',
        \ 'shell cmd(project root)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 's'], 'Unite colorscheme', 'fuzzy find colorschemes', 1)
  if has('nvim')
    nnoremap <silent> <C-p> :Unite file_rec/neovim<cr>
  else
    nnoremap <silent> <C-p> :Unite file_rec/async<cr>
  endif
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'],
        \ 'UniteWithBufferDir file_rec/' . (has('nvim') ? 'neovim' : 'async'),
        \ ['Find files in the directory of the current buffer',
        \ [
        \ '[SPC f f] is to find files in the directory of the current buffer',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
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
        \ 'fuzzy find yank history',
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
  nnoremap <silent> <Leader>fo  :<C-u>Unite outline<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.o = ['Unite outline',
        \ 'fuzzy find outline',
        \ [
        \ '[Leader f o] is to fuzzy find outline',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>f<Space>
        \ :<C-u>Unite menu:CustomKeyMaps<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f['[SPC]'] = ['Unite menu:CustomKeyMaps',
        \ 'fuzzy find custom key bindings',
        \ [
        \ '[Leader f SPC] is to fuzzy find custom key bindings',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
  nnoremap <silent> <Leader>fp  :<C-u>Unite menu:AddedPlugins<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.p = ['Unite menu:AddedPlugins',
        \ 'fuzzy find vim packages',
        \ [
        \ '[Leader f p] is to fuzzy find vim packages installed in SpaceVim',
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

function! SpaceVim#layers#unite#health() abort
  call SpaceVim#layers#unite#plugins()
  call SpaceVim#layers#unite#config()
  return 1
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
