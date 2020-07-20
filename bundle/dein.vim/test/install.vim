" set verbose=1

let s:suite = themis#suite('install')
let s:assert = themis#helper('assert')

let s:path = fnamemodify('.cache', ':p')
if s:path !~ '/$'
  let s:path .= '/'
endif
let s:runtimepath_save = &runtimepath
let s:filetype_save = &l:filetype

let s:this_script = fnamemodify(expand('<sfile>'), ':p')


let s:merged_format = "{'repo': v:val.repo, 'rev': get(v:val, 'rev', '')}"

function! s:dein_install() abort
  call dein#util#_save_merged_plugins()
  return dein#install#_update([], 'install', 0)
endfunction

function! s:dein_update() abort
  return dein#install#_update([], 'update', 0)
endfunction

function! s:dein_check_update() abort
  return dein#install#_update([], 'check_update', 0)
endfunction

function! s:suite.before_each() abort
  call dein#_init()
  let &runtimepath = s:runtimepath_save
  let &l:filetype = s:filetype_save
  let g:temp = tempname()
  let g:dein#install_progress_type = 'echo'
  let g:dein#enable_notification = 0
endfunction

function! s:suite.install() abort
  let g:dein#install_progress_type = 'title'
  let g:dein#enable_notification = 1

  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/deol.nvim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neopairs.vim')
  call dein#add('Shougo/defx.nvim')
  call dein#add('Shougo/denite.nvim')

  call dein#end()

  call s:assert.equals(s:dein_install(), 0)

  let plugin = dein#get('deoplete.nvim')
  call s:assert.true(isdirectory(plugin.rtp))
  call s:assert.equals(dein#each('git gc'), 0)

  call s:assert.equals(dein#util#_get_merged_plugins(),
        \ dein#util#_load_merged_plugins())
endfunction

function! s:suite.tap() abort
  call dein#begin(s:path)
  call s:assert.equals(dein#tap('deoplete.nvim'), 0)
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/denite.nvim', {'if': 0})
  call s:assert.equals(s:dein_install(), 0)
  call s:assert.equals(dein#tap('deoplete.nvim'), 1)
  call s:assert.equals(dein#tap('denite.nvim'), 0)
  call dein#end()
endfunction

function! s:suite.reinstall() abort
  let g:dein#install_progress_type = 'none'

  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim')

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  call s:assert.equals(dein#reinstall('deoplete.nvim'), 0)
endfunction

function! s:suite.direct_install() abort
  let g:dein#install_progress_type = 'none'
  call dein#begin(s:path)
  call dein#end()

  call s:assert.equals(dein#direct_install('Shougo/deoplete.nvim'), 0)
  call s:assert.equals(dein#get('deoplete.nvim').sourced, 1)
endfunction

function! s:suite.update() abort
  let g:dein#install_progress_type = 'echo'

  call dein#begin(s:path)

  call dein#add('Shougo/neopairs.vim', {'frozen': 1})

  call s:assert.equals(s:dein_update(), 0)

  let plugin = dein#get('neopairs.vim')
  let plugin2 = dein#get('neobundle.vim')

  call s:assert.equals(plugin.rtp,
        \ s:path.'repos/github.com/Shougo/neopairs.vim')

  call s:assert.true(isdirectory(plugin.rtp))

  call dein#end()
endfunction

function! s:suite.check_install() abort
  let g:dein#install_progress_type = 'tabline'

  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim')

  call s:assert.equals(s:dein_install(), 0)

  call s:assert.false(dein#check_install())
  call s:assert.equals(dein#check_install(['hoge']), -1)

  call dein#end()
endfunction

function! s:suite.fetch() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', { 'rtp': '' })

  call s:assert.equals(s:dein_install(), 0)

  let plugin = dein#get('deoplete.nvim')

  call s:assert.equals(plugin.rtp, '')

  call dein#end()

  call s:assert.equals(plugin.sourced, 0)
endfunction

function! s:suite.reload() abort
  " 1st load
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim')

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  " 2nd load
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim')

  call dein#end()

  let plugin = dein#get('deoplete.nvim')
endfunction

function! s:suite.if() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', {'if': 0, 'on_cmd': 'FooBar'})

  call s:assert.equals(dein#get('deoplete.nvim'), {})
  call s:assert.false(exists(':FooBar'))

  call dein#end()

  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', {'if': '1+1'})

  call s:assert.equals(dein#get('deoplete.nvim').if, 2)

  call dein#end()
endfunction

function! s:suite.lazy_manual() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', { 'lazy': 1 })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deoplete.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  call s:assert.equals(dein#source(['deoplete.nvim']), 0)

  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.lazy_on_i() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', { 'on_i': 1 })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  call s:assert.equals(g:dein#_event_plugins,
        \ {'InsertEnter': ['deoplete.nvim']})
endfunction

function! s:suite.lazy_on_ft() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', { 'on_ft': 'cpp' })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deoplete.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  set filetype=c

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  set filetype=cpp

  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.lazy_on_path() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deol.nvim', { 'on_path': '.*' })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deol.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  execute 'edit' tempname()

  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.lazy_on_if() abort
  call dein#begin(s:path)

  let temp = tempname()
  call dein#add('Shougo/deol.nvim',
        \ { 'on_if': '&filetype ==# "foobar"' })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deol.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  set filetype=foobar

  call s:assert.equals(plugin.lazy, 1)
  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.lazy_on_source() abort
  call dein#begin(s:path)

  call dein#add('Shougo/neopairs.vim',
        \ { 'on_source': ['deol.nvim'] })
  call dein#add('Shougo/deol.nvim', { 'lazy': 1 })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('neopairs.vim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  call dein#source('deol.nvim')

  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.lazy_on_func() abort
  call dein#begin(s:path)

  call dein#add('Shougo/neosnippet.vim', { 'lazy': 1 })
  call dein#add('Shougo/deoplete.nvim',
        \ { 'on_func': 'deoplete#initialize' })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deoplete.nvim')
  let plugin2 = dein#get('neosnippet.vim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin2.rtp')), 0)

  call dein#autoload#_on_func('deoplete#initialize')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin2.rtp')), 0)

  call neosnippet#expandable()

  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin2.rtp')), 1)
endfunction

function! s:suite.lazy_on_cmd() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim',
        \ { 'on_cmd': 'NeoCompleteDisable' })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deoplete.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  NeoCompleteDisable

  call s:assert.equals(plugin.sourced, 1)
endfunction

function! s:suite.lazy_on_map() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deol.nvim', { 'on_map': {'n': '<Plug>'} })
  call dein#add('Shougo/neosnippet.vim', { 'on_map': {'n': '<Plug>'} })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin1 = dein#get('deol.nvim')
  let plugin2 = dein#get('neosnippet.vim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin1.rtp')), 0)

  call dein#autoload#_on_map('', 'deol.nvim', 'n')
  call dein#autoload#_on_map('', 'neosnippet.vim', 'n')

  call s:assert.equals(plugin1.sourced, 1)
  call s:assert.equals(plugin2.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin1.rtp')), 1)
endfunction

function! s:suite.lazy_on_pre_cmd() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deol.nvim', { 'lazy': 1 })

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deol.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  call dein#autoload#_on_pre_cmd('Deol')

  call s:assert.equals(plugin.sourced, 1)

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.lazy_on_idle() abort
  call dein#begin(s:path)

  call dein#add('Shougo/defx.nvim', { 'on_idle': 1})

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  call s:assert.equals(g:dein#_event_plugins,
        \ {'CursorHold': ['defx.nvim'], 'FocusLost': ['defx.nvim']})

  let plugin = dein#get('defx.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  doautocmd CursorHold

  call s:assert.equals(plugin.sourced, 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.depends() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim', { 'depends': 'deol.nvim' })
  call dein#add('Shougo/deol.nvim', {'merged': 0})

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  let plugin = dein#get('deol.nvim')

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.depends_lazy() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim',
        \ { 'depends': 'deol.nvim', 'lazy': 1 })
  call dein#add('Shougo/deol.nvim', { 'lazy': 1 })

  let plugin = dein#get('deol.nvim')

  call s:assert.equals(s:dein_install(), 0)

  call dein#end()

  call s:assert.equals(plugin.sourced, 0)
  call s:assert.equals(isdirectory(plugin.rtp), 1)
  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 0)

  call s:assert.equals(dein#source(['deoplete.nvim']), 0)

  call s:assert.equals(plugin.sourced, 1)

  call s:assert.equals(
        \ len(filter(dein#util#_split_rtp(&runtimepath),
        \     'v:val ==# plugin.rtp')), 1)
endfunction

function! s:suite.depends_error_lazy() abort
  call dein#begin(s:path)

  call dein#add('Shougo/deoplete.nvim',
        \ { 'depends': 'defx.nvim' })

  call s:assert.equals(s:dein_install(), 0)

  call s:assert.equals(dein#end(), 0)

  call s:assert.equals(dein#source(['deoplete.nvim']), 0)

  call dein#begin(s:path)

  call dein#add('Shougo/defx.nvim', { 'lazy': 1 })
  call dein#add('Shougo/deoplete.nvim',
        \ { 'depends': 'defx.nvim' })

  call s:assert.equals(s:dein_install(), 0)

  call s:assert.equals(dein#end(), 0)

  call s:assert.equals(dein#source(['deoplete.nvim']), 0)
endfunction

function! s:suite.hooks() abort
  call dein#begin(s:path)

  let g:dein#_hook_add = 'let g:foo = 0'

  function! Foo() abort
  endfunction
  call dein#add('Shougo/deoplete.nvim', {
        \ 'hook_source':
        \   join(['let g:foobar = 2'], "\n"),
        \ 'hook_post_source':
        \   join(['if 1', 'let g:bar = 3', 'endif'], "\n"),
        \ })
  call dein#add('Shougo/neosnippet.vim', {
        \ 'hook_add': function('Foo'),
        \ 'hook_post_source': function('Foo'),
        \ })
  call dein#set_hook('neosnippet.vim', 'hook_source', function('Foo'))
  call dein#set_hook(['deoplete.nvim'], 'hook_add', 'let g:foobar = 1')
  call dein#set_hook([], 'hook_add', 'let g:baz = 3')

  call s:assert.equals(g:foobar, 1)

  call s:assert.equals(s:dein_install(), 0)

  call s:assert.equals(dein#end(), 0)
  call s:assert.equals(g:foo, 0)

  call dein#call_hook('source')
  call s:assert.equals(g:foobar, 2)
  call dein#call_hook('post_source')
  call s:assert.equals(g:bar, 3)
  call s:assert.equals(g:baz, 3)
endfunction

function! s:suite.no_toml() abort
  call dein#begin(s:path)

  call writefile([
        \ 'foobar'
        \ ], g:temp)
  call s:assert.equals(dein#load_toml(g:temp, {}), 1)

  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.no_plugins() abort
  call dein#begin(s:path)

  call writefile([], g:temp)
  call s:assert.equals(dein#load_toml(g:temp), 0)

  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.no_repository() abort
  call dein#begin(s:path)

  call writefile([
        \ "[[plugins]]",
        \ "filetypes = 'all'",
        \ "[[plugins]]",
        \ "filetypes = 'all'"
        \ ], g:temp)
  call s:assert.equals(dein#load_toml(g:temp), 1)

  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.normal() abort
  call dein#begin(s:path)

  call writefile([
        \ "[[plugins]]",
        \ "repo = 'Shougo/deoplete.nvim'",
        \ "on_ft = 'all'",
        \ ], g:temp)
  call s:assert.equals(dein#load_toml(g:temp, {'frozen': 1}), 0)

  let plugin = dein#get('deoplete.nvim')
  call s:assert.equals(plugin.frozen, 1)
  call s:assert.equals(plugin.on_ft, ['all'])

  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.local() abort
  call dein#begin(s:path)

  call dein#add('Shougo/neopairs.vim', {'frozen': 1})
  call dein#local(s:path.'repos/github.com/Shougo/', {'timeout': 1})

  call s:assert.equals(dein#get('neopairs.vim').sourced, 0)
  call s:assert.equals(dein#get('neopairs.vim').timeout, 1)

  call s:assert.equals(dein#end(), 0)

  let plugin2 = dein#get('neopairs.vim')

  call s:assert.equals(plugin2.rtp,
        \ s:path.'repos/github.com/Shougo/neopairs.vim')
endfunction

function! s:suite.clean() abort
  call dein#begin(s:path)

  call s:assert.equals(dein#end(), 0)

  call s:assert.true(!empty(dein#check_clean()))
endfunction

function! s:suite.local_nongit() abort
  let temp = tempname()
  call mkdir(temp.'/plugin', 'p')
  call dein#begin(s:path)

  call dein#local(temp, {}, ['plugin'])

  call s:assert.equals(dein#end(), 0)

  call s:assert.equals(dein#get('plugin').type, 'none')

  call s:assert.equals(s:dein_update(), 0)
endfunction

function! s:suite.build() abort
  call dein#begin(tempname())

  call dein#add('Shougo/vimproc.vim', {
        \ 'build': 'make',
        \ 'hook_add':
        \   'let g:foobar = 1',
        \ 'hook_post_update':
        \   'let g:foobar = 4',
        \ })

  call dein#end()

  call s:assert.equals(g:foobar, 1)

  call s:assert.true(dein#check_install())
  call s:assert.true(dein#check_install(['vimproc.vim']))

  call s:assert.equals(s:dein_install(), 0)
  call s:assert.equals(s:dein_check_update(), 0)

  call s:assert.equals(g:foobar, 4)

  call vimproc#version()
  call s:assert.true(filereadable(g:vimproc#dll_path))
endfunction

function! s:suite.rollback() abort
  call dein#begin(tempname())

  call dein#add('Shougo/deoplete.nvim')

  call dein#end()

  call s:assert.equals(s:dein_install(), 0)

  let plugin = dein#get('deoplete.nvim')

  let old_rev = s:get_revision(plugin)

  " Change the revision manually
  let new_rev = 'bc7e8124d9c412fb3b0a6112baabde75a854d7b5'
  let cwd = getcwd()
  try
    call dein#install#_cd(plugin.path)
    call system('git reset --hard ' . new_rev)
  finally
    call dein#install#_cd(cwd)
  endtry

  call s:assert.equals(s:get_revision(plugin), new_rev)

  call dein#rollback('', ['deoplete.nvim'])

  call s:assert.equals(s:get_revision(plugin), old_rev)
endfunction

function! s:suite.script_type() abort
  call dein#begin(s:path)

  call dein#add(
        \ 'https://github.com/bronzehedwick/impactjs-colorscheme',
        \ {'script_type' : 'colors'})

  call dein#add(
        \ 'https://raw.githubusercontent.com/Shougo/'
        \ . 'shougo-s-github/master/vim/colors/candy.vim',
        \ {'script_type' : 'colors'})
  call s:assert.equals(dein#get('candy.vim').type, 'raw')

  call s:assert.equals(dein#end(), 0)

  call s:assert.equals(s:dein_update(), 0)

  call s:assert.true(filereadable(
        \ dein#get('impactjs-colorscheme').rtp . '/colors/impactjs.vim'))
  call s:assert.true(filereadable(
        \ dein#get('candy.vim').rtp . '/colors/candy.vim'))
endfunction

function! s:get_revision(plugin) abort
  let cwd = getcwd()
  try
    execute 'lcd' fnameescape(a:plugin.path)

    let rev = substitute(system('git rev-parse HEAD'), '\n$', '', '')

    return (rev !~ '\s') ? rev : ''
  finally
    execute 'lcd' fnameescape(cwd)
  endtry
endfunction

function! s:suite.ftplugin() abort
  call dein#begin(tempname())

  let g:dein#_ftplugin = {
        \ '_': 'echo 5555',
        \ 'python': 'setlocal foldmethod=indent',
        \ }

  call dein#add('Shougo/echodoc.vim')
  call dein#end()

  call dein#recache_runtimepath()

  call s:assert.equals(
        \ readfile(dein#util#_get_runtime_path() . '/ftplugin.vim'),
        \ dein#install#_get_default_ftplugin() + [
        \ 'function! s:after_ftplugin()',
        \ ] + split(get(g:dein#_ftplugin, '_', []), '\n') + ['endfunction'])

  let python = readfile(dein#util#_get_runtime_path()
        \ . '/after/ftplugin/python.vim')
  call s:assert.equals(python[-1], g:dein#_ftplugin['python'])
  call s:assert.false(filereadable(dein#util#_get_runtime_path()
        \ . '/after/ftplugin/_.vim'))
endfunction
