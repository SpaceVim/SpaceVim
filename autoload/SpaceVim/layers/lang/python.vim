"=============================================================================
" python.vim --- SpaceVim lang#python layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#python, layer-lang-python
" @parentsection layers
" This layer provides python language support for SpaceVim. Includding syntax
" highlighting, code formatting and code completion. This layer is not enabled
" by default, to enable this layer, add following snippet into SpaceVim
" configuration file:
" >
"   [[layers]]
"     name = 'lang#python'
" <
"
" @subsection Options
"
" 1. python_file_head: the default file head for python source code.
" >
"   [layers]
"     name = "lang#python"
"     python_file_head = [      
"       '#!/usr/bin/python3',
"       '# -*- coding : utf-8 -*-'
"       ''
"     ]
" <
" 2. `python_interpreter`: Set the interpreter of python.
" >
"   [[layers]]
"     name = 'lang#python'
"     python_interpreter = '~/download/bin/python3'
" <
" 3. format_on_save: enable/disable code formation when save python file. This
" options is disabled by default, to enable it:
" >
"   [[layers]]
"     name = 'lang#python'
"     format_on_save = true
" <
"
" @subsection Key bindings
"
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
" <
"
" This layer also provides REPL support for python, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


if exists('s:enabled_linters')
  finish
endif

let s:enabled_linters = ['python']
let s:format_on_save = 0
let s:python_file_head = [
      \ '#!/usr/bin/env python',
      \ '# -*- coding: utf-8 -*-',
      \ '',
      \ ''
      \ ]
let s:enable_typeinfo = 0
let s:python_interpreter = 'python3'

function! SpaceVim#layers#lang#python#plugins() abort
  let plugins = []
  " python
  if !SpaceVim#layers#lsp#check_filetype('python')
    if has('nvim')
      call add(plugins, ['zchee/deoplete-jedi', { 'on_ft' : 'python'}])
      " in neovim, we can use deoplete-jedi together with jedi-vim,
      " but we need to disable the completions of jedi-vim.
      let g:jedi#completions_enabled = 0
    endif
    call add(plugins, ['davidhalter/jedi-vim', { 'on_ft' : 'python',
          \ 'if' : has('python') || has('python3')}])
  endif
  call add(plugins, ['heavenshell/vim-pydocstring',
        \ { 'on_cmd' : 'Pydocstring'}])
  call add(plugins, ['Vimjas/vim-python-pep8-indent', 
        \ { 'on_ft' : 'python'}])
  call add(plugins, ['jeetsukumaran/vim-pythonsense', 
        \ { 'on_ft' : 'python'}])
  call add(plugins, ['alfredodeza/coveragepy.vim', 
        \ { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#python#config() abort
  " heavenshell/vim-pydocstring {{{

  " If you execute :Pydocstring at no `def`, `class` line.
  " g:pydocstring_enable_comment enable to put comment.txt value.
  let g:pydocstring_enable_comment = 0

  " Disable this option to prevent pydocstring from creating any
  " key mapping to the `:Pydocstring` command.
  " Note: this value is overridden if you explicitly create a
  " mapping in your vimrc, such as if you do:
  let g:pydocstring_enable_mapping = 0

  if g:spacevim_autocomplete_parens
    augroup python_delimit
      au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
    augroup end
  endif
  " }}}
 let g:deoplete#sources#jedi#enable_typeinfo = s:enable_typeinfo
  call SpaceVim#plugins#runner#reg_runner('python', 
        \ {
        \ 'exe' : function('s:getexe'),
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ })
  call SpaceVim#mapping#gd#add('python', function('s:go_to_def'))
  call SpaceVim#mapping#space#regesit_lang_mappings('python', function('s:language_specified_mappings'))
  call SpaceVim#layers#edit#add_ft_head_tamplate('python', s:python_file_head)
  if executable('ipython')
    call SpaceVim#plugins#repl#reg('python', 'ipython --no-term-title --colors=NoColor')
  elseif executable('ipython3')
    call SpaceVim#plugins#repl#reg('python', 'ipython3 --no-term-title --colors=NoColor')
  elseif executable('python')
    call SpaceVim#plugins#repl#reg('python', ['python', '-i'])
  elseif executable('python3')
    call SpaceVim#plugins#repl#reg('python', ['python3', '-i'])
  endif
  let g:neomake_python_enabled_makers = s:enabled_linters
  let g:neomake_python_python_exe = s:python_interpreter
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.i = {'name' : '+Imports'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i', 's'],
        \ 'Neoformat isort',
        \ 'sort imports', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i', 'r'],
        \ 'Neoformat autoflake',
        \ 'remove unused imports', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("python")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)

  let g:_spacevim_mappings_space.l.c = {'name' : '+Coverage'}

  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'r'],
        \ 'Coveragepy report',
        \ 'coverager eport', 1)

  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 's'],
        \ 'Coveragepy show',
        \ 'coverager show', 1)

  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'e'],
        \ 'Coveragepy session',
        \ 'coverager session', 1)

  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'f'],
        \ 'Coveragepy refresh',
        \ 'coverager refresh', 1)

  " +Generate {{{

  let g:_spacevim_mappings_space.l.g = {'name' : '+Generate'}

  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'g', 'd'],
        \ 'Pydocstring', 'generate docstring', 1)

  " }}}

  if SpaceVim#layers#lsp#check_filetype('python')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif

  " Format on save
  if s:format_on_save
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'python',
          \ 'enable' : 1,
          \ })
  endif

endfunction


function! s:Shebang_to_cmd(line) abort
  let executable = matchstr(a:line, '#!\s*\zs[^ ]*')
  let argvs = split(matchstr(a:line, '#!\s*[^ ]\+\s*\zs.*'))
  return [executable] + argvs
endfunction

func! s:getexe() abort
  let line = getline(1)
  if line =~# '^#!'
    return s:Shebang_to_cmd(line)
  endif
  return [s:python_interpreter]
endf

function! s:go_to_def() abort
  if !SpaceVim#layers#lsp#check_filetype('python')
    call jedi#goto()
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction

function! SpaceVim#layers#lang#python#set_variable(var) abort
  let s:format_on_save = get(a:var,
        \ 'format_on_save',
        \ get(a:var,
        \ 'format-on-save',
        \ s:format_on_save))
  let s:python_file_head = get(a:var,
        \ 'python_file_head',
        \ get(a:var,
        \ 'python-file-head',
        \ s:python_file_head))
  let s:enable_typeinfo = get(a:var,
        \ 'enable_typeinfo',
        \ s:enable_typeinfo
        \ )
  let s:enabled_linters = get(a:var,
        \ 'enabled_linters',
        \ s:enabled_linters
        \ )
  let s:python_interpreter = get(a:var,
        \ 'python_interpreter',
        \ s:python_interpreter
        \ )
endfunction
