"=============================================================================
" plugins.vim --- plugin wrapper
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
function! SpaceVim#plugins#load() abort
  if SpaceVim#plugins#enable_plug()
    call SpaceVim#plugins#begin(g:spacevim_plugin_bundle_dir)
    call SpaceVim#plugins#fetch()
    call s:load_plugins()
    call s:disable_plugins(g:spacevim_disabled_plugins)
    call SpaceVim#plugins#end()
  endif

endfunction
function! s:load_plugins() abort
  for group in SpaceVim#layers#get()
    let g:_spacevim_plugin_layer = group
    for plugin in s:getLayerPlugins(group)
      if len(plugin) == 2
        call SpaceVim#plugins#add(plugin[0], plugin[1])
        if SpaceVim#plugins#tap(split(plugin[0], '/')[-1]) && get(plugin[1], 'loadconf', 0 )
          call SpaceVim#plugins#defind_hooks(split(plugin[0], '/')[-1])
        endif
        if SpaceVim#plugins#tap(split(plugin[0], '/')[-1]) && get(plugin[1], 'loadconf_before', 0 )
          call SpaceVim#plugins#loadPluginBefore(split(plugin[0], '/')[-1])
        endif
      else
        call SpaceVim#plugins#add(plugin[0])
      endif
    endfor
    call s:loadLayerConfig(group)
  endfor
  unlet g:_spacevim_plugin_layer
  for plugin in g:spacevim_custom_plugins
    if len(plugin) == 2
      call SpaceVim#plugins#add(plugin[0], plugin[1])
    else
      call SpaceVim#plugins#add(plugin[0])
    endif
  endfor
endfunction

function! s:getLayerPlugins(layer) abort
  let p = []
  try
    let p = SpaceVim#layers#{a:layer}#plugins()
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction

function! s:loadLayerConfig(layer) abort
  try
    call SpaceVim#layers#{a:layer}#config()
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry

endfunction

let s:plugins_argv = ['-update', '-openurl']

function! SpaceVim#plugins#complete_plugs(ArgLead, CmdLine, CursorPos) abort
  call SpaceVim#commands#debug#completion_debug(a:ArgLead, a:CmdLine, a:CursorPos)
  if a:CmdLine =~# 'Plugin\s*$' || a:ArgLead =~# '^-[a-zA-Z]*'
    return join(s:plugins_argv, "\n")
  endif
  return join(plugins#list(), "\n")
endfunction

function! SpaceVim#plugins#Plugin(...) abort
  let adds = []
  let updates = []
  let flag = 0
  for a in a:000
    if flag == 1
      call add(adds, a)
    elseif flag == 2
      call add(updates, a)
    endif
    if a ==# '-update'
      let flag = 1
    elseif a ==# '-openurl'
      let flag = 2
    endif
  endfor
  echo string(adds) . "\n" . string(updates)
endfunction
function! s:disable_plugins(plugin_list) abort
  if g:spacevim_plugin_manager ==# 'dein'
    for name in a:plugin_list
      call dein#disable(name)
    endfor
  elseif g:spacevim_plugin_manager ==# 'neobundle'
    for name in a:plugin_list
      call neobundle#config#disable(name)
    endfor
  endif
endfunction

function! SpaceVim#plugins#get(...) abort

endfunction

function! s:install_manager() abort
  " Fsep && Psep
  if has('win16') || has('win32') || has('win64')
    let s:Psep = ';'
    let s:Fsep = '\'
  else
    let s:Psep = ':'
    let s:Fsep = '/'
  endif
  " auto install plugin manager
  if g:spacevim_plugin_manager ==# 'neobundle'
    "auto install neobundle
    if filereadable(expand(g:spacevim_plugin_bundle_dir)
          \ . 'neobundle.vim'. s:Fsep. 'README.md')
      let g:_spacevim_neobundle_installed = 1
    else
      if executable('git')
        exec '!git clone '
              \ .'https://github.com/'
              \ .'Shougo/neobundle.vim'
              \ . ' '
              \ . fnameescape(g:spacevim_plugin_bundle_dir)
              \ . 'neobundle.vim'
        let g:_spacevim_neobundle_installed = 1
      else
        echohl WarningMsg
        echom 'You need install git!'
        echohl None
      endif
    endif
    exec 'set runtimepath+='
          \ . fnameescape(g:spacevim_plugin_bundle_dir)
          \ . 'neobundle.vim'
  elseif g:spacevim_plugin_manager ==# 'dein'
    let g:_spacevim_dein_installed = 1
    exec 'set runtimepath+=' . g:_spacevim_root_dir . 'bundle/dein.vim/'
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    "auto install vim-plug
    if filereadable(expand(g:spacevim_data_dir.'/vim-plug/autoload/plug.vim'))
      let g:_spacevim_vim_plug_installed = 1
    else
      if executable('curl')
        exec '!curl -fLo '
              \ . g:spacevim_data_dir.'/vim-plug/autoload/plug.vim'
              \ . ' --create-dirs '
              \ . 'https://raw.githubusercontent.com/'
              \ . 'junegunn/vim-plug/master/plug.vim'
        let g:_spacevim_vim_plug_installed = 1
      else
        echohl WarningMsg
        echom 'You need install curl!'
        echohl None
      endif
    endif
    exec 'set runtimepath+='g:spacevim_data_dir.'/vim-plug/'
  endif
endf

call s:install_manager()


function! SpaceVim#plugins#begin(path) abort
  let g:unite_source_menu_menus.AddedPlugins =
        \ {'description':
        \ 'All the Added plugins'
        \ . '                    <leader>lp'}
  let g:unite_source_menu_menus.AddedPlugins.command_candidates = []
  if g:spacevim_plugin_manager ==# 'neobundle'
    call neobundle#begin(a:path)
  elseif g:spacevim_plugin_manager ==# 'dein'
    call dein#begin(a:path)
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    call plug#begin(a:path)
  endif
endfunction

function! SpaceVim#plugins#end() abort
  if g:spacevim_plugin_manager ==# 'neobundle'
    call neobundle#end()
    if g:spacevim_checkinstall == 1
      silent! let g:_spacevim_checking_flag = neobundle#exists_not_installed_bundles()
      if g:_spacevim_checking_flag
        augroup SpaceVimCheckInstall
          au!
          au VimEnter * SPInstall
        augroup END
      endif
    endif
  elseif g:spacevim_plugin_manager ==# 'dein'
    call dein#end()
    " dein do not include the after dir of SpaceVim by default
    let &rtp .= ',' . g:_spacevim_root_dir . 'after'
    if g:spacevim_checkinstall == 1
      silent! let g:_spacevim_checking_flag = dein#check_install()
      if g:_spacevim_checking_flag
        augroup SpaceVimCheckInstall
          au!
          au VimEnter * SPInstall
        augroup END
      endif
    endif
    call dein#call_hook('source')
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    call plug#end()
  endif
endfunction

function! SpaceVim#plugins#defind_hooks(bundle) abort
  if g:spacevim_plugin_manager ==# 'neobundle'
    let s:hooks = neobundle#get_hooks(a:bundle)
    func! s:hooks.on_source(bundle) abort
      call SpaceVim#util#loadConfig('plugins/' . split(a:bundle['name'],'\.')[0] . '.vim')
    endf
  elseif g:spacevim_plugin_manager ==# 'dein'
    call dein#config(g:dein#name, {
          \ 'hook_source' : "call SpaceVim#util#loadConfig('plugins/" . split(g:dein#name,'\.')[0] . ".vim')"
          \ })
  endif
endfunction

function! SpaceVim#plugins#fetch() abort
  if g:spacevim_plugin_manager ==# 'neobundle'
    NeoBundleFetch 'Shougo/neobundle.vim'
  elseif g:spacevim_plugin_manager ==# 'dein'
    call dein#add('Shougo/dein.vim')
  endif
endfunction

let s:plugins = []

fu! s:parser(args) abort
  return a:args
endf
let g:_spacevim_plugins = []
function! SpaceVim#plugins#add(repo,...) abort
  let g:spacevim_plugin_name = ''
  if g:spacevim_plugin_manager ==# 'neobundle'
    exec 'NeoBundle "'.a:repo.'"'.','.join(a:000,',')
    let g:spacevim_plugin_name = split(a:repo, '/')[-1]
  elseif g:spacevim_plugin_manager ==# 'dein'
    if len(a:000) > 0
      call dein#add(a:repo,s:parser(a:000[0]))
    else
      call dein#add(a:repo)
    endif
    let g:spacevim_plugin_name = g:dein#name
    call add(g:_spacevim_plugins, g:dein#name)
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    if len(a:000) > 0
      exec "Plug '".a:repo."', ".join(a:000,',')
    else
      exec "Plug '".a:repo."'"
    endif
    let g:spacevim_plugin_name = split(a:repo, '/')[-1]
  endif
  let str = get(g:,'_spacevim_plugin_layer', 'custom plugin')
  let str = '[' . str . ']'
  let str = str . repeat(' ', 25 - len(str))
  exec 'call add(g:unite_source_menu_menus'
        \ . '.AddedPlugins.command_candidates, ["'. str . '['
        \ . a:repo
        \ . (len(a:000) > 0 ? (']'
        \ . repeat(' ', 40 - len(a:repo))
        \ . '[lazy loaded]  [' . string(a:000[0])) : '')
        \ . ']","OpenBrowser https://github.com/'
        \ . a:repo
        \ . '"])'
  call add(s:plugins, a:repo)
endfunction

function! SpaceVim#plugins#tap(plugin) abort
  if g:spacevim_plugin_manager ==# 'neobundle'
    return neobundle#tap(a:plugin)
  elseif g:spacevim_plugin_manager ==# 'dein'
    return dein#tap(a:plugin)
  endif
endfunction

function! SpaceVim#plugins#enable_plug() abort
  return g:_spacevim_neobundle_installed
        \ || g:_spacevim_dein_installed
        \ || g:_spacevim_vim_plug_installed
endfunction

function! SpaceVim#plugins#loadPluginBefore(plugin) abort
  if matchend(a:plugin, "\\.vim") == len(a:plugin)
    call SpaceVim#util#loadConfig('plugins_before/' . a:plugin)
  elseif matchend(a:plugin, "\\.nvim") == len(a:plugin)
    call SpaceVim#util#loadConfig('plugins_before/' . a:plugin[:-6] . '.vim')
  else
    call SpaceVim#util#loadConfig('plugins_before/' . a:plugin . '.vim')
  endif
endfunction

" vim:set et sw=2:
