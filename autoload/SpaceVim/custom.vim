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
  let f = fnamemodify(g:_spacevim_root_dir, ':h') . join(['', 'mode', 'dark_powered.toml'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:basic_mode() abort
  let sep = SpaceVim#api#import('file').separator
  let f = fnamemodify(g:_spacevim_root_dir, ':h') . join(['', 'mode', 'basic.toml'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:write_to_config(config) abort

  let global_dir = empty($SPACEVIMDIR) ? expand('~/.SpaceVim.d/') : $SPACEVIMDIR
  let g:_spacevim_global_config_path = global_dir . 'init.toml'
  let cf = global_dir . 'init.toml'
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
  if type(a:config) != type({})
    call SpaceVim#logger#info('config type is wrong!')
  else
    let options = get(a:config, 'options', {})
    for [name, value] in items(options)
      exe 'let g:spacevim_' . name . ' = value'
      unlet value
    endfor
    let layers = get(a:config, 'layers', [])
    for layer in layers
      if !get(layer, 'enable', 1)
        call SpaceVim#layers#disable(layer.name)
      else
        call SpaceVim#layers#load(layer.name, layer)
      endif
    endfor
    let custom_plugins = get(a:config, 'custom_plugins', [])
    for plugin in custom_plugins
      call add(g:spacevim_custom_plugins, [plugin.name, plugin])
    endfor
    let bootstrap_before = get(options, 'bootstrap_before', '')
    let g:_spacevim_bootstrap_after = get(options, 'bootstrap_after', '')
    if !empty(bootstrap_before)
      try
        call call(bootstrap_before, [])
      catch
        call SpaceVim#logger#error('failed to call bootstrap_before function: ' . bootstrap_before)
      endtry
    endif
  endif
endfunction

function! SpaceVim#custom#write(force) abort

endfunction

function! s:path_to_fname(path) abort
  return expand('~/.cache/SpaceVim/conf/') . substitute(a:path, '[\\/:;.]', '_', 'g') . '.json'
endfunction

function! SpaceVim#custom#load() abort
  " if file .SpaceVim.d/init.toml exist 
  if filereadable('.SpaceVim.d/init.toml')
    let g:_spacevim_config_path = fnamemodify('.SpaceVim.d/init.toml', ':p')
    let &rtp =  fnamemodify('.SpaceVim.d', ':p:h') . ',' . &rtp
    let local_conf = fnamemodify('.SpaceVim.d/init.toml', ':p')
    call SpaceVim#logger#info('find config file: ' . local_conf)
    let local_conf_cache = s:path_to_fname(local_conf)
    if getftime(local_conf) < getftime(local_conf_cache)
      call SpaceVim#logger#info('loadding cached config: ' . local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call SpaceVim#custom#apply(conf)
    else
      let conf = s:TOML.parse_file(local_conf)
      call SpaceVim#logger#info('generate config cache: ' . local_conf_cache)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call SpaceVim#custom#apply(conf)
    endif
    if g:spacevim_force_global_config
      call SpaceVim#logger#info('force loadding global config >>>')
      call s:load_glob_conf()
    endif
  elseif filereadable('.SpaceVim.d/init.vim')
    let g:_spacevim_config_path = fnamemodify('.SpaceVim.d/init.vim', ':p')
    let &rtp =  fnamemodify('.SpaceVim.d', ':p:h') . ',' . &rtp
    exe 'source .SpaceVim.d/init.vim'
    if g:spacevim_force_global_config
      call SpaceVim#logger#info('force loadding global config >>>')
      call s:load_glob_conf()
    endif
  else
    call SpaceVim#logger#info('Can not find project local config, start to loadding global config')
    call s:load_glob_conf()
  endif


  if g:spacevim_enable_ycm && g:spacevim_snippet_engine !=# 'ultisnips'
    call SpaceVim#logger#info('YCM only support ultisnips, change g:spacevim_snippet_engine to ultisnips')
    let g:spacevim_snippet_engine = 'ultisnips'
  endif
endfunction


function! s:load_glob_conf() abort
  let global_dir = empty($SPACEVIMDIR) ? expand('~/.SpaceVim.d') : $SPACEVIMDIR
  if filereadable(global_dir . '/init.toml')
    let g:_spacevim_global_config_path = global_dir . '/init.toml'
    let local_conf = global_dir . '/init.toml'
    let local_conf_cache = expand('~/.cache/SpaceVim/conf/init.json')
    let &rtp = global_dir . ',' . &rtp
    if getftime(local_conf) < getftime(local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call SpaceVim#custom#apply(conf)
    else
      let conf = s:TOML.parse_file(local_conf)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call SpaceVim#custom#apply(conf)
    endif
  elseif filereadable(global_dir . '/init.vim')
    let g:_spacevim_global_config_path = global_dir . '/init.vim'
    let custom_glob_conf = global_dir . '/init.vim'
    let &rtp = global_dir . ',' . &rtp
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

