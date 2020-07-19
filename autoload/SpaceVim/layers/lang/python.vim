"=============================================================================
" python.vim --- SpaceVim lang#python layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#python, layer-lang-python
" @parentsection layers
" To make this layer work well, you should install jedi.
" @subsection mappings
" >
"   mode            key             function
" <

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
    call SpaceVim#plugins#repl#reg('python', 'ipython --no-term-title')
  elseif executable('python')
    call SpaceVim#plugins#repl#reg('python', ['python', '-i'])
  endif
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
    augroup SpaceVim_layer_lang_python
      autocmd!
      autocmd BufWritePre *.py undojoin | Neoformat
    augroup end
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
  return ['python']
endf

function! s:go_to_def() abort
  if !SpaceVim#layers#lsp#check_filetype('python')
    call jedi#goto()
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction

let s:format_on_save = 0
let s:python_file_head = [
      \ '#!/usr/bin/env python',
      \ '# -*- coding: utf-8 -*-',
      \ '',
      \ ''
      \ ]
let s:enable_typeinfo = 0
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
endfunction
