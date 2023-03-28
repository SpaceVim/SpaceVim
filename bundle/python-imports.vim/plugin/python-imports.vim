" File: python-imports.vim
" Author: Marius Gedminas <marius@gedmin.as>
" Version: 3.3
" Last Modified: 2023-02-09
"
" Overview
" --------
" Vim script to help adding import statements in Python modules.
"
" You need to have a tags file built (:!ctags -R .).
"
" Type :ImportName [<name>] to add an import statement at the top.
" Type :ImportNameHere [<name>] to add an import statement above the current
" line.
"
" I use mappings like the following one to import the name under cursor with a
" single keystroke
"   map <buffer> <F5>    :ImportName<CR>
"   map <buffer> <C-F5>  :ImportNameHere<CR>
"
" Installation
" ------------
" I like plugin managers like vim-plug.
"
" Needs Vim 7.0, preferably built with Python support.
"
" Tested on Linux only.
"
" Configuration
" -------------
" In addition to the tags file (and builtin + stdlib modules), you can define
" your favourite imports in a file called ~/.vim/python-imports.cfg.  That
" file should contain Python import statements like
"    import module1, module2 as alias1, module3
"    from package.module import name1, name2 as alias2, name3
" Continuation lines are supported if you use parentheses:
"    from package.module import (name1,
"       name2 as alias2, name3)
"
" Bugs
" ----
" The logic for detecting already imported names is not very clever.
" The logic for finding the right place to put an import is not very clever
" either.  Sometimes it might introduce syntax errors.
" This plugin expects your imports to look like
"    import module
"    from package.module import name
" Parenthesized name lists are partially supported, if you use one name per
" line, i.e.
"    from package.module import (
"        name1,
"        name2,
"    )
" Documentation is scant.

if v:version < 700
  finish
endif

" Hardcoded names and locations
" g:pythonImports[module] = '' for module imports
" g:pythonImports[name] = 'module' for other imports
if !exists("g:pythonImports")
  let g:pythonImports = {'print': '__future__'}
endif

" g:pythonImportAliases[alias] = name for module imports using aliases, e.g.
" g:pythonImportAliases['sa'] = 'sqlalchemy' means that you want to 'import sqlalchemy as sa'
if !exists("g:pythonImportAliases")
  let g:pythonImportAliases = {}
endif

if has("python") || has("python3")
  let s:python = has("python3") ? "python3" : "python"
  exec s:python "import sys, vim"
  if !exists("g:pythonStdlibPath")
    exec s:python "vim.command(\"let g:pythonStdlibPath = '%s/lib/python%d.%d'\" % (getattr(sys, 'base_prefix', getattr(sys, 'real_prefix', sys.prefix)), sys.version_info[0], sys.version_info[1]))"
  endif
  if !exists("g:pythonBuiltinModules")
    let g:pythonBuiltinModules = {}
    exec s:python "for m in sys.builtin_module_names: vim.command(\"let g:pythonBuiltinModules['%s'] = ''\" % m)"
  endif
  if !exists("g:pythonExtModuleSuffix")
    exec s:python "import sysconfig"
    " grr old neovim doesn't have pyxeval()
    let s:expr = "sysconfig.get_config_var('EXT_SUFFIX') or '.so'"
    let g:pythonExtModuleSuffix = has("python3") ? py3eval(s:expr) : pyeval(s:expr)
  endif
elseif !exists("g:pythonStdlibPath")
  let _py_versions = glob('/usr/lib/python?.*', 1, 1)
  if _py_versions != []
    " use latest version (assuming glob sorts the list)
    let g:pythonStdlibPath = _py_versions[-1]
  else
    " what, you don't have Python installed on this machine?
    let g:pythonStdlibPath = ""
  endif
endif

if !exists("g:pythonExtModuleSuffix")
  let g:pythonExtModuleSuffix = ".so"
endif

if !exists("g:pythonBuiltinModules")
  " based on python3.6 on linux, with all private ones removed
  let g:pythonBuiltinModules = {
        \ 'array': '',
        \ 'atexit': '',
        \ 'binascii': '',
        \ 'builtins': '',
        \ 'cmath': '',
        \ 'errno': '',
        \ 'faulthandler': '',
        \ 'fcntl': '',
        \ 'gc': '',
        \ 'grp': '',
        \ 'itertools': '',
        \ 'marshal': '',
        \ 'math': '',
        \ 'posix': '',
        \ 'pwd': '',
        \ 'pyexpat': '',
        \ 'select': '',
        \ 'spwd': '',
        \ 'sys': '',
        \ 'syslog': '',
        \ 'time': '',
        \ 'unicodedata': '',
        \ 'xxsubtype': '',
        \ 'zipimport': '',
        \ 'zlib': '',
        \ }
endif

if !exists("g:pythonPaths")
  let g:pythonPaths = []
endif

if !exists("g:pythonImportsUseAleFix")
  let g:pythonImportsUseAleFix = 1
endif

function! LoadPythonImports(...)
  if a:0 == 0
    let filename = expand('~/.vim/python-imports.cfg')
    if !filereadable(filename)
      if &verbose > 0
        echo "skipping" filename "because it does not exist or is not readable"
      endif
      return
    endif
  elseif a:0 == 1
    let filename = a:1
  else
    echoerr "too many arguments: expected one (filename)"
    return
  endif
  if &verbose > 0
    echo "python-imports.vim: loading" filename
  endif
  if !has('python3')
    echoer "Need Python 3 support: I'm not implementing a config file parser in vimscript!"
    return
  endif
  exec s:python "<< END"
import python_imports
python_imports.parse_python_imports_cfg(vim.eval('filename'), int(vim.eval('&verbose')))
END
endf

if has('python3')
  call LoadPythonImports()
endif

function! IsStdlibModule(name)
  return python_imports#is_stdlib_module(name)
endf

function! CurrentPythonModule()
  return python_imports#filename2module(expand("%"))
endfunction

function! CurrentPythonPackage()
  return python_imports#filename2package(expand("%"))
endfunction

function! FindPlaceForImport(pkg, name)
  call python_imports#find_place_for_import(a:pkg, a:name)
endfunction

function! ImportName(name, here, stay)
  call python_imports#import_name(a:name, a:here, a:stay)
endf

command! -nargs=? -bang -complete=tag ImportName	call ImportName(<q-args>, 0, <q-bang> == "!")
command! -nargs=? -bang -complete=tag ImportNameHere	call ImportName(<q-args>, 1, <q-bang> == "!")
