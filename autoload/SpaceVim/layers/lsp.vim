"=============================================================================
" lsp.vim --- SpaceVim lsp layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section language server protocol, layer-lsp
" @parentsection layers
" This layer provides language client support for SpaceVim.

function! SpaceVim#layers#lsp#plugins() abort
  let plugins = []

  if SpaceVim#layers#isLoaded('autocomplete') && get(g:, 'spacevim_autocomplete_method') ==# 'coc'
    " nop
  elseif has('nvim')
    call add(plugins, ['autozimu/LanguageClient-neovim',
          \ { 'merged': 0, 'if': has('python3'), 'build' : 'bash install.sh' }])
  else
    call add(plugins, ['prabirshrestha/async.vim', {'merged' : 0}])
    call add(plugins, ['prabirshrestha/vim-lsp', {'merged' : 0}])
  endif

  return plugins
endfunction

function! SpaceVim#layers#lsp#config() abort
  " SpaceVim/LanguageClient-neovim {{{
  let g:LanguageClient_diagnosticsDisplay = {
        \ 1: {
        \ 'name': 'Error',
        \ 'signText': g:spacevim_error_symbol,
        \ },
        \ 2: {
        \ 'name': 'Warning',
        \ 'signText': g:spacevim_warning_symbol,
        \ },
        \ 3: {
        \ 'name': 'Information',
        \ 'signText': g:spacevim_info_symbol,
        \ },
        \ 4: {
        \ 'name': 'Hint',
        \ 'signText': g:spacevim_info_symbol,
        \ },
        \ }

  if g:spacevim_enable_neomake
    let g:LanguageClient_diagnosticsDisplay[1].texthl = 'NeomakeError'
    let g:LanguageClient_diagnosticsDisplay[1].signTexthl = 'NeomakeErrorSign'

    let g:LanguageClient_diagnosticsDisplay[2].texthl = 'NeomakeWarning'
    let g:LanguageClient_diagnosticsDisplay[2].signTexthl = 
          \ 'NeomakeWarningSign'

    let g:LanguageClient_diagnosticsDisplay[3].texthl = 'NeomakeInfo'
    let g:LanguageClient_diagnosticsDisplay[3].signTexthl = 'NeomakeInfoSign'

    let g:LanguageClient_diagnosticsDisplay[4].texthl = 'NeomakeMessage'
    let g:LanguageClient_diagnosticsDisplay[4].signTexthl = 
          \ 'NeomakeMessageSign'
  elseif g:spacevim_enable_ale
    let g:LanguageClient_diagnosticsDisplay[1].texthl = 'ALEError'
    let g:LanguageClient_diagnosticsDisplay[1].signTexthl = 'ALEErrorSign'

    let g:LanguageClient_diagnosticsDisplay[2].texthl = 'ALEWarning'
    let g:LanguageClient_diagnosticsDisplay[2].signTexthl = 'ALEWarningSign'

    let g:LanguageClient_diagnosticsDisplay[3].texthl = 'ALEInfo'
    let g:LanguageClient_diagnosticsDisplay[3].signTexthl = 'ALEInfoSign'

    let g:LanguageClient_diagnosticsDisplay[4].texthl = 'ALEInfo'
    let g:LanguageClient_diagnosticsDisplay[4].signTexthl = 'ALEInfoSign'
  endif


  if !SpaceVim#layers#isLoaded('checkers')
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'c'], 'call call('
          \ . string(s:_function('s:clear_errors')) . ', [])',
          \ 'clear all errors', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'n'], 'call call('
          \ . string(s:_function('s:jump_to_next_error')) . ', [])',
          \ 'next-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'p'], 'call call('
          \ . string(s:_function('s:jump_to_previous_error')) . ', [])',
          \ 'previous-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'N'], 'call call('
          \ . string(s:_function('s:jump_to_previous_error')) . ', [])',
          \ 'previous-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'l'], 'call call('
          \ . string(s:_function('s:toggle_show_error')) . ', [0])',
          \ 'toggle showing the error list', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', 'L'], 'call call('
          \ . string(s:_function('s:toggle_show_error')) . ', [1])',
          \ 'toggle showing the error list', 1)
  endif

  let g:LanguageClient_autoStart = 1
  let g:lsp_async_completion = 1
  " }}}
  for ft in s:enabled_fts
    call SpaceVim#lsp#reg_server(ft, s:lsp_servers[ft])
  endfor
endfunction

let s:enabled_fts = []

let s:lsp_servers = {
      \ 'c' : ['clangd'],
      \ 'cpp' : ['clangd'],
      \ 'css' : ['css-languageserver', '--stdio'],
      \ 'dart' : ['dart_language_server'],
      \ 'dockerfile' : ['docker-langserver', '--stdio'],
      \ 'go' : ['go-langserver', '-mode', 'stdio'],
      \ 'haskell' : ['hie-wrapper', '--lsp'],
      \ 'html' : ['html-languageserver', '--stdio'],
      \ 'javascript' : ['javascript-typescript-stdio'],
      \ 'julia' : ['julia', '--startup-file=no', '--history-file=no', '-e', 'using LanguageServer; server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false); server.runlinter = true; run(server);'],
      \ 'objc' : ['clangd'],
      \ 'objcpp' : ['clangd'],
      \ 'php' : ['php', g:spacevim_plugin_bundle_dir . 'repos/github.com/felixfbecker/php-language-server/bin/php-language-server.php'],
      \ 'purescript' : ['purescript-language-server', '--stdio'],
      \ 'python' : ['pyls'],
      \ 'crystal' : ['scry'],
      \ 'rust' : ['rustup', 'run', 'nightly', 'rls'],
      \ 'scala' : ['metals-vim'],
      \ 'sh' : ['bash-language-server', 'start'],
      \ 'typescript' : ['typescript-language-server', '--stdio'],
      \ 'ruby' : ['solargraph',  'stdio'],
      \ 'vue' : ['vls']
      \ }

function! SpaceVim#layers#lsp#set_variable(var) abort
  let override = get(a:var, 'override_cmd', {})
  if !empty(override)
    call extend(s:lsp_servers, override, 'force')
  endif
  for ft in get(a:var, 'filetypes', [])
    let cmd = get(s:lsp_servers, ft, [''])[0]
    if empty(cmd)
      call SpaceVim#logger#warn('Failed to find the lsp server command for ' . ft)
    else
      if executable(cmd)
        call add(s:enabled_fts, ft)
      else
        call SpaceVim#logger#warn('Failed to enable lsp for ' . ft . ', ' . cmd . ' is not executable!')
      endif
    endif
  endfor
endfunction

function! SpaceVim#layers#lsp#check_filetype(ft) abort
  return index(s:enabled_fts, a:ft) != -1
endfunction

function! s:jump_to_next_error() abort
  try
    lnext
  catch
    try
      cnext
    catch
      echohl WarningMsg
      echon 'There is no errors!'
      echohl None
    endtry
  endtry
endfunction

function! s:jump_to_previous_error() abort
  try
    lprevious
  catch
    try
      cprevious
    catch
      echohl WarningMsg
      echon 'There is no errors!'
      echohl None
    endtry
  endtry
endfunction

function! s:toggle_show_error(...) abort
  try
    botright lopen
  catch
    try
      if len(getqflist()) == 0
        echohl WarningMsg
        echon 'There is no errors!'
        echohl None
      else
        botright copen
      endif
    catch
    endtry
  endtry
  if a:1 == 1
    wincmd w
  endif
endfunction

if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

" TODO clear errors
function! s:clear_errors() abort
  sign unplace *
endfunction
