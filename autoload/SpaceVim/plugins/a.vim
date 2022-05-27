"=============================================================================
" a.vim --- plugin for manager alternate file
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8


if $SPACEVIM_LUA && has('nvim-0.5.0')
  function! SpaceVim#plugins#a#alt(request_parse, ...) abort
    lua require("spacevim.plugin.a").alt(
          \ require("spacevim").eval("a:request_parse"),
          \ require("spacevim").eval("a:000")
          \ )
  endfunction
  function! SpaceVim#plugins#a#set_config_name(path, name) abort
    lua require("spacevim.plugin.a").set_config_name(
          \ require("spacevim").eval("a:path"),
          \ require("spacevim").eval("a:name")
          \ )
  endfunction
  function! SpaceVim#plugins#a#getConfigPath() abort
    return luaeval('require("spacevim.plugin.a").getConfigPath()')
  endfunction
  function! SpaceVim#plugins#a#complete(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("spacevim.plugin.a").complete('
          \ .'require("spacevim").eval("a:ArgLead"),'
          \ .'require("spacevim").eval("a:CmdLine"),'
          \ .'require("spacevim").eval("a:CursorPos"))')
  endfunction
  function! SpaceVim#plugins#a#get_alt(file, conf_path, request_parse,...) abort
    let type = get(a:000, 0, 'alternate')
    return luaeval('require("spacevim.plugin.a").get_alt('
          \ . 'require("spacevim").eval("a:file"),'
          \ . 'require("spacevim").eval("a:conf_path"),'
          \ . 'require("spacevim").eval("a:request_parse"),'
          \ . 'require("spacevim").eval("type"))')
  endfunction
else
  " Load SpaceVim API

  let s:CMP = SpaceVim#api#import('vim#compatible')
  let s:JSON = SpaceVim#api#import('data#json')
  let s:FILE = SpaceVim#api#import('file')
  let s:LOGGER =SpaceVim#logger#derive('a.vim')


  " local value
  "
  " s:alternate_conf define which file should be loaded as alternate
  " file configuration for current project, This is a directory
  let s:alternate_conf = {
        \ '_' : '.project_alt.json'
        \ }
  let s:cache_path = s:FILE.unify_path(g:spacevim_data_dir, ':p') . 'SpaceVim/a.json'


  " this is for saving the project configuration information. Use the path of
  " the project_alt.json file as the key.
  let s:project_config = {}


  " saving cache

  function! s:cache() abort
    call writefile([s:JSON.json_encode(s:project_config)], s:FILE.unify_path(s:cache_path, ':p'))
  endfunction

  function! s:load_cache() abort
    call s:LOGGER.info('Try to load alt cache from: ' . s:cache_path)
    let cache_context = join(readfile(s:cache_path, ''), '')
    if !empty(cache_context)
      let s:project_config = s:JSON.json_decode(cache_context)
    endif
  endfunction

  " when this function is called, the project_config file name is changed, and
  " the project_config info is cleared.
  function! s:get_project_config(conf_file) abort
    call s:LOGGER.info('read context from: '. a:conf_file)
    let context = join(readfile(a:conf_file), "\n")
    let conf = s:JSON.json_decode(context)
    if type(conf) !=# type({})
      " in Old vim we get E706
      " Variable type mismatch for conf, so we need to unlet conf first
      " ref: patch-7.4.1546
      " https://github.com/vim/vim/commit/f6f32c38bf3319144a84a01a154c8c91939e7acf
      unlet conf
      let conf = {}
    endif
    let root = s:FILE.unify_path(a:conf_file, ':p:h')
    return {
          \ 'root' : root,
          \ 'config' : conf
          \ }
  endfunction

  function! SpaceVim#plugins#a#alt(request_parse,...) abort
    let type = get(a:000, 0, 'alternate')
    if !exists('b:alternate_file_config')
      let conf_file_path = SpaceVim#plugins#a#getConfigPath()
      let file = s:FILE.unify_path(bufname('%'), ':.')
      let alt = SpaceVim#plugins#a#get_alt(file, conf_file_path, a:request_parse, type)
      if !empty(alt)
        exe 'e ' . alt
      else
        echo 'failed to find alternate file!'
      endif
    endif
  endfunction
  function! SpaceVim#plugins#a#set_config_name(path, name) abort
    let s:alternate_conf[a:path] = a:name
  endfunction
  function! SpaceVim#plugins#a#getConfigPath() abort
    return s:FILE.unify_path(get(s:alternate_conf, getcwd(), s:alternate_conf['_']), ':p')
  endfunction


  " @vimlint(EVL103, 1, a:ArgLead)
  " @vimlint(EVL103, 1, a:CmdLine)
  " @vimlint(EVL103, 1, a:CursorPos)
  function! SpaceVim#plugins#a#complete(ArgLead, CmdLine, CursorPos) abort
    let file = s:FILE.unify_path(bufname('%'), ':.')
    let conf_file_path = SpaceVim#plugins#a#getConfigPath()
    let alt_config_json = s:get_project_config(conf_file_path)

    call SpaceVim#plugins#a#get_alt(file, conf_file_path, 0)
    try
      let a = s:project_config[alt_config_json.root][file]
    catch
      let a = {}
    endtry
    return join(keys(a), "\n")
  endfunction
  function! SpaceVim#plugins#a#get_alt(file, conf_path, request_parse,...) abort
    call s:LOGGER.info('getting alt file for:' . a:file)
    call s:LOGGER.info('  >   type: ' . get(a:000, 0, 'alternate'))
    call s:LOGGER.info('  >  parse: ' . a:request_parse)
    call s:LOGGER.info('  > config: ' . a:conf_path)
    " @question when should the cache be loaded?
    " if the local value s:project_config do not has the key a:conf_path
    " and the file a:conf_path has not been updated since last cache
    " and no request_parse specified
    let alt_config_json = s:get_project_config(a:conf_path)
    if !has_key(s:project_config, alt_config_json.root)
          \ && !s:is_config_changed(a:conf_path)
          \ && !a:request_parse
      " config file has been cached since last update.
      " so no need to parse the config for current config file
      " just load the cache
      call s:load_cache()
      if !has_key(s:project_config, alt_config_json.root)
            \ || !has_key(s:project_config[alt_config_json.root], a:file)
        call s:parse(alt_config_json)
      endif
    else
      call s:parse(alt_config_json)
    endif
    " try
    " This will throw error in vim7.4.629 and 7.4.052
    " @quection why can not catch the errors?
    " return s:project_config[alt_config_json.root][a:file][get(a:000, 0, 'alternate')]
    " catch
    " return ''
    " endtry
    if has_key(s:project_config, alt_config_json.root)
          \ && has_key(s:project_config[alt_config_json.root], a:file)
          \ && has_key(s:project_config[alt_config_json.root][a:file], get(a:000, 0, 'alternate'))
      return s:project_config[alt_config_json.root][a:file][get(a:000, 0, 'alternate')]
    else
      return ''
    endif
  endfunction


  " the parse function should only accept one argv
  " the alt_config_json
  "
  " @todo Rewrite alternate file parse
  " parse function is written in vim script, and it is too slow,
  " we are going to rewrite this function in other language.
  " asynchronous parse should be supported.
  function! s:parse(alt_config_json) abort
    call s:LOGGER.info('Start to parse alternate files for: ' . a:alt_config_json.root)
    let s:project_config[a:alt_config_json.root] = {}
    " @question why need sory()
    " if we have two key docs/*.md and docs/cn/*.md
    " with the first key, we can also find files in
    " docs/cn/ directory, for example docs/cn/index.md
    " and the alt file will be
    " docs/cn/cn/index.md. this should be overrided by login in
    " docs/cn/*.md
    "
    " so we need to use sort, and make sure `docs/cn/*.md` is parsed after
    " docs/*.md
    for key in sort(keys(a:alt_config_json.config))
      call s:LOGGER.debug('start parse key:' . key)
      let searchpath = key
      if match(searchpath, '/\*')
        let searchpath = substitute(searchpath, '*', '**/*', 'g')
      endif
      call s:LOGGER.debug('run globpath for: '. searchpath)
      for file in s:CMP.globpath('.', searchpath)
        let file = s:FILE.unify_path(file, ':.')
        let s:project_config[a:alt_config_json.root][file] = {}
        if has_key(a:alt_config_json.config, file)
          for type in keys(a:alt_config_json.config[file])
            let s:project_config[a:alt_config_json.root][file][type] = a:alt_config_json.config[file][type]
          endfor
        else
          for type in keys(a:alt_config_json.config[key])
            let left_index = stridx(key, '*')
            if left_index != -1 && left_index == strridx(key, '*')
              let s:project_config[a:alt_config_json.root][file][type] =
                    \ s:get_type_path(
                    \ key,
                    \ file,
                    \ a:alt_config_json.config[key][type]
                    \ )
            endif
          endfor
        endif
      endfor
    endfor
    call s:LOGGER.info('Paser done, try to cache alternate info')
    call s:cache()
  endfunction

  function! s:get_type_path(a, f, b) abort
    let begin_len = stridx(a:a, '*')
    let end_len = strlen(a:a) - begin_len - 1
    return substitute(a:b, '{}', a:f[begin_len : (end_len+1) * -1], 'g')
  endfunction

  function! s:is_config_changed(conf_path) abort
    if getftime(a:conf_path) > getftime(s:cache_path)
      call s:LOGGER.info('alt config file ('
            \ . a:conf_path
            \ . ') has been changed, parse required!')
      return 1
    endif
  endfunction


  " @vimlint(EVL103, 1, a:file)
  function! s:get_alternate(file) abort

  endfunction
  " @vimlint(EVL103, 0, a:file)


  " @vimlint(EVL103, 0, a:ArgLead)
  " @vimlint(EVL103, 0, a:CmdLine)
  " @vimlint(EVL103, 0, a:CursorPos)

endif
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
