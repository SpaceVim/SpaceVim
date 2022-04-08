"=============================================================================
" custom.vim --- custom API in SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:TOML = SpaceVim#api#import('data#toml')
let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')
let s:VIM = SpaceVim#api#import('vim')
let s:CMP = SpaceVim#api#import('vim#compatible')

function! SpaceVim#custom#profile(dict) abort
  for key in keys(a:dict)
    call s:set(key, a:dict[key])
  endfor
endfunction


function! s:set(key,val) abort
  if !exists('g:spacevim_' . a:key)
    call SpaceVim#logger#warn('unsupported option: ' . a:key)
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

function! s:global_dir() abort
  if empty($SPACEVIMDIR)
    return s:FILE.unify_path('~/.SpaceVim.d/')
  else
    return s:FILE.unify_path($SPACEVIMDIR)
  endif
endfunction

function! s:write_to_config(config) abort
  let global_dir = s:global_dir()
  let g:_spacevim_global_config_path = global_dir . 'init.toml'
  let cf = global_dir . 'init.toml'
  if filereadable(cf)
    call SpaceVim#logger#warn('The file already exists:' . cf)
    return
  endif
  let dir = expand(fnamemodify(cf, ':p:h'))
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  call writefile(a:config, cf, '')
endfunction


""
" The first parameter sets the type of shortcut key,
" which can be `nnoremap` or `nmap`, the second parameter is a list of keys,
" and the third parameter is an ex command or key binding,
" depending on whether the last parameter is true.
" The fourth parameter is a short description of this custom key binding.
function! SpaceVim#custom#SPC(m, keys, cmd, desc, is_cmd) abort
  call add(g:_spacevim_mappings_space_custom,
        \ [a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction

""
" Set the group name of custom key bindings.
function! SpaceVim#custom#SPCGroupName(keys, name) abort
  call add(g:_spacevim_mappings_space_custom_group_name, [a:keys, a:name])
endfunction

""
" This function offers user a way to add custom language specific key
" bindings.
function! SpaceVim#custom#LangSPC(ft, m, keys, cmd, desc, is_cmd) abort
  if !has_key(g:_spacevim_mappings_language_specified_space_custom, a:ft)
    let g:_spacevim_mappings_language_specified_space_custom[a:ft] = []
  endif
  call add(g:_spacevim_mappings_language_specified_space_custom[a:ft],
        \ [a:m, a:keys, a:cmd, a:desc, a:is_cmd])
endfunction
""
" Set the group name of custom language specific key bindings.
function! SpaceVim#custom#LangSPCGroupName(ft, keys, name) abort
  if !has_key(g:_spacevim_mappings_lang_group_name, a:ft)
    let g:_spacevim_mappings_lang_group_name[a:ft] = []
  endif
  call add(g:_spacevim_mappings_lang_group_name[a:ft], [a:keys, a:name])
endfunction

function! s:apply(config, type) abort
  " the type can be local or global
  " local config can override global config
  if type(a:config) != type({})
    call SpaceVim#logger#info('config type is wrong!')
  else
    call SpaceVim#logger#info('start to apply config [' . a:type . ']')
    let options = get(a:config, 'options', {})
    for [name, value] in items(options)
      if name ==# 'filemanager'
        if value ==# 'defx' && !has('python3')
          call SpaceVim#logger#warn('defx requires +python3!', 0)
          continue
        endif
      endif
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
      let name = get(layer, 'name', '')
      if (type(enable) == type('') && !eval(enable))
            \ || (type(enable) != type('') && !enable)
        call SpaceVim#layers#disable(name)
      else
        call SpaceVim#layers#load(name, layer)
      endif
    endfor
    let custom_plugins = get(a:config, 'custom_plugins', [])
    for plugin in custom_plugins
      " name is an option for dein, we need to use repo instead
      " but we also need to keep backward compatible!
      " this the first argv should be get(plugin, 'repo', get(plugin, 'name',
      " ''))
      " BTW, we also need to check if the plugin has name or repo key
      if has_key(plugin, 'repo')
        call add(g:spacevim_custom_plugins, [plugin.repo, plugin])
      elseif has_key(plugin, 'name')
        call add(g:spacevim_custom_plugins, [plugin.name, plugin])
      else
        call SpaceVim#logger#warn('custom_plugins should contains repo key!')
        call SpaceVim#logger#info(string(plugin))
      endif
    endfor

    ""
    " @section bootstrap_before, options-bootstrap_before
    " @parentsection options
    " set the bootstrap_before function, this function will be called when
    " loading custom configuration file. for example:
    " >
    "   [options]
    "     bootstrap_before = 'myspacevim#before'
    " <

    let bootstrap_before = get(options, 'bootstrap_before', '')

    ""
    " @section bootstrap_after, options-bootstrap_after
    " @parentsection options
    " set the bootstrap_after function, this function will be called on
    " `VimEnter` event.
    " >
    "   [options]
    "     bootstrap_after = 'myspacevim#after'
    " <

    let g:_spacevim_bootstrap_after = get(options, 'bootstrap_after', '')
    if !empty(bootstrap_before)
      try
        call call(bootstrap_before, [])
        let g:_spacevim_bootstrap_before_success = 1
      catch
        call SpaceVim#logger#error('bootstrap_before function failed: '
              \ . bootstrap_before)
        call SpaceVim#logger#error('       exception: ' . v:exception)
        call SpaceVim#logger#error('       throwpoint: ' . v:throwpoint)
        let g:_spacevim_bootstrap_before_success = 0
      endtry
    endif
  endif
endfunction

function! SpaceVim#custom#write(force) abort
  if a:force
  endif
endfunction

function! s:path_to_fname(path) abort
  return expand(g:spacevim_data_dir.'SpaceVim/conf/')
        \ . substitute(a:path, '[\\/:;.]', '_', 'g') . '.json'
endfunction

function! SpaceVim#custom#load() abort
  call SpaceVim#logger#info('start loading global config >>>')
  call s:load_glob_conf()
  " if file .SpaceVim.d/init.toml exist
  if filereadable('.SpaceVim.d/init.toml')
    let local_dir = s:FILE.unify_path(
          \ s:CMP.resolve(fnamemodify('.SpaceVim.d/', ':p:h')))
    let g:_spacevim_config_path = local_dir . 'init.toml'
    let &rtp = local_dir . ',' . &rtp . ',' . local_dir . 'after'
    let local_conf = g:_spacevim_config_path
    call SpaceVim#logger#info('find local conf: ' . local_conf)
    let local_conf_cache = s:path_to_fname(local_conf)
    if getftime(local_conf) < getftime(local_conf_cache)
      call SpaceVim#logger#info('loading cached local conf: '
            \ . local_conf_cache)
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call s:apply(conf, 'local')
    else
      let conf = s:TOML.parse_file(local_conf)
      let dir = s:FILE.unify_path(expand(g:spacevim_data_dir
            \ . 'SpaceVim/conf/'))
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
      call SpaceVim#logger#info('generate local conf: ' . local_conf_cache)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call s:apply(conf, 'local')
    endif
  elseif filereadable('.SpaceVim.d/init.vim')
    let local_dir = s:FILE.unify_path(
          \ s:CMP.resolve(fnamemodify('.SpaceVim.d/', ':p:h')))
    let g:_spacevim_config_path = local_dir . 'init.vim'
    let &rtp = local_dir . ',' . &rtp . ',' . local_dir . 'after'
    let local_conf = g:_spacevim_config_path
    call SpaceVim#logger#info('find local conf: ' . local_conf)
  else
    call SpaceVim#logger#info('Could not find project local config')
  endif


  if g:spacevim_enable_ycm && g:spacevim_snippet_engine !=# 'ultisnips'
    call SpaceVim#logger#info(
          \ 'YCM only support ultisnips')
    let g:spacevim_snippet_engine = 'ultisnips'
  endif
endfunction


function! s:load_glob_conf() abort
  let global_dir = s:global_dir()
  call SpaceVim#logger#info('global_dir is: ' . global_dir)
  if filereadable(global_dir . 'init.toml')
    let g:_spacevim_global_config_path = global_dir . 'init.toml'
    let local_conf = global_dir . 'init.toml'
    let local_conf_cache = s:FILE.unify_path(expand(g:spacevim_data_dir
          \ . 'SpaceVim/conf/' . fnamemodify(resolve(local_conf), ':t:r')
          \ . '.json'))
    let &rtp = global_dir . ',' . &rtp . ',' . global_dir . 'after'
    if getftime(resolve(local_conf)) < getftime(resolve(local_conf_cache))
      let conf = s:JSON.json_decode(join(readfile(local_conf_cache, ''), ''))
      call s:apply(conf, 'glob')
    else
      let dir = s:FILE.unify_path(expand(g:spacevim_data_dir
            \ . 'SpaceVim/conf/'))
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
      let conf = s:TOML.parse_file(local_conf)
      call writefile([s:JSON.json_encode(conf)], local_conf_cache)
      call s:apply(conf, 'glob')
    endif
  elseif filereadable(global_dir . 'init.vim')
    let g:_spacevim_global_config_path = global_dir . 'init.vim'
    let custom_glob_conf = global_dir . 'init.vim'
    let &rtp = global_dir . ',' . &rtp . ',' . global_dir . 'after'
    exe 'source ' . custom_glob_conf
  else
    if has('timers')
      " if there is no custom config auto generate it.
      let g:spacevim_checkinstall = 0
      augroup SpaceVimBootstrap
        au!
        au VimEnter * call timer_start(2000,
              \ function('SpaceVim#custom#autoconfig'))
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
  if s:VIM.is_string(var)
    return '[string]'
  elseif s:VIM.is_bool(var)
    return '[boolean]'
  elseif s:VIM.is_number(var)
    return '[number]'
  elseif s:VIM.is_list(var)
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
          let s:complete_layer_name =
                \ eval(split(getline(layer_name_line), '=')[1])
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

" vim:set et sw=2 cc=80:
