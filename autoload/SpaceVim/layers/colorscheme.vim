"=============================================================================
" colorscheme.vim --- SpaceVim colorscheme layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section colorscheme, colorscheme
" @parentsection layers
" The ldefault colorscheme for SpaceVim is gruvbox. The colorscheme can be
" changed with the `g:spacevim_colorscheme` option by adding the following
" line to your `~/.SpaceVim/init.vim`.
" >
"   let g:spacevim_colorscheme = 'solarized'
" <
"
" The following colorschemes are include in SpaceVim. If the colorscheme you
" want is not included in the list below, a PR is welcome.
"
" Also, there's one thing which everyone should know and pay attention to.
" NOT all of below colorschemes support spell check very well. For example,
" a colorscheme called atom doesn't support spell check very well.
"
" SpaceVim is not gonna fix them since these should be in charge of each author.

let s:JSON = SpaceVim#api#import('data#json')

function! SpaceVim#layers#colorscheme#plugins() abort
  return [
        \ ['Gabirel/molokai', { 'merged' : 0 }],
        \ ['joshdick/onedark.vim', { 'merged' : 0 }],
        \ ['nanotech/jellybeans.vim', { 'merged' : 0 }],
        \ ['rakr/vim-one', { 'merged' : 0 }],
        \ ['arcticicestudio/nord-vim', { 'merged' : 0 }],
        \ ['icymind/NeoSolarized', { 'merged' : 0 }],
        \ ['w0ng/vim-hybrid', { 'merged' : 0 }],
        \ ['SpaceVim/vim-material', { 'merged' : 0}],
        \ ['srcery-colors/srcery-vim', { 'merged' : 0}],
        \ [ 'drewtempelmeyer/palenight.vim', {'merged': 0 }],
        \ ]
  "
  " TODO:
  " \ ['mhartington/oceanic-next', { 'merged' : 0 }],
  " \ ['junegunn/seoul256.vim', { 'merged' : 0 }],
  " \ ['kabbamine/yowish.vim', { 'merged' : 0 }],
  " \ ['KeitaNakamura/neodark.vim', { 'merged' : 0 }],
  " \ ['NLKNguyen/papercolor-theme', { 'merged' : 0 }],
  " \ ['SpaceVim/FlatColor', { 'merged' : 0 }],

endfunction

let s:cs = [
      \ 'gruvbox',
      \ 'molokai',
      \ 'onedark',
      \ 'jellybeans',
      \ 'one',
      \ 'nord',
      \ 'hybrid',
      \ 'NeoSolarized',
      \ 'material',
      \ 'srcery',
      \ ]
let s:NUMBER = SpaceVim#api#import('data#number')

let s:time = {
      \ 'daily' : 1 * 24 * 60 * 60 * 1000,
      \ 'hourly' : 1 * 60 * 60 * 1000,
      \ 'weekly' : 7 * 24 * 60 * 60 * 1000,
      \ }

for s:n in range(1, 23)
  call extend(s:time, {s:n . 'h' : s:n * 60 * 60 * 1000})
endfor

unlet s:n

let s:random_colorscheme = 0
let s:random_frequency = ''
let s:bright_statusline = 0

function! SpaceVim#layers#colorscheme#config() abort
  if s:random_colorscheme
    let ctime = ''
    " Use local file's save time, the local file is
    " ~/.cache/SpaceVim/colorscheme_frequence.json
    " {"fequecnce" : "dalily", "last" : 000000, 'theme' : 'one'}
    " FIXME: when global config cache is updated, check the cache also should
    " be updated
    if filereadable(expand(g:spacevim_data_dir.'/SpaceVim/colorscheme_frequence.json'))
      let conf = s:JSON.json_decode(join(readfile(expand(g:spacevim_data_dir.'/SpaceVim/colorscheme_frequence.json'), ''), ''))
      if s:random_frequency !=# '' && !empty(conf)
        let ctime = localtime()
        if ctime - get(conf, 'last', 0) >= get(s:time,  get(conf, 'fequecnce', ''), 0)
          let id = s:NUMBER.random(0, len(s:cs))
          let g:spacevim_colorscheme = s:cs[id]
          call s:update_conf()
        else
          let g:spacevim_colorscheme = conf.theme
        endif
      else
        let id = s:NUMBER.random(0, len(s:cs))
        let g:spacevim_colorscheme = s:cs[id]
      endif
    else
      if s:random_frequency !=# ''
        call s:update_conf()
      endif
    endif
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'n'],
        \ 'call call(' . string(s:_function('s:cycle_spacevim_theme'))
        \ . ', [])', 'cycle-spacevim-theme', 1)
endfunction

function! s:update_conf() abort
  let conf = {
        \ 'fequecnce' : s:random_frequency,
        \ 'last' : localtime(),
        \ 'theme' : g:spacevim_colorscheme
        \ }
  call writefile([s:JSON.json_encode(conf)], expand(g:spacevim_data_dir.'/SpaceVim/colorscheme_frequence.json'))
endfunction


function! SpaceVim#layers#colorscheme#set_variable(var) abort
  let s:random_colorscheme = get(a:var, 'random_theme', get(a:var, 'random-theme', 0))
  let s:random_frequency = get(a:var, 'frequency', 'hourly')
  let s:bright_statusline = get(a:var, 'bright_statusline', 0)
endfunction

function! SpaceVim#layers#colorscheme#get_variable() abort
  return s:
endfunction

function! SpaceVim#layers#colorscheme#get_options() abort

  return ['random_theme']

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
function! s:cycle_spacevim_theme() abort
  let id = s:NUMBER.random(0, len(s:cs))
  " if the frequency is not empty and random_theme is on, SPC T n should
  " update the cache file:
  let g:spacevim_colorscheme = s:cs[id]
  exe 'colorscheme ' . g:spacevim_colorscheme
  call s:update_conf()
endfunction
