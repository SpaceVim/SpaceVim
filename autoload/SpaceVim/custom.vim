"=============================================================================
" custom.vim --- custom API in SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

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

function! SpaceVim#custom#load() abort
  " if file .SpaceVim.d/init.toml exist 
  " first check file time of ./SpaceVim.d/init.toml
  " if it is same as ~/.cache/SpaceVim/{full-path}.json
  "   load ~/.cache/SpaceVim/{full-path}.json and skip parse ./SpaceVim.d/init.toml
  " else
  "   parse ./SpaceVim.d/init.toml and write to ~/.cache/SpaceVim/{full-path}.json 
  "   load ~/.cache/SpaceVim/{full-path}.json
  " endif
  " elseif file ./SpaceVim.d/init.vim exist
  "  load ./SpaceVim.d/init.vim
  "  warnning this file will not supported
  " endif
  " if do not skip global config
  "   if file ~/.SpaceVim.d/init.toml exist 
  "   first check file time of ~/.SpaceVim.d/init.toml
  "   if it is same as ~/.cache/SpaceVim/init.json
  "     load ~/.cache/SpaceVim/init.json and skip parse ~/.SpaceVim.d/init.toml
  "   else
  "     parse ~/.SpaceVim.d/init.toml and write to ~/.cache/SpaceVim/init.json 
  "     load ~/.cache/SpaceVim/init.json
  "   endif
  "   elseif file ~/.SpaceVim.d/init.vim exist
  "     load ./SpaceVim.d/init.vim
  "    warnning this file will not supported
  "   endif
  " endif
  " if all these files do not exist, auto generate custom configuration file.
  let custom_conf = SpaceVim#util#globpath(getcwd(), '.SpaceVim.d/init.vim')
  let custom_glob_conf = expand('~/.SpaceVim.d/init.vim')

  if has('timers')
    if !filereadable(custom_glob_conf)
      " if there is no custom config auto generate it.
      let g:spacevim_checkinstall = 0
      augroup SpaceVimBootstrap
        au!
        au VimEnter * call timer_start(2000, function('SpaceVim#custom#autoconfig'))
      augroup END
    endif
  endif

  if !empty(custom_conf)
    if isdirectory('.SpaceVim.d')
      exe 'set rtp ^=' . fnamemodify('.SpaceVim.d', ':p')
    endif
    exe 'source ' . custom_conf[0]
    if g:spacevim_force_global_config
      if filereadable(custom_glob_conf)
        if isdirectory(expand('~/.SpaceVim.d/'))
          set runtimepath^=~/.SpaceVim.d
        endif
        exe 'source ' . custom_glob_conf
      endif
    else
      call SpaceVim#logger#info('Skip glob configuration of SpaceVim')
    endif
  elseif filereadable(custom_glob_conf)
    if isdirectory(expand('~/.SpaceVim.d/'))
      set runtimepath^=~/.SpaceVim.d
    endif
    exe 'source ' . custom_glob_conf
  endif

  " json config
  let json_global = expand('~/.SpaceVim.d/init.json')
  if filereadable(json_global)
    let config = join(readfile(json_global), '')
    call SpaceVim#custom#apply(config)
  endif

  if g:spacevim_enable_ycm && g:spacevim_snippet_engine !=# 'ultisnips'
    call SpaceVim#logger#info('YCM only support ultisnips, change g:spacevim_snippet_engine to ultisnips')
    let g:spacevim_snippet_engine = 'ultisnips'
  endif
endfunction
