"=============================================================================
" c.vim --- SpaceVim lang#c layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Layer doc {{{

""
" @section lang#c, layers-lang-c
" @parentsection layers
" This layer is for c/cpp development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#c'
" <
"
" @subsection Layer options
"
" `clang_executable`: Set the path to the clang executable, by default, it is
" `clang`.
"
" `enable_clang_syntax_highlight`: Enable/Disable clang based syntax
" highlighting. By default it is disabled.
"
" `libclang_path`: The libclang shared object (dynamic library) file path.
" By default it is empty
"
" `clang_std`: This is a dictionary for setting std for c/cpp. The default
" valuable is :
" >
"   'c'     : 'c11',
"   'cpp'   : 'c++1z',
"   'objc'  : 'c11',
"   'objcpp': 'c++1z',
" <
"
" `clang_flag`: You should be able to just paste most of your compile
" flags in there.
"
" Here is an example how to use above options:
" >
"   [[layers]]
"     name = "lang#c"
"     clang_executable = "/usr/bin/clang"
"     clang_flag = ['-I/user/include']
"     [layers.clang_std]
"       c = "c11"
"       cpp = "c++1z"
"       objc = "c11"
"       objcpp = "c++1z"
" <
"
" Instead of using `clang_flag` options, You can also create a `.clang` file
" in the root directory of your project. SpaceVim will load the options
" defined in `.clang` file. For example:
" >
"   -std=c11
"   -I/home/test
" <
" Note: If `.clang` file contains std configuration, it will override
" `clang_std` layer option.
"
" @subsection Key bindings
"
" >
"   Key             Function
"   --------------------------------
"   SPC l r         run current file
"   g d             jump to definition
" <
"
" This layer also provides REPL support for c, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"
" If the lsp layer is enabled for c/c++, the following key bindings can
" be used:
" >
"   key binding     Description
"   --------------------------------
"   g D             jump to declaration
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l h         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <
"
" Known issue:
"
" You need to use `flush(stdout)` before `scanf()` when run code in code
" runner.
"
" }}}

" Init layer options {{{
if exists('s:clang_executable')
  finish
else
  let s:clang_executable = 'clang'
  let s:clang_flag = []
  let s:clang_std = {
        \ 'c' : 'c11',
        \ 'cpp': 'c++1z',
        \ 'objc': 'c11',
        \ 'objcpp': 'c++1z',
        \ }
  let s:highlight_cmd = ''
  let s:enable_clang_syntax = 0
  let s:c_repl_command = ''
endif
" }}}

let s:format_on_save = 0

" Load the APIs{{{
let s:SYSTEM = SpaceVim#api#import('system')
let s:CPT = SpaceVim#api#import('vim#compatible')
" }}}

" plugins {{{
function! SpaceVim#layers#lang#c#plugins() abort
  let plugins = []
  if !SpaceVim#layers#lsp#check_filetype('c') && !SpaceVim#layers#lsp#check_filetype('cpp')
    if g:spacevim_autocomplete_method ==# 'deoplete'
      call add(plugins, ['Shougo/deoplete-clangx', {'merged' : 0}])
    elseif g:spacevim_autocomplete_method ==# 'ycm'
      " no need extra plugins
    elseif g:spacevim_autocomplete_method ==# 'completor'
      " no need extra plugins
    elseif g:spacevim_autocomplete_method ==# 'asyncomplete'
      call add(plugins, ['wsdjeg/asyncomplete-clang.vim', {'merged' : 0, 'loadconf' : 1}])
    else
      call add(plugins, ['Rip-Rip/clang_complete', {'if' : s:CPT.has('python') || s:CPT.has('python3')}])
    endif
  endif

  if s:enable_clang_syntax
    " chromatica is for neovim with py3
    " clamp is for neovim rpcstart('python', " [s:script_folder_path.'/../python/engine.py'])]
    " clighter8 is for vim8
    " clighter is for old vim
    if has('nvim')
      if s:CPT.has('python3') && SpaceVim#util#haspy3lib('clang')
        call add(plugins, ['arakashic/chromatica.nvim', { 'merged' : 0}])
      else
        call add(plugins, ['bbchung/Clamp', { 'if' : has('python')}])
      endif
    elseif has('job')
      call add(plugins, ['bbchung/clighter8', { 'if' : has('python')}])
    else
      call add(plugins, ['bbchung/clighter', { 'if' : has('python')}])
    endif
  else
    call add(plugins, ['octol/vim-cpp-enhanced-highlight', { 'merged' : 0}])
  endif
  return plugins
endfunction
" }}}

" config {{{
function! SpaceVim#layers#lang#c#config() abort
  call SpaceVim#mapping#g_capital_d#add('c',
        \ function('s:go_to_declaration'))
  call SpaceVim#mapping#g_capital_d#add('cpp',
        \ function('s:go_to_declaration'))
  call SpaceVim#mapping#gd#add('c',
        \ function('s:go_to_def'))
  call SpaceVim#mapping#gd#add('cpp',
        \ function('s:go_to_def'))
  " TODO: add stdin suport flex -t lexer.l | gcc -o lexer.o -xc -
  let c_runner = {
        \ 'exe' : 'gcc',
        \ 'targetopt' : '-o',
        \ 'opt' : ['-std=' . s:clang_std.c] + s:clang_flag + ['-xc', '-'],
        \ 'usestdin' : 1,
        \ }
  call SpaceVim#plugins#runner#reg_runner('c', [c_runner, '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('c', function('s:language_specified_mappings'))
  let cpp_runner = {
        \ 'exe' : 'g++',
        \ 'targetopt' : '-o',
        \ 'opt' : ['-std=' . s:clang_std.cpp] + s:clang_flag + ['-xc++', '-'],
        \ 'usestdin' : 1,
        \ }
  call SpaceVim#plugins#runner#reg_runner('cpp', [cpp_runner, '#TEMP#'])
  if !empty(s:c_repl_command)
    call SpaceVim#plugins#repl#reg('c', s:c_repl_command)
  else
    call SpaceVim#plugins#repl#reg('c', 'igcc')
  endif
  call SpaceVim#mapping#space#regesit_lang_mappings('cpp', function('s:language_specified_mappings'))
  let objc_runner = {
        \ 'exe' : 'gcc',
        \ 'targetopt' : '-o',
        \ 'opt' : ['-std=' . s:clang_std.objc] + s:clang_flag + ['-xobjc', '-'],
        \ 'usestdin' : 1,
        \ }
  call SpaceVim#plugins#runner#reg_runner('objc', [objc_runner, '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('objc', function('s:language_specified_mappings'))
  call SpaceVim#plugins#projectmanager#reg_callback(function('s:update_clang_flag'))
  if executable('clang')
    let g:neomake_c_enabled_makers = ['clang']
    let g:neomake_cpp_enabled_makers = ['clang']
  endif
  let g:neomake_c_gcc_remove_invalid_entries = 1
  let g:chromatica#enable_at_startup = 0
  let g:clighter_autostart           = 0
  augroup SpaceVim_lang_c
    autocmd!
    if s:enable_clang_syntax
      auto FileType c,cpp  call s:highlight()
    endif
    au BufRead,BufNewFile *.m set filetype=objc
    autocmd FileType c,cpp set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
  augroup END
  call add(g:spacevim_project_rooter_patterns, '.clang')
  if has('nvim')
    if s:CPT.has('python3') && SpaceVim#util#haspy3lib('clang')
      let s:highlight_cmd = 'ChromaticaStart'
    else
      let s:highlight_cmd = 'ClampStart'
    endif
  elseif has('job')
    let s:highlight_cmd = 'ClStart'
  else
    let s:highlight_cmd = 'ClighterEnable'
  endif

  " Format on save
  if s:format_on_save
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'c',
          \ 'enable' : 1,
          \ })
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'cpp',
          \ 'enable' : 1,
          \ })
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'objc',
          \ 'enable' : 1,
          \ })
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'objcpp',
          \ 'enable' : 1,
          \ })
  endif
endfunction
" }}}

" local function: highlight {{{
function! s:highlight() abort
  try
    exe s:highlight_cmd
  catch
  endtry
endfunction
" }}}

" set_variable {{{
function! SpaceVim#layers#lang#c#set_variable(var) abort
  if has_key(a:var, 'clang_executable')
    let g:completor_clang_binary = a:var.clang_executable
    let g:deoplete#sources#clang#executable = a:var.clang_executable
    let g:neomake_c_enabled_makers = ['clang']
    let g:neomake_cpp_enabled_makers = ['clang']
    let s:clang_executable = a:var.clang_executable
    if !has('nvim')
      let g:asyncomplete_clang_executable = a:var.clang_executable
    endif
  endif
  let s:c_repl_command = get(a:var, 'repl_command', '') 
  if has_key(a:var, 'libclang_path')
    if has('nvim')
      if s:CPT.has('python3') && SpaceVim#util#haspy3lib('clang')
        let g:chromatica#libclang_path = a:var.libclang_path
      else
        let g:clamp_libclang_path = a:var.libclang_path
      endif
    else
      let g:asyncomplete_clang_libclang_path = a:var.libclang_path
      if has('job')
        let g:clighter8_libclang_path = a:var.libclang_path
      else
        let g:clighter_libclang_file = a:var.libclang_path
      endif
    endif
  endif

  let s:clang_flag = get(a:var, 'clang_flag', s:clang_flag)

  let s:enable_clang_syntax = get(a:var, 'enable_clang_syntax_highlight', s:enable_clang_syntax)

  let s:format_on_save = get(a:var,
        \ 'format_on_save',
        \ s:format_on_save)

  call extend(s:clang_std, get(a:var, 'clang_std', {}))
endfunction
" }}}

" local function: language_specified_mappings {{{
function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  if SpaceVim#layers#lsp#check_filetype('c')
        \ || SpaceVim#layers#lsp#check_server('clangd')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'i'],
          \ 'call SpaceVim#lsp#go_to_impl()', 'implementation', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'h'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call SpaceVim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call SpaceVim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call SpaceVim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)

  endif
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("c")',
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
endfunction
" }}}

" local function: update_clang_flag {{{
function! s:update_clang_flag() abort
  if filereadable('.clang')
    let argvs = readfile('.clang')
    call s:update_checkers_argv(argvs, ['c', 'cpp'])
    call s:update_autocomplete_argv(argvs, ['c', 'cpp'])
    call s:update_neoinclude(argvs, ['c', 'cpp'])
    call s:update_runner(argvs, ['c', 'cpp'])
  endif
endfunction
" }}}

" local function: update_checkers_argv {{{
if g:spacevim_lint_engine ==# 'neomake'
  function! s:update_checkers_argv(argv, fts) abort
    if s:has_std(a:argv)
      let default_std = 1
    else
      let default_std = 0
    endif
    for ft in a:fts
      let g:neomake_{ft}_clang_maker = {
            \ 'args': ['-fsyntax-only', '-Wall', '-Wextra', '-I./'] + a:argv + (default_std ? [] : ['-std=' . s:clang_std[ft]]) + s:clang_flag,
            \ 'exe' : s:clang_executable,
            \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m'
            \ }
    endfor
  endfunction
elseif g:spacevim_lint_engine ==# 'ale'
  function! s:update_checkers_argv(argv, fts) abort
    " g:ale_c_clang_options
    for ft in a:fts
      let g:ale_{ft}_clang_options = ' -fsyntax-only -Wall -Wextra -I./ ' . join(a:argv, ' ')
      let g:ale_{ft}_clang_executable = s:clang_executable
    endfor
  endfunction
else
  function! s:update_checkers_argv(argv, fts) abort

  endfunction
endif
" }}}

" local function: update_autocomplete_argv {{{
function! s:update_autocomplete_argv(argv, fts) abort

endfunction
" }}}

" local function: has_std {{{
function! s:has_std(argv) abort
  for line in a:argv
    if line =~# '^-std='
      return 1
    endif
  endfor
endfunction
" }}}

" local function: update_runner {{{
function! s:update_runner(argv, fts) abort
  if s:has_std(a:argv)
    let default_std = 1
  else
    let default_std = 0
  endif
  if index(a:fts, 'c') !=# -1
    let c_runner = {
          \ 'exe' : 'gcc',
          \ 'targetopt' : '-o',
          \ 'opt' : a:argv + (default_std ? [] : ['-std=' . s:clang_std.c]) + s:clang_flag + ['-xc', '-'],
          \ 'usestdin' : 1,
          \ }
    call SpaceVim#plugins#runner#reg_runner('c', [c_runner, '#TEMP#'])
  endif
  if index(a:fts, 'cpp') !=# -1
    let cpp_runner = {
          \ 'exe' : 'g++',
          \ 'targetopt' : '-o',
          \ 'opt' : a:argv + (default_std ? [] : ['-std=' . s:clang_std.cpp]) + s:clang_flag + ['-xc++', '-'],
          \ 'usestdin' : 1,
          \ }
    call SpaceVim#plugins#runner#reg_runner('cpp', [cpp_runner, '#TEMP#'])
  endif
  " update clang_flag for objective-c
  if index(a:fts, 'objc') !=# -1
    let cpp_runner = {
          \ 'exe' : 'gcc',
          \ 'targetopt' : '-o',
          \ 'opt' : a:argv + (default_std ? [] : ['-std=' . s:clang_std.objc]) + s:clang_flag + ['-xobjc', '-'],
          \ 'usestdin' : 1,
          \ }
    call SpaceVim#plugins#runner#reg_runner('objc', [cpp_runner, '#TEMP#'])
  endif
endfunction
" }}}

" local function: update_neoinclude {{{
function! s:update_neoinclude(argv, fts) abort
  if s:SYSTEM.isLinux
    let path = '.,/usr/include,,' 
  else
    let path = '.,,' 
  endif
  for argv in a:argv
    if argv =~# '^-I'
      let path .= ',' . argv[2:]
    endif
  endfor
  let b:neoinclude_paths = path
endfunction
" }}}

" local function: go_to_declaration {{{
function! s:go_to_declaration() abort
  if !SpaceVim#layers#lsp#check_filetype(&ft)
        \ && !SpaceVim#layers#lsp#check_server('clangd')
    try
      exe 'ts' expand('<cword>')
    catch /^Vim\%((\a\+)\)\=:E426/
      echohl WarningMsg
      echo 'tag not found: ' . expand('<cword>')
      echohl NONE
    endtry
  else
    call SpaceVim#lsp#go_to_declaration()
  endif
endfunction
" }}}

" local function: go_to_def {{{
function! s:go_to_def() abort
  if !SpaceVim#layers#lsp#check_filetype(&ft)
        \ && !SpaceVim#layers#lsp#check_server('clangd')
    try
      exe 'ts' expand('<cword>')
    catch /^Vim\%((\a\+)\)\=:E426/
      echohl WarningMsg
      echo 'tag not found: ' . expand('<cword>')
      echohl NONE
    endtry
  else
    call SpaceVim#lsp#go_to_def()
  endif
endfunction
" }}}

function! SpaceVim#layers#lang#c#health() abort
  call SpaceVim#layers#lang#c#plugins()
  call SpaceVim#layers#lang#c#config()
  return 1
endfunction
