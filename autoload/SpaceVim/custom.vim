"=============================================================================
" custom.vim --- custom API in SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:TOML = SpaceVim#api#import('data#toml')
let s:JSON = SpaceVim#api#import('data#json')

function! SpaceVim#custom#profile(dict) abort
  for key in keys(a:dict)
    call s:set(key, a:dict[key])
  endfor
endfunction


function! s:set(key,val) abort
  if !exists('g:spacevim_' . a:key)
    call SpaceVim#logger#warn('no option named ' . a:key)
  else
    exe 'let ' . 'g:spacevim_' . a:key . '=' . a:val
  endif
endfunction

" What is your preferred editing style?
" - Among the stars aboard the Evil flagship (vim)
" - On the planet Emacs in the Holy control tower (emacs)
"
" What distribution of spacemacs would you like to start with?
" The standard distribution, recommended (spacemacs)
" A minimalist distribution that you can build on (spacemacs-base)

function! SpaceVim#custom#autoconfig(...) abort
  let menu = SpaceVim#api#import('cmdlinemenu')
  let ques = [
        \ ['dark powered mode', function('s:awesome_mode')],
        \ ['basic mode', function('s:basic_mode')],
        \ ]
  call menu.menu(ques)
endfunction

function! s:awesome_mode() abort
  let sep = SpaceVim#api#import('file').separator
  let f = fnamemodify(g:_spacevim_root_dir, ':h') . join(['', 'mode', 'dark_powered.vim'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:basic_mode() abort
  let sep = SpaceVim#api#import('file').separator
  let f = fnamemodify(g:_spacevim_root_dir, ':h') . join(['', 'mode', 'basic.vim'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:write_to_config(config) abort
  let cf = expand('~/.SpaceVim.d/init.vim')
  if filereadable(cf)
    return
  endif
  if !isdirectory(fnamemodify(cf, ':p:h'))
    call mkdir(expand(fnamemodify(cf, ':p:h')), 'p')
  endif
  call writefile(a:config, cf, '')
endfunction

function! SpaceVim#custom#SPC(m, keys, cmd, desc, is_cmd) abort
  call add(g:_spacevim_mappings_space_custom,[a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction

function! SpaceVim#custom#SPCGroupName(keys, name) abort
  call add(g:_spacevim_mappings_space_custom_group_name, [a:keys, a:name])
endfunction


function! SpaceVim#custom#apply(config) abort
  let config = json_decode(a:config)
  for key in keys(config)
    if exists('g:spacevim_' . key)
      exe 'let g:spacevim_' . key . ' = "' . config[key] . '"'
    endif
  endfor
endfunction

function! SpaceVim#custom#write(force) abort

endfunction

function! s:path_to_fname(path) abort
  return expand('~/.cache/SpaceVim/conf/') . substitute(a:path, '/', '_', '')
endfunction

function! SpaceVim#custom#load() abort
  " if file .SpaceVim.d/init.toml exist 
  if filereadable('.SpaceVim.d/init.toml')
    let local_conf = fnamemodify('.SpaceVim.d/init.toml', ':p')
    let local_conf_cache = s:path_to_fname(local_conf)
    if getftime(local_conf) < getftime(local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call SpaceVim#custom#apply(conf)
    else
      let conf = s:TOML.parse_file(local_conf)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call SpaceVim#custom#apply(conf)
    endif
    if g:spacevim_force_global_config
      call s:load_glob_conf()
    endif
  elseif filereadable('.SpaceVim.d/init.vim')
    exe 'set rtp ^=' . fnamemodify('.SpaceVim.d', ':p')
    exe 'source .SpaceVim.d/init.vim'
    if g:spacevim_force_global_config
      call s:load_glob_conf()
    endif
  endif

  call s:load_glob_conf()

  if g:spacevim_enable_ycm && g:spacevim_snippet_engine !=# 'ultisnips'
    call SpaceVim#logger#info('YCM only support ultisnips, change g:spacevim_snippet_engine to ultisnips')
    let g:spacevim_snippet_engine = 'ultisnips'
  endif
endfunction


function! s:load_glob_conf() abort
  if filereadable(expand('~/.SpaceVim.d/init.toml'))
    let local_conf = expand('~/.SpaceVim.d/init.toml')
    let local_conf_cache = expand('~/.cache/SpaceVim/conf/init.json')
    if getftime(local_conf) < getftime(local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call SpaceVim#custom#apply(conf)
    else
      let conf = s:TOML.parse_file(local_conf)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call SpaceVim#custom#apply(conf)
    endif
  elseif filereadable(expand('~/.SpaceVim.d/init.vim'))
    let custom_glob_conf = expand('~/.SpaceVim.d/init.vim')
    if isdirectory(expand('~/.SpaceVim.d/'))
      set runtimepath^=~/.SpaceVim.d
    endif
    exe 'source ' . custom_glob_conf
  else
    if has('timers')
      " if there is no custom config auto generate it.
      let g:spacevim_checkinstall = 0
      augroup SpaceVimBootstrap
        au!
        au VimEnter * call timer_start(2000, function('SpaceVim#custom#autoconfig'))
      augroup END
    endif
  endif

endfunction

