"=============================================================================
" lsp.vim --- SpaceVim lsp layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lsp#plugins() abort
  let plugins = []

  if has('nvim')
    call add(plugins, ['SpaceVim/LanguageClient-neovim',
          \ { 'merged': 0, 'if': has('python3') }])
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

  let g:LanguageClient_autoStart = 1
  let g:lsp_async_completion = 1
  " }}}
  for ft in s:enabled_fts
    call SpaceVim#lsp#reg_server(ft, s:lsp_servers[ft])
  endfor
endfunction

let s:enabled_fts = []

let s:lsp_servers = {
      \ 'javascript' : ['typescript-language-server', '--stdio'],
      \ 'haskell' : ['hie', '--lsp'],
      \ 'c' : ['clangd'],
      \ 'cpp' : ['clangd'],
      \ 'objc' : ['clangd'],
      \ 'objcpp' : ['clangd'],
      \ 'dart' : ['dart_language_server'],
      \ 'go' : ['go-langserver', '-mode', 'stdio'],
      \ 'rust' : ['rustup', 'run', 'nightly', 'rls'],
      \ 'python' : ['pyls'],
      \ 'html' : ['html-languageserver', '--stdio'],
      \ 'php' : ['php', g:spacevim_plugin_bundle_dir . 'repos/github.com/felixfbecker/php-language-server/bin/php-language-server.php']
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
