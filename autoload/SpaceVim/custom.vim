"=============================================================================
" custom.vim --- custom API in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:TOML = SpaceVim#api#import('data#toml')
let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')
let s:CMP = SpaceVim#api#import('vim#compatible')

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
        \ ['basic mode', function('s:basic_mode')],
        \ ['dark powered mode', function('s:awesome_mode')],
        \ ]
  call menu.menu(ques)
endfunction



function! s:awesome_mode() abort
  let sep = s:FILE.separator
  let f = g:_spacevim_root_dir . join(['', 'mode', 'dark_powered.toml'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:basic_mode() abort
  let sep = s:FILE.separator
  let f = g:_spacevim_root_dir . join(['', 'mode', 'basic.toml'], sep)
  let config = readfile(f, '')
  call s:write_to_config(config)
endfunction

function! s:write_to_config(config) abort

  let global_dir = empty($SPACEVIMDIR) ? expand('~/.SpaceVim.d/') : $SPACEVIMDIR
  let g:_spacevim_global_config_path = global_dir . 'init.toml'
  let cf = global_dir . 'init.toml'
  if filereadable(cf)
    call SpaceVim#logger#warn('Failed to generate config file, it is not readable: ' . cf)
    return
  endif
  let dir = expand(fnamemodify(cf, ':p:h'))
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  call writefile(a:config, cf, '')
endfunction

function! SpaceVim#custom#SPC(m, keys, cmd, desc, is_cmd) abort
  call add(g:_spacevim_mappings_space_custom,[a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction

function! SpaceVim#custom#SPCGroupName(keys, name) abort
  call add(g:_spacevim_mappings_space_custom_group_name, [a:keys, a:name])
endfunction


function! SpaceVim#custom#apply(config, type) abort
  " the type can be local or global
  " local config can override global config
  if type(a:config) != type({})
    call SpaceVim#logger#info('config type is wrong!')
  else
    call SpaceVim#logger#info('start to apply config [' . a:type . ']')
    let options = get(a:config, 'options', {})
    for [name, value] in items(options)
      exe 'let g:spacevim_' . name . ' = value'
      if name ==# 'project_rooter_patterns'
        " clear rooter cache
        call SpaceVim#plugins#projectmanager#current_root()
      endif
      unlet value
    endfor
    if g:spacevim_debug_level !=# 1
      call SpaceVim#logger#setLevel(g:spacevim_debug_level)
    endif
    let layers = get(a:config, 'layers', [])
    for layer in layers
      let enable = get(layer, 'enable', 1)
      if (type(enable) == type('') && !eval(enable)) || (type(enable) != type('') && !enable)
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
        call SpaceVim#logger#error('       exception: ' . v:exception)
        call SpaceVim#logger#error('       throwpoint: ' . v:throwpoint)
      endtry
    endif
  endif
endfunction

function! SpaceVim#custom#write(force) abort
  if a:force
  endif
endfunction

function! s:path_to_fname(path) abort
  return expand(g:spacevim_data_dir.'/SpaceVim/conf/') . substitute(a:path, '[\\/:;.]', '_', 'g') . '.json'
endfunction

function! SpaceVim#custom#load() abort
  " if file .SpaceVim.d/init.toml exist
  if filereadable('.SpaceVim.d/init.toml')
    let g:_spacevim_config_path = s:CMP.resolve(fnamemodify('.SpaceVim.d/init.toml', ':p'))
    let &rtp =  s:FILE.unify_path(s:CMP.resolve(fnamemodify('.SpaceVim.d', ':p:h'))) . ',' . &rtp
    let local_conf = g:_spacevim_config_path
    call SpaceVim#logger#info('find local conf: ' . local_conf)
    let local_conf_cache = s:path_to_fname(local_conf)
    if getftime(local_conf) < getftime(local_conf_cache)
      call SpaceVim#logger#info('loading cached local conf: ' . local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call SpaceVim#custom#apply(conf, 'local')
    else
      let conf = s:TOML.parse_file(local_conf)
      call SpaceVim#logger#info('generate local conf: ' . local_conf_cache)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call SpaceVim#custom#apply(conf, 'local')
    endif
    if g:spacevim_force_global_config
      call SpaceVim#logger#info('force loading global config >>>')
      call s:load_glob_conf()
    endif
  elseif filereadable('.SpaceVim.d/init.vim')
    let g:_spacevim_config_path = fnamemodify('.SpaceVim.d/init.vim', ':p')
    let &rtp =  s:FILE.unify_path(s:CMP.resolve(fnamemodify('.SpaceVim.d', ':p:h'))) . ',' . &rtp
    let local_conf = g:_spacevim_config_path
    call SpaceVim#logger#info('find local conf: ' . local_conf)
    exe 'source .SpaceVim.d/init.vim'
    if g:spacevim_force_global_config
      call SpaceVim#logger#info('force loading global config >>>')
      call s:load_glob_conf()
    endif
  else
    call SpaceVim#logger#info('Can not find project local config, start loading global config')
    call s:load_glob_conf()
  endif


  if g:spacevim_enable_ycm && g:spacevim_snippet_engine !=# 'ultisnips'
    call SpaceVim#logger#info('YCM only support ultisnips, change g:spacevim_snippet_engine to ultisnips')
    let g:spacevim_snippet_engine = 'ultisnips'
  endif
endfunction


function! s:load_glob_conf() abort
  let global_dir = empty($SPACEVIMDIR) ? s:FILE.unify_path(s:CMP.resolve(expand('~/.SpaceVim.d/'))) : $SPACEVIMDIR
  if filereadable(global_dir . 'init.toml')
    let g:_spacevim_global_config_path = global_dir . 'init.toml'
    let local_conf = global_dir . 'init.toml'
    let local_conf_cache = s:FILE.unify_path(expand(g:spacevim_data_dir.'/SpaceVim/conf/init.json'))
    let &rtp = global_dir . ',' . &rtp
    if getftime(local_conf) < getftime(local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call SpaceVim#custom#apply(conf, 'glob')
    else
      let conf = s:TOML.parse_file(local_conf)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call SpaceVim#custom#apply(conf, 'glob')
    endif
  elseif filereadable(global_dir . 'init.vim')
    let g:_spacevim_global_config_path = global_dir . 'init.vim'
    let custom_glob_conf = global_dir . 'init.vim'
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

" FIXME: the type should match the toml's type
function! s:opt_type(opt) abort
  " autoload/SpaceVim/custom.vim:221:31:Error: EVL103: unused argument `a:opt`
  " @bugupstream viml-parser seem do not think this is used argument
  let opt = a:opt
  let var = get(g:, 'spacevim_' . opt, '')
  if type(var) == type('')
    return '[string]'
  elseif type(var) == 5
    return '[boolean]'
  elseif type(var) == 0
    return '[number]'
  elseif type(var) == 3
    return '[list]'
  endif
endfunction

function! s:short_desc_of_opt(opt) abort
  if a:opt =~# '^enable_'
  else
  endif
  return ''
endfunction

function! SpaceVim#custom#complete(findstart, base) abort
  if a:findstart
    let s:complete_type = ''
    let s:complete_layer_name = ''
    " locate the start of the word
    let section_line = search('^\s*\[','bn')
    if section_line > 0
      if getline(section_line) =~# '^\s*\[options\]\s*$'
        if getline('.')[:col('.')-1] =~# '^\s*[a-zA-Z_]*$'
          let s:complete_type = 'spacevim_options'
        endif
      elseif getline(section_line) =~# '^\s*\[\[layers\]\]\s*$'
        let s:complete_type = 'layers_options'
        let layer_name_line = search('^\s*name\s*=','bn')
        if layer_name_line > section_line && layer_name_line < line('.')
          let s:complete_layer_name = eval(split(getline(layer_name_line), '=')[1])
        endif
      endif
    endif
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~# '[a-zA-Z_]'
      let start -= 1
    endwhile
    return start
  else
    call SpaceVim#logger#info('Complete SpaceVim configuration file:')
    call SpaceVim#logger#info('complete_type: ' . s:complete_type)
    call SpaceVim#logger#info('complete_layer_name: ' . s:complete_layer_name)
    let res = []
    if s:complete_type ==# 'spacevim_options'
      for m in map(getcompletion('g:spacevim_','var'), 'v:val[11:]')
        if m =~ '^' . a:base
          call add(res, {
                \ 'word' : m,
                \ 'kind' : s:opt_type(m),
                \ 'menu' : s:short_desc_of_opt(m),
                \ })
        endif
      endfor
    elseif s:complete_type ==# 'layers_options'
      let options = ['name']
      if !empty(s:complete_layer_name)
        try
          let options = SpaceVim#layers#{s:complete_layer_name}#get_options()
        catch
        endtry
      endif
      for m in options
        if m =~ '^' . a:base
          call add(res, m)
        endif
      endfor
    endif
    return res
  endif
endfunction
