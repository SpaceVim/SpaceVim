"=============================================================================
" FILE: config.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

if !exists('s:neobundles')
  let s:within_block = 0
  let s:lazy_rtp_bundles = []
  let s:neobundles = {}
  let neobundle#tapped = {}
endif

function! neobundle#config#init() abort "{{{
  if neobundle#config#within_block()
    call neobundle#util#print_error(
          \ 'neobundle#begin()/neobundle#end() usage is invalid.')
    call neobundle#util#print_error(
          \ 'Please check your .vimrc.')
    return
  endif

  augroup neobundle
    autocmd VimEnter * call s:on_vim_enter()
  augroup END

  call s:filetype_off()

  let s:within_block = 1
  let s:lazy_rtp_bundles = []

  " Load extra bundles configuration.
  call neobundle#config#load_extra_bundles()
endfunction"}}}
function! neobundle#config#append() abort "{{{
  if neobundle#config#within_block()
    call neobundle#util#print_error(
          \ 'neobundle#begin()/neobundle#end() usage is invalid.')
    call neobundle#util#print_error(
          \ 'Please check your .vimrc.')
    return
  endif

  if neobundle#get_rtp_dir() == ''
    call neobundle#util#print_error(
          \ 'You must call neobundle#begin() before.')
    call neobundle#util#print_error(
          \ 'Please check your .vimrc.')
    return
  endif

  call s:filetype_off()

  let s:within_block = 1
  let s:lazy_rtp_bundles = []
endfunction"}}}
function! neobundle#config#final() abort "{{{
  if !neobundle#config#within_block()
    call neobundle#util#print_error(
          \ 'neobundle#begin()/neobundle#end() usage is invalid.')
    call neobundle#util#print_error(
          \ 'Please check your .vimrc.')
    return
  endif

  " Join to the tail in runtimepath.
  let rtps = neobundle#util#split_rtp(&runtimepath)
  let index = index(rtps, neobundle#get_rtp_dir())
  if index < 0
    call neobundle#util#print_error(
          \ 'Invalid runtimepath is detected.')
    call neobundle#util#print_error(
          \ 'Please check your .vimrc.')
    return
  endif
  for bundle in filter(s:lazy_rtp_bundles,
        \ 'isdirectory(v:val.rtp) && !v:val.disabled')
    let bundle.sourced = 1
    call insert(rtps, bundle.rtp, index)
    let index += 1

    if isdirectory(bundle.rtp.'/after')
      call add(rtps, s:get_rtp_after(bundle))
    endif
  endfor
  let &runtimepath = neobundle#util#join_rtp(rtps, &runtimepath, '')

  call neobundle#call_hook('on_source', s:lazy_rtp_bundles)

  let s:within_block = 0
  let s:lazy_rtp_bundles = []
endfunction"}}}
function! neobundle#config#within_block() abort "{{{
  return s:within_block
endfunction"}}}

function! neobundle#config#get(name) abort "{{{
  return get(s:neobundles, a:name, {})
endfunction"}}}

function! neobundle#config#get_neobundles() abort "{{{
  return values(s:neobundles)
endfunction"}}}

function! neobundle#config#get_enabled_bundles() abort "{{{
  return filter(values(s:neobundles),
        \ "!v:val.disabled")
endfunction"}}}

function! neobundle#config#get_autoload_bundles() abort "{{{
  return filter(values(s:neobundles),
        \ "!v:val.sourced && v:val.lazy && !v:val.disabled")
endfunction"}}}

function! neobundle#config#source_bundles(bundles) abort "{{{
  if !empty(a:bundles)
    call neobundle#config#source(map(copy(a:bundles),
          \ "type(v:val) == type({}) ? v:val.name : v:val"))
  endif
endfunction"}}}

function! neobundle#config#check_not_exists(names, ...) abort "{{{
  " For infinite loop.
  let self = get(a:000, 0, [])

  let _ = map(neobundle#get_not_installed_bundles(a:names), 'v:val.name')
  for bundle in map(filter(copy(a:names),
        \ 'index(self, v:val) < 0 && has_key(s:neobundles, v:val)'),
        \ 's:neobundles[v:val]')
    call add(self, bundle.name)

    if !empty(bundle.depends)
      let _ += neobundle#config#check_not_exists(
            \ map(copy(bundle.depends), 'v:val.name'), self)
    endif
  endfor

  if len(_) > 1
    let _ = neobundle#util#uniq(_)
  endif

  return _
endfunction"}}}

function! neobundle#config#source(names, ...) abort "{{{
  let is_force = get(a:000, 0, 1)

  let bundles = neobundle#config#search(
        \ neobundle#util#convert2list(a:names))

  let bundles = filter(bundles, "!v:val.disabled && !v:val.sourced")
  if empty(bundles)
    return
  endif

  let filetype_before = neobundle#util#redir("autocmd FileType")

  let reset_ftplugin = 0
  for bundle in bundles
    let bundle.sourced = 1
    let bundle.disabled = 0

    if !empty(bundle.dummy_commands)
      for command in bundle.dummy_commands
        silent! execute 'delcommand' command
      endfor
      let bundle.dummy_commands = []
    endif

    if !empty(bundle.dummy_mappings)
      for [mode, mapping] in bundle.dummy_mappings
        silent! execute mode.'unmap' mapping
      endfor
      let bundle.dummy_mappings = []
    endif

    call neobundle#config#rtp_add(bundle)

    if exists('g:loaded_neobundle') || is_force
      try
        call s:on_source(bundle)
      catch
        call neobundle#util#print_error(
              \ 'Uncaught error while sourcing "' . bundle.name .
              \ '": '.v:exception . ' in ' . v:throwpoint)
      endtry
    endif

    call neobundle#autoload#_source(bundle.name)

    if !reset_ftplugin
      let reset_ftplugin = s:is_reset_ftplugin(&filetype, bundle.rtp)
    endif
  endfor

  let filetype_after = neobundle#util#redir('autocmd FileType')

  if reset_ftplugin && &filetype != ''
    if &verbose
      call neobundle#util#print_error(
            \ "Neobundle: resetting ftplugin, after loading bundles:"
            \ .join(map(copy(bundles), 'v:val.name'), ", "))
    endif
    call s:reset_ftplugin()
  elseif filetype_before !=# filetype_after
    if &verbose
      call neobundle#util#print_error(
            \ "Neobundle: FileType autocommand triggered by:"
            \ .join(map(copy(bundles), 'v:val.name'), ", "))
    endif
    execute 'doautocmd FileType' &filetype
  endif

  if exists('g:loaded_neobundle')
    call neobundle#call_hook('on_post_source', bundles)
  endif
endfunction"}}}

function! neobundle#config#disable(...) abort "{{{
  let bundle_names = neobundle#config#search(a:000)
  if empty(bundle_names)
    call neobundle#util#print_error(
          \ 'Disabled bundles ' . string(a:000) . ' are not found.')
    return
  endif

  for bundle in bundle_names
    call neobundle#config#rtp_rm(bundle)
    let bundle.refcnt -= 1

    if bundle.refcnt <= 0
      if bundle.sourced
        call neobundle#util#print_error(
              \ bundle.name . ' is already sourced.  Cannot be disabled.')
        continue
      endif

      let bundle.disabled = 1
    endif
  endfor
endfunction"}}}

function! neobundle#config#is_disabled(name) abort "{{{
  return get(neobundle#config#get(a:name), 'disabled', 1)
endfunction"}}}

function! neobundle#config#is_sourced(name) abort "{{{
  return get(neobundle#config#get(a:name), 'sourced', 0)
endfunction"}}}

function! neobundle#config#is_installed(name) abort "{{{
  return isdirectory(get(neobundle#config#get(a:name), 'path', ''))
endfunction"}}}

function! neobundle#config#rm(bundle) abort "{{{
  call neobundle#config#rtp_rm(a:bundle)
  call remove(s:neobundles, a:bundle.name)
endfunction"}}}
function! neobundle#config#rmdir(path) abort "{{{
  for bundle in filter(neobundle#config#get_neobundles(),
        \ 'v:val.path ==# a:path')
    call neobundle#config#rm(bundle)
  endfor
endfunction"}}}

function! neobundle#config#get_types(...) abort "{{{
  let type = get(a:000, 0, '')

  if type ==# 'git'
    if !exists('s:neobundle_type_git')
      let s:neobundle_type_git = neobundle#types#git#define()
    endif

    return s:neobundle_type_git
  endif

  if !exists('s:neobundle_types')
    " Load neobundle types.
    let s:neobundle_types = []
    for list in map(split(globpath(&runtimepath,
          \ 'autoload/neobundle/types/*.vim', 1), '\n'),
          \ "neobundle#util#convert2list(
          \    neobundle#types#{fnamemodify(v:val, ':t:r')}#define())")
      let s:neobundle_types += list
    endfor

    let s:neobundle_types = neobundle#util#uniq(
          \ s:neobundle_types, 'v:val.name')
  endif

  return (type == '') ? s:neobundle_types :
        \ get(filter(copy(s:neobundle_types), 'v:val.name ==# type'), 0, {})
endfunction"}}}

function! neobundle#config#rtp_rm_all_bundles() abort "{{{
  call filter(values(s:neobundles), 'neobundle#config#rtp_rm(v:val)')
endfunction"}}}

function! neobundle#config#rtp_rm(bundle) abort "{{{
  execute 'set rtp-='.fnameescape(a:bundle.rtp)
  if isdirectory(a:bundle.rtp.'/after')
    execute 'set rtp-='.s:get_rtp_after(a:bundle)
  endif

  " Remove from lazy runtimepath
  call filter(s:lazy_rtp_bundles, "v:val.name !=# a:bundle.name")
endfunction"}}}

function! neobundle#config#rtp_add(bundle) abort "{{{
  if has_key(s:neobundles, a:bundle.name)
    call neobundle#config#rtp_rm(s:neobundles[a:bundle.name])
  endif

  if s:within_block && !a:bundle.force
    " Add rtp lazily.
    call add(s:lazy_rtp_bundles, a:bundle)
    return
  endif

  let rtp = a:bundle.rtp
  if isdirectory(rtp)
    " Join to the tail in runtimepath.
    let rtps = neobundle#util#split_rtp(&runtimepath)
    let &runtimepath = neobundle#util#join_rtp(
          \ insert(rtps, rtp, index(rtps, neobundle#get_rtp_dir())),
          \ &runtimepath, rtp)
  endif
  if isdirectory(rtp.'/after')
    execute 'set rtp+='.s:get_rtp_after(a:bundle)
  endif
  let a:bundle.sourced = 1

  call neobundle#call_hook('on_source', a:bundle)
endfunction"}}}

function! neobundle#config#search(bundle_names, ...) abort "{{{
  " For infinite loop.
  let self = get(a:000, 0, [])

  let bundle_names = filter(copy(a:bundle_names), 'index(self, v:val) < 0')
  if empty(bundle_names)
    return []
  endif

  let _ = []
  let bundles = len(bundle_names) != 1 ?
        \ filter(neobundle#config#get_neobundles(),
        \ 'index(a:bundle_names, v:val.name) >= 0') :
        \ has_key(s:neobundles, bundle_names[0]) ?
        \     [s:neobundles[bundle_names[0]]] : []
  for bundle in bundles
    call add(self, bundle.name)

    if !empty(bundle.depends)
      let _ += neobundle#config#search(
            \ map(copy(bundle.depends), 'v:val.name'), self)
    endif
    call add(_, bundle)
  endfor

  if len(_) > 1
    let _ = neobundle#util#uniq(_)
  endif

  return _
endfunction"}}}

function! neobundle#config#search_simple(bundle_names) abort "{{{
  return filter(neobundle#config#get_neobundles(),
        \ 'index(a:bundle_names, v:val.name) >= 0')
endfunction"}}}

function! neobundle#config#fuzzy_search(bundle_names) abort "{{{
  let bundles = []
  for name in a:bundle_names
    let bundles += filter(neobundle#config#get_neobundles(),
          \ 'stridx(v:val.name, name) >= 0')
  endfor

  let _ = []
  for bundle in bundles
    if !empty(bundle.depends)
      let _ += neobundle#config#search(
            \ map(copy(bundle.depends), 'v:val.name'))
    endif
    call add(_, bundle)
  endfor

  if len(_) > 1
    let _ = neobundle#util#uniq(_)
  endif

  return _
endfunction"}}}

function! neobundle#config#load_extra_bundles() abort "{{{
  let path = neobundle#get_neobundle_dir() . '/extra_bundles.vim'

  if filereadable(path)
    execute 'source' fnameescape(path)
  endif
endfunction"}}}

function! neobundle#config#save_direct(arg) abort "{{{
  if neobundle#util#is_sudo()
    call neobundle#util#print_error(
          \ '"sudo vim" is detected. This feature is disabled.')
    return
  endif

  let path = neobundle#get_neobundle_dir() . '/extra_bundles.vim'
  let bundles = filereadable(path) ? readfile(path) : []
  call writefile(add(bundles, 'NeoBundle ' . a:arg), path)
endfunction"}}}

function! neobundle#config#set(name, dict) abort "{{{
  let bundle = neobundle#config#get(a:name)
  if empty(bundle)
    call neobundle#util#print_error(
          \ 'Plugin name "' . a:name . '" is not defined.')
    return
  endif
  if bundle.sourced
    return
  endif
  if !neobundle#config#within_block()
    call neobundle#util#print_error(
          \ 'You must call neobundle#config() '
          \ .'within neobundle#begin()/neobundle#end() block.')
    return
  endif

  call neobundle#config#add(
        \ neobundle#init#_bundle(extend(bundle, a:dict)))
endfunction"}}}

function! neobundle#config#add(bundle) abort "{{{
  if empty(a:bundle)
    return
  endif

  let bundle = a:bundle

  let prev_bundle = get(s:neobundles, bundle.name, {})
  if !empty(prev_bundle) && prev_bundle.lazy != bundle.lazy
    let bundle.lazy = 0
  endif

  if !empty(bundle.depends)
    call s:add_depends(bundle)
  endif

  if !empty(prev_bundle)
    if prev_bundle.sourced
      return
    endif

    call neobundle#config#rtp_rm(prev_bundle)
  endif
  let s:neobundles[bundle.name] = bundle

  if bundle.disabled
    " Ignore load.
    return
  endif

  if !bundle.lazy && bundle.rtp != ''
    if !has('vim_starting')
      " Load automatically.
      call neobundle#config#source(bundle.name, bundle.force)
    else
      call neobundle#config#rtp_add(bundle)

      if bundle.force
        execute 'runtime!' bundle.rtp . '/plugin/**/*.vim'
      endif
    endif
  elseif bundle.lazy && !bundle.sourced
    if !empty(bundle.on_cmd)
      call s:add_dummy_commands(bundle)
    endif

    if !empty(bundle.on_map)
      call s:add_dummy_mappings(bundle)
    endif
  endif
endfunction"}}}

function! neobundle#config#tsort(bundles) abort "{{{
  let sorted = []
  let mark = {}
  for target in a:bundles
    call s:tsort_impl(target, a:bundles, mark, sorted)
  endfor

  return sorted
endfunction"}}}

function! neobundle#config#get_lazy_rtp_bundles() abort "{{{
  return s:lazy_rtp_bundles
endfunction"}}}

function! neobundle#config#check_commands(commands) abort "{{{
  " Environment check.
  if type(a:commands) == type([])
        \ || type(a:commands) == type('')
    let commands = a:commands
  elseif neobundle#util#is_windows() && has_key(a:commands, 'windows')
    let commands = a:commands.windows
  elseif neobundle#util#is_mac() && has_key(a:commands, 'mac')
    let commands = a:commands.mac
  elseif neobundle#util#is_cygwin() && has_key(a:commands, 'cygwin')
    let commands = a:commands.cygwin
  elseif !neobundle#util#is_windows() && has_key(a:commands, 'unix')
    let commands = a:commands.unix
  elseif has_key(a:commands, 'others')
    let commands = a:commands.others
  else
    " Invalid.
    return 0
  endif

  for command in neobundle#util#convert2list(commands)
    if !executable(command)
      return 1
    endif
  endfor
endfunction"}}}

function! s:tsort_impl(target, bundles, mark, sorted) abort "{{{
  if has_key(a:mark, a:target.name)
    return
  endif

  let a:mark[a:target.name] = 1
  for depend in get(a:target, 'depends', [])
    call s:tsort_impl(get(s:neobundles, depend.name, depend),
          \ a:bundles, a:mark, a:sorted)
  endfor

  call add(a:sorted, a:target)
endfunction"}}}

function! s:on_vim_enter() abort "{{{
  if !empty(s:lazy_rtp_bundles)
    call neobundle#util#print_error(
          \ 'neobundle#begin() was called without calling ' .
          \ 'neobundle#end() in .vimrc.')
    " We're past the point of plugins being sourced, so don't bother
    " trying to recover.
    return
  endif

  call neobundle#call_hook('on_post_source')
endfunction"}}}

function! s:add_depends(bundle) abort "{{{
  " Add depends.
  for depend in a:bundle.depends
    let depend.lazy = a:bundle.lazy

    if !has_key(s:neobundles, depend.name)
      call neobundle#config#add(depend)
    else
      let depend_bundle = s:neobundles[depend.name]
      " Add reference count
      let depend_bundle.refcnt += 1

      if (a:bundle.sourced && !depend_bundle.sourced) || !a:bundle.lazy
        " Load automatically.
        call neobundle#config#source(depend.name, depend.force)
      endif
    endif
  endfor
endfunction"}}}

function! s:add_dummy_commands(bundle) abort "{{{
  let a:bundle.dummy_commands = []
  for command in map(copy(a:bundle.on_cmd), "
        \ type(v:val) == type('') ?
          \ { 'name' : v:val } : v:val
          \")

    for name in neobundle#util#convert2list(command.name)
      " Define dummy commands.
      silent! execute 'command '
            \ . '-complete=customlist,neobundle#autoload#_command_dummy_complete'
            \ . ' -bang -bar -range -nargs=*' name printf(
            \ "call neobundle#autoload#_command(%s, %s, <q-args>,
            \  expand('<bang>'), expand('<line1>'), expand('<line2>'))",
            \   string(name), string(a:bundle.name))

      call add(a:bundle.dummy_commands, name)
    endfor
  endfor
endfunction"}}}
function! s:add_dummy_mappings(bundle) abort "{{{
  let a:bundle.dummy_mappings = []
  for [modes, mappings] in map(copy(a:bundle.on_map), "
        \   type(v:val) == type([]) ?
        \     [v:val[0], v:val[1:]] : ['nxo', [v:val]]
        \ ")
    if mappings ==# ['<Plug>']
      " Use plugin name.
      let mappings = ['<Plug>(' . a:bundle.normalized_name]
      if stridx(a:bundle.normalized_name, '-') >= 0
        " The plugin mappings may use "_" instead of "-".
        call add(mappings, '<Plug>(' .
              \ substitute(a:bundle.normalized_name, '-', '_', 'g'))
      endif
    endif

    for mapping in mappings
      " Define dummy mappings.
      for mode in filter(split(modes, '\zs'),
            \ "index(['n', 'v', 'x', 'o', 'i', 'c'], v:val) >= 0")
        let mapping_str = substitute(mapping, '<', '<lt>', 'g')
        silent! execute mode.'noremap <unique><silent>' mapping printf(
              \ (mode ==# 'c' ? "\<C-r>=" :
              \  (mode ==# 'i' ? "\<C-o>:" : ":\<C-u>")."call ").
              \   "neobundle#autoload#_mapping(%s, %s, %s)<CR>",
              \   string(mapping_str), string(a:bundle.name), string(mode))

        call add(a:bundle.dummy_mappings, [mode, mapping])
      endfor
    endfor
  endfor
endfunction"}}}

function! s:on_source(bundle) abort "{{{
  if a:bundle.verbose && a:bundle.lazy
    redraw
    echo 'source:' a:bundle.name
  endif

  " Reload script files.
  for directory in filter(['plugin', 'after/plugin'],
        \ "isdirectory(a:bundle.rtp.'/'.v:val)")
    for file in split(glob(a:bundle.rtp.'/'.directory.'/**/*.vim'), '\n')
      " Note: "silent!" is required to ignore E122, E174 and E227.
      "       try/catching them aborts sourcing of the file.
      "       "unsilent" then displays any messages while sourcing.
      execute 'silent! unsilent source' fnameescape(file)
    endfor
  endfor

  if !has('vim_starting')
    if exists('#'.a:bundle.augroup.'#VimEnter')
      execute 'doautocmd' a:bundle.augroup 'VimEnter'
    endif

    if has('gui_running') && &term ==# 'builtin_gui'
          \ && exists('#'.a:bundle.augroup.'#GUIEnter')
      execute 'doautocmd' a:bundle.augroup 'GUIEnter'
    endif
  endif

  if a:bundle.verbose && a:bundle.lazy
    redraw
    echo 'sourced:' a:bundle.name
  endif
endfunction"}}}

function! s:clear_dummy(bundle) abort "{{{
endfunction"}}}

function! s:is_reset_ftplugin(filetype, rtp) abort "{{{
  for filetype in split(a:filetype, '\.')
    for directory in ['ftplugin', 'indent',
          \ 'after/ftplugin', 'after/indent']
      let base = a:rtp . '/' . directory
      if filereadable(base.'/'.filetype.'.vim') ||
            \ (directory =~# 'ftplugin$' &&
            \   isdirectory(base . '/' . filetype) ||
            \   glob(base.'/'.filetype.'_*.vim') != '')
        return 1
      endif
    endfor
  endfor

  return 0
endfunction"}}}

function! s:reset_ftplugin() abort "{{{
  let filetype_out = s:filetype_off()

  if filetype_out =~# 'detection:ON'
        \ && filetype_out =~# 'plugin:ON'
        \ && filetype_out =~# 'indent:ON'
    silent! filetype plugin indent on
  else
    if filetype_out =~# 'detection:ON'
      silent! filetype on
    endif

    if filetype_out =~# 'plugin:ON'
      silent! filetype plugin on
    endif

    if filetype_out =~# 'indent:ON'
      silent! filetype indent on
    endif
  endif

  if filetype_out =~# 'detection:ON'
    filetype detect
  endif

  " Reload filetype plugins.
  let &l:filetype = &l:filetype

  " Recall FileType autocmd
  execute 'doautocmd FileType' &filetype
endfunction"}}}

function! s:filetype_off() abort "{{{
  let filetype_out = neobundle#util#redir('filetype')

  if filetype_out =~# 'plugin:ON'
        \ || filetype_out =~# 'indent:ON'
    filetype plugin indent off
  endif

  if filetype_out =~# 'detection:ON'
    filetype off
  endif

  return filetype_out
endfunction"}}}

function! s:get_rtp_after(bundle) abort "{{{
  return substitute(
          \ fnameescape(a:bundle.rtp . '/after'), '//', '/', 'g')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
