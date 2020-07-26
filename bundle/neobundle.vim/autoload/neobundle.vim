"=============================================================================
" FILE: neobundle.vim
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

" Check 'term' option value.
if exists('g:loaded_neobundle') && &term ==# 'builtin_gui'
  echoerr 'neobundle is initialized in .gvimrc!'
        \' neobundle must be initialized in .vimrc.'
endif

if v:version < 702
  echoerr 'neobundle does not work this version of Vim (' . v:version . ').'
  finish
endif

" Global options definition." "{{{
call neobundle#util#set_default(
      \ 'g:neobundle#log_filename', '', 'g:neobundle_log_filename')
call neobundle#util#set_default(
      \ 'g:neobundle#default_site', 'github', 'g:neobundle_default_site')
call neobundle#util#set_default(
      \ 'g:neobundle#enable_name_conversion', 0)
call neobundle#util#set_default(
      \ 'g:neobundle#default_options', {})
call neobundle#util#set_default(
      \ 'g:neobundle#install_max_processes', 8,
      \ 'g:unite_source_neobundle_install_max_processes')
call neobundle#util#set_default(
      \ 'g:neobundle#install_process_timeout', 120)
"}}}

let g:neobundle#tapped = {}
let g:neobundle#hooks = {}
let s:neobundle_dir = ''
let s:neobundle_runtime_dir = neobundle#util#substitute_path_separator(
      \ fnamemodify(expand('<sfile>'), ':p:h:h'))

command! -nargs=+
      \ NeoBundle
      \ call neobundle#parser#bundle(
      \   substitute(<q-args>, '\s"[^"]\+$', '', ''))

command! -bar
      \ NeoBundleCheck
      \ call neobundle#commands#check()

command! -nargs=? -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleCheckUpdate
      \ call neobundle#commands#check_update(<q-args>)

command! -nargs=+
      \ NeoBundleLazy
      \ call neobundle#parser#lazy(
      \   substitute(<q-args>, '\s"[^"]\+$', '', ''))

command! -nargs=+
      \ NeoBundleFetch
      \ call neobundle#parser#fetch(
      \   substitute(<q-args>, '\s"[^"]\+$', '', ''))

command! -nargs=1 -complete=dir -bar
      \ NeoBundleLocal
      \ call neobundle#local(<q-args>, {})

command! -nargs=+ -bar
      \ NeoBundleDirectInstall
      \ call neobundle#parser#direct(
      \   substitute(<q-args>, '\s"[^"]\+$', '', ''))

command! -nargs=* -bar
      \ -complete=customlist,neobundle#commands#complete_lazy_bundles
      \ NeoBundleSource
      \ call neobundle#commands#source([<f-args>])

command! -nargs=+ -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleDisable
      \ call neobundle#config#disable(<f-args>)

command! -nargs=? -bang -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleInstall
      \ call neobundle#commands#install(
      \   '!' == '<bang>', <q-args>)
command! -nargs=? -bang -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleUpdate
      \ call neobundle#commands#install(
      \  ('!' == '<bang>' ? 2 : 1), <q-args>)

command! -nargs=+ -bang -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleReinstall
      \ call neobundle#commands#reinstall(<q-args>)

command! -nargs=? -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleGC
      \ call neobundle#commands#gc(<q-args>)

command! -nargs=? -bang -bar
      \ NeoBundleList
      \ call neobundle#commands#list()

command! -bar
      \ NeoBundleDocs
      \ call neobundle#commands#helptags(
      \   neobundle#config#get_enabled_bundles())

command! -bar
      \ NeoBundleLog
      \ echo join(neobundle#installer#get_log(), "\n")

command! -bar
      \ NeoBundleUpdatesLog
      \ echo join(neobundle#installer#get_updates_log(), "\n")

command! -bar
      \ NeoBundleExtraEdit
      \ execute 'edit' fnameescape(
      \   neobundle#get_neobundle_dir()).'/extra_bundles.vim'

command! -bar
      \ NeoBundleCount
      \ echo len(neobundle#config#get_neobundles())

command! -bar
      \ NeoBundleSaveCache
      \ call neobundle#commands#save_cache()
command! -bar
      \ NeoBundleLoadCache
      \ call neobundle#util#print_error(
      \ 'NeoBundleLoadCache is deprecated command.') |
      \ call neobundle#util#print_error(
      \ 'It will be removed in the next version.') |
      \ call neobundle#util#print_error(
      \ 'Please use neobundle#load_cache() instead.') |
      \ call neobundle#commands#load_cache([$MYVIMRC])
command! -bar
      \ NeoBundleClearCache
      \ call neobundle#commands#clear_cache()

command! -nargs=1 -bar
      \ -complete=customlist,neobundle#commands#complete_bundles
      \ NeoBundleRollback
      \ call neobundle#commands#rollback(<f-args>)

command! -nargs=+ -bar
      \ NeoBundleLock
      \ call neobundle#commands#lock(<f-args>)

command! -bar
      \ NeoBundleRemotePlugins
      \ call neobundle#commands#remote_plugins()

function! neobundle#rc(...) abort "{{{
  call neobundle#util#print_error(
        \ 'neobundle#rc() is removed function.')
  call neobundle#util#print_error(
        \ 'Please use neobundle#begin()/neobundle#end() instead.')
  return 1
endfunction"}}}

function! neobundle#begin(...) abort "{{{
  if a:0 > 0
    let path = a:1
  else
    " Use default path
    let paths = filter(split(globpath(&runtimepath,
          \            'bundle', 1), '\n'), 'isdirectory(v:val)')
    if empty(paths)
      let rtps = neobundle#util#split_rtp(&runtimepath)
      if empty(rtps)
        call neobundle#util#print_error(
              \ 'Invalid runtimepath is detected.')
        call neobundle#util#print_error(
              \ 'Please check your .vimrc.')
        return 1
      endif

      let paths = [rtps[0].'/bundle']
    endif

    let path = paths[0]
  endif

  return neobundle#init#_rc(path)
endfunction"}}}
function! neobundle#append() abort "{{{
  call neobundle#config#append()
endfunction"}}}
function! neobundle#end() abort "{{{
  call neobundle#config#final()
endfunction"}}}

function! neobundle#add(repository, ...) abort "{{{
  let options = get(a:000, 0, {})
  let bundle = neobundle#parser#_init_bundle(
        \ a:repository, [options])
  if empty(bundle)
    return {}
  endif

  let bundle.orig_arg = [a:repository, options]
  call neobundle#config#add(bundle)

  return bundle
endfunction"}}}
function! neobundle#add_meta(name, ...) abort "{{{
  let metadata = neobundle#metadata#get(a:name)
  if empty(metadata)
    call neobundle#util#print_error(
          \ 'Plugin name "' . a:name . '" is not found.')
    return {}
  endif

  let repository = substitute(metadata.url, '^git://', 'https://', '')
  let options = { 'name' : a:name }
  if has_key(metadata, 'addon-info')
        \ && has_key(metadata['addon-info'], 'dependencies')
    let options.depends = map(keys(metadata['addon-info'].dependencies),
          \ "substitute(neobundle#metadata#get(v:val).url,
          \   '^git://', 'https://', '')")
  endif
  call extend(options, get(a:000, 0, {}))

  return neobundle#add(repository, options)
endfunction"}}}

function! neobundle#set_neobundle_dir(path) abort "{{{
  let s:neobundle_dir = a:path
endfunction"}}}

function! neobundle#get_neobundle_dir() abort "{{{
  if s:neobundle_dir == ''
    call neobundle#util#print_error(
          \ 'neobundle directory is empty.')
    return ''
  endif

  let dir = s:neobundle_dir
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  return dir
endfunction"}}}

function! neobundle#get_runtime_dir() abort "{{{
  return s:neobundle_runtime_dir
endfunction"}}}

function! neobundle#get_tags_dir() abort "{{{
  if s:neobundle_dir == ''
    return ''
  endif

  let dir = s:neobundle_dir . '/.neobundle/doc'
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  return dir
endfunction"}}}

function! neobundle#get_rtp_dir() abort "{{{
  if s:neobundle_dir == ''
    return ''
  endif

  let dir = s:neobundle_dir . '/.neobundle'
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
  return dir
endfunction"}}}

function! neobundle#source(bundle_names) abort "{{{
  return neobundle#config#source(a:bundle_names)
endfunction"}}}

function! neobundle#local(localdir, ...) abort "{{{
  return neobundle#parser#local(
        \ a:localdir, get(a:000, 0, {}), get(a:000, 1, ['*']))
endfunction"}}}

function! neobundle#exists_not_installed_bundles() abort "{{{
  return !empty(neobundle#get_not_installed_bundles([]))
endfunction"}}}

function! neobundle#is_installed(...) abort "{{{
  return type(get(a:000, 0, [])) == type([]) ?
        \ !empty(neobundle#_get_installed_bundles(get(a:000, 0, []))) :
        \ neobundle#config#is_installed(a:1)
endfunction"}}}

function! neobundle#is_sourced(name) abort "{{{
  return neobundle#config#is_sourced(a:name)
endfunction"}}}

function! neobundle#has_cache() abort "{{{
  call neobundle#util#print_error(
        \ 'neobundle#has_cache() is deprecated function.')
  call neobundle#util#print_error(
        \ 'It will be removed in the next version.')
  call neobundle#util#print_error(
        \ 'Please use neobundle#load_cache() instead.')

  return filereadable(neobundle#commands#get_cache_file())
endfunction"}}}

function! neobundle#load_cache(...) abort "{{{
  let vimrcs = len(a:000) == 0 ? [$MYVIMRC] : a:000
  return neobundle#commands#load_cache(vimrcs)
endfunction"}}}

function! neobundle#get_not_installed_bundle_names() abort "{{{
  return map(neobundle#get_not_installed_bundles([]), 'v:val.name')
endfunction"}}}

function! neobundle#get_not_installed_bundles(bundle_names) abort "{{{
  let bundles = empty(a:bundle_names) ?
        \ neobundle#config#get_neobundles() :
        \ neobundle#config#fuzzy_search(a:bundle_names)

  call neobundle#installer#_load_install_info(bundles)

  return filter(copy(bundles), "
        \  !v:val.disabled && v:val.path != '' && !v:val.local
        \  && !isdirectory(neobundle#util#expand(v:val.path))
        \")
endfunction"}}}

function! neobundle#get_force_not_installed_bundles(bundle_names) abort "{{{
  let bundles = empty(a:bundle_names) ?
        \ neobundle#config#get_neobundles() :
        \ neobundle#config#fuzzy_search(a:bundle_names)

  call neobundle#installer#_load_install_info(bundles)

  return filter(copy(bundles), "
        \  !v:val.disabled && v:val.path != '' && !v:val.local
        \  && (!isdirectory(neobundle#util#expand(v:val.path))
        \   || v:val.install_rev !=#
        \      neobundle#installer#get_revision_number(v:val))
        \")
endfunction"}}}

function! neobundle#get(name) abort "{{{
  return neobundle#config#get(a:name)
endfunction"}}}
function! neobundle#get_hooks(name) abort "{{{
  return get(neobundle#config#get(a:name), 'hooks', {})
endfunction"}}}

function! neobundle#tap(name) abort "{{{
  let g:neobundle#tapped = neobundle#get(a:name)
  let g:neobundle#hooks = get(neobundle#get(a:name), 'hooks', {})
  return !empty(g:neobundle#tapped) && !g:neobundle#tapped.disabled
endfunction"}}}
function! neobundle#untap() abort "{{{
  let g:neobundle#tapped = {}
  let g:neobundle#hooks = {}
endfunction"}}}

function! neobundle#bundle(arg, ...) abort "{{{
  let opts = get(a:000, 0, {})
  call map(neobundle#util#convert2list(a:arg),
        \ "neobundle#config#add(neobundle#parser#_init_bundle(
        \     v:val, [deepcopy(opts)]))")
endfunction"}}}

function! neobundle#config(arg, ...) abort "{{{
  " Use neobundle#tapped or name.
  return type(a:arg) == type({}) ?
        \   neobundle#config#set(g:neobundle#tapped.name, a:arg) :
        \ type(a:arg) == type('') ?
        \   neobundle#config#set(a:arg, a:1) :
        \   map(copy(a:arg), "neobundle#config#set(v:val, deepcopy(a:1))")
endfunction"}}}

function! neobundle#call_hook(hook_name, ...) abort "{{{
  let bundles = neobundle#util#convert2list(
        \ (empty(a:000) ? neobundle#config#get_neobundles() : a:1))
  let bundles = filter(copy(bundles),
        \ 'has_key(v:val.hooks, a:hook_name)')

  if a:hook_name ==# 'on_source' || a:hook_name ==# 'on_post_source'
    let bundles = filter(neobundle#config#tsort(filter(bundles,
          \ 'neobundle#config#is_sourced(v:val.name) &&
          \  neobundle#config#is_installed(v:val.name)')),
          \ 'has_key(v:val.hooks, a:hook_name)')
  endif

  for bundle in bundles
    if type(bundle.hooks[a:hook_name]) == type('')
      execute 'source' fnameescape(bundle.hooks[a:hook_name])
    else
      call call(bundle.hooks[a:hook_name], [bundle], bundle)
    endif
  endfor
endfunction"}}}

function! neobundle#_get_installed_bundles(bundle_names) abort "{{{
  let bundles = empty(a:bundle_names) ?
        \ neobundle#config#get_neobundles() :
        \ neobundle#config#search(a:bundle_names)

  return filter(copy(bundles),
        \ 'neobundle#config#is_installed(v:val.name)')
endfunction"}}}

function! neobundle#load_toml(filename, ...) abort "{{{
  let opts = get(a:000, 0, {})
  return neobundle#parser#load_toml(a:filename, opts)
endfunction"}}}

let s:init_vim_path = fnamemodify(expand('<sfile>'), ':h')
      \ . '/neobundle/init.vim'
function! neobundle#get_cache_version() abort "{{{
  return getftime(s:init_vim_path)
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
