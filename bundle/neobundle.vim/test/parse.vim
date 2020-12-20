let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

let g:neobundle#types#git#default_protocol = 'https'
let g:neobundle#types#hg#default_protocol = 'https'
let g:neobundle#enable_name_conversion = 0

function! s:suite.github_git_repos() abort
  call s:assert.equals(neobundle#parser#path(
        \ 'Shougo/neocomplcache-clang.git'),
        \ {'type' : 'git', 'uri' :
        \   g:neobundle#types#git#default_protocol .
        \  '://github.com/Shougo/neocomplcache-clang.git',
        \  'name' : 'neocomplcache-clang'})
  call s:assert.equals(neobundle#parser#path('Shougo/vimshell'),
        \ {'type' : 'git', 'uri' :
        \   g:neobundle#types#git#default_protocol .
        \  '://github.com/Shougo/vimshell.git',
        \  'name' : 'vimshell'})
  call s:assert.equals(neobundle#parser#path('rails.vim'),
        \ {'type' : 'git', 'uri' :
        \ g:neobundle#types#git#default_protocol .
        \ '://github.com/vim-scripts/rails.vim.git',
        \  'name' : 'rails.vim'})
  call s:assert.equals(neobundle#parser#path('vim-scripts/ragtag.vim'),
        \ {'type' : 'git', 'uri' :
        \ g:neobundle#types#git#default_protocol .
        \ '://github.com/vim-scripts/ragtag.vim.git',
        \  'name' : 'ragtag.vim'})
  call s:assert.equals(neobundle#parser#path(
        \ 'https://github.com/vim-scripts/vim-game-of-life'),
        \ {'type' : 'git', 'uri' :
        \ 'https://github.com/vim-scripts/vim-game-of-life.git',
        \  'name' : 'vim-game-of-life'})
  call s:assert.equals(neobundle#parser#path(
        \ 'git@github.com:gmarik/ingretu.git'),
        \ {'type' : 'git', 'uri' :
        \ 'git@github.com:gmarik/ingretu.git',
        \  'name' : 'ingretu'})
  call s:assert.equals(neobundle#parser#path(
        \ 'gh:gmarik/snipmate.vim.git'),
        \ {'type' : 'git', 'uri' :
        \ g:neobundle#types#git#default_protocol .
        \ '://github.com/gmarik/snipmate.vim.git',
        \  'name' : 'snipmate.vim'})
  call s:assert.equals(neobundle#parser#path(
        \ 'github:mattn/gist-vim.git'),
        \ {'type' : 'git', 'uri' :
        \ g:neobundle#types#git#default_protocol .
        \ '://github.com/mattn/gist-vim.git',
        \  'name' : 'gist-vim'})
  call s:assert.equals(neobundle#parser#path(
        \ 'git@github.com:Shougo/neocomplcache.git'),
        \ {'type' : 'git', 'uri' :
        \ 'git@github.com:Shougo/neocomplcache.git',
        \  'name' : 'neocomplcache'})
  call s:assert.equals(neobundle#parser#path(
        \ 'https://github.com/Shougo/neocomplcache/'),
        \ {'type' : 'git', 'uri' :
        \ 'https://github.com/Shougo/neocomplcache.git',
        \  'name' : 'neocomplcache'})
  call s:assert.equals(neobundle#parser#path(
        \ 'git://git.wincent.com/command-t.git'),
        \ {})
  call s:assert.equals(neobundle#parser#path(
        \ 'http://github.com/Shougo/neocomplcache/'),
        \ {})
endfunction

function! s:suite.svn_repos() abort
  call s:assert.equals(neobundle#parser#path(
        \ 'http://svn.macports.org/repository/macports/contrib/mpvim/'),
        \ {})
  call s:assert.equals(neobundle#parser#path(
        \ 'svn://user@host/repos/bar'),
        \ {})
  call s:assert.equals(neobundle#parser#path(
        \ 'https://svn.macports.org/repository/macports/contrib/mpvim/'),
        \ {'type' : 'svn', 'uri' :
        \  'https://svn.macports.org/repository/macports/contrib/mpvim',
        \  'name' : 'mpvim'})
  call s:assert.equals(neobundle#parser#path(
        \ 'svn+ssh://user@host/repos/bar'),
        \ {'type' : 'svn', 'uri' :
        \  'svn+ssh://user@host/repos/bar',
        \  'name' : 'bar'})
endfunction

function! s:suite.hg_repos() abort
  call s:assert.equals(neobundle#parser#path(
        \ 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'),
        \ {'type' : 'hg', 'uri' :
        \  'https://bitbucket.org/ns9tks/vim-fuzzyfinder',
        \  'name' : 'vim-fuzzyfinder'})
  call s:assert.equals(neobundle#parser#path(
        \ 'bitbucket://bitbucket.org/ns9tks/vim-fuzzyfinder'),
        \ {'type' : 'hg', 'uri' :
        \  g:neobundle#types#hg#default_protocol.
        \  '://bitbucket.org/ns9tks/vim-fuzzyfinder',
        \  'name' : 'vim-fuzzyfinder'})
  call s:assert.equals(neobundle#parser#path(
        \ 'bitbucket:ns9tks/vim-fuzzyfinder'),
        \ {'type' : 'hg', 'uri' :
        \  g:neobundle#types#hg#default_protocol.
        \  '://bitbucket.org/ns9tks/vim-fuzzyfinder',
        \  'name' : 'vim-fuzzyfinder'})
  call s:assert.equals(neobundle#parser#path(
        \ 'ns9tks/vim-fuzzyfinder', {'site': 'bitbucket'}),
        \ {'type' : 'hg', 'uri' :
        \  g:neobundle#types#hg#default_protocol.
        \  '://bitbucket.org/ns9tks/vim-fuzzyfinder',
        \  'name' : 'vim-fuzzyfinder'})
  call s:assert.equals(neobundle#parser#path(
        \ 'ssh://hg@bitbucket.org/ns9tks/vim-fuzzyfinder'),
        \ {'type' : 'hg', 'uri' :
        \  'ssh://hg@bitbucket.org/ns9tks/vim-fuzzyfinder',
        \  'name' : 'vim-fuzzyfinder'})

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'type' : 'hg'}])
  call s:assert.equals(bundle.name, 'neobundle.vim')
  call s:assert.equals(bundle.type, 'hg')
  call s:assert.equals(bundle.uri,
        \ 'https://github.com/Shougo/neobundle.vim.git')
endfunction

function! s:suite.gitbucket_git_repos() abort
  call s:assert.equals(neobundle#parser#path(
        \ 'https://bitbucket.org/kh3phr3n/vim-qt-syntax.git'),
        \ {'type' : 'git', 'uri' :
        \  'https://bitbucket.org/kh3phr3n/vim-qt-syntax.git',
        \  'name' : 'vim-qt-syntax'})
  call s:assert.equals(neobundle#parser#path(
        \ 'bitbucket:kh3phr3n/vim-qt-syntax.git'),
        \ {'type' : 'git', 'uri' :
        \  g:neobundle#types#git#default_protocol.
        \  '://bitbucket.org/kh3phr3n/vim-qt-syntax.git',
        \  'name' : 'vim-qt-syntax'})
  call s:assert.equals(neobundle#parser#path(
        \ 'git@bitbucket.com:accountname/reponame.git'),
        \ {'type' : 'git', 'uri' :
        \ 'git@bitbucket.com:accountname/reponame.git',
        \  'name' : 'reponame'})
  call s:assert.equals(neobundle#parser#path(
        \ 'ssh://git@bitbucket.com:foo/bar.git'),
        \ {'type' : 'git', 'uri' :
        \ 'ssh://git@bitbucket.com:foo/bar.git',
        \  'name' : 'bar'})
endfunction

function! s:suite.raw_repos() abort
  call s:assert.equals(neobundle#parser#path(
        \ 'http://raw.github.com/m2ym/rsense/master/etc/rsense.vim'),
        \ {})
  call s:assert.equals(neobundle#parser#path(
        \ 'http://www.vim.org/scripts/download_script.php?src_id=19237'),
        \ {})
  let bundle = neobundle#parser#_init_bundle(
        \ 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim',
        \ [{ 'script_type' : 'plugin'}])
  call s:assert.equals(bundle.name, 'rsense.vim')
  call s:assert.equals(bundle.type, 'raw')
  call s:assert.equals(bundle.uri,
        \ 'https://raw.github.com/m2ym/rsense/master/etc/rsense.vim')
endfunction

function! s:suite.vba_repos() abort
  call s:assert.equals(neobundle#parser#path(
        \ 'https://foo/bar.vba'),
        \ { 'name' : 'bar', 'uri' : 'https://foo/bar.vba', 'type' : 'vba' })
  call s:assert.equals(neobundle#parser#path(
        \ 'https://foo/bar.vba.gz'),
        \ { 'name' : 'bar', 'uri' : 'https://foo/bar.vba.gz', 'type' : 'vba' })
  call s:assert.equals(neobundle#parser#path(
        \ 'http://foo/bar.vba.gz'),
        \ {})
endfunction

function! s:suite.default_options() abort
  let g:default_options_save = g:neobundle#default_options
  let g:neobundle#default_options =
        \ { 'rev' : {'type__update_style' : 'current'},
        \   '_' : {'type' : 'hg'} }

  let bundle = neobundle#parser#_init_bundle(
        \ 'Shougo/neocomplcache', ['', 'rev', {}])
  call s:assert.equals(bundle.type__update_style, 'current')

  let bundle2 = neobundle#parser#_init_bundle(
        \ 'Shougo/neocomplcache', [])
  call s:assert.equals(bundle2.type, 'hg')

  let g:neobundle#default_options = g:default_options_save
endfunction

function! s:suite.ssh_protocol() abort
  let bundle = neobundle#parser#_init_bundle(
        \ 'accountname/reponame', [{
        \ 'site' : 'github', 'type' : 'git', 'type__protocol' : 'ssh' }])
  call s:assert.equals(bundle.uri,
        \ 'git@github.com:accountname/reponame.git')

  let bundle = neobundle#parser#_init_bundle(
        \ 'accountname/reponame', [{
        \ 'site' : 'bitbucket', 'type' : 'hg', 'type__protocol' : 'ssh' }])
  call s:assert.equals(bundle.uri,
        \ 'ssh://hg@bitbucket.org/accountname/reponame')

  let bundle = neobundle#parser#_init_bundle(
        \ 'accountname/reponame.git', [{
        \ 'site' : 'bitbucket', 'type' : 'git', 'type__protocol' : 'ssh' }])
  call s:assert.equals(bundle.uri,
        \ 'git@bitbucket.org:accountname/reponame.git')
endfunction

function! s:suite.fetch_plugins() abort
  let bundle = neobundle#parser#fetch(
        \ string('accountname/reponame.git'))
  call s:assert.equals(bundle.rtp, '')
endfunction

function! s:suite.parse_directory() abort
  let bundle = neobundle#parser#_init_bundle(
        \ 'Shougo/neocomplcache', [])
  call s:assert.equals(bundle.directory, 'neocomplcache')

  let bundle = neobundle#parser#_init_bundle(
        \ 'Shougo/neocomplcache', ['ver.3'])
  call s:assert.equals(bundle.directory, 'neocomplcache_ver_3')
endfunction

function! s:suite.name_conversion() abort
  let g:neobundle#enable_name_conversion = 1

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'type' : 'hg'}])
  call s:assert.equals(bundle.name, 'neobundle')

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://bitbucket.org/kh3phr3n/vim-qt-syntax.git',
        \ [{ 'type' : 'hg'}])
  call s:assert.equals(bundle.name, 'qt-syntax')

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://bitbucket.org/kh3phr3n/qt-syntax-vim.git',
        \ [{ 'type' : 'hg'}])
  call s:assert.equals(bundle.name, 'qt-syntax')

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://bitbucket.org/kh3phr3n/vim-qt-syntax.git',
        \ [{ 'name' : 'vim-qt-syntax'}])
  call s:assert.equals(bundle.name, 'vim-qt-syntax')

  let g:neobundle#enable_name_conversion = 0
endfunction

function! s:suite.autoload() abort
  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'filetypes' : 'foo_ft' }])
  call s:assert.equals(bundle.on_ft, ['foo_ft'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'filename_patterns' : 'foo_filename' }])
  call s:assert.equals(bundle.on_path, ['foo_filename'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'explorer' : 1 }])
  call s:assert.equals(bundle.on_path, ['.*'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'commands' : 'Foo' }])
  call s:assert.equals(bundle.on_cmd, ['Foo'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'functions' : 'foo#bar' }])
  call s:assert.equals(bundle.on_func, ['foo#bar'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'mappings' : '<Plug>' }])
  call s:assert.equals(bundle.on_map, ['<Plug>'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'insert' : 1 }])
  call s:assert.equals(bundle.on_i, 1)
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'on_source' : 'plug_foo' }])
  call s:assert.equals(bundle.on_source, ['plug_foo'])
  call s:assert.equals(bundle.lazy, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'command_prefix' : 'PreFoo' }])
  call s:assert.equals(bundle.pre_cmd, ['PreFoo'])
  call s:assert.equals(bundle.lazy, 0)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'function_prefixes' : 'foo#' }])
  call s:assert.equals(bundle.pre_func, ['foo#'])
  call s:assert.equals(bundle.lazy, 0)
endfunction

function! s:suite.deprecated() abort
  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'stay_same' : '1' }])
  call s:assert.equals(bundle.frozen, 1)

  let bundle = neobundle#parser#_init_bundle(
        \ 'https://github.com/Shougo/neobundle.vim.git',
        \ [{ 'type' : 'nosync' }])
  call s:assert.equals(bundle.type, 'none')
endfunction

" vim:foldmethod=marker:fen:
