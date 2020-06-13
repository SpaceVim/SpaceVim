" set verbose=1

let s:suite = themis#suite('parse')
let s:assert = themis#helper('assert')

let s:path = tempname()

function! s:suite.before_each() abort
  call dein#_init()
endfunction

function! s:suite.after_each() abort
endfunction

function! s:suite.parse_dict() abort
  call dein#begin(s:path)

  let plugin = {'name': 'baz'}
  let parsed_plugin = dein#parse#_dict(dein#parse#_init('', plugin))
  call s:assert.equals(parsed_plugin.name, 'baz')

  let plugin = {'name': 'baz', 'if': '1'}
  let parsed_plugin = dein#parse#_dict(dein#parse#_init('', plugin))
  call s:assert.equals(parsed_plugin.merged, 0)

  let plugin = {'name': 'baz', 'rev': 'foo'}
  let parsed_plugin = dein#parse#_dict(dein#parse#_init('foo', plugin))
  call s:assert.equals(parsed_plugin.path, '_foo')

  let plugin = {'name': 'baz', 'rev': 'foo/bar'}
  let parsed_plugin = dein#parse#_dict(dein#parse#_init('foo', plugin))
  call s:assert.equals(parsed_plugin.path, '_foo_bar')

  let $BAZDIR = '/baz'
  let repo = '$BAZDIR/foo'
  let plugin = {'repo': repo}
  let parsed_plugin = dein#parse#_dict(dein#parse#_init(repo, plugin))
  call s:assert.equals(parsed_plugin.repo, '/baz/foo')

  call dein#end()
endfunction

function! s:suite.name_conversion() abort
  let g:dein#enable_name_conversion = 1

  let plugin = dein#parse#_dict(
        \ {'repo': 'https://github.com/Shougo/dein.vim.git'})
  call s:assert.equals(plugin.name, 'dein')

  let plugin = dein#parse#_dict(
        \ {'repo': 'https://bitbucket.org/kh3phr3n/vim-qt-syntax.git'})
  call s:assert.equals(plugin.name, 'qt-syntax')

  let plugin = dein#parse#_dict(
        \ {'repo': 'https://bitbucket.org/kh3phr3n/qt-syntax-vim.git'})
  call s:assert.equals(plugin.name, 'qt-syntax')

  let plugin = dein#parse#_dict(
        \ {'repo': 'https://bitbucket.org/kh3phr3n/vim-qt-syntax.git',
        \  'name': 'vim-qt-syntax'})
  call s:assert.equals(plugin.name, 'vim-qt-syntax')

  let g:dein#enable_name_conversion = 0
endfunction

function! s:suite.load_toml() abort
  let toml = tempname()
  call writefile([
        \ '# TOML sample',
        \ 'hook_add = "let g:foo = 0"',
        \ '',
        \ '[ftplugin]',
        \ 'c = "let g:bar = 0"',
        \ '',
        \ '[[plugins]]',
        \ '# repository name is required.',
        \ "repo = 'Shougo/denite.nvim'",
        \ "on_map = '<Plug>'",
        \ '[[plugins]]',
        \ "repo = 'Shougo/neosnippet.vim'",
        \ 'on_i = 1',
        \ "on_ft = 'snippet'",
        \ "hook_add = '''",
        \ '"echo',
        \ '"comment',
        \ "echo",
        \ "'''",
        \ "hook_source = '''",
        \ "echo",
        \ '\',
        \ "echo",
        \ "'''",
        \ '[plugins.ftplugin]',
        \ 'c = "let g:bar = 0"',
        \ ], toml)

  call dein#begin(s:path)
  call s:assert.equals(g:dein#_hook_add, '')
  call s:assert.equals(g:dein#_ftplugin, {})
  call s:assert.equals(dein#load_toml(toml), 0)
  call s:assert.equals(g:dein#_hook_add, "\nlet g:foo = 0")
  call s:assert.equals(g:dein#_ftplugin,
        \ {'c': "let g:bar = 0\nlet g:bar = 0"})
  call dein#end()

  call s:assert.equals(dein#get('neosnippet.vim').on_i, 1)
  call s:assert.equals(dein#get('neosnippet.vim').hook_add,
        \ "\necho\n")
  call s:assert.equals(dein#get('neosnippet.vim').hook_source,
        \ "echo\necho\n")
endfunction

function! s:suite.error_toml() abort
  let toml = tempname()
  call writefile([
        \ '# TOML sample',
        \ '[[plugins]]',
        \ '# repository name is required.',
        \ "on_map = '<Plug>'",
        \ '[[plugins]]',
        \ 'on_i = 1',
        \ "on_ft = 'snippet'",
        \ ], toml)

  call dein#begin(s:path)
  call s:assert.equals(dein#load_toml(toml), 1)
  call dein#end()
endfunction

function! s:suite.load_dict() abort
  call dein#begin(s:path)
  call s:assert.equals(dein#load_dict({
        \ 'Shougo/denite.nvim': {},
        \ 'Shougo/deoplete.nvim': {'name': 'deoplete'}
        \ }, {'lazy': 1}), 0)
  call dein#end()

  call s:assert.not_equals(dein#get('denite.nvim'), {})
  call s:assert.equals(dein#get('deoplete').lazy, 1)
endfunction

function! s:suite.disable() abort
  call dein#begin(s:path)
  call dein#load_dict({
        \ 'Shougo/denite.nvim': {'on_cmd': 'Unite'}
        \ })
  call s:assert.false(!exists(':Unite'))
  call dein#disable('denite.nvim')
  call s:assert.false(exists(':Unite'))
  call dein#end()

  call s:assert.equals(dein#get('denite.nvim'), {})
endfunction

function! s:suite.config() abort
  call dein#begin(s:path)
  call dein#load_dict({
        \ 'Shougo/denite.nvim': {}
        \ })
  let g:dein#name = 'denite.nvim'
  call dein#config({'on_i': 1})
  call dein#end()
  call dein#config('unite', {'on_i': 0})

  call s:assert.equals(dein#get('denite.nvim').on_i, 1)
endfunction

function! s:suite.plugins2toml() abort
  let parsed_plugin = dein#parse#_init('Shougo/denite.nvim', {})
  let parsed_plugin2 = dein#parse#_init('Shougo/deoplete.nvim',
        \ {'on_ft': ['vim'], 'hook_add': "hoge\npiyo"})
  let parsed_plugin3 = dein#parse#_init('Shougo/deoppet.nvim',
        \ {'on_map': {'n': ['a', 'b']}})
  call s:assert.equals(dein#plugins2toml(
        \ [parsed_plugin, parsed_plugin2, parsed_plugin3]), [
        \ "[[plugins]]",
        \ "repo = 'Shougo/denite.nvim'",
        \ "",
        \ "[[plugins]]",
        \ "repo = 'Shougo/deoplete.nvim'",
        \ "hook_add = '''",
        \ "hoge",
        \ "piyo",
        \ "'''",
        \ "on_ft = 'vim'",
        \ "",
        \ "[[plugins]]",
        \ "repo = 'Shougo/deoppet.nvim'",
        \ "on_map = {'n': ['a', 'b']}",
        \ "",
        \ ])
endfunction

function! s:suite.trusted() abort
  let sudo = g:dein#_is_sudo
  let g:dein#_is_sudo = 1

  let parsed_plugin = dein#parse#_add('Shougo/denite.nvim', {})
  call s:assert.equals(parsed_plugin.rtp, '')

  let parsed_plugin = dein#parse#_add('Shougo/denite.nvim', {'trusted': 1})
  call s:assert.not_equals(parsed_plugin.rtp, '')

  let g:dein#_is_sudo = sudo
endfunction
