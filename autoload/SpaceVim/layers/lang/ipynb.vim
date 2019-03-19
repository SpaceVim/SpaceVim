"=============================================================================
" ipynb.vim --- SpaceVim lang#ipynb layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section lang#ipynb, layer-lang-ipynb
" @parentsection layers
" To make this layer work well, you should install jedi.
" @subsection mappings
" >
"   mode            key             function
" <


function! SpaceVim#layers#lang#ipynb#plugins() abort
  let plugins = [
        \ ['szymonmaszke/vimpyter'        , {'on_ft' : 'ipynb'}],
        \ ['heavenshell/vim-pydocstring'  , {'on_cmd': 'Pydocstring'}],
        \ ]
  " \ ['Vimjas/vim-python-pep8-indent', {'on_ft' : 'ipynb'             }],
  if !SpaceVim#layers#lsp#check_filetype('ipynb')
    if has('nvim')
      call add(plugins, ['zchee/deoplete-jedi', { 'on_ft' : 'ipynb'}])
      " in neovim, we can use deoplete-jedi together with jedi-vim,
      " but we need to disable the completions of jedi-vim.
      let g:jedi#completions_enabled = 0
    endif
    call add(plugins, ['davidhalter/jedi-vim', { 'on_ft' : 'ipynb',
          \ 'if' : has('python') || has('python3')}])
  endif
  return plugins
endfunction


let s:format_on_save = 0
function! SpaceVim#layers#lang#ipynb#config() abort
  if !SpaceVim#layers#lsp#check_filetype('ipynb')
    let g:jedi#completions_command    = ''
    let g:jedi_auto_vim_configuration = 0
    let g:jedi#use_splits_not_buffers = 1
    let g:jedi#force_py_version       = 3
  endif
  " heavenshell/vim-pydocstring {{{
    " If you execute :Pydocstring at no `def`, `class` line.
    " g:pydocstring_enable_comment enable to put comment.txt value.
  let g:pydocstring_enable_comment = 0
    " Disable this option to prevent pydocstring from creating any
    " key mapping to the `:Pydocstring` command.
    " Note: this value is overridden if you explicitly create a
    " mapping in your vimrc, such as if you do:
  let g:pydocstring_enable_mapping = 0
  " }}}

    call SpaceVim#mapping#gd#add('ipynb', function('s:go_to_def'))
    call SpaceVim#mapping#space#regesit_lang_mappings('ipynb', function('s:language_specified_mappings'))
    call SpaceVim#layers#edit#add_ft_head_tamplate('python',
          \ ['#!/usr/bin/env python',
          \ '# -*- coding: utf-8 -*-',
          \ '']
          \ )
    if executable('ipython')
      call SpaceVim#plugins#repl#reg('python', 'ipython --no-term-title')
    elseif executable('python')
      call SpaceVim#plugins#repl#reg('python', ['python', '-i'])
    endif
endfunction


function! s:language_specified_mappings() abort
  let g:_spacevim_mappings_space.l.j = {'name' : '+Jupyter Notebook'}
  imap <silent><buffer> <c-o> <esc>:VimpyterInsertPythonBlock<CR>i
  call SpaceVim#mapping#space#langSPC('nmap', ['l','j','u'],
        \ 'vimpyter#updateNotebook()',
        \ 'update Notebook'        , 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','j','j'],
        \ 'VimpyterInsertPythonBlock',
        \ 'insert python code block', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','j','s'],
        \ 'VimpyterStartJupyter',
        \ 'start Jupyter Notebook' , 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','j','n'],
        \ 'VimpyterStartNteract',
        \ 'start Nteract Notebook' , 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','j','v'],
        \ 'vimpyter#createView()',
        \ 'create view of Notebook', 1)

  let g:_spacevim_mappings_space.l.i = {'name' : '+Imports'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i','s'],
        \ 'Neoformat isort',
        \ 'sort Imports', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i','r'],
        \ 'Neoformat autoflake',
        \ 'remove unused imports', 1)

  let g:_spacevim_mappings_space.l.g = {'name' : '+Generate'}
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'g'],
        \ 'Pydocstring',
        \ 'generate Docstring', 1)

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

  if SpaceVim#layers#lsp#check_filetype('ipynb')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show Document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename Symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
          \ 'call SpaceVim#lsp#references()', 'find References', 1)
  else
    nnoremap <silent><buffer> K :call jedi#show_documentation()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call jedi#show_documentation()', 'show Document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call jedi#rename()', 'rename Symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
          \ 'call jedi#usages()', 'find References', 1)
  endif

  if s:format_on_save
    augroup SpaceVim_layer_lang_ipynb
      autocmd!
      autocmd BufWritePost *.ipynb Neoformat yapf
    augroup END
  endif
endfunction


function! s:go_to_def() abort
  if !SpaceVim#layers#lsp#check_filetype('ipynb')
    call jedi#goto()
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction

  let s:format_on_save = 0
function! SpaceVim#layers#lang#ipynb#set_variable(var) abort

  let s:format_on_save = get(a:var,
        \ 'format-on-save',
        \ 0)
endfunction
